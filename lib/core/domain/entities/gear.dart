import 'gear_type.dart';

/// A piece of gear usable by the user.
class Gear {
  /// Datetime of creation of this piece of gear.
  DateTime creationTime;

  /// Type of gear.
  GearType gearType;

  /// Name of this piece of gear.
  String name;

  /// Total distance ran with this piece of gear.
  double distanceInMeters;

  /// Total use duration of this piece of gear.
  Duration useTime;

  Gear(
      {required this.creationTime,
      required this.gearType,
      required this.name,
      double? distanceInMeters,
      Duration? useTime})
      : distanceInMeters = distanceInMeters ?? 0,
        useTime = useTime ?? Duration.zero;
}
