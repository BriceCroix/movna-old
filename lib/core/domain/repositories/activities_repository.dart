import 'package:movna/core/domain/entities/activities_filter.dart';
import 'package:movna/core/typedefs.dart';
import 'package:movna/core/domain/entities/activity.dart';

abstract class ActivitiesRepository {
  /// Save an [activity] to disk.
  Future<ErrorState> saveActivity(Activity activity);

  /// Delete an [activity] from disk.
  Future<ErrorState> deleteActivity(Activity activity);

  /// Get stored used activities according to given [filter].
  Future<List<Activity>> getActivities(ActivitiesFilter? filter);
}
