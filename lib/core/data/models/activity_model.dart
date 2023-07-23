import 'package:isar/isar.dart';
import 'package:movna/core/data/models/duration_converter.dart';
import 'package:movna/core/data/models/gear_model.dart';
import 'package:movna/core/data/models/itinerary_model.dart';
import 'package:movna/core/data/models/list_list_track_point_model_converter.dart';
import 'package:movna/core/data/models/sport_converter.dart';
import 'package:movna/core/data/models/track_point_model.dart';
import 'package:movna/core/domain/entities/activity.dart';
import 'package:movna/core/domain/entities/sport.dart';

part 'activity_model.g.dart';

@Collection()
class ActivityModel {
  static const propertyIdName = 'id';

  /// Unique ID of this instance for the database.
  @Id()
  @Name(propertyIdName)
  int id;

  static const propertyStartTimeName = 'startTime';
  @Index()
  @Name(propertyStartTimeName)
  DateTime startTime;

  static const propertyStopTimeName = 'stopTime';
  @Index()
  @Name(propertyStopTimeName)
  DateTime stopTime;

  static const propertyLocalTimeOffsetName = 'localTimeOffset';

  /// Isar converts time to utc and returns them in local time.
  /// If I a want to store the 1/1/2000 at 12h in tz +1h,
  /// Isar will store the 1/1/2000 at 11h UTC.
  /// If I then load this from a +2 timezone, I will have the 1/1/2000 at 13h in +2 tz.
  /// In this case localTimeOffset is +1h in order to prevent this effect.
  @DurationConverter()
  @Name(propertyLocalTimeOffsetName)
  Duration localTimeOffset;

  static const propertyNameName = 'name';
  @Name(propertyNameName)
  String? name;

  static const propertySportName = 'sport';
  @SportConverter()
  @Name(propertySportName)
  Sport sport;

  static const propertyDurationName = 'duration';
  @DurationConverter()
  @Name(propertyDurationName)
  Duration duration;

  static const propertyDistanceInMetersName = 'distance';
  @Name(propertyDistanceInMetersName)
  double distanceInMeters;

  static const propertyMaxSpeedInKilometersPerHourName = 'maxSpeed';
  @Name(propertyMaxSpeedInKilometersPerHourName)
  double maxSpeedInKilometersPerHour;

  static const propertyTrackPointsName = 'trackPointsSegments';
  @ListListTrackPointModelConverter()
  @Name(propertyTrackPointsName)
  List<List<TrackPointModel>> trackPointsSegments;

  // Reference to other database tables
  static const propertyItineraryName = 'itinerary';
  @Name(propertyItineraryName)
  final itinerary = IsarLink<ItineraryModel>();

  static const propertyGearName = 'gear';
  @Name(propertyGearName)
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
    required this.trackPointsSegments,
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
      trackPointsSegments: activity.trackPointsSegments
          .map((segment) =>
              segment.map((e) => TrackPointModel.fromTrackPoint(e)).toList())
          .toList(),
      name: activity.name,
    );
    if (activity.itinerary != null) {
      model.itinerary.value = ItineraryModel.fromItinerary(activity.itinerary!);
    }
    if (activity.gear != null) {
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
      gear:
          (gear.isAttached && gear.value != null) ? gear.value!.toGear() : null,
      maxSpeedInKilometersPerHour: maxSpeedInKilometersPerHour,
      trackPointsSegments: trackPointsSegments
          .map((segment) => segment.map((e) => e.toTrackPoint()).toList())
          .toList(),
      itinerary: (itinerary.isAttached && itinerary.value != null)
          ? itinerary.value!.toItinerary()
          : null,
    );
  }
}
