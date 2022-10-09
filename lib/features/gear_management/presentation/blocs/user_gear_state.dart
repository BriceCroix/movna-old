part of 'user_gear_bloc.dart';

abstract class UserGearState extends Equatable {
  const UserGearState();

  @override
  List<Object> get props => [];
}

class UserGearInitial extends UserGearState {}

class UserGearLoaded extends UserGearState {
  const UserGearLoaded({
    required this.gear,
    required this.gearEdited,
    required this.editMode,
  });

  /// The piece of gear currently stored.
  final Gear gear;

  /// The piece of gear currently edited by user.
  final Gear gearEdited;

  /// Is the edit mode enabled or not.
  final bool editMode;

  UserGearLoaded copyWith({
    Gear? gear,
    Gear? gearEdited,
    bool? editMode,
  }) {
    return UserGearLoaded(
      gear: gear ?? this.gear,
      gearEdited: gearEdited ?? this.gearEdited,
      editMode: editMode ?? this.editMode,
    );
  }

  @override
  List<Object> get props => [gear, gearEdited, editMode];
}

/// Indicates that bloc is busy and should not be closed.
class UserGearBusy extends UserGearLoaded{
  const UserGearBusy({
    required super.gear,
    required super.gearEdited,
    required super.editMode,
  });

  @override
  UserGearBusy copyWith({
    Gear? gear,
    Gear? gearEdited,
    bool? editMode,
  }) {
    return UserGearBusy(
      gear: gear ?? this.gear,
      gearEdited: gearEdited ?? this.gearEdited,
      editMode: editMode ?? this.editMode,
    );
  }
}

/// Indicates to UI that page must be popped or replaced.
class UserGearDone extends UserGearState {}
