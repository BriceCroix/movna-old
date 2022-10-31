import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movna/core/domain/entities/itinerary.dart';

part 'ongoing_activity_settings.freezed.dart';

/// Non-persistent settings for ongoing activities.
@freezed
class OngoingActivitySettings with _$OngoingActivitySettings {
  const factory OngoingActivitySettings({
    /// The itinerary to be followed during an activity.
    Itinerary? itinerary,
  }) = _OngoingActivitySettings;
}
