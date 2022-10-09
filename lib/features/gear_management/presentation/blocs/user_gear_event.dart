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

class EditModeEnabled extends UserGearEvent {}

class EditDone extends UserGearEvent {}

class GearNameEdited extends UserGearEvent {
  const GearNameEdited({required this.name});

  final String name;
}

class GearTypeEdited extends UserGearEvent {
  const GearTypeEdited({required this.gearType});

  final GearType gearType;
}

/// Order the bloc to delete its piece of gear.
class DeleteGearEvent extends UserGearEvent {}
