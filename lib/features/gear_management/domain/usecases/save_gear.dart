import 'package:injectable/injectable.dart';
import 'package:movna/core/typedefs.dart';
import 'package:movna/core/domain/entities/gear.dart';
import 'package:movna/core/domain/repositories/gear_repository.dart';

@Injectable()
class SaveGear{
  final GearRepository repository;
  SaveGear({required this.repository});

  Future<ErrorState> call(Gear gear) {
    return repository.saveGear(gear);
  }
}