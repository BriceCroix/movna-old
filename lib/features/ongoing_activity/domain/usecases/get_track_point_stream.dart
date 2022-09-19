import 'package:injectable/injectable.dart';
import 'package:movna/core/domain/entities/track_point.dart';
import 'package:movna/core/domain/repositories/location_repository.dart';

@Injectable()
class GetTrackPointStream {
  final LocationRepository repository;

  GetTrackPointStream({required this.repository});

  Future<Stream<TrackPoint>> call() {
    return repository.getTrackPointStream();
  }
}
