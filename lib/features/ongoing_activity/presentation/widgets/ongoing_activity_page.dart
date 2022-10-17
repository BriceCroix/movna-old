import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movna/core/domain/entities/activity.dart';
import 'package:movna/core/injection.dart';
import 'package:movna/core/presentation/router/router.dart';
import 'package:movna/core/presentation/widgets/colors.dart';
import 'package:movna/core/presentation/widgets/movna_loading_spinner.dart';
import 'package:movna/core/presentation/widgets/movna_map_layers.dart';
import 'package:movna/core/presentation/widgets/presentation_constants.dart';
import 'package:movna/features/ongoing_activity/domain/entities/pause_status.dart';
import 'package:movna/features/ongoing_activity/presentation/widgets/ongoing_activity_measure.dart';
import 'package:movna/features/past_activity/presentation/widgets/past_activity_page.dart';
import 'package:wakelock/wakelock.dart';

import '../blocs/ongoing_activity_bloc.dart';

class OngoingActivityPage extends StatelessWidget {
  const OngoingActivityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => injector<OngoingActivityBloc>(),
      child: _OngoingActivityView(),
    );
  }
}

class _OngoingActivityView extends StatelessWidget {
  _OngoingActivityView({Key? key}) : super(key: key);

  final MapController _mapController = MapController();

  /// Called when the OS return button is pressed
  Future<bool> _onWillPop() async {
    //https://www.flutterbeads.com/disable-override-back-button-in-flutter/
    // TODO AlertDialog
    return false;
  }

  Widget _buildLockButton(BuildContext context, bool isLocked) {
    return FloatingActionButton(
      heroTag: 'lock',
      key: UniqueKey(),
      backgroundColor: userPositionColor,
      onPressed: () => context
          .read<OngoingActivityBloc>()
          .add(isLocked ? UnlockEvent() : LockEvent()),
      child: Icon(
        isLocked ? Icons.lock_rounded : Icons.lock_open_rounded,
      ),
    );
  }

