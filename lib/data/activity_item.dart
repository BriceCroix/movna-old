import 'package:isar/isar.dart';
import '../model/activity_base.dart';

part 'activity_item.g.dart';

@Collection()
class ActivityItem extends ActivityBase {
  /// Unique ID of this instance for the database
  @Id()
  int? id;
  /// Path to gps data file
  String? pathToFile;

  ActivityItem();

  ActivityItem.fromBase(ActivityBase other){
    sport = other.sport;
    startTime = other.startTime;
    stopTime = other.stopTime;
    duration = other.duration;
    distanceInMeters = other.distanceInMeters;
    averageSpeedInKilometersPerHour = other.averageSpeedInKilometersPerHour;
    energySpentInCalories = other.energySpentInCalories;
  }

  void updateId(){
    id = startTime.millisecondsSinceEpoch;
  }
}