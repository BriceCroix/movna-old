part of 'history_tab_bloc.dart';

abstract class HistoryTabState extends Equatable {
  const HistoryTabState();

  @override
  List<Object?> get props => [];
}

class HistoryTabInitial extends HistoryTabState {}

class HistoryTabLoaded extends HistoryTabState {
  final List<Activity> activities;

  const HistoryTabLoaded({required this.activities});

  HistoryTabLoaded copyWith({
    List<Activity>? activities,
  }) {
    return HistoryTabLoaded(
      activities: activities ?? this.activities,
    );
  }

  @override
  List<Object?> get props => [activities];
}
