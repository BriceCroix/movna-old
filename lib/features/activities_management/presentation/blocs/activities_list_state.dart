part of 'activities_list_bloc.dart';

abstract class ActivitiesListState extends Equatable {
  const ActivitiesListState();

  @override
  List<Object> get props => [];
}

class ActivitiesListInitial extends ActivitiesListState {}

class ActivitiesListLoaded extends ActivitiesListState {
  const ActivitiesListLoaded(
      {required this.activitiesList, required this.activitiesFilter});

  final List<Activity> activitiesList;
  final ActivitiesFilter activitiesFilter;

  @override
  List<Object> get props => [activitiesList, activitiesFilter];

  ActivitiesListLoaded copyWith({
    List<Activity>? activitiesList,
    ActivitiesFilter? activitiesFilter,
  }) {
    return ActivitiesListLoaded(
      activitiesList: activitiesList ?? this.activitiesList,
      activitiesFilter: activitiesFilter ?? this.activitiesFilter,
    );
  }
}
