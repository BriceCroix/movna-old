import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movna/core/domain/entities/itinerary.dart';
import 'package:movna/core/injection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movna/core/presentation/router/router.dart';
import 'package:movna/core/presentation/widgets/movna_loading_spinner.dart';
import 'package:movna/features/itineraries_management/presentation/blocs/itineraries_list_bloc.dart';
import 'package:movna/features/itineraries_management/presentation/widgets/itinerary_card.dart';
import 'package:movna/features/itineraries_management/presentation/widgets/user_itinerary_page.dart';

class ItinerariesListPage extends StatelessWidget {
  const ItinerariesListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<ItinerariesListBloc>(),
      child: const _ItinerariesListView(),
    );
  }
}

class _ItinerariesListView extends StatelessWidget {
  const _ItinerariesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItinerariesListBloc, ItinerariesListState>(
      builder: (context, state) {
        return Scaffold(
          appBar:
              AppBar(title: Text(AppLocalizations.of(context)!.myItineraries)),
          body: state is ItinerariesListLoaded
              ? (state.itinerariesList.isNotEmpty
                  ? _buildListView(context, state)
                  : Center(
                      child:
                          Text(AppLocalizations.of(context)!.noItinerariesYet)))
              : const Center(child: MovnaLoadingSpinner()),
        );
      },
    );
  }

  Widget _buildListView(BuildContext context, ItinerariesListLoaded state) {
    return ListView.builder(
      itemCount: state.itinerariesList.length,
      itemBuilder: (BuildContext context, int index) {
        Itinerary itinerary = state.itinerariesList.elementAt(index);
        return ItineraryCard(
          itinerary: itinerary,
          onTap: () => navigateTo(RouteName.userItinerary,
                  UserItineraryPageParams(itinerary: itinerary))
              .whenComplete(() => context
                  .read<ItinerariesListBloc>()
                  .add(RefreshItineraries())),
        );
      },
    );
  }
}
