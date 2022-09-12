import 'package:movna/core/domain/entities/position.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'track_point.freezed.dart';

@freezed
class TrackPoint with _$TrackPoint {
  const TrackPoint._();

  const factory TrackPoint({
    Position? position,
    DateTime? dateTime,
    double? altitudeInMeters,
    double? heartRateInBeatsPerMinute,
    double? speedInKilometersPerHour,
    double? cadence,
  }) = _TrackPoint;

  /// Computes speed in kilometers per hour if position and datetime is
  /// available for both this trackpoint and the [previous] one.
  double? speedInKilometersPerHourFrom(TrackPoint previous) {
    if (position != null &&
        dateTime != null &&
        previous.position != null &&
        previous.dateTime != null) {
      double distance = position!.distanceInMetersFrom(previous.position!);
      int duration =
          dateTime!.difference(previous.dateTime!).inMilliseconds;
      return duration > 0 ? 3600000 * 1e-3 * distance / duration : 0;
    } else {
      return null;
    }
  }
}
