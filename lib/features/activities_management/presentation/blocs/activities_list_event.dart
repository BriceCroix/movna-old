part of 'activities_list_bloc.dart';

abstract class ActivitiesListEvent extends Equatable {
  const ActivitiesListEvent();

  @override
  List<Object?> get props => [];
}

class ActivitiesLoaded extends ActivitiesListEvent {
  const ActivitiesLoaded({required this.activities});

  final List<Activity> activities;

  @override
  List<Object?> get props => [activities];
}

class ActivitiesFilterChanged extends ActivitiesListEvent {
  const ActivitiesFilterChanged(this.activitiesFilter);

  final ActivitiesFilter activitiesFilter;

  @override
  List<Object?> get props => [activitiesFilter];
}

/// Orders the bloc to reload its list of activities.
class RefreshActivities extends ActivitiesListEvent {}
