import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'position.freezed.dart';

/// Position on the globe.
@freezed
class Position with _$Position {
  static const int earthRadiusInMeters = 6371000;

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
    final deltaLatitudeInRadiant = (other.latitudeInRadiant-latitudeInRadiant);
    final deltaLongitudeInRadiant = (other.longitudeInRadiant-longitudeInRadiant);

    final a = sin(deltaLatitudeInRadiant/2) * sin(deltaLatitudeInRadiant/2) +
    cos(latitudeInRadiant) * cos(other.latitudeInRadiant) *
    sin(deltaLongitudeInRadiant/2) * sin(deltaLongitudeInRadiant/2);
    final c = 2 * atan2(sqrt(a), sqrt(1-a));

    return earthRadiusInMeters * c;
    // TODO : take into account altitude if available (pythagorean)
  }
}
