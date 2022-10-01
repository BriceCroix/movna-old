part of 'profile_tab_bloc.dart';

abstract class ProfileTabState extends Equatable {
  const ProfileTabState();

  @override
  List<Object?> get props => [];
}

class ProfileTabInitial extends ProfileTabState {
  const ProfileTabInitial();
}

/// When all parameters are not available.
class ProfileTabLoading extends ProfileTabState {
  const ProfileTabLoading(
      {this.settings, this.itinerariesCount, this.gearCount});

  /// Settings of the app.
  final Settings? settings;

  /// Number of user itineraries
  final int? itinerariesCount;

  /// Number of user pieces of gear
  final int? gearCount;

  ProfileTabLoading copyWith({
    Settings? settings,
    int? itinerariesCount,
    int? gearCount,
  }) {
    return ProfileTabLoading(
      settings: settings ?? this.settings,
      itinerariesCount: itinerariesCount ?? this.itinerariesCount,
      gearCount: gearCount ?? this.gearCount,
    );
  }

  @override
  List<Object?> get props => [settings, itinerariesCount, gearCount];
}

class ProfileTabLoaded extends ProfileTabState {
  const ProfileTabLoaded({
    required this.settings,
    required this.itinerariesCount,
    required this.gearCount,
  });

  /// Settings of the app.
  final Settings settings;

  /// Number of user itineraries
  final int itinerariesCount;

  /// Number of user pieces of gear
  final int gearCount;

  ProfileTabLoaded copyWith({
    Settings? settings,
    int? itinerariesCount,
    int? gearCount,
  }) {
    return ProfileTabLoaded(
      settings: settings ?? this.settings,
      itinerariesCount: itinerariesCount ?? this.itinerariesCount,
      gearCount: gearCount ?? this.gearCount,
    );
  }

  @override
  List<Object?> get props => [settings, itinerariesCount, gearCount];
}
