import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:injectable/injectable.dart';
import 'package:movna/core/domain/entities/settings.dart';
import 'package:movna/core/domain/usecases/get_settings.dart';
import 'package:movna/core/domain/usecases/save_settings.dart';

part 'start_tab_event.dart';

part 'start_tab_state.dart';

@injectable
class StartTabBloc extends Bloc<StartTabEvent, StartTabState> {
  final GetSettings getSettings;
  final SaveSettings saveSettings;

  StartTabBloc({required this.getSettings, required this.saveSettings})
      : super(const StartTabInitial()) {
    on<SettingsLoaded>(_onSettingsLoaded);
    on<MapTileLayerSettingChanged>(_onMapTileLayerSettingChanged);
    on<AutoPauseSettingChanged>(_onAutoPauseSettingChanged);
    on<AutoLockSettingChanged>(_onAutoLockSettingChanged);
    on<StartEvent>(_onStartEvent);
    on<StartActivitySheetClosed>(_onStartActivitySheetClosed);

    getSettings().then((settings) => add(SettingsLoaded(settings: settings)));
  }

  MapController _getMapController(MapTileLayer mapTileLayer) {
    late MapController mapController;
    switch (mapTileLayer) {
      case (MapTileLayer.publicTransportation):
        mapController = MapController.publicTransportationLayer(
            initMapWithUserPosition: true);
        break;
      case (MapTileLayer.cyclOSM):
        mapController =
            MapController.cyclOSMLayer(initMapWithUserPosition: true);
        break;
      default:
        mapController = MapController(initMapWithUserPosition: true);
        break;
    }
    return mapController;
  }

  void _onSettingsLoaded(SettingsLoaded event, Emitter<StartTabState> emit) {
    final Settings settings = event.settings;
    emit(StartTabLoaded(
        mapController: _getMapController(settings.mapTileLayer),
        settings: settings));
  }

  void _onMapTileLayerSettingChanged(
      MapTileLayerSettingChanged event, Emitter<StartTabState> emit) {
    final stateLoaded = (state as StartTabLoaded);
    final MapTileLayer mapTileLayer = event.mapTileLayer;
    print('EVENT!!!!!!!!!!!!!!!!!!!!!!    ${mapTileLayer.name}');
    Settings newSettings = stateLoaded.settings.copyWith(mapTileLayer: mapTileLayer);
    saveSettings(newSettings);
    emit(stateLoaded.copyWith(
        settings: stateLoaded.settings.copyWith(mapTileLayer: mapTileLayer),
        mapController: _getMapController(mapTileLayer)));

  }

  void _onAutoPauseSettingChanged(
      AutoPauseSettingChanged event, Emitter<StartTabState> emit) {
    final stateLoaded = (state as StartTabLoaded);
    emit(stateLoaded.copyWith(
        settings:
            stateLoaded.settings.copyWith(automaticPause: event.autoPause)));
  }

  void _onAutoLockSettingChanged(
      AutoLockSettingChanged event, Emitter<StartTabState> emit) {
    final stateLoaded = (state as StartTabLoaded);
    emit(stateLoaded.copyWith(
        settings:
            stateLoaded.settings.copyWith(automaticLock: event.autoLock)));
  }

  void _onStartEvent(StartEvent event, Emitter<StartTabState> emit) {
    saveSettings((state as StartTabLoaded).settings);
  }

  void _onStartActivitySheetClosed(
      StartActivitySheetClosed event, Emitter<StartTabState> emit) {
    saveSettings((state as StartTabLoaded).settings);
  }
}
