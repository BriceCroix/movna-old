part of 'past_activity_bloc.dart';

abstract class PastActivityState extends Equatable {
  const PastActivityState();
}

class PastActivityInitial extends PastActivityState {
  const PastActivityInitial();

  @override
  List<Object> get props => [];
}

class PastActivityLoaded extends PastActivityState {
  const PastActivityLoaded({required this.position});

  final Position position;

  PastActivityLoaded copyWith({Position? position}) {
    return PastActivityLoaded(position: position ?? this.position);
  }

  @override
  List<Object> get props => [position];
}
