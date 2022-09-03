import 'package:isar/isar.dart';

/// Converts type Duration to a type that Isar can Handle
class DurationConverter extends TypeConverter<Duration, int> {
  const DurationConverter(); // Converters need to have an empty const constructor

  @override
  Duration fromIsar(int object) {
    return Duration(microseconds: object);
  }

  @override
  int toIsar(Duration object) {
    return object.inMicroseconds;
  }
}