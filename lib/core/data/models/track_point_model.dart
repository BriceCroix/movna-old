import 'package:movna/core/data/models/position_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movna/core/domain/entities/track_point.dart';

part 'track_point_model.freezed.dart';

part 'track_point_model.g.dart';

@freezed
class TrackPointModel with _$TrackPointModel {
  const TrackPointModel._();

  @JsonSerializable(explicitToJson: true)
  const factory TrackPointModel({
    @JsonKey(name: 'pos') PositionModel? position,
    @JsonKey(name: 'time') DateTime? dateTime,
    @JsonKey(name: 'tz') Duration? timeZoneOffset,
    @JsonKey(name: 'alt') double? altitudeInMeters,
    @JsonKey(name: 'bpm') double? heartRateInBeatsPerMinute,
    @JsonKey(name: 'kmh') double? speedInKilometersPerHour,
    @JsonKey(name: 'cad') double? cadence,
  }) = _TrackPointModel;

  factory TrackPointModel.fromJson(Map<String, Object?> json) =>
      _$TrackPointModelFromJson(json);

  static TrackPointModel fromTrackPoint(TrackPoint trackPoint) {
    return TrackPointModel(
      position: trackPoint.position != null
          ? PositionModel.fromPosition(trackPoint.position!)
          : null,
      dateTime: trackPoint.dateTime?.toUtc(),
      timeZoneOffset: trackPoint.dateTime?.timeZoneOffset,
      altitudeInMeters: trackPoint.altitudeInMeters,
      heartRateInBeatsPerMinute: trackPoint.heartRateInBeatsPerMinute,
      speedInKilometersPerHour: trackPoint.speedInKilometersPerHour,
      cadence: trackPoint.cadence,
    );
  }

  TrackPoint toTrackPoint() {
    return TrackPoint(
      position: position?.toPosition(),
      // TODO handle timezone offset (isar returns objects in local time)
      dateTime: dateTime,
      altitudeInMeters: altitudeInMeters,
      heartRateInBeatsPerMinute: heartRateInBeatsPerMinute,
      speedInKilometersPerHour: speedInKilometersPerHour,
      cadence: cadence,
    );
  }
}
