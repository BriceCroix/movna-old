import 'package:movna/core/domain/entities/position.dart';
import 'package:movna/core/domain/entities/track_point.dart';

abstract class LocationRepository {
  /// Get the current location.
  Future<Position> getPosition();

  /// Get stream of locations.
  Future<Stream<Position>> getPositionStream();

  /// Get the current location along with additional data.
  Future<TrackPoint> getTrackPoint();

  /// Get stream of trackpoints.
  Future<Stream<TrackPoint>> getTrackPointStream();
}
