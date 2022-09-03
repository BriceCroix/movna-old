import 'package:flutter_test/flutter_test.dart';
import 'package:movna/core/data/models/list_position_model_converter.dart';
import 'package:movna/core/data/models/position_model.dart';

void listPositionModelConverterTest() {
  late ListPositionModelConverter listPositionModelConverter;

  setUp(() {
    listPositionModelConverter = const ListPositionModelConverter();
  });

  test(
    'encode/decode list of PositionModel',
    () {
      List<PositionModel> listPositionModel = [
        const PositionModel(latitudeInDegrees: -48, longitudeInDegrees: 30),
        const PositionModel(
            latitudeInDegrees: -48.6, longitudeInDegrees: -25.5),
      ];

      String listPositionModelToIsar = listPositionModelConverter.toIsar(listPositionModel);
      List<PositionModel> listPositionModelFromIsar = listPositionModelConverter.fromIsar(listPositionModelToIsar);

      // assert
      expect(listPositionModel, equals(listPositionModelFromIsar));
    },
  );
}
