import 'package:injectable/injectable.dart';
import 'package:movna/core/domain/entities/gear.dart';
import 'package:movna/core/domain/repositories/gear_repository.dart';

@Injectable()
class GetGearPieces{
  final GearRepository repository;
  GetGearPieces({required this.repository});

  Future<List<Gear>> call([int? maxCount]) {
    return repository.getGear(maxCount);
  }
}