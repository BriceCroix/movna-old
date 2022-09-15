import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:movna/core/domain/entities/position.dart';
import 'package:movna/core/domain/usecases/get_position.dart';
import 'package:movna/core/domain/usecases/get_position_stream.dart';

part 'past_activity_event.dart';

part 'past_activity_state.dart';

@Injectable()
class PastActivityBloc extends Bloc<PastActivityEvent, PastActivityState> {
  final GetPositionStream getPositionStream;
  final GetPosition getPosition;

  /// Stream yielding user positions.
  StreamSubscription<Position>? _positionSubscription;

  PastActivityBloc({
    required this.getPositionStream,
    required this.getPosition,
  }) : super(const PastActivityInitial()) {
    on<PositionChanged>(_onPositionChanged);

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

  void _onPositionChanged(
      PositionChanged event, Emitter<PastActivityState> emit) {
    if (state is PastActivityInitial) {
      emit(PastActivityLoaded(position: event.position));
    }else if(state is PastActivityLoaded){
      emit((state as PastActivityLoaded).copyWith(position: event.position));
    }
  }
}
