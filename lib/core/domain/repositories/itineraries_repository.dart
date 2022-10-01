import 'package:movna/core/domain/entities/itinerary.dart';
import 'package:movna/core/typedefs.dart';

abstract class ItinerariesRepository {
  /// Save an [itinerary] to disk.
  Future<ErrorState> saveItinerary(Itinerary itinerary);

  /// Get all itineraries stored on disk, with a maximum of [maxCount] elements.
  Future<List<Itinerary>> getItineraries([int? maxCount]);

  /// Get number of itineraries stored on disk.
  Future<int> getItinerariesCount();
}
