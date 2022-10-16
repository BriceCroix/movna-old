import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:movna/core/domain/entities/activity.dart';
import 'package:movna/core/domain/entities/itinerary.dart';
import 'package:movna/core/domain/entities/position.dart';
import 'package:movna/core/domain/entities/track_point.dart';
import 'package:movna/core/domain/usecases/get_position.dart';
import 'package:movna/core/domain/usecases/get_position_stream.dart';
import 'package:movna/core/domain/usecases/save_activity.dart';
import 'package:movna/features/past_activity/domain/usecases/delete_activity.dart';
import 'package:movna/features/past_activity/presentation/widgets/past_activity_page.dart';

part 'past_activity_event.dart';

part 'past_activity_state.dart';

@Injectable()
class PastActivityBloc extends Bloc<PastActivityEvent, PastActivityState> {
  final GetPositionStream getPositionStream;
  final GetPosition getPosition;
  final DeleteActivity deleteActivity;
  final SaveActivity saveActivity;

  /// Stream yielding user positions.
  StreamSubscription<Position>? _positionSubscription;

  PastActivityBloc({
    required this.getPositionStream,
    required this.getPosition,
    required this.deleteActivity,
    required this.saveActivity,
  }) : super(const PastActivityInitial()) {
    on<ParametersGiven>(_onParametersGiven);
    on<PositionChanged>(_onPositionChanged);
    on<DeleteActivityEvent>(_onDeleteActivity);
    on<CreateItineraryFromActivity>(_onCreateItineraryFromActivity);

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
    ParametersGiven event,
    Emitter<PastActivityState> emit,
  ) {
    if (state is PastActivityInitial) {
      emit(PastActivityLoaded(
        // Position is not mandatory on this page.
        activity: event.params.activity, position: const Position(),
      ));
    } else if (state is PastActivityLoading) {
      final stateLoading = state as PastActivityLoading;
      emit(PastActivityLoaded(
        activity: event.params.activity,
        position: stateLoading.position,
      ));
    }
  }

  void _onPositionChanged(
    PositionChanged event,
    Emitter<PastActivityState> emit,
  ) {
    if (state is PastActivityInitial) {
      emit(PastActivityLoading(position: event.position));
    } else if (state is PastActivityLoaded) {
      emit((state as PastActivityLoaded).copyWith(position: event.position));
    }
  }

  void _onDeleteActivity(
    DeleteActivityEvent event,
    Emitter<PastActivityState> emit,
  ) async {
    if (state is PastActivityLoaded) {
      PastActivityLoaded stateLoaded = state as PastActivityLoaded;
      await deleteActivity(stateLoaded.activity).whenComplete(() {
        emit(PastActivityDone());
      });
    }
  }

  void _onCreateItineraryFromActivity(
    CreateItineraryFromActivity event,
    Emitter<PastActivityState> emit,
  ) {
    if (state is PastActivityLoaded) {
      PastActivityLoaded stateLoaded = state as PastActivityLoaded;
      List<Position> positions = [];
      for (TrackPoint t in stateLoaded.activity.trackPoints) {
        if (t.position != null) {
          positions.add(t.position!);
        }
      }
      Itinerary itinerary = Itinerary(
        creationTime: DateTime.now(),
        name: event.itineraryName,
        positions: positions,
      );
      Activity newActivity =
          stateLoaded.activity.copyWith(itinerary: itinerary);

      saveActivity(newActivity);
      emit(stateLoaded.copyWith(activity: newActivity));
    }
  }
}
