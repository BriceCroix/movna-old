import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movna/core/domain/entities/sport.dart';

part 'settings.freezed.dart';

@freezed
class Settings with _$Settings {
  const factory Settings({
    // OngoingActivitySettings -------------------------------------------------
    /// The activation of the automatic pause functionality during an activity.
    required bool automaticPause,

    /// The sport to be practiced during an activity.
    required Sport sport,
    // /// Is the vocal coach enabled.
    // @Default(false) bool vocalCoach,
    // /// The map to be showed on screen on all pages.
    // required MapTileLayer mapTileLayer,

    // User profile ------------------------------------------------------------
    /// Name of user.
    required String userName,

    /// Height of user in meters.
    required double userHeightInMeters,

    /// Weight of user in kilograms.
    required double userWeightInKilograms,

    /// Gender of user.
    required Gender userGender,

    // // Power usage -------------------------------------------------------------
    // /// Should the screen stay on during an activity.
    // @Default(true) bool keepScreenOnDuringActivity,

    // Miscellaneous -----------------------------------------------------------
    // /// Maximum speed in kilometers per hour to use when showing an activity
    // /// speeds on the map.
    // @Default(50) double maxSpeedReferenceInKilometersPerHour,

    /// The minimum speed under which the user is considered immobile to
    /// activate the automatic pause feature.
    required double automaticPauseThresholdSpeedInKilometersPerHour,

    // /// The preferred type of units.
    // @Default(UnitType.metric) UnitType unitType,

    /// Should the screen automatically lock itself during an activity.
    required bool automaticLock,

    /// The duration without user input to lock the screen during an activity.
    required Duration automaticLockThresholdDurationWithoutInput,
  }) = _Settings;
}

enum MapTileLayer { openStreetMap, cyclOSM, publicTransportation }

enum Gender { male, female, undefined }

enum UnitType { metric, imperial }
