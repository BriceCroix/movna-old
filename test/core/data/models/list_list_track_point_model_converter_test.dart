import 'package:flutter_test/flutter_test.dart';
import 'package:movna/core/data/models/list_list_track_point_model_converter.dart';
import 'package:movna/core/data/models/position_model.dart';
import 'package:movna/core/data/models/track_point_model.dart';

void listListTrackPointModelConverterTest() {
  late ListListTrackPointModelConverter listListTrackPointModelConverter;

  setUp(() {
    listListTrackPointModelConverter = const ListListTrackPointModelConverter();
  });

  test(
    'encode/decode list of TrackPointModel',
    () {
      final listListTrackPointModel = [[
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
      ],
      [
        TrackPointModel(
          cadence: 13.4,
          speedInKilometersPerHour: 22.1,
          altitudeInMeters: 599.4,
          dateTime: DateTime(2022, 5, 21, 19, 4, 52, 12, 35),
          heartRateInBeatsPerMinute: 86,
          timeZoneOffset: const Duration(hours: 2),
          position: const PositionModel(
              latitudeInDegrees: 49.22, longitudeInDegrees: 12.69),
        ),
      ]];

      String listListTrackPointModelToIsar =
          listListTrackPointModelConverter.toIsar(listListTrackPointModel);
      final listListTrackPointModelFromIsar =
          listListTrackPointModelConverter.fromIsar(listListTrackPointModelToIsar);

      // assert
      expect(listListTrackPointModel, equals(listListTrackPointModelFromIsar));
    },
  );
}
