import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movna/core/domain/entities/sport.dart';

part 'activities_filter.freezed.dart';

/// A filter for lists of Activity.
@freezed
class ActivitiesFilter with _$ActivitiesFilter {
  const factory ActivitiesFilter({
    /// Maximum number of result. Null value for no maximum.
    int? maxCount,

    /// Sport of activity. Null value for all.
    Sport? sport,

    /// Minimum date of activity. Null value for no minimum.
    DateTime? dateTimeFrom,

    /// Maximum date of activity. Null value for no maximum.
    DateTime? dateTimeTo,

    /// Minimum distance of activity. Null value for no minimum.
    double? distanceFrom,

    /// Maximum distance of activity. Null value for no maximum.
    double? distanceTo,
  }) = _ActivitiesFilter;
}
