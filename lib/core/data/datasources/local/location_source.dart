import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:injectable/injectable.dart';

abstract class LocationSource {
  Future<geolocator.Position> getLocation();
  Future<Stream<geolocator.Position>> getLocationStream();
}

@Injectable(as: LocationSource)
class LocationSourceImpl extends LocationSource {
  @override
  Future<geolocator.Position> getLocation() async {
    return await geolocator.Geolocator.getCurrentPosition();
  }

  @override
  Future<Stream<geolocator.Position>> getLocationStream() async {
    return geolocator.Geolocator.getPositionStream();
  }
}
