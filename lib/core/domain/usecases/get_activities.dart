import 'package:injectable/injectable.dart';
import 'package:movna/core/domain/entities/activity.dart';
import 'package:movna/core/domain/repositories/activities_repository.dart';

@Injectable()
class GetActivities{
  final ActivitiesRepository repository;
  GetActivities({required this.repository});

  Future<List<Activity>> call({bool mapped = false}) {
    return repository.getActivities(mapped: mapped);
  }
}