import 'package:injectable/injectable.dart';
import 'package:movna/core/domain/entities/settings.dart';
import 'package:movna/core/domain/repositories/settings_repository.dart';

@Injectable()
class GetSettings{
  final SettingsRepository repository;
  GetSettings({required this.repository});

  Future<Settings> call() {
    return repository.getSettings();
  }
}