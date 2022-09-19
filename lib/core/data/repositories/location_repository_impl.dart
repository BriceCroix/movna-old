import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:injectable/injectable.dart';
import 'package:movna/core/data/datasources/local/location_source.dart';
import 'package:movna/core/domain/entities/position.dart' as movna_pos;
import 'package:movna/core/domain/entities/track_point.dart';
import 'package:movna/core/domain/repositories/location_repository.dart';

@Injectable(as: LocationRepository)
class LocationRepositoryImpl implements LocationRepository {
  LocationSource locationSource;

  LocationRepositoryImpl({required this.locationSource});

  TrackPoint _geoPositionToTrackPoint(geolocator.Position p) {
    return TrackPoint(
      position: movna_pos.Position(
        latitudeInDegrees: p.latitude,
        longitudeInDegrees: p.longitude,
      ),
      dateTime: p.timestamp,
      altitudeInMeters: p.altitude,
      speedInKilometersPerHour: 3600 * 1e-3 * p.speed,
    );
  }

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

  @override
  Future<TrackPoint> getTrackPoint() async {
    geolocator.Position position = await locationSource.getLocation();
    return _geoPositionToTrackPoint(position);
  }

  @override
  Future<Stream<TrackPoint>> getTrackPointStream() async {
    Stream<geolocator.Position> geoPositionStream =
        await locationSource.getLocationStream();
    // Filter in order to get positions only if accuracy is under 10 meters.
    //TODO : return p.accuracy && p.speedAccuracy to interface
    return geoPositionStream
        .map((geolocator.Position p) => _geoPositionToTrackPoint(p));
  }
}
