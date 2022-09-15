part of 'past_activity_bloc.dart';

abstract class PastActivityEvent extends Equatable {
  const PastActivityEvent();
}

class PositionChanged extends PastActivityEvent {
  final Position position;

  const PositionChanged({required this.position});

  @override
  List<Object?> get props => [position];
}
