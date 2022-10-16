import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movna/core/domain/entities/activity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movna/core/presentation/router/router.dart';
import 'package:movna/core/presentation/utils/illustrator.dart';
import 'package:movna/features/past_activity/presentation/widgets/past_activity_page.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String date = DateFormat.yMMMMd(Localizations.localeOf(context).toString())
        .format(activity.startTime);
    String duration = activity.duration.toString();
    // remove .mmmmmm
    duration = duration.substring(0, duration.length - 7);
    String distance =
        '${(activity.distanceInMeters * 1e-3).toStringAsFixed(1)} km';
    return Card(
      child: ListTile(
        leading: Icon(getSportIcon(activity.sport)),
        title: Text(
            activity.name ?? '${AppLocalizations.of(context)!.activity} $date'),
        subtitle: Text('$date, $duration, $distance'),
        dense: true,
        //TODO turn that callback into a widget parameter
        onTap: () => navigateTo(
            RouteName.pastActivity, PastActivityPageParams(activity: activity)),
      ),
    );
  }
}
