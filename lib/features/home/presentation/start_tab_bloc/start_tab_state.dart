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
  const StartTabLoading({this.settings, this.position});

  /// Settings of the app.
  final Settings? settings;

  /// Current Location
  final Position? position;

  StartTabLoading copyWith({
    Settings? settings,
    Position? position,
  }) {
    return StartTabLoading(
      settings: settings ?? this.settings,
      position: position ?? this.position,
    );
  }

  @override
  List<Object?> get props => [settings, position];
}

class StartTabLoaded extends StartTabState {
  const StartTabLoaded({required this.settings, required this.position});

  /// Settings of the app.
  final Settings settings;
  /// Current Location
  final Position position;

  StartTabLoaded copyWith({
    Settings? settings,
    Position? position,
  }) {
    return StartTabLoaded(
      settings: settings ?? this.settings,
      position: position ?? this.position,
    );
  }

  @override
  List<Object> get props => [settings, position];
}
