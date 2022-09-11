import 'package:flutter_test/flutter_test.dart';
import 'package:movna/core/domain/entities/position.dart';

void positionTest(){
  late Position p1;
  late Position p2;

  setUp(() {
    // Distance between these points is 10001965.72931165
    p1 = const Position(latitudeInDegrees:0.0, longitudeInDegrees:0.0);
    p2 = const Position(latitudeInDegrees:90.0, longitudeInDegrees:0.0);
  });

  test(
    'distance between two points',
        () {
      double distance = p1.distanceInMetersFrom(p2);
      // With 10m of uncertainty
      expect(distance, closeTo(10001965.72931165, 10));
    },
  );
}