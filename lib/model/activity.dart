import 'package:movna/model/activity_track_point.dart';
import 'activity_base.dart';

class Activity extends ActivityBase{
  /// All the trackpoints of this activity
  List<ActivityTrackPoint> trackPoints = [];

  void updateStartStop(){
    if(trackPoints.isNotEmpty) {
      startTime = trackPoints.first.dateTime;
      stopTime = trackPoints.last.dateTime;
    }
  }
}
