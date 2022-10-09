import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:movna/core/domain/entities/gear.dart';
import 'package:movna/core/domain/entities/gear_type.dart';
import 'package:movna/features/gear_management/domain/usecases/delete_gear.dart';
import 'package:movna/features/gear_management/domain/usecases/save_gear.dart';
import 'package:movna/features/gear_management/presentation/widgets/user_gear_page.dart';

part 'user_gear_event.dart';

part 'user_gear_state.dart';

/// A task performed by UserGearBloc
enum _UserGearBlocTask {
  saveGear,
  deleteGear,
}

@injectable
class UserGearBloc extends Bloc<UserGearEvent, UserGearState> {
  SaveGear saveGear;
  DeleteGear deleteGear;
  List<_UserGearBlocTask> _tasks = [];

  UserGearBloc({
    required this.saveGear,
    required this.deleteGear,
  }) : super(UserGearInitial()) {
    on<ParametersGiven>(_onParametersGiven);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditDone>(_onEditDone);
    on<GearNameEdited>(_onGearNameEdited);
    on<GearTypeEdited>(_onGearTypeEdited);
    on<DeleteGearEvent>(_onDeleteGear);
  }

  void _onParametersGiven(ParametersGiven event, Emitter<UserGearState> emit) {
    if (state is UserGearInitial) {
      emit(UserGearLoaded(
        gear: event.params.gear,
        gearEdited: event.params.gear,
        editMode: event.params.editMode,
      ));
    }
  }

  void _onEditModeEnabled(EditModeEnabled event, Emitter<UserGearState> emit) {
    if (state is UserGearLoaded) {
      UserGearLoaded stateLoaded = state as UserGearLoaded;
      emit(stateLoaded.copyWith(editMode: true));
    }
  }

  void _onEditDone(EditDone event, Emitter<UserGearState> emit) async {
    if (state is UserGearLoaded) {
      UserGearLoaded stateLoaded = state as UserGearLoaded;

      // Can only start the task if not already saving.
      if (_tasks.contains(_UserGearBlocTask.saveGear) == false) {
        _tasks.add(_UserGearBlocTask.saveGear);
        emit(UserGearBusy(
          gear: stateLoaded.gearEdited,
          gearEdited: stateLoaded.gearEdited,
          editMode: false,
        ));
        await saveGear(stateLoaded.gearEdited).whenComplete(
            () => _removeTaskAndEmit(_UserGearBlocTask.saveGear, emit));
      }
    }
  }

  void _onGearNameEdited(GearNameEdited event, Emitter<UserGearState> emit) {
    if (state is UserGearLoaded) {
      UserGearLoaded stateLoaded = state as UserGearLoaded;

      emit(stateLoaded.copyWith(
        gearEdited: stateLoaded.gearEdited.copyWith(name: event.name),
      ));
    }
  }

  void _onGearTypeEdited(GearTypeEdited event, Emitter<UserGearState> emit) {
    if (state is UserGearLoaded) {
      UserGearLoaded stateLoaded = state as UserGearLoaded;

      emit(stateLoaded.copyWith(
        gearEdited: stateLoaded.gearEdited.copyWith(gearType: event.gearType),
      ));
    }
  }

  void _onDeleteGear(DeleteGearEvent event, Emitter<UserGearState> emit) async {
    if (state is UserGearLoaded) {
      UserGearLoaded stateLoaded = state as UserGearLoaded;

      // Can only start the task if not already deleting.
      if (_tasks.contains(_UserGearBlocTask.deleteGear) == false) {
        _tasks.add(_UserGearBlocTask.deleteGear);
        emit(UserGearBusy(
          gear: stateLoaded.gearEdited,
          gearEdited: stateLoaded.gearEdited,
          editMode: false,
        ));
        await deleteGear(stateLoaded.gear).whenComplete(() {
          _removeTaskAndEmit(_UserGearBlocTask.deleteGear, emit);
          emit(UserGearDone());
        });
      }
    }
  }

  /// Removes given task from bloc and eventually emits a "not busy" state if
  /// list of tasks is now empty.
  void _removeTaskAndEmit(
    _UserGearBlocTask task,
    Emitter<UserGearState> emit,
  ) {
    _tasks.remove(task);
    if (_tasks.isEmpty && state is UserGearLoaded) {
      UserGearLoaded stateLoaded = state as UserGearLoaded;
      emit(UserGearLoaded(
        gear: stateLoaded.gear,
        gearEdited: stateLoaded.gearEdited,
        editMode: stateLoaded.editMode,
      ));
    }
  }
}
