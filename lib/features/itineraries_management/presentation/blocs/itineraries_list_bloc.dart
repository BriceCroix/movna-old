import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:movna/core/domain/entities/itinerary.dart';
import 'package:movna/core/domain/usecases/get_itineraries.dart';

part 'itineraries_list_event.dart';

part 'itineraries_list_state.dart';

@injectable
class ItinerariesListBloc
    extends Bloc<ItinerariesListEvent, ItinerariesListState> {
  final GetItineraries getItineraries;

  ItinerariesListBloc({
    required this.getItineraries,
  }) : super(ItinerariesListInitial()) {
    on<ItinerariesLoaded>(_onItinerariesLoaded);
    on<RefreshItineraries>(_onRefreshItineraries);

    getItineraries()
        .then((value) => add(ItinerariesLoaded(itineraries: value)));
  }

  @override
  Future<void> close() {
    return super.close();
  }

  void _onItinerariesLoaded(
      ItinerariesLoaded event, Emitter<ItinerariesListState> emit) {
    if (state is ItinerariesListInitial) {
      emit(ItinerariesListLoaded(itinerariesList: event.itineraries));
    } else if (state is ItinerariesListLoaded) {
      emit((state as ItinerariesListLoaded)
          .copyWith(itinerariesList: event.itineraries));
    }
  }

  void _onRefreshItineraries(
      RefreshItineraries event, Emitter<ItinerariesListState> emit) {
    getItineraries()
        .then((value) => add(ItinerariesLoaded(itineraries: value)));
  }
}
