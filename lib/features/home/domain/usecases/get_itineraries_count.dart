import 'package:injectable/injectable.dart';
import 'package:movna/core/domain/repositories/itineraries_repository.dart';

@Injectable()
class GetItinerariesCount {
  final ItinerariesRepository repository;
  GetItinerariesCount({required this.repository});

  Future<int> call() {
    return repository.getItinerariesCount();
  }
}
