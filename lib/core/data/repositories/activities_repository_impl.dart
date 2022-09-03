import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:movna/core/data/datasources/local/database_source.dart';
import 'package:movna/core/data/models/activity_model.dart';
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
  Future<List<Activity>> getActivities([int? maxCount]) async {
    try {
      List<ActivityModel> models = await dataBaseSource.getActivities(maxCount);

      return models.map((e) => e.toActivity()).toList();
    } catch (e) {
      Logger logger = Logger();
      logger.e(e);
      return [];
    }
  }

  @override
  Future<ErrorState> saveActivity(Activity activity) async {
    try {
      ActivityModel model = ActivityModel.fromActivity(activity);

      await dataBaseSource.saveActivityToDatabase(model);

      return true;
    } catch (e) {
      Logger logger = Logger();
      logger.e(e);
      return false;
    }
  }
}
