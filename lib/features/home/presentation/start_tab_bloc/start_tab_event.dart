part of 'start_tab_bloc.dart';

abstract class StartTabEvent extends Equatable {
  const StartTabEvent();

  @override
  List<Object?> get props => [];
}

class SettingsLoaded extends StartTabEvent {
  final Settings settings;

  const SettingsLoaded({required this.settings});
}

class MapTileLayerSettingChanged extends StartTabEvent {
  final MapTileLayer mapTileLayer;

  const MapTileLayerSettingChanged({required this.mapTileLayer});

  @override
  List<Object?> get props => [mapTileLayer];
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

/// When the start activity modal sheet is closed
class StartActivitySheetClosed extends StartTabEvent {
  const StartActivitySheetClosed();
}
