import 'package:flutter/material.dart';
import 'package:movna/core/presentation/widgets/titled_box.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ProfileTab extends StatelessWidget {
  const ProfileTab({Key? key}) : super(key: key);
  // TODO serve all tabs with a "HomeBloc"

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
          TitledBox(
            title: AppLocalizations.of(context)!.myProfile,
            //onMorePressed: nothing more to show or do here,
            child: Text('TODO'), //TODO
          ),
        TitledBox(
          title: AppLocalizations.of(context)!.myItineraries,
          onMorePressed: (){
            //TODO
          },
          child: Text('TODO'), //TODO
        ),
        TitledBox(
          title: AppLocalizations.of(context)!.myGear,
          onMorePressed: (){
            //TODO
          },
          child: Text('TODO'), //TODO
        ),
        TitledBox(
          title: AppLocalizations.of(context)!.settings,
          //onMorePressed: nothing more to show or do here,
          child: Text('TODO'), //TODO
        ),
      ],
    );
  }
}
