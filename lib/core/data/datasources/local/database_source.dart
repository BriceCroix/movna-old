import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:movna/core/data/models/activity_model.dart';
import 'package:movna/core/data/models/gear_model.dart';
import 'package:movna/core/data/models/itinerary_model.dart';
import 'package:path_provider/path_provider.dart';

@Injectable()
class DataBaseSource {
  /// Returns Isar schema for the activity models. Must be closed after use.
  Future<Isar> _openIsar() async {
    Directory dir = await getApplicationDocumentsDirectory();

    return Isar.open(
      schemas: [ActivityModelSchema, GearModelSchema, ItineraryModelSchema],
      directory: dir.path,
    );
  }

  /// Returns activity models sorted by start time.
  Future<List<ActivityModel>> getActivities([int? maxCount]) async {
    final isar = await _openIsar();

    Future<List<ActivityModel>> res = maxCount != null
        ? isar.activityModels
            .where()
            .sortByStartTimeDesc()
            .limit(maxCount)
            .findAll()
        : isar.activityModels.where().sortByStartTimeDesc().findAll();

    isar.close();

    return res;
  }

  Future<void> saveActivityToDatabase(ActivityModel model) async {
    final isar = await _openIsar();
    await isar.writeTxn((isar) async {
      await isar.activityModels.put(model);
    });
    isar.close();
  }

  /// Returns gear models sorted by name.
  Future<List<GearModel>> getGear([int? maxCount]) async {
    final isar = await _openIsar();

    Future<List<GearModel>> res = maxCount != null
        ? isar.gearModels.where().sortByName().limit(maxCount).findAll()
        : isar.gearModels.where().sortByName().findAll();

    isar.close();

    return res;
  }

  Future<void> saveGearToDatabase(GearModel model) async {
    final isar = await _openIsar();
    await isar.writeTxn((isar) async {
      await isar.gearModels.put(model);
    });
    isar.close();
  }

  /// Returns number of gear models in database.
  Future<int> getGearCount() async {
    final isar = await _openIsar();
    int count = await isar.gearModels.where().count();
    isar.close();
    return count;
  }

  /// Returns itinerary models sorted by name.
  Future<List<ItineraryModel>> getItineraries([int? maxCount]) async {
    final isar = await _openIsar();

    Future<List<ItineraryModel>> res = maxCount != null
        ? isar.itineraryModels.where().sortByName().limit(maxCount).findAll()
        : isar.itineraryModels.where().sortByName().findAll();

    isar.close();

    return res;
  }

  Future<void> saveItineraryToDatabase(ItineraryModel model) async {
    final isar = await _openIsar();
    await isar.writeTxn((isar) async {
      await isar.itineraryModels.put(model);
    });
    isar.close();
  }

  /// Returns number of itineraries stored in database.
  Future<int> getItinerariesCount() async {
    final isar = await _openIsar();
    int count = await isar.itineraryModels.where().count();
    isar.close();
    return count;
  }
}
