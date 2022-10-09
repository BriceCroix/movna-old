import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:movna/core/domain/entities/gear.dart';
import 'package:movna/core/domain/usecases/get_gear_pieces.dart';

part 'gear_list_event.dart';

part 'gear_list_state.dart';

@injectable
class GearListBloc extends Bloc<GearListEvent, GearListState> {
  final GetGearPieces getGearPieces;

  GearListBloc({
    required this.getGearPieces,
  }) : super(GearListInitial()) {
    on<GearPiecesLoaded>(_onGearPiecesLoaded);
    on<RefreshGearPieces>(_onRefreshGearPieces);

    getGearPieces().then((value) => add(GearPiecesLoaded(gearPieces: value)));
  }

  @override
  Future<void> close() {
    return super.close();
  }

  void _onGearPiecesLoaded(
      GearPiecesLoaded event, Emitter<GearListState> emit) {
    if (state is GearListInitial) {
      emit(GearListLoaded(gearList: event.gearPieces));
    } else if (state is GearListLoaded) {
      emit((state as GearListLoaded).copyWith(gearList: event.gearPieces));
    }
  }

  void _onRefreshGearPieces(
      RefreshGearPieces event, Emitter<GearListState> emit) {
    getGearPieces().then((value) => add(GearPiecesLoaded(gearPieces: value)));
  }
}
