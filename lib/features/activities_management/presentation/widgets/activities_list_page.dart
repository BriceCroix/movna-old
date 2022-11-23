import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movna/core/domain/entities/activity.dart';
import 'package:movna/core/injection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movna/core/presentation/router/router.dart';
import 'package:movna/core/presentation/widgets/activities_filter_widget.dart';
import 'package:movna/core/presentation/widgets/activity_card.dart';
import 'package:movna/core/presentation/widgets/movna_loading_spinner.dart';
import 'package:movna/features/activities_management/presentation/blocs/activities_list_bloc.dart';
import 'package:movna/features/activities_management/presentation/widgets/past_activity_page.dart';

class ActivitiesListPage extends StatelessWidget {
  const ActivitiesListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<ActivitiesListBloc>(),
      child: const _ActivitiesListView(),
    );
  }
}

class _ActivitiesListView extends StatelessWidget {
  const _ActivitiesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivitiesListBloc, ActivitiesListState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(AppLocalizations.of(context)!.activities)),
          body: state is ActivitiesListLoaded
              ? _buildBody(context, state)
              : const Center(child: MovnaLoadingSpinner()),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ActivitiesListLoaded state) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        ActivitiesFilterWidget(
          value: state.activitiesFilter,
          onChanged: (value) => context
              .read<ActivitiesListBloc>()
              .add(ActivitiesFilterChanged(value)),
        ),
        Expanded(
          child: state.activitiesList.isNotEmpty
              ? ListView.builder(
                  itemCount: state.activitiesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    Activity activity = state.activitiesList.elementAt(index);
                    return ActivityCard(
                      activity: activity,
                      onTap: () => navigateTo(RouteName.pastActivity,
                              PastActivityPageParams(activity: activity))
                          .whenComplete(() => context
                              .read<ActivitiesListBloc>()
                              .add(RefreshActivities())),
                    );
                  },
                )
              : Center(
                  child: Text(AppLocalizations.of(context)!.noActivitiesYet)),
        ),
      ],
    );
  }
}
