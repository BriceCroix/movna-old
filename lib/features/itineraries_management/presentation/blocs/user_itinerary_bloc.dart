import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movna/core/domain/entities/itinerary.dart';
import 'package:injectable/injectable.dart';
import 'package:movna/core/domain/entities/position.dart';
import 'package:movna/core/domain/usecases/get_position.dart';
import 'package:movna/core/domain/usecases/get_position_stream.dart';
import 'package:movna/features/itineraries_management/domain/usecases/delete_itinerary.dart';
import 'package:movna/features/itineraries_management/presentation/widgets/user_itinerary_page.dart';

part 'user_itinerary_event.dart';

part 'user_itinerary_state.dart';

@Injectable()
class UserItineraryBloc extends Bloc<UserItineraryEvent, UserItineraryState> {
  final GetPosition getPosition;
  final GetPositionStream getPositionStream;
  final DeleteItinerary deleteItinerary;

  /// Stream yielding user positions.
  StreamSubscription<Position>? _positionSubscription;

  UserItineraryBloc({
    required this.getPosition,
    required this.getPositionStream,
    required this.deleteItinerary,
  }) : super(UserItineraryInitial()) {
    on<ParametersGiven>(_onParametersGiven);
    on<PositionChanged>(_onPositionChanged);
    on<DeleteItineraryEvent>(_onDeleteItinerary);

    getPositionStream().then((stream) {
      _positionSubscription =
          stream.listen((event) => add(PositionChanged(position: event)));
    });
    getPosition().then((value) => add(PositionChanged(position: value)));
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    return super.close();
  }

  void _onParametersGiven(
      ParametersGiven event, Emitter<UserItineraryState> emit) {
    if (state is UserItineraryInitial) {
      emit(UserItineraryLoaded(itinerary: event.params.itinerary));
    }
  }

  void _onPositionChanged(
    PositionChanged event,
    Emitter<UserItineraryState> emit,
  ) {
    if (state is UserItineraryInitial) {
      emit(UserItineraryLoading(userPosition: event.position));
    } else if (state is UserItineraryLoading) {
      emit((state as UserItineraryLoading)
          .copyWith(userPosition: event.position));
    } else if (state is UserItineraryLoaded) {
      emit((state as UserItineraryLoaded)
          .copyWith(userPosition: event.position));
    }
  }

  void _onDeleteItinerary(
      DeleteItineraryEvent event,
      Emitter<UserItineraryState> emit,
      ) async {
    if (state is UserItineraryLoaded) {
      final stateLoaded = state as UserItineraryLoaded;
      await deleteItinerary(stateLoaded.itinerary).whenComplete(() {
        emit(UserItineraryDone());
      });
    }
  }
}
