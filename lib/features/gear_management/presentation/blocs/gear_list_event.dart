part of 'gear_list_bloc.dart';

abstract class GearListEvent extends Equatable {
  const GearListEvent();

  @override
  List<Object?> get props => [];
}

class GearPiecesLoaded extends GearListEvent {
  const GearPiecesLoaded({required this.gearPieces});

  final List<Gear> gearPieces;

  @override
  List<Object?> get props => [gearPieces];
}

/// Orders the bloc to reload its list of gear.
class RefreshGearPieces extends GearListEvent {}
