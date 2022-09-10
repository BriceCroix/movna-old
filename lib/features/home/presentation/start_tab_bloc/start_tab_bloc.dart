import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:movna/core/domain/entities/position.dart';
import 'package:movna/core/domain/entities/settings.dart';
import 'package:movna/core/domain/usecases/get_position.dart';
import 'package:movna/core/domain/usecases/get_position_stream.dart';
import 'package:movna/core/domain/usecases/get_settings.dart';
import 'package:movna/core/domain/usecases/save_settings.dart';

part 'start_tab_event.dart';

part 'start_tab_state.dart';

@injectable
class StartTabBloc extends Bloc<StartTabEvent, StartTabState> {
  final GetSettings getSettings;
  final SaveSettings saveSettings;
  final GetPosition getPosition;
  final GetPositionStream getPositionStream;

  StartTabBloc({required this.getSettings,
    required this.saveSettings,
    required this.getPosition,
    required this.getPositionStream,})
      : super(const StartTabInitial()) {
    on<SettingsLoaded>(_onSettingsLoaded);
    on<LocationLoaded>(_onLocationLoaded);
    on<AutoPauseSettingChanged>(_onAutoPauseSettingChanged);
    on<AutoLockSettingChanged>(_onAutoLockSettingChanged);
    on<StartEvent>(_onStartEvent);
    on<PositionChanged>(_onPositionChanged);

    getSettings().then((settings) => add(SettingsLoaded(settings: settings)));
    getPosition().then((position) => add(LocationLoaded(position: position)));

    getPositionStream().then((stream){
      stream.listen((event) => add(PositionChanged(position: event)));
    });
  }

  void _onSettingsLoaded(SettingsLoaded event, Emitter<StartTabState> emit) {
    final Settings settings = event.settings;
    if (state is StartTabInitial) {
      emit(StartTabLoading(settings: settings));
    } else if (state is StartTabLoading) {
      StartTabLoading stateLoading = state as StartTabLoading;
      // If more than two fields to load in the future, add an if to check
      // what fields are loaded
      emit(
          StartTabLoaded(settings: settings, position: stateLoading.position!));
    }
  }

  void _onLocationLoaded(LocationLoaded event, Emitter<StartTabState> emit) {
    final Position position = event.position;
    if (state is StartTabInitial) {
      emit(StartTabLoading(position: position));
    } else if (state is StartTabLoading) {
      StartTabLoading stateLoading = state as StartTabLoading;
      // If more than two fields to load in the future, add an if to check
      // what fields are loaded
      emit(
          StartTabLoaded(settings: stateLoading.settings!, position: position));
    }
  }

  void _onAutoPauseSettingChanged(AutoPauseSettingChanged event,
      Emitter<StartTabState> emit) {
    final stateLoaded = (state as StartTabLoaded);
    Settings newSettings = stateLoaded.settings.copyWith(
        automaticPause: event.autoPause);
    emit(stateLoaded.copyWith(settings: newSettings));
    saveSettings(newSettings);
  }

  void _onAutoLockSettingChanged(AutoLockSettingChanged event,
      Emitter<StartTabState> emit) {
    final stateLoaded = (state as StartTabLoaded);
    Settings newSettings = stateLoaded.settings.copyWith(
        automaticLock: event.autoLock);
    emit(stateLoaded.copyWith(settings: newSettings));
    saveSettings(newSettings);
  }

  void _onStartEvent(StartEvent event, Emitter<StartTabState> emit) {
    saveSettings((state as StartTabLoaded).settings);
  }

  void _onPositionChanged(PositionChanged event, Emitter<StartTabState> emit){
    if(state is StartTabLoaded) {
      emit((state as StartTabLoaded).copyWith(position: event.position));
    }
  }
}
