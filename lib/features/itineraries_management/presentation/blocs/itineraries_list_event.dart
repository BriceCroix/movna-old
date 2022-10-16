part of 'itineraries_list_bloc.dart';

abstract class ItinerariesListEvent extends Equatable {
  const ItinerariesListEvent();

  @override
  List<Object?> get props => [];
}

class ItinerariesLoaded extends ItinerariesListEvent {
  const ItinerariesLoaded({required this.itineraries});

  final List<Itinerary> itineraries;

  @override
  List<Object?> get props => [itineraries];
}

/// Orders the bloc to reload its list of itineraries.
class RefreshItineraries extends ItinerariesListEvent {}
