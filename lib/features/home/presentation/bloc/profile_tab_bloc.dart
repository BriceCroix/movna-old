import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:movna/core/domain/entities/settings.dart';
import 'package:movna/core/domain/usecases/get_settings.dart';
import 'package:movna/core/domain/usecases/save_settings.dart';
import 'package:movna/features/home/domain/usecases/get_gear_count.dart';
import 'package:movna/features/home/domain/usecases/get_itineraries_count.dart';

part 'profile_tab_event.dart';

part 'profile_tab_state.dart';

@injectable
class ProfileTabBloc extends Bloc<ProfileTabEvent, ProfileTabState> {
  final GetSettings getSettings;
  final SaveSettings saveSettings;
  final GetItinerariesCount getItinerariesCount;
  final GetGearCount getGearCount;

  ProfileTabBloc({
    required this.getSettings,
    required this.saveSettings,
    required this.getItinerariesCount,
    required this.getGearCount,
  }) : super(const ProfileTabInitial()) {
    on<SettingsLoaded>(_onSettingsLoaded);
    on<ItinerariesCountLoaded>(_onItinerariesCountLoaded);
    on<GearCountLoaded>(_onGearCountLoaded);
    on<UserNameChanged>(_onUserNameChanged);
    on<UserHeightChanged>(_onUserHeightChanged);
    on<UserWeightChanged>(_onUserWeightChanged);
    on<UserGenderChanged>(_onUserGenderChanged);
    on<AutomaticPauseSpeedThresholdChanged>(
        _onAutomaticPauseSpeedThresholdChanged);
    on<AutomaticLockDurationThresholdChanged>(
        _onAutomaticLockDurationThresholdChanged);

    getSettings().then((value) => add(SettingsLoaded(settings: value)));
    getItinerariesCount()
        .then((value) => add(ItinerariesCountLoaded(count: value)));
    getGearCount().then((value) => add(GearCountLoaded(count: value)));
  }

  void _onSettingsLoaded(SettingsLoaded event, Emitter<ProfileTabState> emit) {
    final Settings settings = event.settings;
    if (state is ProfileTabInitial) {
      emit(ProfileTabLoading(settings: settings));
    } else if (state is ProfileTabLoading) {
      ProfileTabLoading stateLoading = state as ProfileTabLoading;
      emit(stateLoading.copyWith(settings: settings));
      _checkAndEmitLoadedState(emit);
    }
  }

  void _onItinerariesCountLoaded(
      ItinerariesCountLoaded event, Emitter<ProfileTabState> emit) {
    final int count = event.count;
    if (state is ProfileTabInitial) {
      emit(ProfileTabLoading(itinerariesCount: count));
    } else if (state is ProfileTabLoading) {
      ProfileTabLoading stateLoading = state as ProfileTabLoading;
      emit(stateLoading.copyWith(itinerariesCount: count));
      _checkAndEmitLoadedState(emit);
    }
  }

  void _onGearCountLoaded(
      GearCountLoaded event, Emitter<ProfileTabState> emit) {
    final int count = event.count;
    if (state is ProfileTabInitial) {
      emit(ProfileTabLoading(gearCount: count));
    } else if (state is ProfileTabLoading) {
      ProfileTabLoading stateLoading = state as ProfileTabLoading;
      emit(stateLoading.copyWith(gearCount: count));
      _checkAndEmitLoadedState(emit);
    }
  }

  void _onUserNameChanged(
    UserNameChanged event,
    Emitter<ProfileTabState> emit,
  ) {
    if (state is ProfileTabLoaded) {
      ProfileTabLoaded stateLoaded = state as ProfileTabLoaded;
      Settings newSettings = stateLoaded.settings.copyWith(
        userName: event.name,
      );
      emit(stateLoaded.copyWith(settings: newSettings));
      saveSettings(newSettings);
    }
  }

  void _onUserHeightChanged(
    UserHeightChanged event,
    Emitter<ProfileTabState> emit,
  ) {
    if (state is ProfileTabLoaded) {
      ProfileTabLoaded stateLoaded = state as ProfileTabLoaded;
      Settings newSettings = stateLoaded.settings.copyWith(
        userHeightInMeters: event.heightInMeters,
      );
      emit(stateLoaded.copyWith(settings: newSettings));
      saveSettings(newSettings);
    }
  }

  void _onUserWeightChanged(
    UserWeightChanged event,
    Emitter<ProfileTabState> emit,
  ) {
    if (state is ProfileTabLoaded) {
      ProfileTabLoaded stateLoaded = state as ProfileTabLoaded;
      Settings newSettings = stateLoaded.settings.copyWith(
        userWeightInKilograms: event.weightInKg,
      );
      emit(stateLoaded.copyWith(settings: newSettings));
      saveSettings(newSettings);
    }
  }

  void _onUserGenderChanged(
    UserGenderChanged event,
    Emitter<ProfileTabState> emit,
  ) {
    if (state is ProfileTabLoaded) {
      ProfileTabLoaded stateLoaded = state as ProfileTabLoaded;
      Settings newSettings = stateLoaded.settings.copyWith(
        userGender: event.gender,
      );
      emit(stateLoaded.copyWith(settings: newSettings));
      saveSettings(newSettings);
    }
  }

  void _onAutomaticPauseSpeedThresholdChanged(
    AutomaticPauseSpeedThresholdChanged event,
    Emitter<ProfileTabState> emit,
  ) {
    if (state is ProfileTabLoaded) {
      ProfileTabLoaded stateLoaded = state as ProfileTabLoaded;
      Settings newSettings = stateLoaded.settings.copyWith(
        automaticPauseThresholdSpeedInKilometersPerHour: event.thresholdInKmPH,
      );
      emit(stateLoaded.copyWith(settings: newSettings));
      saveSettings(newSettings);
    }
  }

  void _onAutomaticLockDurationThresholdChanged(
    AutomaticLockDurationThresholdChanged event,
    Emitter<ProfileTabState> emit,
  ) {
    if (state is ProfileTabLoaded) {
      ProfileTabLoaded stateLoaded = state as ProfileTabLoaded;
      Settings newSettings = stateLoaded.settings.copyWith(
        automaticLockThresholdDurationWithoutInput:
            Duration(seconds: event.durationInSeconds),
      );
      emit(stateLoaded.copyWith(settings: newSettings));
      saveSettings(newSettings);
    }
  }

  /// Checks if all parameters have successfully been loaded,
  /// and yields a loaded state if so.
  void _checkAndEmitLoadedState(Emitter<ProfileTabState> emit) {
    if (state is ProfileTabLoading) {
      ProfileTabLoading stateLoading = state as ProfileTabLoading;
      if (stateLoading.settings != null &&
          stateLoading.itinerariesCount != null &&
          stateLoading.gearCount != null) {
        emit(ProfileTabLoaded(
            settings: stateLoading.settings!,
            itinerariesCount: stateLoading.itinerariesCount!,
            gearCount: stateLoading.gearCount!));
      }
    }
  }
}
