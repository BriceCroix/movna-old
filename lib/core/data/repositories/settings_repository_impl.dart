import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:movna/core/data/datasources/local/settings_source.dart';
import 'package:movna/core/data/models/settings_model.dart';
import 'package:movna/core/domain/entities/settings.dart';
import 'package:movna/core/domain/repositories/settings_repository.dart';
import 'package:movna/core/typedefs.dart';

@Injectable(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsSource settingsSource;

  SettingsRepositoryImpl({required this.settingsSource});

  @override
  Future<Settings> getSettings() async {
    try {
      return (await settingsSource.getSettings()).toSettings();
    } catch (e, stackTrace) {
      Logger logger = Logger();
      logger.e(e.toString(), e, stackTrace);
      // return default settings
      return const SettingsModel().toSettings();
    }
  }

  @override
  Future<ErrorState> saveSettings(Settings settings) async {
    try {
      settingsSource.saveSettings(SettingsModel.fromSettings(settings));
      return false;
    } catch (e, stackTrace) {
      Logger logger = Logger();
      logger.e(e.toString(), e, stackTrace);
      return true;
    }
  }
}
