import 'package:isar/isar.dart';
import 'package:movna/core/data/models/gear_type_converter.dart';
import 'package:movna/core/domain/entities/gear.dart';
import 'package:movna/core/domain/entities/gear_type.dart';

import 'duration_converter.dart';

part 'gear_model.g.dart';

@Collection()
class GearModel {
  @Id()
  int id;
  DateTime creationTime;
  @DurationConverter()
  Duration localTimeOffset;
  @GearTypeConverter()
  GearType gearType;
  @Index()
  String name;
  double distanceInMeters;
  @DurationConverter()
  Duration useTime;

  GearModel({
    required this.creationTime,
    required this.localTimeOffset,
    required this.gearType,
    required this.name,
    required this.distanceInMeters,
    required this.useTime,
  }) : id = creationTime.microsecondsSinceEpoch;

  static GearModel fromGear(Gear gear) {
    return GearModel(
      creationTime: gear.creationTime,
      localTimeOffset: gear.creationTime.timeZoneOffset,
      gearType: gear.gearType,
      name: gear.name,
      distanceInMeters: gear.distanceInMeters,
      useTime: gear.useTime,
    );
  }

  Gear toGear() {
    return Gear(
      // TODO handle timezone
      creationTime: creationTime,
      gearType: gearType,
      name: name,
      distanceInMeters: distanceInMeters,
      useTime: useTime,
    );
  }
}
