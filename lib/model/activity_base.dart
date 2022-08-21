import 'package:movna/model/sport.dart';

class ActivityBase {
  String? name;

  Sport sport = Sport.other;
  DateTime startTime = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime stopTime = DateTime.fromMillisecondsSinceEpoch(0);
  Duration duration = Duration.zero;

  double distanceInMeters = 0.0;
  double averageSpeedInKilometersPerHour = 0.0;
  double maxSpeedInKilometersPerHour = 0.0;

  double energySpentInCalories = 0.0;

  /// Updates average speed using stored distance and duration.
  void updateAverageSpeed() {
    averageSpeedInKilometersPerHour = duration.inSeconds != 0
        ? 3600 * 1e-3 * distanceInMeters / duration.inSeconds
        : 0;
  }

  /// Updates average speed using available data
  void updateEnergySpent() {
    // See this https://en.wikipedia.org/wiki/Metabolic_equivalent_of_task
    //TODO
    energySpentInCalories = 0.0;
  }
}
