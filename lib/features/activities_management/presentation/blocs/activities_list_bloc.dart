import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:movna/core/domain/entities/activities_filter.dart';
import 'package:movna/core/domain/entities/activity.dart';
import 'package:movna/core/domain/usecases/get_activities.dart';

part 'activities_list_event.dart';

part 'activities_list_state.dart';

@injectable
class ActivitiesListBloc
    extends Bloc<ActivitiesListEvent, ActivitiesListState> {
  final GetActivities getActivities;

  ActivitiesListBloc({
    required this.getActivities,
  }) : super(ActivitiesListInitial()) {
    on<ActivitiesLoaded>(_onActivitiesLoaded);
    on<ActivitiesFilterChanged>(_onActivitiesFilterChanged);
    on<RefreshActivities>(_onRefreshActivities);

    getActivities().then((value) => add(ActivitiesLoaded(activities: value)));
  }

  @override
  Future<void> close() {
    return super.close();
  }

  void _onActivitiesLoaded(
    ActivitiesLoaded event,
    Emitter<ActivitiesListState> emit,
  ) {
    if (state is ActivitiesListInitial) {
      emit(ActivitiesListLoaded(
        activitiesList: event.activities,
        activitiesFilter: const ActivitiesFilter(),
      ));
    } else if (state is ActivitiesListLoaded) {
      emit((state as ActivitiesListLoaded)
          .copyWith(activitiesList: event.activities));
    }
  }

  void _onRefreshActivities(
    RefreshActivities event,
    Emitter<ActivitiesListState> emit,
  ) {
    getActivities().then((value) => add(ActivitiesLoaded(activities: value)));
  }

  void _onActivitiesFilterChanged(
    ActivitiesFilterChanged event,
    Emitter<ActivitiesListState> emit,
  ) async {
    if (state is ActivitiesListLoaded) {
      var newActivities = await getActivities(event.activitiesFilter);
      emit((state as ActivitiesListLoaded).copyWith(
        activitiesFilter: event.activitiesFilter,
        activitiesList: newActivities,
      ));
    }
  }
}
