import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:movna/pages/ongoing_activity/ongoing_activity_measure.dart';
import 'package:movna/data/activity_manager.dart';
import 'package:movna/model/activity.dart';
import 'package:movna/model/activity_track_point.dart';

class OngoingActivityPage extends StatefulWidget {
  const OngoingActivityPage({super.key});

  @override
  State<OngoingActivityPage> createState() => _OngoingActivityPageState();
}

class _OngoingActivityPageState extends State<OngoingActivityPage> {
  late MapController _mapController;

  /// activity data
  late Activity _activity;

  /// Current speed
  double _currentSpeedKmPerHour = 0.0;

  bool _lock = true;

  /// Timer used to monitor duration of activity,
  /// also to know if activity is paused
  late Timer _timer;

  /// Starts or resume activity
  void _startTimer() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          _activity.duration += oneSec;
        });
      },
    );
  }

  void _onPauseButtonPressed() {
    _registerCurrentLocation();
    setState(_timer.cancel);
  }

  void _onResumeButtonPressed() {
    _registerCurrentLocation();
    _lock = true;
    setState(_startTimer);
  }

  void _onLockButtonPressed() {
    setState(() {
      _lock = !_lock;
    });
  }

  void _onStopButtonPressed() {
    // Do not save very short activities, perhaps inform user ? -> ScaffoldMessenger
    //TODO
    //if (_activity.duration.inSeconds >= 30) {
    _activity.updateStartStop();
    saveActivity(_activity);
    //}
    // TODO : goto PastActivityPage
    Navigator.pop(context);
  }

  /// Called when the OS return button is pressed
  Future<bool> _onWillPop() async {
    //https://www.flutterbeads.com/disable-override-back-button-in-flutter/
    // TODO AlertDialog
    return false;
  }

  void _onMapIsReady(bool ready) {
    if (ready) {
      // Initialize first position
      _registerCurrentLocation();
      setState(_startTimer);
    }
  }

  void _onLocationChanged(GeoPoint currentPosition) async {
    // Do not do anything if activity is paused
    if (_timer.isActive) {
      // Prevent from reading list before initValue is called
      if (_activity.trackPoints.isNotEmpty) {
        ActivityTrackPoint lastTrackPoint = _activity.trackPoints.last;

        double distance = await distance2point(
            GeoPoint(
                latitude: lastTrackPoint.latitude,
                longitude: lastTrackPoint.longitude),
            currentPosition);
        _activity.trackPoints.add(ActivityTrackPoint(
            latitude: currentPosition.latitude,
            longitude: currentPosition.longitude,
            dateTime: DateTime.now()));
        Duration durationSinceLastUpdate = _activity.trackPoints.last.dateTime
            .difference(lastTrackPoint.dateTime);

        setState(() {
          _activity.distanceInMeters += distance;
          _currentSpeedKmPerHour = durationSinceLastUpdate.inSeconds != 0
              ? 1e-3 * distance / durationSinceLastUpdate.inSeconds
              : 0;
          _activity.updateAverageSpeed();
        });
      }
    }
  }

  /// Requests current location and adds a trackpoint to the activity
  void _registerCurrentLocation() async {
    GeoPoint currentPosition = await _mapController.myLocation();
    _activity.trackPoints.add(ActivityTrackPoint(
        latitude: currentPosition.latitude,
        longitude: currentPosition.longitude,
        dateTime: DateTime.now()));
  }

  void _initActivity() {
    _activity = Activity();
    _currentSpeedKmPerHour = 0.0;
    _activity.averageSpeedInKilometersPerHour = 0.0;
    _activity.distanceInMeters = 0.0;
  }

  @override
  void initState() {
    super.initState();
    // Instantiate the map controller
    _mapController = MapController(
      initMapWithUserPosition: true,
    );
    _initActivity();
    _timer = Timer(Duration.zero, () {});
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        // https://pub.dev/packages/flutter_osm_plugin
        body: Stack(
          children: [
            OSMFlutter(
              controller: _mapController,
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
                    size: 48,
                  ),
                ),
              ),
              onLocationChanged: _onLocationChanged,
              onMapIsReady: _onMapIsReady,
              mapIsLoading: const Center(
                child: SpinKitRotatingCircle(
                  color: Colors.blue,
                  size: 50.0,
                ),
              ),
            ),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _activity.duration
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
                            value: 1e-3 * _activity.distanceInMeters,
                            legend: AppLocalizations.of(context)!.distance,
                            unit: 'km'),
                        OngoingActivityMeasure(
                            value: _activity.averageSpeedInKilometersPerHour,
                            legend: AppLocalizations.of(context)!.averageSpeed,
                            unit: 'km/h'),
                        OngoingActivityMeasure(
                            value: _currentSpeedKmPerHour,
                            legend: AppLocalizations.of(context)!.speed,
                            unit: 'km/h'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // TODO : hide all buttons but lock with Flow
            FloatingActionButton(
              heroTag: "settings",
              backgroundColor: _lock ? Colors.grey : Colors.grey[400],
              onPressed: _lock ? null : () {},
              child: const Icon(Icons.settings),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              heroTag: "pause_stop",
              backgroundColor: _lock
                  ? Colors.grey
                  : (_timer.isActive ? Colors.amber : Colors.red),
              //TODO : preserve state of timer, milliseconds
              onPressed: _lock
                  ? null
                  : (_timer.isActive
                      ? _onPauseButtonPressed
                      : _onStopButtonPressed),
              child: Icon(_timer.isActive ? Icons.pause : Icons.stop_rounded),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              heroTag: "lock_resume",
              backgroundColor:
                  _timer.isActive ? Colors.blue : Colors.lightGreen,
              onPressed: _timer.isActive
                  ? _onLockButtonPressed
                  : _onResumeButtonPressed,
              child: Icon(_lock
                  ? Icons.lock
                  : (_timer.isActive
                      ? Icons.lock_open
                      : Icons.play_arrow_rounded)),
            ),
          ],
        ),
      ),
    );
  }
}
