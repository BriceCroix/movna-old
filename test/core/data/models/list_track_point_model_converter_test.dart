import 'package:flutter_test/flutter_test.dart';
import 'package:movna/core/data/models/list_track_point_model_converter.dart';
import 'package:movna/core/data/models/position_model.dart';
import 'package:movna/core/data/models/track_point_model.dart';

void listTrackPointModelConverterTest() {
  late ListTrackPointModelConverter listTrackPointModelConverter;

  setUp(() {
    listTrackPointModelConverter = const ListTrackPointModelConverter();
  });

  test(
    'encode/decode list of TrackPointModel',
    () {
      List<TrackPointModel> listTrackPointModel = [
        TrackPointModel(
          cadence: 12.2,
          speedInKilometersPerHour: 30.2,
          altitudeInMeters: 600.5,
          dateTime: DateTime(2022, 5, 21, 18, 4, 56, 12, 35),
          heartRateInBeatsPerMinute: 84,
          timeZoneOffset: const Duration(hours: 2),
          position: const PositionModel(
              latitudeInDegrees: 48.23, longitudeInDegrees: 12.65),
        ),
        TrackPointModel(
          cadence: 14.2,
          altitudeInMeters: 648.5,
          dateTime: DateTime(2022, 5, 21, 15, 45, 45, 3, 24),
          timeZoneOffset: const Duration(hours: 1),
        ),
      ];

      String listTrackPointModelToIsar =
          listTrackPointModelConverter.toIsar(listTrackPointModel);
      List<TrackPointModel> listTrackPointModelFromIsar =
          listTrackPointModelConverter.fromIsar(listTrackPointModelToIsar);

      // assert
      expect(listTrackPointModel, equals(listTrackPointModelFromIsar));
    },
  );
}
