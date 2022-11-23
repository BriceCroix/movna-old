import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:movna/core/data/datasources/local/database_source.dart';
import 'package:movna/core/data/models/activity_model.dart';
import 'package:movna/core/domain/entities/activities_filter.dart';
import 'package:movna/core/domain/entities/activity.dart';
import 'package:movna/core/domain/repositories/activities_repository.dart';
import 'package:movna/core/typedefs.dart';

@Injectable(as: ActivitiesRepository)
class ActivitiesRepositoryImpl implements ActivitiesRepository {
  DataBaseSource dataBaseSource;

  ActivitiesRepositoryImpl({
    required this.dataBaseSource,
  });

  @override
  Future<List<Activity>> getActivities([ActivitiesFilter? filter]) async {
    try {
      List<ActivityModel> models = await dataBaseSource.getActivities(filter);

      return models.map((e) => e.toActivity()).toList();
    } catch (e, stackTrace) {
      Logger logger = Logger();
      logger.e(e.toString(), e, stackTrace);
      return [];
    }
  }

  @override
  Future<ErrorState> saveActivity(Activity activity) async {
    try {
      ActivityModel model = ActivityModel.fromActivity(activity);

      await dataBaseSource.saveActivityToDatabase(model);

      return false;
    } catch (e, stackTrace) {
      Logger logger = Logger();
      logger.e(e.toString(), e, stackTrace);
      return true;
    }
  }

  @override
  Future<ErrorState> deleteActivity(Activity activity) async {
    try {
      ActivityModel model = ActivityModel.fromActivity(activity);

      await dataBaseSource.removeActivityFromDatabase(model);

      return false;
    } catch (e, stackTrace) {
      Logger logger = Logger();
      logger.e(e.toString(), e, stackTrace);
      return true;
    }
  }
}
