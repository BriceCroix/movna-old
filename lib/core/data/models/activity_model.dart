import 'package:isar/isar.dart';
import 'package:movna/core/data/models/duration_converter.dart';
import 'package:movna/core/data/models/gear_model.dart';
import 'package:movna/core/data/models/itinerary_model.dart';
import 'package:movna/core/data/models/list_track_point_model_converter.dart';
import 'package:movna/core/data/models/sport_converter.dart';
import 'package:movna/core/data/models/track_point_model.dart';
import 'package:movna/core/domain/entities/activity.dart';
import 'package:movna/core/domain/entities/sport.dart';

part 'activity_model.g.dart';

@Collection()
class ActivityModel {
  /// Unique ID of this instance for the database.
  @Id()
  int id;
  @Index()
  DateTime startTime;
  DateTime stopTime;

  /// Isar converts time to utc and returns them in local time.
  /// If I a want to store the 1/1/2000 at 12h in tz +1h,
  /// Isar will store the 1/1/2000 at 11h UTC.
  /// If I then load this from a +2 timezone, I will have the 1/1/2000 at 13h in +2 tz.
  /// In this case localTimeOffset is +1h in order to prevent this effect.
  @DurationConverter()
  Duration localTimeOffset;
  String? name;
  @SportConverter()
  Sport sport;
  @DurationConverter()
  Duration duration;
  double distanceInMeters;
  double maxSpeedInKilometersPerHour;

  @ListTrackPointModelConverter()
  List<TrackPointModel> trackPoints;

  // Reference to other database tables
  final itinerary = IsarLink<ItineraryModel>();
  final gear = IsarLink<GearModel>();

  ActivityModel({
    required this.startTime,
    required this.stopTime,
    required this.localTimeOffset,
    required this.duration,
    this.name,
    required this.sport,
    required this.distanceInMeters,
    required this.maxSpeedInKilometersPerHour,
    required this.trackPoints,
  }) : id = startTime.microsecondsSinceEpoch;

  static ActivityModel fromActivity(Activity activity) {
    ActivityModel model = ActivityModel(
      startTime: activity.startTime,
      stopTime: activity.stopTime,
      localTimeOffset: activity.startTime.timeZoneOffset,
      duration: activity.duration,
      sport: activity.sport,
      distanceInMeters: activity.distanceInMeters,
      maxSpeedInKilometersPerHour: activity.maxSpeedInKilometersPerHour,
      trackPoints: activity.trackPoints
          .map((e) => TrackPointModel.fromTrackPoint(e))
          .toList(),
      name: activity.name,
    );
    if(activity.itinerary != null) {
      model.itinerary.value = ItineraryModel.fromItinerary(activity.itinerary!);
    }
    if(activity.gear != null) {
      model.gear.value = GearModel.fromGear(activity.gear!);
    }
    return model;
  }

  Activity toActivity() {
    return Activity(
      name: name,
      sport: sport,
      // TODO : handle timezone
      startTime: startTime,
      stopTime: stopTime,
      distanceInMeters: distanceInMeters,
      duration: duration,
      gear: (gear.isAttached && gear.value != null)
          ? gear.value!.toGear()
          : null,
      maxSpeedInKilometersPerHour: maxSpeedInKilometersPerHour,
      trackPoints: trackPoints.map((e) => e.toTrackPoint()).toList(),
      itinerary: (itinerary.isAttached && itinerary.value != null)
          ? itinerary.value!.toItinerary()
          : null,
    );
  }
}
