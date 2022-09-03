import 'package:injectable/injectable.dart';
import 'package:movna/core/typedefs.dart';
import 'package:movna/core/domain/entities/settings.dart';
import 'package:movna/core/domain/repositories/settings_repository.dart';

@Injectable()
class SaveSettings{
  final SettingsRepository repository;
  SaveSettings({required this.repository});

  Future<ErrorState> call(Settings settings) {
    return repository.saveSettings(settings);
  }
}