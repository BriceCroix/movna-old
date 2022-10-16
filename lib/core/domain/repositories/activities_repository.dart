import 'package:movna/core/typedefs.dart';
import 'package:movna/core/domain/entities/activity.dart';

abstract class ActivitiesRepository {
  /// Save an [activity] to disk.
  Future<ErrorState> saveActivity(Activity activity);

  /// Delete an [activity] from disk.
  Future<ErrorState> deleteActivity(Activity activity);

  /// Get all activities stored on disk. With a maximum of [maxCount] elements.
  /// Activities are sorted from latest to oldest.
  Future<List<Activity>> getActivities([int? maxCount]);
}
