part of 'history_tab_bloc.dart';

abstract class HistoryTabEvent extends Equatable {
  const HistoryTabEvent();

  @override
  List<Object?> get props => [];
}

/// New list of activities received.
class ActivitiesLoaded extends HistoryTabEvent{
  final List<Activity> activities;

  const ActivitiesLoaded(this.activities);

  @override
  List<Object?> get props => [activities];
}

/// List of activities must be refreshed.
class RefreshActivities extends HistoryTabEvent{}