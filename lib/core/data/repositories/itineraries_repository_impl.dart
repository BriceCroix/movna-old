import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:movna/core/data/datasources/local/database_source.dart';
import 'package:movna/core/data/models/itinerary_model.dart';
import 'package:movna/core/domain/entities/itinerary.dart';
import 'package:movna/core/domain/repositories/itineraries_repository.dart';
import 'package:movna/core/typedefs.dart';

@Injectable(as: ItinerariesRepository)
class ItinerariesRepositoryImpl implements ItinerariesRepository {
  DataBaseSource dataBaseSource;

  ItinerariesRepositoryImpl(
      {required this.dataBaseSource});

  @override
  Future<List<Itinerary>> getItineraries([int? maxCount]) async {
    try {
      List<ItineraryModel> models = await dataBaseSource.getItineraries(maxCount);

      return models.map((e) => e.toItinerary()).toList();
    } catch (e) {
      Logger logger = Logger();
      logger.e(e);
      return [];
    }
  }

  @override
  Future<ErrorState> saveItinerary(Itinerary itinerary) async {
    try {
      ItineraryModel model = ItineraryModel.fromItinerary(itinerary);

      await dataBaseSource.saveItineraryToDatabase(model);

      return true;
    } catch (e) {
      Logger logger = Logger();
      logger.e(e);
      return false;
    }
  }
}
