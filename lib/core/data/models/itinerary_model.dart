import 'package:isar/isar.dart';
import 'package:movna/core/data/models/duration_converter.dart';
import 'package:movna/core/data/models/list_position_model_converter.dart';
import 'package:movna/core/data/models/position_model.dart';
import 'package:movna/core/domain/entities/itinerary.dart';

part 'itinerary_model.g.dart';

@Collection()
class ItineraryModel {
  @Id()
  int id;
  DateTime creationTime;
  @DurationConverter()
  Duration localTimeOffset;
  @Index()
  String name;
  bool isFavorite;

  @ListPositionModelConverter()
  List<PositionModel> positions;

  ItineraryModel({
    required this.creationTime,
    required this.localTimeOffset,
    required this.name,
    required this.isFavorite,
    required this.positions,
  }) : id = creationTime.microsecondsSinceEpoch;

  static ItineraryModel fromItinerary(Itinerary itinerary) {
    return ItineraryModel(
      creationTime: itinerary.creationTime,
      localTimeOffset: itinerary.creationTime.timeZoneOffset,
      name: itinerary.name,
      isFavorite: itinerary.isFavorite,
      positions: itinerary.positions
          .map((e) => PositionModel.fromPosition(e))
          .toList(),
    );
  }

  Itinerary toItinerary() {
    return Itinerary(
      // TODO handle timezone
      creationTime: creationTime,
      name: name,
      positions: positions.map((e) => e.toPosition()).toList(),
      isFavorite: isFavorite,
    );
  }
}
