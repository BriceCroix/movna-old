import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:movna/core/data/datasources/local/database_source.dart';
import 'package:movna/core/data/models/activity_model.dart';
import 'package:movna/core/data/repositories/gear_repository_impl.dart';
import 'package:movna/core/data/repositories/itineraries_repository_impl.dart';
import 'package:movna/core/domain/entities/activity.dart';
import 'package:movna/core/domain/entities/track_point.dart';
import 'package:movna/core/domain/repositories/activities_repository.dart';
import 'package:movna/core/typedefs.dart';

@Injectable(as: ActivitiesRepository)
class ActivitiesRepositoryImpl implements ActivitiesRepository {
  DataBaseSource dataBaseSource;

  ActivitiesRepositoryImpl({required this.dataBaseSource});

  static Activity convertActivityModelToEntity(ActivityModel model, List<TrackPoint>? trackPoints) {
    return Activity(
      name: model.name,
      sport: model.sport,
      startTime: model.startTime,
      stopTime: model.stopTime,
      distanceInMeters: model.distanceInMeters,
      duration: Duration(microseconds: model.durationInMicroSeconds),
      gear: (model.gear.isAttached && model.gear.value != null)
          ? GearRepositoryImpl.convertGearModelToEntity(model.gear.value!)
          : null,
      maxSpeedInKilometersPerHour: model.maxSpeedInKilometersPerHour,
      trackPoints: trackPoints,
    );
  }

  static ActivityModel convertActivityEntityToModel(
      Activity activity, String? pathToFile, String? pathToItineraryFile) {
    ActivityModel activityModel = ActivityModel(
      name: activity.name,
      sport: activity.sport,
      startTime: activity.startTime,
      stopTime: activity.stopTime,
      localTimeOffsetInMicroSeconds:
          activity.startTime.timeZoneOffset.inMicroseconds,
      distanceInMeters: activity.distanceInMeters,
      durationInMicroSeconds: activity.duration.inMicroseconds,
      maxSpeedInKilometersPerHour: activity.maxSpeedInKilometersPerHour,
      pathToFile: pathToFile,
    );
    if (activity.gear != null) {
      activityModel.gear.value = GearRepositoryImpl.convertGearEntityToModel(activity.gear!);
    }
    //TODO
    if (activity.itinerary != null) {
      activityModel.itinerary.value = ItinerariesRepositoryImpl.convertItineraryEntityToModel(activity.itinerary!, pathToItineraryFile!);
    }
    return activityModel;
  }

  static String createActivityFilename(Activity activity) {
    return activity.startTime
        .toUtc()
        .toIso8601String()
        .replaceAll(RegExp(r':'), '-');
  }

  @override
  Future<List<Activity>> getActivities({bool mapped = false}) async {
    try {
      List<ActivityModel> activityModels =
          await dataBaseSource.getActivities();

      List<Activity> activities = [];

      for (ActivityModel model in activityModels) {
        List<TrackPoint>? trackPoints;
        if (mapped) {
          //TODO : read disk to fill gps
          trackPoints = [];
        }
        activities.add(convertActivityModelToEntity(model, trackPoints));
      }

      return activities;
    } catch (e) {
      // TODO : handle error
      Logger logger = Logger();
      logger.e(e);
      return [];
    }
  }

  @override
  Future<ErrorState> saveActivity(Activity activity) async {
    try {
      // TODO write itinerary to file (call ItinerariesRepositories) and get its filename
      // TODO write trackpoints to file and pass path to following function
      ActivityModel activityModel = convertActivityEntityToModel(activity, null, "");

      await dataBaseSource.saveActivityToDatabase(activityModel);

      return true;
    } catch (e) {
      // TODO handle errors
      Logger logger = Logger();
      logger.e(e);
      return false;
    }
  }

  @override
  Future<Activity> getActivity(
      {required DateTime startTime, bool mapped = false}) {
    // TODO: implement getActivity
    throw UnimplementedError();
  }
}
