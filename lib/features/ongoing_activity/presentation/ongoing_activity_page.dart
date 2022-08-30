import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movna/core/domain/entities/position.dart';
import 'package:movna/core/domain/usecases/save_activity.dart';
import 'package:movna/core/injection.dart';
import 'package:movna/features/ongoing_activity/presentation/widgets/ongoing_activity_measure.dart';

import 'blocs/ongoing_activity_bloc.dart';

class OngoingActivityPage extends StatelessWidget {
  const OngoingActivityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OngoingActivityBloc(injector<SaveActivity>()),
      child: const OngoingActivityView(),
    );
  }
}

class OngoingActivityView extends StatelessWidget {
  const OngoingActivityView({Key? key}) : super(key: key);

  /// Called when the OS return button is pressed
  Future<bool> _onWillPop() async {
    //https://www.flutterbeads.com/disable-override-back-button-in-flutter/
    // TODO AlertDialog
    return false;
  }

  void _onMapIsReady(BuildContext context, bool ready) {
    if (ready) {
      context.read<OngoingActivityBloc>().add(StartEvent());
    }
  }

  void _onLocationChanged(BuildContext context, GeoPoint geoPoint) {
    context.read<OngoingActivityBloc>().add(
          NewLocationEvent(
            position: Position(
                latitudeInDegrees: geoPoint.latitude,
                longitudeInDegrees: geoPoint.longitude),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        // https://pub.dev/packages/flutter_osm_plugin
        body: Stack(
          children: [
            BlocBuilder<OngoingActivityBloc, OngoingActivityState>(
                builder: (context, state) {
              return OSMFlutter(
                controller: state.mapController,
                trackMyPosition: true,
                initZoom: 16,
                minZoomLevel: 8,
                maxZoomLevel: 18,
                stepZoom: 1.0,
                userLocationMarker: UserLocationMaker(
                  personMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.circle,
                      color: Colors.blue,
                      size: 48,
                    ),
                  ),
                  directionArrowMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.navigation,
                      color: Colors.blue,
                      size: 48,
                    ),
                  ),
                ),
                onLocationChanged: (geoPoint) =>
                    _onLocationChanged(context, geoPoint),
                onMapIsReady: (ready) => _onMapIsReady(context, ready),
                mapIsLoading: const Center(
                  child: SpinKitRotatingCircle(
                    color: Colors.blue,
                    size: 50.0,
                  ),
                ),
              );
            }),
            SafeArea(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(16),
                child: BlocBuilder<OngoingActivityBloc, OngoingActivityState>(
                  builder: (context, state) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.activity.duration
                              .toString()
                              .split('.')
                              .first
                              .padLeft(8, "0"),
                          style: const TextStyle(
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            OngoingActivityMeasure(
                                value: 1e-3 * state.activity.distanceInMeters,
                                legend: AppLocalizations.of(context)!.distance,
                                unit: 'km'),
                            OngoingActivityMeasure(
                                value: state
                                    .activity.averageSpeedInKilometersPerHour,
                                legend:
                                    AppLocalizations.of(context)!.averageSpeed,
                                unit: 'km/h'),
                            OngoingActivityMeasure(
                                value: state.lastTrackPoint
                                        .speedInKilometersPerHour ??
                                    0,
                                legend: AppLocalizations.of(context)!.speed,
                                unit: 'km/h'),
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
        floatingActionButton:
            BlocBuilder<OngoingActivityBloc, OngoingActivityState>(
          builder: (context, state) {
            if (state is OngoingActivityRunningState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // TODO : hide all buttons but lock with Flow
                  /// Settings button
                  FloatingActionButton(
                    heroTag: "settings",
                    backgroundColor:
                        state.isLocked ? Colors.grey : Colors.grey[400],
                    onPressed: state.isLocked ? null : () {},
                    child: const Icon(Icons.settings),
                  ),
                  const SizedBox(height: 8),

                  /// Pause or stop button depending on whether is paused or not
                  FloatingActionButton(
                    heroTag: "pause_stop",
                    backgroundColor: state.isLocked
                        ? Colors.grey
                        : (state.isPaused ? Colors.red : Colors.amber),
                    onPressed: state.isLocked
                        ? null
                        : () {
                            context.read<OngoingActivityBloc>().add(
                                state.isPaused ? StopEvent() : PauseEvent());
                            if (state.isPaused) {
                              // TODO : handle navigation better
                              Navigator.of(context).pop();
                            }
                          },
                    child: Icon(state.isPaused
                        ? Icons.stop_rounded
                        : Icons.pause_rounded),
                  ),
                  const SizedBox(height: 8),

                  /// Lock, Unlock or resume button depending on whether is paused or not
                  FloatingActionButton(
                    heroTag: "lock_resume",
                    backgroundColor:
                        state.isPaused ? Colors.lightGreen : Colors.blue,
                    onPressed: () => context.read<OngoingActivityBloc>().add(
                        state.isLocked
                            ? UnlockEvent()
                            : (state.isPaused ? ResumeEvent() : LockEvent())),
                    child: Icon(
                      state.isLocked
                          ? Icons.lock_rounded
                          : (state.isPaused
                              ? Icons.play_arrow_rounded
                              : Icons.lock_open_rounded),
                    ),
                  ),
                ],
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}