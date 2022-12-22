part of 'user_gear_bloc.dart';

abstract class UserGearEvent extends Equatable {
  const UserGearEvent();

  @override
  List get props => [];
}

class ParametersGiven extends UserGearEvent {
  const ParametersGiven({required this.params});

  final UserGearPageParams params;
}

/// Enable edit mode.
class EditModeEnabled extends UserGearEvent {}

/// Disable edit mode and confirm changes.
class EditDone extends UserGearEvent {}

/// Change the gear name.
class GearNameChanged extends UserGearEvent {
  const GearNameChanged({required this.name});

  final String name;
}

/// Change the gear type.
class GearTypeChanged extends UserGearEvent {
  const GearTypeChanged({required this.gearType});

  final GearType gearType;
}

/// Order the bloc to delete its piece of gear.
class DeleteGearEvent extends UserGearEvent {}
