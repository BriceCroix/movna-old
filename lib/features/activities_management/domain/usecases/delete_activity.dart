import 'package:injectable/injectable.dart';
import 'package:movna/core/typedefs.dart';
import 'package:movna/core/domain/entities/activity.dart';
import 'package:movna/core/domain/repositories/activities_repository.dart';

@Injectable()
class DeleteActivity{
  final ActivitiesRepository repository;
  DeleteActivity({required this.repository});

  Future<ErrorState> call(Activity activity) {
    return repository.deleteActivity(activity);
  }
}