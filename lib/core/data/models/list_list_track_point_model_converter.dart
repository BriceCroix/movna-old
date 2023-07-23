import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:movna/core/data/models/track_point_model.dart';

/// Converts type List<List<TrackPointModel>> to a type that Isar can Handle
class ListListTrackPointModelConverter
    extends TypeConverter<List<List<TrackPointModel>>, String> {
  const ListListTrackPointModelConverter(); // Converters need to have an empty const constructor

  @override
  List<List<TrackPointModel>> fromIsar(String object) {
    return (jsonDecode(object) as List)
        .map((jsonList) => (jsonList as List)
            .map((jsonTrackPoint) => TrackPointModel.fromJson(jsonTrackPoint))
            .toList())
        .toList();
  }

  @override
  String toIsar(List<List<TrackPointModel>> object) {
    //return jsonEncode(object.map((i) => i.toJson()).toList());
    return jsonEncode(object
        .map((segment) => segment.map((e) => e.toJson()).toList())
        .toList());
  }
}
