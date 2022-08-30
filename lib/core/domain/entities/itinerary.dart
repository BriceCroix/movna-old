import 'position.dart';

/// Planned itinerary, already taken or not.
class Itinerary {
  /// Datetime of creation of this itinerary.
  DateTime creationTime;

  /// Name of this itinerary.
  String name;

  /// Is this itinerary one of the user favorites.
  bool isFavorite;

  /// All the positions of this itinerary.
  /// A null value indicates that this itinerary is not fully loaded.
  /// If the itinerary is mapped but no positions are available then it is
  /// non null but empty.
  List<Position>? positions;

  Itinerary(
      {required this.creationTime, required this.name, bool? isFavorite, this.positions})
      : isFavorite = isFavorite ?? false;
}
