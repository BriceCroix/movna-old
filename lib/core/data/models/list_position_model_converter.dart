import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:movna/core/data/models/position_model.dart';

/// Converts type List<PositionModel> to a type that Isar can Handle
class ListPositionModelConverter extends TypeConverter<List<PositionModel>, String> {
  const ListPositionModelConverter(); // Converters need to have an empty const constructor

  @override
  List<PositionModel> fromIsar(String object) {
    return (jsonDecode(object) as List).map((e) => PositionModel.fromJson(e)).toList();
  }

  @override
  String toIsar(List<PositionModel> object) {
    return jsonEncode(object.map((i) => i.toJson()).toList());
  }
}