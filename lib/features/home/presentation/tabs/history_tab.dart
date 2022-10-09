import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movna/core/domain/usecases/get_activities.dart';
import 'package:movna/core/injection.dart';
import 'package:movna/core/domain/entities/activity.dart';
import 'package:movna/core/presentation/widgets/movna_loading_spinner.dart';
import 'package:movna/features/home/presentation/widgets/activity_card.dart';
import 'package:movna/core/presentation/widgets/titled_box.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TitledBox(
            title: AppLocalizations.of(context)!.activities,
            onMorePressed: () {
              //TODO : Navigator push pastActivitiesPage
            },
            child: Expanded(
              child: FutureBuilder(
                future: injector<GetActivities>()(),
                builder: (context, AsyncSnapshot<List<Activity>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: MovnaLoadingSpinner());
                  } else {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          AppLocalizations.of(context)!.noActivitiesYet,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      );
                    } else {
                      List<Activity> activities = snapshot.data!;
                      return ListView(
                        children: activities
                            .map((activity) => ActivityCard(activity: activity))
                            .toList(),
                      );
                    }
                  }
                },
              ),
            ),
          ),
        ),
        const Divider(),
        Expanded(
          child: TitledBox(
            title: AppLocalizations.of(context)!.statistics,
            //TODO
            child: const Center(child: Text('TODO')),
            onMorePressed: () {
              //TODO : Navigator push statistics page
            },
          ),
        ),
      ],
    );
  }
}
