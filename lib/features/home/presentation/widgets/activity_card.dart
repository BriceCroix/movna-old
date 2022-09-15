import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movna/core/domain/entities/activity.dart';
import 'package:movna/core/domain/entities/sport.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movna/core/presentation/router/router.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({Key? key, required this.activity}) : super(key: key);

  static IconData getSportIcon(Sport sport) {
    switch (sport) {
      case Sport.walk:
        return Icons.directions_walk_rounded;
      case Sport.walkNordic:
        return Icons.directions_walk_rounded;
      case Sport.hiking:
        return Icons.hiking_rounded;
      case Sport.biking:
      case Sport.bikingRoad:
      case Sport.bikingMountain:
      case Sport.bikingElectric:
        return Icons.directions_bike_rounded;
      case Sport.running:
      case Sport.runningTrail:
        return Icons.directions_run_rounded;
      case Sport.skiingCrossCountry:
      case Sport.skiingOffPiste:
        return Icons.downhill_skiing_rounded;
      case Sport.snowboard:
        return Icons.snowboarding_rounded;
      case Sport.crossSkating:
        return Icons.skateboarding_rounded;
      case Sport.iceSkating:
        return Icons.ice_skating_rounded;
      case Sport.swimming:
        return Icons.pool_rounded;
      case Sport.scubaDiving:
        return Icons.scuba_diving_rounded;
      case Sport.kayak:
      case Sport.paddle:
        return Icons.kayaking_rounded;
      case Sport.surf:
        return Icons.surfing_rounded;
      case Sport.windsurfing:
      case Sport.kitesurfing:
        return Icons.kitesurfing_rounded;
      case Sport.scooter:
        return Icons.electric_scooter_rounded;
      case Sport.skateboarding:
        return Icons.skateboarding_rounded;
      case Sport.rollerblading:
        return Icons.roller_skating_rounded;
      case Sport.horseRiding:
        return Icons.sunny; //TODO : use more icons
      case Sport.other:
      default:
        return Icons.question_mark_rounded;
    }
  }

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
        onTap: () => navigateTo(RouteName.pastActivity, activity),
      ),
    );
  }
}
