import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movna/core/domain/entities/gear.dart';
import 'package:movna/core/domain/entities/itinerary.dart';
import 'package:movna/core/domain/entities/track_point.dart';
import 'package:movna/core/domain/entities/sport.dart';

part 'activity.freezed.dart';

@freezed
class Activity with _$Activity {
  const Activity._();

  factory Activity({
    /// All the trackpoints of this activity.
    //TODO : replace by List<List<TrackPoint>> in order to know when pauses occurred
    @Default([]) List<TrackPoint> trackPoints,

    /// Optional name of this activity.
    String? name,

    /// Practiced sport.
    @Default(Sport.other) Sport sport,

    /// Datetime of beginning of activity.
    //@Default(DateTime(0)) // Datetime has no const constructor...
    required DateTime startTime,

    /// Datetime of end of activity.
    //@Default(DateTime(0)) // Datetime has no const constructor...
    required DateTime stopTime,

    /// Duration of activity.
    @Default(Duration.zero) Duration duration,

    /// Total distance in meters
    @Default(0) double distanceInMeters,

    /// Maximum speed reached during activity in kilometers per hour.
    @Default(0) double maxSpeedInKilometersPerHour,

    /// Optional itinerary this activity is supposed to follow
    Itinerary? itinerary,

    //TODO add either a member or a getter "energySpentInCalories" (if computable using only duration, distance, etc...

    /// Optional gear used during this activity
    Gear? gear,
  }) = _Activity;

  /// Average speed during activity.
  double get averageSpeedInKilometersPerHour {
    return duration.inSeconds != 0
        ? 3600 * 1e-3 * distanceInMeters / duration.inSeconds
        : 0;
  }
}
