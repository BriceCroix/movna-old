import 'package:movna/core/domain/entities/itinerary.dart';
import 'package:movna/core/typedefs.dart';

abstract class ItinerariesRepository {
  /// Save an [itinerary] to disk.
  Future<ErrorState> saveItinerary(Itinerary itinerary);

  /// Get all itineraries stored on disk, specifying whether positions are required or not with [mapped].
  Future<List<Itinerary>> getItineraries({bool mapped = false});

  /// Get one specific itinerary using its [creationTime] property.
  Future<Itinerary> getItinerary(
      {required DateTime creationTime, bool mapped = false});
}
