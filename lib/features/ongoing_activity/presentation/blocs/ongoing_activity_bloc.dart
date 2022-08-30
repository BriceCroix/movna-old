import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:injectable/injectable.dart';
import 'package:movna/core/domain/entities/activity.dart';
import 'package:movna/core/domain/entities/position.dart';
import 'package:movna/core/domain/entities/track_point.dart';
import 'package:movna/core/domain/usecases/save_activity.dart';
import 'package:movna/features/ongoing_activity/data/models/chronometer.dart';

part 'ongoing_activity_event.dart';

part 'ongoing_activity_state.dart';

@injectable
class OngoingActivityBloc
    extends Bloc<OngoingActivityEvent, OngoingActivityState> {
  final SaveActivity _saveActivity;
  final Chronometer _chronometer = Chronometer(value: Duration.zero);
  StreamSubscription<Duration>? _chronometerSubscription;

  OngoingActivityBloc(this._saveActivity)
      : super(
          OngoingActivityInitial(
            mapController: MapController(
              initMapWithUserPosition: true,
            ),
            activity: Activity(
              startTime: DateTime.now(),
              stopTime: DateTime.now(),
              trackPoints: [],
            ),
          ),
        ) {
    on<PauseEvent>(_onPauseEvent);
    on<StopEvent>(_onStopEvent);
    on<ResumeEvent>(_onResumeEvent);
    on<LockEvent>(_onLockEvent);
    on<UnlockEvent>(_onUnlockEvent);
    on<StartEvent>(_onStartEvent);
    on<NewLocationEvent>(_onNewLocationEvent);
    on<TimeIntervalElapsedEvent>(_onTimeIntervalElapsedEvent);
  }

  void _onPauseEvent(PauseEvent event, Emitter<OngoingActivityState> emit) {
    _chronometerSubscription?.pause();
    emit(state.copyWith(isPaused: true));
  }

  void _onStopEvent(StopEvent event, Emitter<OngoingActivityState> emit) {
    _chronometerSubscription?.cancel();
    // Save stopDate
    state.copyWith(activity: state.activity.copyWith(stopTime: DateTime.now()));
    _saveActivity(state.activity);
    // TODO : return to home page from bloc
  }

  void _onResumeEvent(ResumeEvent event, Emitter<OngoingActivityState> emit) {
    _chronometerSubscription?.resume();
    emit(state.copyWith(isPaused: false, isLocked: true));
  }

  void _onLockEvent(LockEvent event, Emitter<OngoingActivityState> emit) {
    emit(state.copyWith(isLocked: true));
  }

  void _onUnlockEvent(UnlockEvent event, Emitter<OngoingActivityState> emit) {
    emit(state.copyWith(isLocked: false));
  }

  void _onStartEvent(StartEvent event, Emitter<OngoingActivityState> emit) {
    _chronometerSubscription?.cancel();
    _chronometerSubscription = _chronometer.tick().listen(
        (duration) => add(TimeIntervalElapsedEvent(duration: duration)));
    emit(OngoingActivityRunningState(
      mapController: state.mapController,
      activity: state.activity.copyWith(startTime: DateTime.now()),
      isLocked: true,
      isPaused: false,
      lastTrackPoint: state.lastTrackPoint,
    ));
  }

  void _onTimeIntervalElapsedEvent(
      TimeIntervalElapsedEvent event, Emitter<OngoingActivityState> emit) {
    emit(state.copyWith(
      activity: state.activity.copyWith(
        duration: event.duration,
        stopTime: DateTime.now(),
      ),
    ));
  }

  void _onNewLocationEvent(
      NewLocationEvent event, Emitter<OngoingActivityState> emit) {
    TrackPoint newTrackpoint = TrackPoint(
      position: event.position,
      dateTime: DateTime.now(),
    );
    // Update speed value
    newTrackpoint = newTrackpoint.copyWith(
      speedInKilometersPerHour:
          newTrackpoint.speedInKilometersPerHourFrom(state.lastTrackPoint),
    );
    if (!state.isPaused) {
      emit(state.copyWith(
        activity: state.activity.copyWith(
          trackPoints: [...state.activity.trackPoints!, newTrackpoint],
          stopTime: newTrackpoint.dateTime!,
        ),
      ));
    }
  }
}
