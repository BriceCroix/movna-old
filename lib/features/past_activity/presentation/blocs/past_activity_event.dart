part of 'past_activity_bloc.dart';

abstract class PastActivityEvent extends Equatable {
  const PastActivityEvent();

  @override
  List<Object?> get props => [];
}

class ParametersGiven extends PastActivityEvent {
  const ParametersGiven({required this.params});

  final PastActivityPageParams params;

  @override
  List<Object?> get props => [params];
}

class PositionChanged extends PastActivityEvent {
  final Position position;

  const PositionChanged({required this.position});

  @override
  List<Object?> get props => [position];
}

class DeleteActivityEvent extends PastActivityEvent {}

class CreateItineraryFromActivity extends PastActivityEvent {
  final String itineraryName;

  const CreateItineraryFromActivity({required this.itineraryName});

  @override
  List<Object?> get props => [itineraryName];
}
