part of 'ongoing_activity_bloc.dart';

abstract class OngoingActivityEvent extends Equatable {
  const OngoingActivityEvent();

  @override
  List<Object> get props => [];
}

class SettingsLoaded extends OngoingActivityEvent {
  final Settings settings;

  const SettingsLoaded({required this.settings});
  List<Object> get props => [settings];
}

class UnlockEvent extends OngoingActivityEvent {}

class LockEvent extends OngoingActivityEvent {}

class PauseEvent extends OngoingActivityEvent {}

class StopEvent extends OngoingActivityEvent {}

class StartEvent extends OngoingActivityEvent {}

class ResumeEvent extends OngoingActivityEvent {}

class TimeIntervalElapsedEvent extends OngoingActivityEvent {
  final Duration duration;

  const TimeIntervalElapsedEvent({required this.duration});
  List<Object> get props => [duration];
}

class PositionChangedEvent extends OngoingActivityEvent {
  final Position position;

  const PositionChangedEvent({required this.position});
  List<Object> get props => [position];
}
