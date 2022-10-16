import 'package:freezed_annotation/freezed_annotation.dart';

import 'position.dart';

part 'itinerary.freezed.dart';

/// Planned itinerary, already taken or not.
@freezed
class Itinerary with _$Itinerary {
  const Itinerary._();

  factory Itinerary({
    /// Datetime of creation of this itinerary.
    required DateTime creationTime,

    /// Name of this itinerary.
    required String name,

    /// Is this itinerary one of the user favorites.
    @Default(false) bool isFavorite,

    /// All the positions of this itinerary.
    required List<Position> positions,
  }) = _Itinerary;

  /// Total distance of this itinerary in meters.
  double get distanceInMeters {
    double distance = 0.0;
    for (int i = 1; i < positions.length; ++i) {
      distance += positions
          .elementAt(i)
          .distanceInMetersFrom(positions.elementAt(i - 1));
    }
    return distance;
  }
}
