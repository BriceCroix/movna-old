import 'package:injectable/injectable.dart';
import 'package:movna/core/domain/repositories/gear_repository.dart';

@Injectable()
class GetGearCount {
  final GearRepository repository;
  GetGearCount({required this.repository});

  Future<int> call() {
    return repository.getGearCount();
  }
}
