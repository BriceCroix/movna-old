part of 'user_itinerary_bloc.dart';

/// UserItineraryPage events.
abstract class UserItineraryEvent extends Equatable {
  const UserItineraryEvent();

  @override
  List<Object?> get props => [];
}

/// Gives initial parameters to the bloc
class ParametersGiven extends UserItineraryEvent {
  const ParametersGiven({required this.params});

  final UserItineraryPageParams params;

  @override
  List<Object?> get props => [params];
}

/// User moved.
class PositionChanged extends UserItineraryEvent {
  final Position position;

  const PositionChanged({required this.position});

  @override
  List<Object?> get props => [position];
}

/// Order the bloc to delete its itinerary.
class DeleteItineraryEvent extends UserItineraryEvent {}