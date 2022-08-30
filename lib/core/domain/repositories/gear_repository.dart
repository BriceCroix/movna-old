import 'package:movna/core/domain/entities/gear.dart';
import 'package:movna/core/typedefs.dart';

abstract class GearRepository {
  /// Save a piece of [gear] to disk.
  Future<ErrorState> saveGear(Gear gear);

  /// Get all pieces of gear stored on disk,
  Future<List<Gear>> getAllGear();

  /// Get one specific piece of gear using its [creationTime] property.
  Future<Gear> getGear(
      {required DateTime creationTime});
}
