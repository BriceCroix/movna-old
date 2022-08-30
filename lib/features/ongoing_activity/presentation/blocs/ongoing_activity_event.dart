part of 'ongoing_activity_bloc.dart';

abstract class OngoingActivityEvent extends Equatable {
  const OngoingActivityEvent();

  @override
  List<Object> get props => [];
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
}

class NewLocationEvent extends OngoingActivityEvent{
  final Position position;
  const NewLocationEvent({required this.position});
}
