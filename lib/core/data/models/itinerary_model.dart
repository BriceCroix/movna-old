import 'package:isar/isar.dart';

part 'itinerary_model.g.dart';

@Collection()
class ItineraryModel {
  @Id()
  int id;
  DateTime creationTime;
  int localTimeOffsetInMicroSeconds;
  @Index()
  String name;
  bool isFavorite;
  String pathToFile;

  ItineraryModel(
      {required this.creationTime,
      required this.localTimeOffsetInMicroSeconds,
      required this.name,
      this.isFavorite = false,
      required this.pathToFile})
      : id = creationTime.microsecondsSinceEpoch;
}
