import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movna/core/domain/entities/activity.dart';
import 'package:movna/core/injection.dart';
import 'package:movna/core/presentation/widgets/movna_tile_layers.dart';
import 'package:movna/features/ongoing_activity/presentation/widgets/ongoing_activity_measure.dart';

import 'blocs/ongoing_activity_bloc.dart';

class OngoingActivityPage extends StatelessWidget {
  const OngoingActivityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => injector<OngoingActivityBloc>(),
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

  Color _getUserColor(BuildContext context) =>
      Theme.of(context).colorScheme.secondary;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            BlocBuilder<OngoingActivityBloc, OngoingActivityState>(
                builder: (context, state) {
              return state is! OngoingActivityLoaded
                  ? SpinKitRotatingCircle(
                      color: Theme.of(context).colorScheme.secondary,
                      size: 50.0)
                  : FlutterMap(
                      mapController: MapController(),
                      options: MapOptions(
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
                        getOpenStreetMapTileLayer(),
                        BlocBuilder<OngoingActivityBloc, OngoingActivityState>(
                          builder: (context, state) {
                            OngoingActivityLoaded stateLoaded =
                                (state as OngoingActivityLoaded);
                            List<Marker> markers = [];
                            // Add starting point
                            if (stateLoaded.activity.trackPoints.isNotEmpty &&
                                stateLoaded
                                        .activity.trackPoints.first.position !=
                                    null) {
                              Position start = stateLoaded
                                  .activity.trackPoints.first.position!;
                              markers.add(Marker(
                                point: LatLng(start.latitudeInDegrees,
                                    start.longitudeInDegrees),
                                builder: (context) => const Icon(
                                  Icons.circle_rounded,
                                  color: Colors.green,
                                ),
                              ));
                            }
                            // Add current position
                            Position? current =
                                stateLoaded.lastTrackPoint.position;
                            if (current != null) {
                              markers.add(Marker(
                                point: LatLng(current.latitudeInDegrees,
                                    current.longitudeInDegrees),
                                builder: (context) => Icon(
                                  Icons.circle_rounded,
                                  color: _getUserColor(context),
                                ),
                              ],
                            );
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
                    Radius.circular(8.0),
                  ),
                ),
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(16),
                child: BlocBuilder<OngoingActivityBloc, OngoingActivityState>(
                  builder: (context, state) {
                    Activity? activity =
                        state is OngoingActivityLoaded ? state.activity : null;
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
        floatingActionButton:
            BlocBuilder<OngoingActivityBloc, OngoingActivityState>(
          builder: (context, state) {
            if (state is OngoingActivityLoaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // TODO : hide all buttons but lock with Flow
                  /// Settings button
                  FloatingActionButton(
                    heroTag: 'settings',
                    backgroundColor:
                        state.isLocked ? Colors.grey : Colors.grey[400],
                    onPressed: state.isLocked ? null : () {},
                    child: const Icon(Icons.settings),
                  ),
                  const SizedBox(height: 8),

                  /// Pause or stop button depending on whether is paused or not
                  FloatingActionButton(
                    heroTag: 'pause_stop',
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
                  //TODO redo all these buttons, separate pause, stop etc and show with Flow
                  FloatingActionButton(
                    heroTag: 'lock_resume',
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
