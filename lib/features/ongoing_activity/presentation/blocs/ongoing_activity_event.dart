part of 'ongoing_activity_bloc.dart';

abstract class OngoingActivityEvent extends Equatable {
  const OngoingActivityEvent();

  @override
  List<Object> get props => [];
}

class SettingsLoaded extends OngoingActivityEvent {
  final Settings settings;

  const SettingsLoaded({required this.settings});

  @override
  List<Object> get props => [settings];
}

class MapReadyEvent extends OngoingActivityEvent {}

class UnlockEvent extends OngoingActivityEvent {}

class LockEvent extends OngoingActivityEvent {}

class PauseStatusChangedEvent extends OngoingActivityEvent {
  final PauseStatus pauseStatus;

  const PauseStatusChangedEvent({this.pauseStatus = PauseStatus.pausedManually});

  @override
  List<Object> get props => [pauseStatus];
}

class StopEvent extends OngoingActivityEvent {}

class StartEvent extends OngoingActivityEvent {}

class TimeIntervalElapsedEvent extends OngoingActivityEvent {
  final Duration duration;

  const TimeIntervalElapsedEvent({required this.duration});

  List<Object> get props => [duration];
}

class NewTrackPointEvent extends OngoingActivityEvent {
  final TrackPoint trackPoint;

  const NewTrackPointEvent({required this.trackPoint});

  @override
  List<Object> get props => [trackPoint];
}
