import 'package:isar/isar.dart';
import 'package:movna/core/data/models/gear_type_converter.dart';
import 'package:movna/core/domain/entities/gear_type.dart';

part 'gear_model.g.dart';

@Collection()
class GearModel {
  @Id()
  int id;
  DateTime creationTime;
  int localTimeOffsetInMicroSeconds;
  @GearTypeConverter()
  GearType gearType;
  @Index()
  String name;
  double distanceInMeters;
  int useTimeInMicroSeconds;

  GearModel(
      {required this.creationTime,
      required this.localTimeOffsetInMicroSeconds,
      required this.gearType,
      required this.name,
      required this.distanceInMeters,
      required this.useTimeInMicroSeconds})
      : id = creationTime.microsecondsSinceEpoch;
}
