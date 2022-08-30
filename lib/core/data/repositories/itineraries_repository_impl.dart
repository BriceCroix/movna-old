import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:movna/core/data/datasources/local/database_source.dart';
import 'package:movna/core/data/models/itinerary_model.dart';
import 'package:movna/core/domain/entities/itinerary.dart';
import 'package:movna/core/domain/entities/position.dart';
import 'package:movna/core/domain/repositories/itineraries_repository.dart';
import 'package:movna/core/typedefs.dart';

@Injectable(as: ItinerariesRepository)
class ItinerariesRepositoryImpl implements ItinerariesRepository {
  DataBaseSource dataBaseSource;

  ItinerariesRepositoryImpl({required this.dataBaseSource});

  static Itinerary convertItineraryModelToEntity(ItineraryModel model, List<Position>? positions) {
    return Itinerary(
      //TODO handle timezoneoffset
        creationTime: model.creationTime,
        name: model.name,
        isFavorite: model.isFavorite,
    positions: positions,);
  }

  static ItineraryModel convertItineraryEntityToModel(
      Itinerary itinerary, String pathToFile) {
    return ItineraryModel(
      creationTime: itinerary.creationTime,
      localTimeOffsetInMicroSeconds:
      itinerary.creationTime.timeZoneOffset.inMicroseconds,
      name: itinerary.name,
      pathToFile: pathToFile,
    );
  }

  static String createItineraryFilename(Itinerary itinerary) {
    return itinerary.creationTime
        .toUtc()
        .toIso8601String()
        .replaceAll(RegExp(r':'), '-');
  }

  @override
  Future<List<Itinerary>> getItineraries({bool mapped = false}) async {
    try {
      List<ItineraryModel> itineraryModels =
      await dataBaseSource.getItineraries();

      List<Itinerary> itineraries = [];

      for (ItineraryModel model in itineraryModels) {
        List<Position>? positions;
        if (mapped) {
          //TODO : read disk to fill gps
          positions = [];
        }
        itineraries.add(convertItineraryModelToEntity(model, positions));
      }

      return itineraries;
    } catch (e) {
      // TODO : handle error
      Logger logger = Logger();
      logger.e(e);
      return [];
    }
  }

  @override
  Future<ErrorState> saveItinerary(Itinerary itinerary) async {
    try {
      // TODO write trackpoints to file and pass path to following function
      ItineraryModel itineraryModel = convertItineraryEntityToModel(itinerary, "");
      //itineraryModel.pathToFile = TODO;

      await dataBaseSource.saveItineraryToDatabase(itineraryModel);

      return true;
    } catch (e) {
      // TODO handle errors
      Logger logger = Logger();
      logger.e(e);
      return false;
    }
  }

  @override
  Future<Itinerary> getItinerary(
      {required DateTime creationTime, bool mapped = false}) {
    // TODO: implement getItinerary
    throw UnimplementedError();
  }
}
