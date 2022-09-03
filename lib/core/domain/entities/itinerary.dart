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
    @Default (false) bool isFavorite,

    /// All the positions of this itinerary.
    /// A null value indicates that this itinerary is not fully loaded.
    /// If the itinerary is mapped but no positions are available then it is
    /// non null but empty.
    @Default([]) List<Position> positions,
  }) = _Itinerary;
}
