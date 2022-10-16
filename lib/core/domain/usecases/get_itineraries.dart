import 'package:injectable/injectable.dart';
import 'package:movna/core/domain/entities/itinerary.dart';
import 'package:movna/core/domain/repositories/itineraries_repository.dart';

@Injectable()
class GetItineraries {
  final ItinerariesRepository repository;

  GetItineraries({required this.repository});

  Future<List<Itinerary>> call([int? maxCount]) {
    return repository.getItineraries(maxCount);
  }
}
