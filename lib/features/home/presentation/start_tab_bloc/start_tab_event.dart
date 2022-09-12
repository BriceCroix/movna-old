part of 'start_tab_bloc.dart';

abstract class StartTabEvent extends Equatable {
  const StartTabEvent();

  @override
  List<Object?> get props => [];
}

class LocationLoaded extends StartTabEvent {
  final Position position;

  const LocationLoaded({required this.position});
}

class SettingsLoaded extends StartTabEvent {
  final Settings settings;

  const SettingsLoaded({required this.settings});
}

class SportSettingChanged extends StartTabEvent {
  final Sport sport;

  const SportSettingChanged({required this.sport});

  @override
  List<Object?> get props => [sport];
}

class AutoPauseSettingChanged extends StartTabEvent {
  final bool autoPause;

  const AutoPauseSettingChanged({required this.autoPause});

  @override
  List<Object?> get props => [autoPause];
}

class AutoLockSettingChanged extends StartTabEvent {
  final bool autoLock;

  const AutoLockSettingChanged({required this.autoLock});

  @override
  List<Object?> get props => [autoLock];
}

/// When 'Start Activity' is pressed
class StartEvent extends StartTabEvent {
  const StartEvent();
}

class PositionChanged extends StartTabEvent {
  final Position position;

  const PositionChanged({required this.position});
}