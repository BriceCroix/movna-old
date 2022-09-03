import 'package:injectable/injectable.dart';
import 'package:movna/core/domain/entities/activity.dart';
import 'package:movna/core/domain/repositories/activities_repository.dart';

@Injectable()
class GetActivities{
  final ActivitiesRepository repository;
  GetActivities({required this.repository});

  Future<List<Activity>> call([int? maxCount]) {
    return repository.getActivities(maxCount);
  }
}