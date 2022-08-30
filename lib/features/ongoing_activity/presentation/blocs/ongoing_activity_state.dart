part of 'ongoing_activity_bloc.dart';

abstract class OngoingActivityState extends Equatable {
  const OngoingActivityState({
    required this.mapController,
    required this.activity,
    required this.isLocked,
    required this.isPaused,
    required this.lastTrackPoint,
  });

  /// The controller of the map
  final MapController mapController;

  /// Current activity
  final Activity activity;

  /// Is the screen locked or not
  final bool isLocked;

  /// Is the activity paused or not
  final bool isPaused;

  /// Last trackpoint data event when the activity is paused
  final TrackPoint lastTrackPoint;

  copyWith({
    MapController? mapController,
    Activity? activity,
    bool? isLocked,
    bool? isPaused,
    TrackPoint? lastTrackPoint,
  });

  @override
  List<Object> get props => [activity, isLocked, isPaused, lastTrackPoint];
}

class OngoingActivityInitial extends OngoingActivityState {
  const OngoingActivityInitial(
      {required super.mapController, required super.activity})
      : super(
          isLocked: true,
          isPaused: true,
          lastTrackPoint: const TrackPoint(),
        );

  @override
  OngoingActivityInitial copyWith({
    MapController? mapController,
    Activity? activity,

    /// Ignored parameter
    bool? isLocked,

    /// Ignored parameter
    bool? isPaused,

    /// Ignored parameter
    TrackPoint? lastTrackPoint,
  }) {
    return OngoingActivityInitial(
      mapController: mapController ?? this.mapController,
      activity: activity ?? this.activity,
    );
  }
}

class OngoingActivityRunningState extends OngoingActivityState {
  const OngoingActivityRunningState({
    required super.mapController,
    required super.activity,
    required super.isLocked,
    required super.isPaused,
    required super.lastTrackPoint,
  });

  @override
  OngoingActivityRunningState copyWith({
    MapController? mapController,
    Activity? activity,
    bool? isLocked,
    bool? isPaused,
    TrackPoint? lastTrackPoint,
  }) {
    return OngoingActivityRunningState(
      mapController: mapController ?? this.mapController,
      activity: activity ?? this.activity,
      isLocked: isLocked ?? this.isLocked,
      isPaused: isPaused ?? this.isPaused,
      lastTrackPoint: lastTrackPoint ?? this.lastTrackPoint,
    );
  }
}
