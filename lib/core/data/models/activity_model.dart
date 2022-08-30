import 'package:isar/isar.dart';
import 'package:movna/core/data/models/gear_model.dart';
import 'package:movna/core/data/models/itinerary_model.dart';
import 'package:movna/core/data/models/sport_converter.dart';
import 'package:movna/core/domain/entities/sport.dart';

part 'activity_model.g.dart';

@Collection()
class ActivityModel {
  /// Unique ID of this instance for the database.
  @Id()
  int? id;
  @Index()
  DateTime startTime;
  DateTime stopTime;

  /// Isar converts time to utc and returns them in local time.
  /// If I a want to store the 1/1/2000 at 12h in tz +1h,
  /// Isar will store the 1/1/2000 at 11h UTC.
  /// If I then load this from a +2 timezone, I will have the 1/1/2000 at 13h in +2 tz.
  /// In this case localTimeOffset is +1h in order to prevent this effect.
  int localTimeOffsetInMicroSeconds;
  String? name;
  @SportConverter()
  Sport sport;
  int durationInMicroSeconds;
  double distanceInMeters;
  double maxSpeedInKilometersPerHour;
  String? pathToFile;

  // Reference to other tables
  final itinerary = IsarLink<ItineraryModel>();
  final gear = IsarLink<GearModel>();

  ActivityModel(
      {required this.startTime,
      required this.stopTime,
      required this.localTimeOffsetInMicroSeconds,
      required this.durationInMicroSeconds,
      this.name,
      required this.sport,
      required this.distanceInMeters,
      required this.maxSpeedInKilometersPerHour,
      this.pathToFile})
      : id = startTime.microsecondsSinceEpoch;
}
