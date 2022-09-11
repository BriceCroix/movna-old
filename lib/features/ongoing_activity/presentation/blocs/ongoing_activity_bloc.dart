import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:movna/core/domain/entities/activity.dart';
import 'package:movna/core/domain/entities/position.dart';
import 'package:movna/core/domain/entities/settings.dart';
import 'package:movna/core/domain/entities/track_point.dart';
import 'package:movna/core/domain/usecases/get_position.dart';
import 'package:movna/core/domain/usecases/get_position_stream.dart';
import 'package:movna/core/domain/usecases/get_settings.dart';
import 'package:movna/core/domain/usecases/save_activity.dart';
import 'package:movna/core/domain/usecases/save_settings.dart';
import 'package:movna/features/ongoing_activity/data/models/chronometer.dart';

part 'ongoing_activity_event.dart';

part 'ongoing_activity_state.dart';

@injectable
class OngoingActivityBloc
    extends Bloc<OngoingActivityEvent, OngoingActivityState> {
  final SaveActivity _saveActivity;
  final GetSettings _getSettings;
  final SaveSettings _saveSettings;
  final GetPosition _getPosition;
  final GetPositionStream _getPositionStream;
  StreamSubscription<Duration>? _durationSubscription;

  OngoingActivityBloc(
    this._saveActivity,
    this._getSettings,
    this._saveSettings,
    this._getPosition,
    this._getPositionStream,
  ) : super(const OngoingActivityInitial()) {
    on<SettingsLoaded>(_onSettingsLoaded);
    on<LocationLoaded>(_onLocationLoaded);
    on<PauseEvent>(_onPauseEvent);
    on<StopEvent>(_onStopEvent);
    on<ResumeEvent>(_onResumeEvent);
    on<LockEvent>(_onLockEvent);
    on<UnlockEvent>(_onUnlockEvent);
    on<StartEvent>(_onStartEvent);
    on<PositionChangedEvent>(_onPositionChangedEvent);
    on<TimeIntervalElapsedEvent>(_onTimeIntervalElapsedEvent);

    _getSettings().then((settings) => add(SettingsLoaded(settings: settings)));
    _getPosition().then((position) => add(LocationLoaded(position: position)));

    _getPositionStream().then((stream) {
      stream.listen((event) => add(PositionChangedEvent(position: event)));
    });
  }

  void _onSettingsLoaded(
      SettingsLoaded event, Emitter<OngoingActivityState> emit) {
    final Settings settings = event.settings;
    if (state is OngoingActivityInitial) {
      emit(OngoingActivityLoading(settings: settings));
    } else if (state is OngoingActivityLoading) {
      OngoingActivityLoading stateLoading = state as OngoingActivityLoading;
      emit(stateLoading.copyWith(settings: settings));
      add(StartEvent());
      // If more than two fields to load in the future, add an if to check
      // what fields are loaded
    }
  }

  void _onLocationLoaded(
      LocationLoaded event, Emitter<OngoingActivityState> emit) {
    final Position position = event.position;
    if (state is OngoingActivityInitial) {
      emit(OngoingActivityLoading(position: position));
    } else if (state is OngoingActivityLoading) {
      OngoingActivityLoading stateLoading = state as OngoingActivityLoading;
      emit(stateLoading.copyWith(position: position));
      add(StartEvent());
      // If more than two fields to load in the future, add an if to check
      // what fields are loaded
    }
  }

  void _onPauseEvent(PauseEvent event, Emitter<OngoingActivityState> emit) {
    if (state is OngoingActivityLoaded) {
      OngoingActivityLoaded stateLoaded = state as OngoingActivityLoaded;
      _durationSubscription?.pause();
      emit(stateLoaded.copyWith(isPaused: true));
    }
  }

  void _onStopEvent(StopEvent event, Emitter<OngoingActivityState> emit) {
    if (state is OngoingActivityLoaded) {
      OngoingActivityLoaded stateLoaded = state as OngoingActivityLoaded;
      _durationSubscription?.cancel();
      // Save activity with accurate stopDate
      _saveActivity(stateLoaded.activity.copyWith(stopTime: DateTime.now()));
      // TODO : return to home page from bloc
    }
  }

  void _onResumeEvent(ResumeEvent event, Emitter<OngoingActivityState> emit) {
    if (state is OngoingActivityLoaded) {
      OngoingActivityLoaded stateLoaded = state as OngoingActivityLoaded;
      _durationSubscription?.resume();
      emit(stateLoaded.copyWith(isPaused: false, isLocked: true));
    }
  }

  void _onLockEvent(LockEvent event, Emitter<OngoingActivityState> emit) {
    if (state is OngoingActivityLoaded) {
      OngoingActivityLoaded stateLoaded = state as OngoingActivityLoaded;
      emit(stateLoaded.copyWith(isLocked: true));
    }
  }

  void _onUnlockEvent(UnlockEvent event, Emitter<OngoingActivityState> emit) {
    if (state is OngoingActivityLoaded) {
      OngoingActivityLoaded stateLoaded = state as OngoingActivityLoaded;
      emit(stateLoaded.copyWith(isLocked: false));
    }
  }
  //TODO handle autolock by starting a chronometer when unlocking, then push a lock event if nothing happens after that

  void _onStartEvent(StartEvent event, Emitter<OngoingActivityState> emit) {
    if (state is OngoingActivityLoading) {
      OngoingActivityLoading stateLoading = state as OngoingActivityLoading;
      _durationSubscription?.cancel();
      _durationSubscription = Chronometer(value: Duration.zero).tick().listen(
          (duration) => add(TimeIntervalElapsedEvent(duration: duration)));
      DateTime now = DateTime.now();
      emit(
        OngoingActivityLoaded(
          settings: stateLoading.settings!,
          activity: Activity(startTime: now, stopTime: DateTime(0)),
          isLocked: true,
          isPaused: false,
          lastTrackPoint: TrackPoint(
            dateTime: now,
            position: stateLoading.position!,
          ),
        ),
      );
    }
  }

  void _onTimeIntervalElapsedEvent(
      TimeIntervalElapsedEvent event, Emitter<OngoingActivityState> emit) {
    if (state is OngoingActivityLoaded) {
      OngoingActivityLoaded stateLoaded = state as OngoingActivityLoaded;
      emit(
        stateLoaded.copyWith(
          activity: stateLoaded.activity.copyWith(duration: event.duration),
        ),
      );
    }
  }

  void _onPositionChangedEvent(
      PositionChangedEvent event, Emitter<OngoingActivityState> emit) {
    //TODO : start a chronometer to measure time without position change
    if (state is OngoingActivityLoaded) {
      OngoingActivityLoaded stateLoaded = state as OngoingActivityLoaded;

      // Create new trackpoint
      TrackPoint newTrackpoint = TrackPoint(
        position: event.position,
        dateTime: DateTime.now(),
      );

      // Update speed value
      double? speedInKmPerHour = newTrackpoint
          .speedInKilometersPerHourFrom(stateLoaded.lastTrackPoint);
      newTrackpoint = newTrackpoint.copyWith(
        speedInKilometersPerHour: speedInKmPerHour,
      );

      // Only update activity if not paused
      Activity newActivity = (!stateLoaded.isPaused)
          ? stateLoaded.activity.copyWith(
              trackPoints: [...stateLoaded.activity.trackPoints, newTrackpoint])
          : stateLoaded.activity;

      // Handle automatic pause is activated
      late bool newIsPaused;
      if(stateLoaded.settings.automaticPause && speedInKmPerHour != null){
        newIsPaused = speedInKmPerHour < stateLoaded.settings.automaticPauseThresholdSpeedInKilometersPerHour;
        if(newIsPaused && !stateLoaded.isPaused){
          add(PauseEvent());
        }
      }else{
        newIsPaused = stateLoaded.isPaused;
      }


      // Finally emit state
      emit(stateLoaded.copyWith(
        activity: newActivity,
        lastTrackPoint: newTrackpoint,
        isPaused: newIsPaused,
      ));
    }
  }
}
