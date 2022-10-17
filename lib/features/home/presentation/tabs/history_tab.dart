import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movna/core/injection.dart';
import 'package:movna/core/domain/entities/activity.dart';
import 'package:movna/core/presentation/router/router.dart';
import 'package:movna/core/presentation/widgets/movna_loading_spinner.dart';
import 'package:movna/features/home/presentation/bloc/history_tab_bloc.dart';
import 'package:movna/features/home/presentation/widgets/activity_card.dart';
import 'package:movna/core/presentation/widgets/titled_box.dart';
import 'package:movna/features/past_activity/presentation/widgets/past_activity_page.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<HistoryTabBloc>(),
      child: const _HistoryTabView(),
    );
  }
}

class _HistoryTabView extends StatelessWidget {
  const _HistoryTabView({Key? key}) : super(key: key);

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
              child: BlocBuilder<HistoryTabBloc, HistoryTabState>(
                builder: (context, state) {
                  if (state is! HistoryTabLoaded) {
                    return const Center(child: MovnaLoadingSpinner());
                  }
                  if (state.activities.isEmpty) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context)!.noActivitiesYet,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.activities.length,
                    itemBuilder: (BuildContext context, int index) {
                      Activity activity = state.activities.elementAt(index);
                      return ActivityCard(
                        activity: activity,
                        onTap: () => navigateTo(RouteName.pastActivity,
                            PastActivityPageParams(activity: activity))
                            .whenComplete(() => context
                            .read<HistoryTabBloc>()
                            .add(RefreshActivities())),
                      );
                    },
                  );
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
