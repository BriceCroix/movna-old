import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'position.freezed.dart';

/// Position on the globe.
@freezed
class Position with _$Position {
  /// Equator radius in meters (WGS84 ellipsoid).
  static const double equatorRadiusInMeters = 6378137.0;

  /// Polar radius in meters (WGS84 ellipsoid).
  static const double polarRadiusInMeters = 6356752.314245;

  /// Earth approximate radius in meters.
  static const double earthRadiusInMeters =
      (equatorRadiusInMeters + polarRadiusInMeters) / 2;

  const Position._();

  const factory Position({
    /// Latitude of position between -180 and 180 degrees
    @Default(0) double latitudeInDegrees,

    /// Longitude of position between -90 and 90 degrees
    @Default(0) double longitudeInDegrees,
  }) = _Position;

  double get latitudeInRadiant => latitudeInDegrees * pi / 180;

  double get longitudeInRadiant => longitudeInDegrees * pi / 180;

  /// Computes distance in meters between this position and [other] position,
  /// using Haversine formula.
  double distanceInMetersFrom(Position other) {
    final sinDLat = sin((other.latitudeInRadiant - latitudeInRadiant) / 2);
    final sinDLng = sin((other.longitudeInRadiant - longitudeInRadiant) / 2);

    // Sides
    final double a = sinDLat * sinDLat +
        sinDLng *
            sinDLng *
            cos(latitudeInRadiant) *
            cos(other.latitudeInRadiant);
    final double c = 2 * atan2(sqrt(a), sqrt(1.0 - a));

    return earthRadiusInMeters * c;

    // TODO : take into account altitude if available (pythagorean)
  }
}
