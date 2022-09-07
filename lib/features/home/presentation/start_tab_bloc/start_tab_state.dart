part of 'start_tab_bloc.dart';

abstract class StartTabState extends Equatable {
  const StartTabState();

  @override
  List<Object?> get props => [];
}

class StartTabInitial extends StartTabState {
  const StartTabInitial();
}

class StartTabLoaded extends StartTabState {
  const StartTabLoaded({required this.mapController, required this.settings});

  /// The controller of the map.
  final MapController mapController;

  /// Settings of the app.
  final Settings settings;

  StartTabLoaded copyWith({
    MapController? mapController,
    Settings? settings,
  }) {
    return StartTabLoaded(
      mapController: mapController ?? this.mapController,
      settings: settings ?? this.settings,
    );
  }

  @override
  List<Object> get props => [settings];
}
