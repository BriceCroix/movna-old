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
  const OngoingActivityLoading({this.settings, this.position});

  /// Settings of the app.
  final Settings? settings;

  /// Current Location
  final Position? position;

  OngoingActivityLoading copyWith({
    Settings? settings,
    Position? position,
  }) {
    return OngoingActivityLoading(
      settings: settings ?? this.settings,
      position: position ?? this.position,
    );
  }

  @override
  List<Object?> get props => [settings, position];
}

class OngoingActivityLoaded extends OngoingActivityState {
  const OngoingActivityLoaded({
    required this.settings,
    required this.activity,
    required this.isLocked,
    required this.isPaused,
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
  final bool isPaused;

  /// Last trackpoint data even when the activity is paused
  final TrackPoint lastTrackPoint;

  /// Is the map ready or not
  final bool isMapReady;

  OngoingActivityLoaded copyWith({
    Settings? settings,
    Activity? activity,
    bool? isLocked,
    bool? isPaused,
    TrackPoint? lastTrackPoint,
    bool? isMapReady,
  }) {
    return OngoingActivityLoaded(
      settings: settings ?? this.settings,
      activity: activity ?? this.activity,
      isLocked: isLocked ?? this.isLocked,
      isPaused: isPaused ?? this.isPaused,
      lastTrackPoint: lastTrackPoint ?? this.lastTrackPoint,
      isMapReady: isMapReady ?? this.isMapReady,
    );
  }

  @override
  List<Object?> get props =>
      [settings, activity, isLocked, isPaused, lastTrackPoint, isMapReady];
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
