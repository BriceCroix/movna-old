import 'package:movna/core/typedefs.dart';
import 'package:movna/core/domain/entities/activity.dart';

abstract class ActivitiesRepository {
  /// Save an [activity] to disk.
  Future<ErrorState> saveActivity(Activity activity);

  /// Get all activities stored on disk, specifying whether trackpoints are required or not with [mapped].
  /// Activities are sorted from latest to oldest.
  Future<List<Activity>> getActivities({bool mapped = false});

  /// Get one specific activity using its [startTime] property.
  Future<Activity> getActivity(
      {required DateTime startTime, bool mapped = false});
}