  Widget _buildPauseButton(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'pause',
      backgroundColor: pauseColor,
      onPressed: () => context.read<OngoingActivityBloc>().add(
          const PauseStatusChangedEvent(
              pauseStatus: PauseStatus.pausedManually)),
      child: const Icon(Icons.pause_rounded),
    );
  }

  Widget _buildStopButton(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'stop',
      key: UniqueKey(),
      backgroundColor: stopColor,
      onPressed: () => context.read<OngoingActivityBloc>().add(StopEvent()),
      // Navigation is handled by the bloc listener
      child: const Icon(Icons.stop_rounded),
    );
  }

  Widget _buildResumeButton(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'resume',
      key: UniqueKey(),
      backgroundColor: startColor,
      onPressed: () => context
          .read<OngoingActivityBloc>()
          .add(const PauseStatusChangedEvent(pauseStatus: PauseStatus.running)),
      child: const Icon(Icons.play_arrow_rounded),
    );
  }

  Widget _buildSettingsButton(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'settings',
      key: UniqueKey(),
      backgroundColor: Colors.grey[500],
      onPressed: () {},
      //TODO
      child: const Icon(Icons.settings),
    );
  }

  Widget _buildButtons(BuildContext context, bool isLocked, bool isPaused) {
    const double padding = 8;
    if (isLocked) {
      return _buildLockButton(context, isLocked);
    } else {
      if (isPaused) {
        return Column(
            key: UniqueKey(),
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildSettingsButton(context),
              const SizedBox(height: padding),
              _buildStopButton(context),
              const SizedBox(height: padding),
              _buildResumeButton(context),
              const SizedBox(height: padding),
              _buildLockButton(context, isLocked),
            ]);
      } else {
        return Column(
            key: UniqueKey(),
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildSettingsButton(context),
              const SizedBox(height: padding),
              _buildPauseButton(context),
              const SizedBox(height: padding),
              _buildLockButton(context, isLocked),
            ]);
      }
    }
  }

  Widget _getUI(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            BlocConsumer<OngoingActivityBloc, OngoingActivityState>(
                listenWhen: (previous, current) {
              return current is OngoingActivityLoaded;
            }, listener: (context, state) {
              if (state is OngoingActivityLoaded) {
                // Handle auto center map movements if not in pause
                if (state.isMapReady &&
                    !state.isPaused &&
                    state.lastTrackPoint.position != null) {
                  LatLng center = LatLng(
                    state.lastTrackPoint.position!.latitudeInDegrees,
                    state.lastTrackPoint.position!.longitudeInDegrees,
                  );
                  bool res = _mapController.move(center, _mapController.zoom);
                }
              }
            }, builder: (context, state) {
              return state is! OngoingActivityLoaded
                  ? const MovnaLoadingSpinner()
                  : FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        slideOnBoundaries: true,
                        onMapReady: () => context
                            .read<OngoingActivityBloc>()
                            .add(MapReadyEvent()),
                        zoom: 16.0,
                        maxZoom: 18.0,
                        minZoom: 6.0,
                        interactiveFlags:
                            InteractiveFlag.all & ~InteractiveFlag.rotate,
                        center: state.lastTrackPoint.position != null
                            ? LatLng(
                                state
                                    .lastTrackPoint.position!.latitudeInDegrees,
                                state.lastTrackPoint.position!
                                    .longitudeInDegrees)
                            : LatLng(0, 0),
                      ),
                      children: [
                        // Tile Layer
                        getOpenStreetMapTileLayer(),
                        // Polyline layer
                        BlocBuilder<OngoingActivityBloc, OngoingActivityState>(
                          buildWhen: (previous, current) =>
                              (current is OngoingActivityLoaded) &&
                              (previous as OngoingActivityLoaded)
                                      .activity
                                      .trackPoints !=
                                  (current).activity.trackPoints,
                          builder: (context, state) {
                            OngoingActivityLoaded stateLoaded =
                                (state as OngoingActivityLoaded);

                            return getActivityPolylineLayer(
                                activity: stateLoaded.activity);
                          },
                        ),
                        // Markers Layer
                        BlocBuilder<OngoingActivityBloc, OngoingActivityState>(
                          buildWhen: (previous, current) =>
                              (current is OngoingActivityLoaded) &&
                              (previous as OngoingActivityLoaded)
                                      .lastTrackPoint !=
                                  current.lastTrackPoint,
                          builder: (context, state) {
                            OngoingActivityLoaded stateLoaded =
                                (state as OngoingActivityLoaded);
                            // Add starting point
                            if (stateLoaded.activity.trackPoints.isNotEmpty) {
                              return getPathMarkerLayer(
                                start: stateLoaded
                                    .activity.trackPoints.first.position,
                                user: state.lastTrackPoint.position,
                              );
                            } else {
                              return getPathMarkerLayer(
                                  user: state.lastTrackPoint.position);
                            }
                          },
                        ),
                      ],
                    );
            }),
            SafeArea(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(globalPadding),
                  ),
                ),
                margin: const EdgeInsets.all(globalPadding),
                padding: const EdgeInsets.all(globalPadding * 2),
                child: BlocBuilder<OngoingActivityBloc, OngoingActivityState>(
                  builder: (context, state) {
                    Activity? activity;
                    if (state is OngoingActivityLoaded) {
                      activity = state.activity;
                    } else if (state is OngoingActivityDone) {
                      activity = state.activity;
                    }
                    bool isPaused = (state is OngoingActivityLoaded)
                        ? state.isPaused
                        : false;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          (activity != null
                                  ? activity.duration
                                  : const Duration())
                              .toString()
                              .split('.')
                              .first
                              .padLeft(8, '0'),
                          style: TextStyle(
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                            color: isPaused ? pauseColor : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            OngoingActivityMeasure(
                              value: (activity != null
                                  ? 1e-3 * activity.distanceInMeters
                                  : 0),
                              legend: AppLocalizations.of(context)!.distance,
                              unit: 'km',
                            ),
                            OngoingActivityMeasure(
                              value: (activity != null
                                  ? activity.averageSpeedInKilometersPerHour
                                  : 0),
                              legend:
                                  AppLocalizations.of(context)!.averageSpeed,
                              unit: 'km/h',
                            ),
                            OngoingActivityMeasure(
                              value: state is OngoingActivityLoaded
                                  ? (state.lastTrackPoint
                                          .speedInKilometersPerHour ??
                                      0)
                                  : 0,
                              legend: AppLocalizations.of(context)!.speed,
                              unit: 'km/h',
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton:
            BlocBuilder<OngoingActivityBloc, OngoingActivityState>(
          buildWhen: (previous, current) =>
              (previous is! OngoingActivityLoaded &&
                  current is OngoingActivityLoaded) ||
              (previous is OngoingActivityLoaded &&
                  current is OngoingActivityLoaded &&
                  (previous.isLocked != current.isLocked ||
                      (!previous.isLocked &&
                          !current.isLocked &&
                          previous.isPaused != current.isPaused))),
          builder: (context, state) {
            return AnimatedSwitcher(
              layoutBuilder:
                  (Widget? currentChild, List<Widget> previousChildren) {
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    ...previousChildren,
                    if (currentChild != null) currentChild,
                  ],
                );
              },
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: state is OngoingActivityLoaded
                  ? _buildButtons(context, state.isLocked, state.isPaused)
                  : const SizedBox(),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OngoingActivityBloc, OngoingActivityState>(
      listener: (context, state) {
        if (state is OngoingActivityDone) {
          // Handle screen power
          Wakelock.disable();
          _mapController.dispose();
          // Handle navigation at the end of the activity
          navigateToReplacement(
            RouteName.pastActivity,
            PastActivityPageParams(activity: state.activity),
          );
        } else if (state is OngoingActivityLoaded) {
          // Handle screen power (always-on)
          Wakelock.enable();
        }
      },
      child: _getUI(context),
    );
  }
}
