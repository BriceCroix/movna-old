import 'package:injectable/injectable.dart';
import 'package:movna/core/typedefs.dart';
import 'package:movna/core/domain/entities/activity.dart';
import 'package:movna/core/domain/repositories/activities_repository.dart';

@Injectable()
class SaveActivity{
  final ActivitiesRepository repository;
  SaveActivity({required this.repository});

  Future<ErrorState> call(Activity activity) {
    return repository.saveActivity(activity);
  }
}