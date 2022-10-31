part of 'start_tab_bloc.dart';

abstract class StartTabState extends Equatable {
  const StartTabState();

  @override
  List<Object?> get props => [];
}

class StartTabInitial extends StartTabState {
  const StartTabInitial();
}

/// When all parameters are not available.
class StartTabLoading extends StartTabState {
  const StartTabLoading({
    this.settings,
    this.position,
    this.itineraries,
  });

  /// Settings of the app.
  final Settings? settings;

  /// Current Location
  final Position? position;

  /// List of user itineraries
  final List<Itinerary>? itineraries;

  StartTabLoading copyWith({
    Settings? settings,
    Position? position,
    List<Itinerary>? itineraries,
  }) {
    return StartTabLoading(
      settings: settings ?? this.settings,
      position: position ?? this.position,
      itineraries: itineraries ?? this.itineraries,
    );
  }

  @override
  List<Object?> get props => [settings, position, itineraries];
}

class StartTabLoaded extends StartTabState {
  const StartTabLoaded({
    required this.settings,
    required this.position,
    required this.itineraries,
    this.ongoingActivitySettings = const OngoingActivitySettings(),
  });

  /// Settings of the app.
  final Settings settings;

  /// Current Location.
  final Position position;

  /// List of user itineraries.
  final List<Itinerary> itineraries;

  /// Ongoing activity specific settings.
  final OngoingActivitySettings ongoingActivitySettings;

  StartTabLoaded copyWith({
    Settings? settings,
    Position? position,
    List<Itinerary>? itineraries,
    OngoingActivitySettings? ongoingActivitySettings,
  }) {
    return StartTabLoaded(
      settings: settings ?? this.settings,
      position: position ?? this.position,
      itineraries: itineraries ?? this.itineraries,
      ongoingActivitySettings:
          ongoingActivitySettings ?? this.ongoingActivitySettings,
    );
  }

  @override
  List<Object> get props => [
        settings,
        position,
        itineraries,
        ongoingActivitySettings,
      ];
}
