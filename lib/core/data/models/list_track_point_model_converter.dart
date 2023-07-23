import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:movna/core/data/models/track_point_model.dart';

/// Converts type List<TrackPointModel> to a type that Isar can Handle
class ListTrackPointModelConverter extends TypeConverter<List<TrackPointModel>, String> {
  const ListTrackPointModelConverter(); // Converters need to have an empty const constructor

  @override
  List<TrackPointModel> fromIsar(String object) {
    return (jsonDecode(object) as List).map((e) => TrackPointModel.fromJson(e)).toList();
  }

  @override
  String toIsar(List<TrackPointModel> object) {
    return jsonEncode(object.map((i) => i.toJson()).toList());
  }
}