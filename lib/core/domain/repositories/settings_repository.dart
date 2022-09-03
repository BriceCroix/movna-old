import 'package:movna/core/domain/entities/settings.dart';
import 'package:movna/core/typedefs.dart';

abstract class SettingsRepository {
  /// Save a [settings] to disk.
  Future<ErrorState> saveSettings(Settings settings);

  /// Get the settings.
  Future<Settings> getSettings();
}
