import 'package:injectable/injectable.dart';
import 'package:movna/core/domain/entities/activity.dart';
import 'package:movna/core/domain/repositories/activities_repository.dart';

@Injectable()
class GetActivity{
  final ActivitiesRepository repository;
  GetActivity({required this.repository});

  Future<Activity> call({required DateTime startTime, bool mapped = false}) {
    return repository.getActivity(startTime: startTime, mapped: mapped);
  }
}