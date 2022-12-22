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
    required this.editMode,
  });

  /// The piece of gear currently stored.
  final Gear gear;

  /// Is the edit mode enabled or not.
  final bool editMode;

  UserGearLoaded copyWith({
    Gear? gear,
    bool? editMode,
  }) {
    return UserGearLoaded(
      gear: gear ?? this.gear,
      editMode: editMode ?? this.editMode,
    );
  }

  @override
  List<Object> get props => [gear, editMode];
}

/// Indicates to UI that page must be popped or replaced.
class UserGearDone extends UserGearState {}
