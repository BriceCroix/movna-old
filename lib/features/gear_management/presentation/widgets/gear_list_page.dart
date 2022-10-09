import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movna/core/domain/entities/gear.dart';
import 'package:movna/core/domain/entities/gear_type.dart';
import 'package:movna/core/injection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movna/core/presentation/router/router.dart';
import 'package:movna/core/presentation/widgets/movna_loading_spinner.dart';
import 'package:movna/features/gear_management/presentation/blocs/gear_list_bloc.dart';
import 'package:movna/features/gear_management/presentation/widgets/gear_card.dart';
import 'package:movna/features/gear_management/presentation/widgets/user_gear_page.dart';

class GearListPage extends StatelessWidget {
  const GearListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<GearListBloc>(),
      child: const _GearListView(),
    );
  }
}

class _GearListView extends StatelessWidget {
  const _GearListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GearListBloc, GearListState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(AppLocalizations.of(context)!.myGear)),
          body: state is GearListLoaded
              ? (state.gearList.isNotEmpty
                  ? _buildListView(context, state)
                  : Center(
                      child: Text(AppLocalizations.of(context)!.noGearYet)))
              : const Center(child: MovnaLoadingSpinner()),
          floatingActionButton: FloatingActionButton(
            onPressed: () => navigateTo(
              RouteName.userGear,
              UserGearPageParams(
                gear: Gear(
                  name: AppLocalizations.of(context)!.myNewGear,
                  gearType: GearType.other,
                  creationTime: DateTime.now(),
                ),
                editMode: true,
              ),
            ).then(
                (_) => context.read<GearListBloc>().add(RefreshGearPieces())),
            child: const Icon(Icons.add_rounded),
          ),
        );
      },
    );
  }

  Widget _buildListView(BuildContext context, GearListLoaded state) {
    return ListView.builder(
      itemCount: state.gearList.length,
      itemBuilder: (BuildContext context, int index) {
        Gear gear = state.gearList.elementAt(index);
        return GearCard(
            gear: gear,
            onTap: () =>
                navigateTo(RouteName.userGear, UserGearPageParams(gear: gear))
                    .then((_) =>
                        context.read<GearListBloc>().add(RefreshGearPieces())));
      },
    );
  }
}
