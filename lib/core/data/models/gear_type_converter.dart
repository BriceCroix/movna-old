import 'package:isar/isar.dart';
import 'package:movna/core/domain/entities/gear_type.dart';

/// Converts enum GearType to a type that Isar can Handle
class GearTypeConverter extends TypeConverter<GearType, String> {
  const GearTypeConverter(); // Converters need to have an empty const constructor

  @override
  GearType fromIsar(String object) {
    return GearType.values.byName(object);
  }

  @override
  String toIsar(GearType object) {
    return object.name;
  }
}