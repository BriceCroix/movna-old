import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:injectable/injectable.dart';
import 'package:movna/core/data/datasources/local/location_source.dart';
import 'package:movna/core/domain/entities/position.dart' as movna_pos;
import 'package:movna/core/domain/repositories/location_repository.dart';

@Injectable(as: LocationRepository)
class LocationRepositoryImpl implements LocationRepository {
  LocationSource locationSource;

  LocationRepositoryImpl({required this.locationSource});

  // TODO : geolocator.Position actually contains way more than just coordinates,
  // can use it to return altitude too

  @override
  Future<movna_pos.Position> getPosition() async {
    geolocator.Position position = await locationSource.getLocation();
    return movna_pos.Position(
      latitudeInDegrees: position.latitude,
      longitudeInDegrees: position.longitude,
    );
  }

  @override
  Future<Stream<movna_pos.Position>> getPositionStream() async {
    Stream<geolocator.Position> geoPositionStream =
        await locationSource.getLocationStream();
    return geoPositionStream.map((event) => movna_pos.Position(
          latitudeInDegrees: event.latitude,
          longitudeInDegrees: event.longitude,
        ));
  }
}
