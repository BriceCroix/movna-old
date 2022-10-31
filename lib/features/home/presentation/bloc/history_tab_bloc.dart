import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:movna/core/domain/entities/activity.dart';
import 'package:movna/core/domain/usecases/get_activities.dart';

part 'history_tab_event.dart';

part 'history_tab_state.dart';

@Injectable()
class HistoryTabBloc extends Bloc<HistoryTabEvent, HistoryTabState> {
  final GetActivities getActivities;

  /// Number of activities fetched by this bloc.
  static const int _activitiesCount = 10;

  HistoryTabBloc({
    required this.getActivities,
  }) : super(HistoryTabInitial()) {
    on<ActivitiesLoaded>(_onActivitiesLoaded);
    on<RefreshActivities>(_onRefreshActivities);

    add(RefreshActivities());
  }

  void _onActivitiesLoaded(
      ActivitiesLoaded event, Emitter<HistoryTabState> emit) {
    if (state is HistoryTabInitial) {
      emit(HistoryTabLoaded(activities: event.activities));
    } else if (state is HistoryTabLoaded) {
      emit((state as HistoryTabLoaded).copyWith(activities: event.activities));
    }
  }

  void _onRefreshActivities(
      RefreshActivities event, Emitter<HistoryTabState> emit) {
    getActivities(_activitiesCount)
        .then((value) => add(ActivitiesLoaded(value)));
  }
}
