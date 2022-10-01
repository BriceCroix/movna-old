part of 'profile_tab_bloc.dart';

abstract class ProfileTabEvent extends Equatable {
  const ProfileTabEvent();

  @override
  List<Object?> get props => [];
}

class SettingsLoaded extends ProfileTabEvent {
  final Settings settings;

  const SettingsLoaded({required this.settings});
}

class ItinerariesCountLoaded extends ProfileTabEvent {
  final int count;

  const ItinerariesCountLoaded({required this.count});
}

class GearCountLoaded extends ProfileTabEvent {
  final int count;

  const GearCountLoaded({required this.count});
}

class UserNameChanged extends ProfileTabEvent {
  final String name;

  const UserNameChanged({required this.name});
}

class UserWeightChanged extends ProfileTabEvent {
  final double weightInKg;

  const UserWeightChanged({required this.weightInKg});
}

class UserHeightChanged extends ProfileTabEvent {
  final double heightInMeters;

  const UserHeightChanged({required this.heightInMeters});
}

class UserGenderChanged extends ProfileTabEvent {
  final Gender gender;

  const UserGenderChanged({required this.gender});
}

class AutomaticPauseSpeedThresholdChanged extends ProfileTabEvent {
  final double thresholdInKmPH;

  const AutomaticPauseSpeedThresholdChanged({required this.thresholdInKmPH});
}

class AutomaticPauseDurationThresholdChanged extends ProfileTabEvent {
  final int durationInSeconds;

  const AutomaticPauseDurationThresholdChanged(
      {required this.durationInSeconds});
}

class AutomaticLockDurationThresholdChanged extends ProfileTabEvent {
  final int durationInSeconds;

  const AutomaticLockDurationThresholdChanged(
      {required this.durationInSeconds});
}
