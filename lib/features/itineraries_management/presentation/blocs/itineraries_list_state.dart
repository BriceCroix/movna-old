part of 'itineraries_list_bloc.dart';

abstract class ItinerariesListState extends Equatable {
  const ItinerariesListState();

  @override
  List<Object> get props => [];
}

class ItinerariesListInitial extends ItinerariesListState {}

class ItinerariesListLoaded extends ItinerariesListState {
  const ItinerariesListLoaded({required this.itinerariesList});

  final List<Itinerary> itinerariesList;

  @override
  List<Object> get props => [itinerariesList];

  ItinerariesListLoaded copyWith({
    List<Itinerary>? itinerariesList,
  }) {
    return ItinerariesListLoaded(
      itinerariesList: itinerariesList ?? this.itinerariesList,
    );
  }
}
