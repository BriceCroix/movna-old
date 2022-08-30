import 'package:isar/isar.dart';
import 'package:movna/core/domain/entities/sport.dart';

/// Converts enum Sport to a type that Isar can Handle
class SportConverter extends TypeConverter<Sport, String> {
  const SportConverter(); // Converters need to have an empty const constructor

  @override
  Sport fromIsar(String object) {
    return Sport.values.byName(object);
  }

  @override
  String toIsar(Sport object) {
    return object.name;
  }
}