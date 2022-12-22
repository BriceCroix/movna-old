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

@injectable
class UserGearBloc extends Bloc<UserGearEvent, UserGearState> {
  SaveGear saveGear;
  DeleteGear deleteGear;

  UserGearBloc({
    required this.saveGear,
    required this.deleteGear,
  }) : super(UserGearInitial()) {
    on<ParametersGiven>(_onParametersGiven);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditDone>(_onEditDone);
    on<GearNameChanged>(_onGearNameChanged);
    on<GearTypeChanged>(_onGearTypeChanged);
    on<DeleteGearEvent>(_onDeleteGear);
  }

  void _onParametersGiven(ParametersGiven event, Emitter<UserGearState> emit) {
    if (state is UserGearInitial) {
      emit(UserGearLoaded(
        gear: event.params.gear,
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
      final stateLoaded = state as UserGearLoaded;

      await saveGear(stateLoaded.gear);
      emit(stateLoaded.copyWith(
        editMode: false
      ));
    }
  }

  void _onGearNameChanged(GearNameChanged event, Emitter<UserGearState> emit) {
    if (state is UserGearLoaded) {
      UserGearLoaded stateLoaded = state as UserGearLoaded;

      emit(stateLoaded.copyWith(
        gear: stateLoaded.gear.copyWith(name: event.name),
      ));
    }
  }

  void _onGearTypeChanged(GearTypeChanged event, Emitter<UserGearState> emit) {
    if (state is UserGearLoaded) {
      UserGearLoaded stateLoaded = state as UserGearLoaded;

      emit(stateLoaded.copyWith(
        gear: stateLoaded.gear.copyWith(gearType: event.gearType),
      ));
    }
  }

  void _onDeleteGear(DeleteGearEvent event, Emitter<UserGearState> emit) async {
    if (state is UserGearLoaded) {
      UserGearLoaded stateLoaded = state as UserGearLoaded;

      await deleteGear(stateLoaded.gear);
      emit(UserGearDone());
    }
  }
}
