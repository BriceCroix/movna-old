part of 'past_activity_bloc.dart';

abstract class PastActivityState extends Equatable {
  const PastActivityState();

  @override
  List<Object?> get props => [];
}

class PastActivityInitial extends PastActivityState {
  const PastActivityInitial();
}

class PastActivityLoading extends PastActivityState {
  const PastActivityLoading({
    this.activity,
    this.position,
  });

  /// Activity represented by this state.
  final Activity? activity;

  /// Current user position.
  final Position? position;

  PastActivityLoading copyWith({
    Activity? activity,
    Position? position,
  }) {
    return PastActivityLoading(
      activity: activity ?? this.activity,
      position: position ?? this.position,
    );
  }

  @override
  List<Object?> get props => [activity, position];
}

class PastActivityLoaded extends PastActivityState {
  const PastActivityLoaded({
    required this.activity,
    required this.position,
  });

  /// Activity represented by this state.
  final Activity activity;

  /// Current user position.
  final Position? position;

  PastActivityLoaded copyWith({
    Activity? activity,
    Position? position,
  }) {
    return PastActivityLoaded(
      activity: activity ?? this.activity,
      position: position ?? this.position,
    );
  }

  @override
  List<Object?> get props => [activity, position];
}

class PastActivityDone extends PastActivityState {}
