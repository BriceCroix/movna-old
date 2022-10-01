import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movna/core/domain/entities/settings.dart';
import 'package:movna/core/domain/entities/sport.dart';

part 'settings_model.freezed.dart';
part 'settings_model.g.dart';

@freezed
class SettingsModel with _$SettingsModel {
  const SettingsModel._();

  @JsonSerializable(explicitToJson: true)
  const factory SettingsModel({
    // OngoingActivitySettings -------------------------------------------------
    @Default(true) bool automaticPause,
    @Default(true) bool automaticLock,
    @Default(Sport.other) Sport sport,
    @Default(MapTileLayer.openStreetMap) MapTileLayer mapTileLayer,

    // User profile ------------------------------------------------------------
    @Default('Movna user') String userName,
    @Default(1.70) double userHeightInMeters,
    @Default(70) double userWeightInKilograms,
    @Default(Gender.undefined) Gender userGender,

    // Miscellaneous -----------------------------------------------------------
    @Default(1.5) double automaticPauseThresholdSpeedInKilometersPerHour,
    @Default(Duration(seconds: 3))
        Duration automaticPauseThresholdDurationWithoutMovement,
    @Default(Duration(seconds: 3))
        Duration automaticLockThresholdDurationWithoutInput,
  }) = _SettingsModel;

  factory SettingsModel.fromJson(Map<String, Object?> json) =>
      _$SettingsModelFromJson(json);

  static SettingsModel fromSettings(Settings settings) => SettingsModel(
        automaticPause: settings.automaticPause,
        automaticLock: settings.automaticLock,
        sport: settings.sport,
        //mapTileLayer: settings.mapTileLayer,
        userName: settings.userName,
        userHeightInMeters: settings.userHeightInMeters,
        userWeightInKilograms: settings.userWeightInKilograms,
        userGender: settings.userGender,
        automaticPauseThresholdSpeedInKilometersPerHour:
            settings.automaticPauseThresholdSpeedInKilometersPerHour,
        automaticPauseThresholdDurationWithoutMovement:
            settings.automaticPauseThresholdDurationWithoutMovement,
        automaticLockThresholdDurationWithoutInput:
            settings.automaticLockThresholdDurationWithoutInput,
      );

  Settings toSettings() => Settings(
      automaticPause: automaticPause,
      automaticLock: automaticLock,
      sport: sport,
      //mapTileLayer: mapTileLayer,
      userName: userName,
      userHeightInMeters: userHeightInMeters,
      userWeightInKilograms: userWeightInKilograms,
      userGender: userGender,
      automaticPauseThresholdSpeedInKilometersPerHour:
          automaticPauseThresholdSpeedInKilometersPerHour,
      automaticPauseThresholdDurationWithoutMovement:
          automaticPauseThresholdDurationWithoutMovement,
      automaticLockThresholdDurationWithoutInput:
          automaticLockThresholdDurationWithoutInput);
}
