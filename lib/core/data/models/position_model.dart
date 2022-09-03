import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movna/core/domain/entities/position.dart';

part 'position_model.freezed.dart';
part 'position_model.g.dart';

@freezed
class PositionModel with _$PositionModel {
  const PositionModel._();

  @JsonSerializable(explicitToJson: true)
  const factory PositionModel({
    /// Latitude of position between -180 and 180 degrees
    @Default(0) @JsonKey(name: 'lat') double latitudeInDegrees,

    /// Longitude of position between -90 and 90 degrees
    @Default(0) @JsonKey(name: 'lon') double longitudeInDegrees,
  }) = _PositionModel;

  factory PositionModel.fromJson(Map<String, Object?> json) =>
      _$PositionModelFromJson(json);

  static PositionModel fromPosition(Position position) {
    return PositionModel(
        latitudeInDegrees: position.latitudeInDegrees,
        longitudeInDegrees: position.longitudeInDegrees);
  }

  Position toPosition() {
    return Position(
        latitudeInDegrees: latitudeInDegrees,
        longitudeInDegrees: longitudeInDegrees);
  }
}
