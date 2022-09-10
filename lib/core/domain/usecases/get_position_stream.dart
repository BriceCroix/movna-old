import 'package:injectable/injectable.dart';
import 'package:movna/core/domain/entities/position.dart';
import 'package:movna/core/domain/repositories/location_repository.dart';

@Injectable()
class GetPositionStream{
  final LocationRepository repository;
  GetPositionStream({required this.repository});

  Future<Stream<Position>> call() {
    return repository.getPositionStream();
  }
}