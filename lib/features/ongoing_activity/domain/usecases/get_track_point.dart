import 'package:injectable/injectable.dart';
import 'package:movna/core/domain/entities/track_point.dart';
import 'package:movna/core/domain/repositories/location_repository.dart';

@Injectable()
class GetTrackPoint {
  final LocationRepository repository;

  GetTrackPoint({required this.repository});

  Future<TrackPoint> call() {
    return repository.getTrackPoint();
  }
}
