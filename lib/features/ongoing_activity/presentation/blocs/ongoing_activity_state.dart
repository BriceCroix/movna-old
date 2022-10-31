part of 'ongoing_activity_bloc.dart';

abstract class OngoingActivityState extends Equatable {
  const OngoingActivityState();

  @override
  List<Object?> get props => [];
}

class OngoingActivityInitial extends OngoingActivityState {
  const OngoingActivityInitial();
}

class OngoingActivityLoading extends OngoingActivityState {
  const OngoingActivityLoading(
      {this.ongoingActivitySettings, this.settings, this.trackPoint});

  /// Settings of the app.
  final Settings? settings;

  /// Settings og the current ongoing activity.
  final OngoingActivitySettings? ongoingActivitySettings;

  /// Current TrackPoint
  final TrackPoint? trackPoint;

  OngoingActivityLoading copyWith({
    Settings? settings,
    OngoingActivitySettings? ongoingActivitySettings,
    TrackPoint? trackPoint,
  }) {
    return OngoingActivityLoading(
      settings: settings ?? this.settings,
      ongoingActivitySettings:
          ongoingActivitySettings ?? this.ongoingActivitySettings,
      trackPoint: trackPoint ?? this.trackPoint,
    );
  }

  @override
  List<Object?> get props => [settings, ongoingActivitySettings, trackPoint];
}

class OngoingActivityLoaded extends OngoingActivityState {
  const OngoingActivityLoaded({
    required this.settings,
    required this.activity,
    required this.isLocked,
    required this.pauseStatus,
    required this.lastTrackPoint,
    this.isMapReady = false,
  });

  /// Settings of the app.
  final Settings settings;

  /// Current activity
  final Activity activity;

  /// Is the screen locked or not
  final bool isLocked;

  /// Is the activity paused or not
  final PauseStatus pauseStatus;

  /// Last trackpoint data even when the activity is paused
  final TrackPoint lastTrackPoint;

  /// Is the map ready or not
  final bool isMapReady;

  OngoingActivityLoaded copyWith({
    Settings? settings,
    Activity? activity,
    bool? isLocked,
    PauseStatus? pauseStatus,
    TrackPoint? lastTrackPoint,
    bool? isMapReady,
  }) {
    return OngoingActivityLoaded(
      settings: settings ?? this.settings,
      activity: activity ?? this.activity,
      isLocked: isLocked ?? this.isLocked,
      pauseStatus: pauseStatus ?? this.pauseStatus,
      lastTrackPoint: lastTrackPoint ?? this.lastTrackPoint,
      isMapReady: isMapReady ?? this.isMapReady,
    );
  }

  bool get isPaused =>
      pauseStatus == PauseStatus.pausedAutomatically ||
      pauseStatus == PauseStatus.pausedManually;

  @override
  List<Object?> get props =>
      [settings, activity, isLocked, pauseStatus, lastTrackPoint, isMapReady];
}

/// Final state indicating that page must be changed.
class OngoingActivityDone extends OngoingActivityState {
  const OngoingActivityDone({
    required this.activity,
  });

  /// Current activity
  final Activity activity;

  @override
  List<Object?> get props => [activity];
}
