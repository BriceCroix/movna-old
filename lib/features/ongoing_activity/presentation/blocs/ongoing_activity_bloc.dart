import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:movna/core/domain/entities/activity.dart';
import 'package:movna/core/domain/entities/ongoing_activity_settings.dart';
import 'package:movna/core/domain/entities/settings.dart';
import 'package:movna/core/domain/entities/track_point.dart';
import 'package:movna/core/domain/usecases/get_settings.dart';
import 'package:movna/core/domain/usecases/save_activity.dart';
import 'package:movna/features/ongoing_activity/data/models/chronometer.dart';
import 'package:movna/features/ongoing_activity/domain/entities/pause_status.dart';
import 'package:movna/features/ongoing_activity/domain/usecases/get_track_point.dart';
import 'package:movna/features/ongoing_activity/domain/usecases/get_track_point_stream.dart';
import 'package:movna/features/ongoing_activity/presentation/widgets/ongoing_activity_page.dart';

part 'ongoing_activity_event.dart';

part 'ongoing_activity_state.dart';

@injectable
class OngoingActivityBloc
    extends Bloc<OngoingActivityEvent, OngoingActivityState> {
  final SaveActivity _saveActivity;
  final GetSettings _getSettings;
  final GetTrackPoint _getTrackPoint;
  final GetTrackPointStream _getTrackPointStream;

  /// Stream yielding activity duration.
  StreamSubscription<Duration>? _durationSubscription;

  /// Stream yielding user trackpoints.
  StreamSubscription<TrackPoint>? _trackPointSubscription;

  /// Countdown timer, automatic lock pushed when duration is out.
  Timer? _automaticLockTimer;

  /// Countdown timer, automatic pause pushed when duration is out.
  Timer? _automaticPauseTimer;

  /// The duration at the end of which a trackpoint is requested to update position.
  static const Duration _maxDurationWithoutMovement = Duration(seconds: 2);

  OngoingActivityBloc(
    this._saveActivity,
    this._getSettings,
    this._getTrackPoint,
    this._getTrackPointStream,
  ) : super(const OngoingActivityInitial()) {
    on<SettingsLoaded>(_onSettingsLoaded);
    on<MapReadyEvent>(_onMapReadyEvent);
    on<PauseStatusChangedEvent>(_onPauseStatusChangedEvent);
    on<StopEvent>(_onStopEvent);
    on<LockEvent>(_onLockEvent);
    on<UnlockEvent>(_onUnlockEvent);
    on<StartEvent>(_onStartEvent);
    on<NewTrackPointEvent>(_onNewTrackPointEvent);
    on<TimeIntervalElapsedEvent>(_onTimeIntervalElapsedEvent);
    on<ParametersGiven>(_onParametersGiven);

    _getSettings().then((settings) => add(SettingsLoaded(settings: settings)));
    _requestTrackPoint();

    _getTrackPointStream().then((stream) {
      _trackPointSubscription = stream.listen(
          (trackPoint) => add(NewTrackPointEvent(trackPoint: trackPoint)));
    });
  }

  @override
  Future<void> close() {
    _trackPointSubscription?.cancel();
    _durationSubscription?.cancel();
    return super.close();
  }

  void _onParametersGiven(
    ParametersGiven event,
    Emitter<OngoingActivityState> emit,
  ) {
    final params = event.pageParams;
    if (state is OngoingActivityInitial) {
      emit(OngoingActivityLoading(
          ongoingActivitySettings: params.ongoingActivitySettings));
    } else if (state is OngoingActivityLoading) {
      final stateLoading = state as OngoingActivityLoading;
      emit(stateLoading.copyWith(
          ongoingActivitySettings: params.ongoingActivitySettings));
      _checkLoadingState(emit);
    }
  }

  void _onSettingsLoaded(
    SettingsLoaded event,
    Emitter<OngoingActivityState> emit,
  ) {
    final settings = event.settings;
    if (state is OngoingActivityInitial) {
      emit(OngoingActivityLoading(settings: settings));
    } else if (state is OngoingActivityLoading) {
      OngoingActivityLoading stateLoading = state as OngoingActivityLoading;
      emit(stateLoading.copyWith(settings: settings));
      _checkLoadingState(emit);
    }
  }

  void _onMapReadyEvent(
    MapReadyEvent event,
    Emitter<OngoingActivityState> emit,
  ) {
    if (state is OngoingActivityLoaded) {
      final stateLoaded = state as OngoingActivityLoaded;
      emit(stateLoaded.copyWith(isMapReady: true));
    }
  }

  void _onPauseStatusChangedEvent(
      PauseStatusChangedEvent event, Emitter<OngoingActivityState> emit) {
    if (state is OngoingActivityLoaded) {
      OngoingActivityLoaded stateLoaded = state as OngoingActivityLoaded;
      OngoingActivityLoaded newState =
          stateLoaded.copyWith(pauseStatus: event.pauseStatus);
      if (newState.isPaused) {
        _durationSubscription?.pause();
        _cancelAutomaticLockTimer();
        _cancelAutomaticPauseTimer();
      } else {
        // On resume, add a new trackPoint segment to activity
        Activity newActivity = stateLoaded.activity.copyWith(
          trackPointsSegments: [
            ...stateLoaded.activity.trackPointsSegments,
            [stateLoaded.lastTrackPoint]
          ],
        );
        newState = newState.copyWith(isLocked: true, activity: newActivity);
        _durationSubscription?.resume();
        _resetAutomaticPauseTimer();
      }
      emit(newState);
    }
  }

  void _onStopEvent(StopEvent event, Emitter<OngoingActivityState> emit) {
    if (state is OngoingActivityLoaded) {
      OngoingActivityLoaded stateLoaded = state as OngoingActivityLoaded;
      _durationSubscription?.cancel();
      _trackPointSubscription?.cancel();
      // Save activity with accurate stopDate
      Activity activityDone =
          stateLoaded.activity.copyWith(stopTime: DateTime.now());
      _saveActivity(activityDone);
      _cancelAutomaticLockTimer();
      _cancelAutomaticPauseTimer();

      emit(OngoingActivityDone(activity: activityDone));
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
      _resetAutomaticLockTimer();
    }
  }

  void _onStartEvent(StartEvent event, Emitter<OngoingActivityState> emit) {
    if (state is OngoingActivityLoading) {
      final stateLoading = state as OngoingActivityLoading;
      _durationSubscription?.cancel();
      _durationSubscription = Chronometer(value: Duration.zero).tick().listen(
          (duration) => add(TimeIntervalElapsedEvent(duration: duration)));
      emit(
        OngoingActivityLoaded(
          settings: stateLoading.settings!,
          activity: Activity(
            startTime: stateLoading.trackPoint!.dateTime!,
            stopTime: DateTime(0),
            sport: stateLoading.settings!.sport,
            trackPointsSegments: <TrackPointsSegment>[
              [stateLoading.trackPoint!]
            ],
            itinerary: stateLoading.ongoingActivitySettings!.itinerary,
          ),
          isLocked: true,
          pauseStatus: PauseStatus.running,
          lastTrackPoint: stateLoading.trackPoint!,
        ),
      );
      _resetAutomaticPauseTimer();
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

  void _onNewTrackPointEvent(
      NewTrackPointEvent event, Emitter<OngoingActivityState> emit) {
    if (state is OngoingActivityInitial) {
      emit(OngoingActivityLoading(trackPoint: event.trackPoint));
    } else if (state is OngoingActivityLoading) {
      OngoingActivityLoading stateLoading = state as OngoingActivityLoading;
      emit(stateLoading.copyWith(trackPoint: event.trackPoint));
      _checkLoadingState(emit);
    } else if (state is OngoingActivityLoaded) {
      OngoingActivityLoaded stateLoaded = state as OngoingActivityLoaded;

      TrackPoint newTrackPoint = event.trackPoint;

      // Update speed value if missing
      if (newTrackPoint.speedInKilometersPerHour == null) {
        double? speedInKmPerHour = newTrackPoint
            .speedInKilometersPerHourFrom(stateLoaded.lastTrackPoint);
        newTrackPoint = newTrackPoint.copyWith(
          speedInKilometersPerHour: speedInKmPerHour,
        );
      }

      // Handle automatic pause if activated
      if (stateLoaded.settings.automaticPause &&
          newTrackPoint.speedInKilometersPerHour != null) {
        bool shouldBePaused = newTrackPoint.speedInKilometersPerHour! <
            stateLoaded
                .settings.automaticPauseThresholdSpeedInKilometersPerHour;
        if (shouldBePaused && !stateLoaded.isPaused) {
          add(const PauseStatusChangedEvent(
              pauseStatus: PauseStatus.pausedAutomatically));
        } else if (!shouldBePaused &&
            stateLoaded.pauseStatus == PauseStatus.pausedAutomatically) {
          add(const PauseStatusChangedEvent(pauseStatus: PauseStatus.running));
        }
      }

      // Only update activity if not paused
      late Activity newActivity;
      if (!stateLoaded.isPaused) {
        // Compute distance
        double lastDistance = newTrackPoint.position!
            .distanceInMetersFrom(stateLoaded.lastTrackPoint.position!);
        double totalDistance =
            stateLoaded.activity.distanceInMeters + lastDistance;
        newActivity = stateLoaded.activity.copyWith(
          // Add new trackpoint to last segment
          trackPointsSegments: [
            ...stateLoaded.activity.trackPointsSegments.sublist(
                0, stateLoaded.activity.trackPointsSegments.length - 1),
            [...stateLoaded.activity.trackPointsSegments.last, newTrackPoint]
          ],
          distanceInMeters: totalDistance,
        );
      } else {
        newActivity = stateLoaded.activity;
      }

      // Reset the timer that ultimately requests new TrackPoints
      _resetAutomaticPauseTimer();

      // Finally emit state
      emit(stateLoaded.copyWith(
        activity: newActivity,
        lastTrackPoint: newTrackPoint,
      ));
    }
  }

  /// Resets the automatic lock timer according to user settings.
  void _resetAutomaticLockTimer() {
    if (state is OngoingActivityLoaded) {
      OngoingActivityLoaded stateLoaded = state as OngoingActivityLoaded;
      if (stateLoaded.settings.automaticLock) {
        _automaticLockTimer?.cancel();
        _automaticLockTimer = Timer(
          stateLoaded.settings.automaticLockThresholdDurationWithoutInput,
          () => add(LockEvent()),
        );
      }
    }
  }

  /// Cancels the automatic lock timer if started.
  void _cancelAutomaticLockTimer() {
    _automaticLockTimer?.cancel();
  }

  /// Resets the automatic pause timer according to user settings.
  void _resetAutomaticPauseTimer() {
    if (state is OngoingActivityLoaded) {
      OngoingActivityLoaded stateLoaded = state as OngoingActivityLoaded;
      if (stateLoaded.settings.automaticPause) {
        _automaticPauseTimer?.cancel();
        _automaticPauseTimer =
            Timer(_maxDurationWithoutMovement, () => _requestTrackPoint());
      }
    }
  }

  /// Cancels the automatic pause timer if started.
  void _cancelAutomaticPauseTimer() {
    _automaticPauseTimer?.cancel();
  }

  /// Request a TrackPoint update to push a NewTrackPointEvent.
  void _requestTrackPoint() {
    _getTrackPoint()
        .then((trackPoint) => add(NewTrackPointEvent(trackPoint: trackPoint)));
  }

  /// Checks if all the fields of loading state are loaded to add start event.
  void _checkLoadingState(Emitter<OngoingActivityState> emit) {
    if (state is OngoingActivityLoading) {
      final stateLoading = state as OngoingActivityLoading;
      if (stateLoading.ongoingActivitySettings != null &&
          stateLoading.settings != null &&
          stateLoading.trackPoint != null) {
        add(StartEvent());
      }
    }
  }
}
