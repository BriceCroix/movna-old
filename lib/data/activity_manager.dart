import 'dart:io';
import 'package:isar/isar.dart';
import 'package:logger/logger.dart';
import 'package:movna/model/activity.dart';
import 'package:movna/model/activity_base.dart';
import 'package:movna/model/sport.dart';
import 'package:movna/model/activity_track_point.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';
import 'activity_item.dart';

/// Saves the [activity] TCX file to disk and its main data to database.
/// Returns false in case of error.
Future<bool> saveActivity(Activity activity) async {
  // First save gps data file
  final String? pathToFile = await saveActivityToDisk(activity);

  // Then push activity to database
  ActivityItem activityCollection = ActivityItem.fromBase(activity);
  activityCollection.updateId();
  activityCollection.pathToFile = pathToFile;

  try {
    Directory dir = await getApplicationDocumentsDirectory();

    final isar = await Isar.open(
      schemas: [ActivityItemSchema],
      directory: dir.path,
    );
    await isar.writeTxn((isar) async {
      await isar.activityItems.put(activityCollection);
    });

    isar.close();
    return true;
  } on MissingPlatformDirectoryException catch (e) {
    // If getApplicationDocumentsDirectory cannot find suitable location
    Logger logger = Logger();
    logger.e(e.message);
    return false;
  } catch (e) {
    Logger logger = Logger();
    logger.e(e);
    return false;
  }
}

/// Get the [count] last activities. Return all activities if [count] is 0.
Future<List<ActivityBase>> getLastNActivities(int count) async {
  Directory dir = await getApplicationDocumentsDirectory();

  final isar = await Isar.open(
    schemas: [ActivityItemSchema],
    directory: dir.path,
  );
  Future<List<ActivityBase>> res = count > 0
      ? isar.activityItems
          .where()
          .sortByStartTimeDesc()
          .limit(count)
          .findAll()
      : isar.activityItems.where().sortByStartTimeDesc().findAll();

  isar.close();

  return res;
}

Future<XmlDocument> _getTCX(Activity activity) async {
  // Only sports supported natively by tcx
  String tcxSportString;
  if (activity.sport == Sport.biking ||
      activity.sport == Sport.bikingElectric ||
      activity.sport == Sport.bikingMountain ||
      activity.sport == Sport.bikingRoad) {
    tcxSportString = 'Biking';
  } else if (activity.sport == Sport.running ||
      activity.sport == Sport.runningTrail) {
    tcxSportString = 'Running';
  } else {
    tcxSportString = 'Other';
  }

  final builder = XmlBuilder();
  builder.processing('xml', 'version="1.0" encoding="UTF-8"');
  // xmlns="http://www.garmin.com/xmlschemas/TrainingCenterDatabase/v2"
  // xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  // xsi:schemaLocation="http://www.garmin.com/xmlschemas/TrainingCenterDatabase/v2 http://www.garmin.com/xmlschemas/TrainingCenterDatabasev2.xsd"
  builder.element('TrainingCenterDatabase', attributes: {
    'xmlns': 'http://www.garmin.com/xmlschemas/TrainingCenterDatabase/v2',
    'xmlns:xsi': 'http://www.w3.org/2001/XMLSchema-instance',
    'xsi:schemaLocation':
        'http://www.garmin.com/xmlschemas/TrainingCenterDatabase/v2 http://www.garmin.com/xmlschemas/TrainingCenterDatabasev2.xsd'
  }, nest: () {
    builder.element('Activities', nest: () {
      builder.element('Activity', attributes: {'Sport': tcxSportString},
          nest: () {
        builder.element('Id', nest: activity.startTime.toIso8601String());
        builder.element('Lap',
            attributes: {'StartTime': activity.startTime.toIso8601String()},
            nest: () {
          builder.element('TotalTimeSeconds',
              nest: activity.duration.inSeconds);
          builder.element('DistanceMeters', nest: activity.distanceInMeters);
          //builder.element('MaximumSpeed', nest: TODO);
          builder.element('Calories', nest: activity.energySpentInCalories);
          builder.element('Track', nest: () {
            for (ActivityTrackPoint trackPoint in activity.trackPoints) {
              builder.element('Trackpoint', nest: () {
                builder.element('Time',
                    nest: trackPoint.dateTime.toIso8601String());
                builder.element('Position', nest: () {
                  builder.element('LatitudeDegrees', nest: trackPoint.latitude);
                  builder.element('LongitudeDegrees',
                      nest: trackPoint.longitude);
                });
                if(trackPoint.altitudeInMeters != null) {
                  builder.element('AltitudeMeters', nest: trackPoint.altitudeInMeters);
                }
                if(trackPoint.heartRateInBeatsPerMinute != null) {
                  builder.element('HeartRateBpm', nest: trackPoint.heartRateInBeatsPerMinute);
                }
              });
            }
          });
        });
      });
    });
  });

  return builder.buildDocument();
}

/// Creates TCX file corresponding to given [activity],
/// writes it to disk and returns the complete path to created file.
/// Returns null in case of error.
Future<String?> saveActivityToDisk(Activity activity) async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    const String subDir = 'ActivityFiles';
    final path = '${dir.path}${Platform.pathSeparator}$subDir';
    final String filename = activity.startTime.toUtc().toIso8601String().replaceAll(':', '-');
    const String extension = '.tcx';
    final String pathToFile =
        '$path${Platform.pathSeparator}$filename$extension';
    File f = File(pathToFile);
    await f.create(recursive: true);

    XmlDocument activityAsTcx = await _getTCX(activity);
    await f.writeAsString(activityAsTcx.toXmlString(pretty: false));
    return pathToFile;
  } on MissingPlatformDirectoryException catch (e) {
    // If getApplicationDocumentsDirectory cannot find suitable location
    Logger logger = Logger();
    logger.e(e);
    return null;
  } on FileSystemException catch (e) {
    // If cannot open file
    Logger logger = Logger();
    logger.e(e);
    return null;
  } catch (e) {
    Logger logger = Logger();
    logger.e(e);
    return null;
  }
}
