import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movna/data/activity_manager.dart';
import 'package:movna/model/activity_base.dart';
import 'package:movna/pages/home/history_titled_box.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({Key? key}) : super(key: key);

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: HistoryTitledBox(
            title: AppLocalizations.of(context)!.activities,
            onMorePressed: () {
              //TODO : Navigator push pastActivitiesPage
            },
            child: FutureBuilder(
              future: getLastNActivities(10),
              builder: (context, AsyncSnapshot<List<ActivityBase>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitRotatingCircle(
                      color: Colors.blue,
                      size: 50.0,
                    ),
                  );
                } else {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context)!.noActivityYet,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  } else {
                    List<ActivityBase> activities = snapshot.data!;
                    return ListView(
                      children: activities
                          .map((activity) => Card(
                                child: ListTile(
                                  //TODO : relevant icon
                                  leading: const Icon(
                                      Icons.sports_gymnastics_rounded),
                                  title: Text(activity.startTime.toString()),
                                  subtitle: Text(activity.stopTime.toString()),
                                  dense: true,
                                ),
                              ))
                          .toList(),
                    );
                  }
                }
              },
            ),
          ),
        ),
        const Divider(),
        Expanded(
          child: HistoryTitledBox(
            title: AppLocalizations.of(context)!.statistics,
            child: const Center(child: Text('TODO')),
          ),
        ), // TODO
      ],
    );
  }
}
