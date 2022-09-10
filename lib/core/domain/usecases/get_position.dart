import 'package:injectable/injectable.dart';
import 'package:movna/core/domain/entities/position.dart';
import 'package:movna/core/domain/repositories/location_repository.dart';

@Injectable()
class GetPosition{
  final LocationRepository repository;
  GetPosition({required this.repository});

  Future<Position> call() {
    return repository.getPosition();
  }
}