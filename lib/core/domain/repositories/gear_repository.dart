import 'package:movna/core/domain/entities/gear.dart';
import 'package:movna/core/typedefs.dart';

abstract class GearRepository {
  /// Save a piece of [gear] to disk.
  Future<ErrorState> saveGear(Gear gear);

  /// Delete a piece of [gear] from disk.
  Future<ErrorState> deleteGear(Gear gear);

  /// Get all pieces of gear stored on disk, with a maximum of [maxCount] elements.
  Future<List<Gear>> getGear([int? maxCount]);

  /// Get number of gear pieces stored on disk.
  Future<int> getGearCount();
}
