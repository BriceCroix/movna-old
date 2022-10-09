import 'package:injectable/injectable.dart';
import 'package:movna/core/typedefs.dart';
import 'package:movna/core/domain/entities/gear.dart';
import 'package:movna/core/domain/repositories/gear_repository.dart';

@Injectable()
class DeleteGear{
  final GearRepository repository;
  DeleteGear({required this.repository});

  Future<ErrorState> call(Gear gear) {
    return repository.deleteGear(gear);
  }
}