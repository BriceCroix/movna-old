import 'package:injectable/injectable.dart';
import 'package:movna/core/typedefs.dart';
import 'package:movna/core/domain/entities/itinerary.dart';
import 'package:movna/core/domain/repositories/itineraries_repository.dart';

@Injectable()
class DeleteItinerary{
  final ItinerariesRepository repository;
  DeleteItinerary({required this.repository});

  Future<ErrorState> call(Itinerary itinerary) {
    return repository.deleteItinerary(itinerary);
  }
}