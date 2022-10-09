part of 'gear_list_bloc.dart';

abstract class GearListState extends Equatable {
  const GearListState();

  @override
  List<Object> get props => [];
}

class GearListInitial extends GearListState {}

class GearListLoaded extends GearListState {
  const GearListLoaded({required this.gearList});

  final List<Gear> gearList;

  @override
  List<Object> get props => [gearList];

  GearListLoaded copyWith({
    List<Gear>? gearList,
  }) {
    return GearListLoaded(
      gearList: gearList ?? this.gearList,
    );
  }
}
