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
  Future<List<ActivityModel>> getActivities() async {
    final isar = await _openIsar();

    Future<List<ActivityModel>> res =
        isar.activityModels.where().sortByStartTimeDesc().findAll();

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

  /// Returns activity models sorted by name.
  Future<List<GearModel>> getAllGear() async {
    final isar = await _openIsar();

    Future<List<GearModel>> res =
    isar.gearModels.where().sortByName().findAll();

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

  /// Returns itinerary models sorted by name.
  Future<List<ItineraryModel>> getItineraries() async {
    final isar = await _openIsar();

    Future<List<ItineraryModel>> res =
    isar.itineraryModels.where().sortByName().findAll();

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
}
