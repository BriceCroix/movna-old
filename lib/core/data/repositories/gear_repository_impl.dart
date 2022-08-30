import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:movna/core/data/datasources/local/database_source.dart';
import 'package:movna/core/data/models/gear_model.dart';
import 'package:movna/core/domain/entities/gear.dart';
import 'package:movna/core/domain/repositories/gear_repository.dart';
import 'package:movna/core/typedefs.dart';

@Injectable(as: GearRepository)
class GearRepositoryImpl implements GearRepository {
  DataBaseSource dataBaseSource;

  GearRepositoryImpl({required this.dataBaseSource});

  static Gear convertGearModelToEntity(GearModel model) {
    return Gear(
        creationTime: model.creationTime,
        gearType: model.gearType,
        name: model.name,
        distanceInMeters: model.distanceInMeters,
        useTime: Duration(microseconds: model.useTimeInMicroSeconds));
  }

  static GearModel convertGearEntityToModel(Gear gear) {
    return GearModel(
        creationTime: gear.creationTime,
        localTimeOffsetInMicroSeconds:
        gear.creationTime.timeZoneOffset.inMicroseconds,
        gearType: gear.gearType,
        name: gear.name,
        distanceInMeters: gear.distanceInMeters,
        useTimeInMicroSeconds: gear.useTime.inMicroseconds);
  }

  @override
  Future<List<Gear>> getAllGear() async {
    try {
      List<GearModel> models =
      await dataBaseSource.getAllGear();

      List<Gear> gear = [];

      for (GearModel model in models) {
        gear.add(convertGearModelToEntity(model));
      }

      return gear;
    } catch (e) {
      // TODO : handle error
      Logger logger = Logger();
      logger.e(e);
      return [];
    }
  }

  @override
  Future<ErrorState> saveGear(Gear gear) async {
    try {
      GearModel model = convertGearEntityToModel(gear);

      await dataBaseSource.saveGearToDatabase(model);

      return true;
    } catch (e) {
      // TODO handle errors
      Logger logger = Logger();
      logger.e(e);
      return false;
    }
  }

  @override
  Future<Gear> getGear(
      {required DateTime creationTime}) {
    // TODO: implement getGear
    throw UnimplementedError();
  }
}
