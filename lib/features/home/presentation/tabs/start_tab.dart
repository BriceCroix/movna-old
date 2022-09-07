import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movna/core/injection.dart';
import 'package:movna/features/home/presentation/start_tab_bloc/start_tab_bloc.dart';
import 'package:movna/features/ongoing_activity/presentation/ongoing_activity_page.dart';

class StartTab extends StatelessWidget {
  const StartTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<StartTabBloc>(),
      child: const StartTabView(),
    );
  }
}

class StartTabView extends StatelessWidget {
  const StartTabView({super.key});

  Widget _buildStartBottomSheet(BuildContext context) {
    return BlocBuilder<StartTabBloc, StartTabState>(
      builder: (context, state) {
        state = state as StartTabLoaded;
        return Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.automaticPause),
                  Checkbox(
                    tristate: false,
                    value: state.settings.automaticPause,
                    onChanged: (value) => context
                        .read<StartTabBloc>()
                        .add(AutoPauseSettingChanged(autoPause: value!)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.automaticLock),
                  Checkbox(
                    tristate: false,
                    value: state.settings.automaticLock,
                    onChanged: (value) => context
                        .read<StartTabBloc>()
                        .add(AutoLockSettingChanged(autoLock: value!)),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO handle navigation better
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OngoingActivityPage()),
                  );
                },
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(AppLocalizations.of(context)!.start),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartTabBloc, StartTabState>(
      builder: (context, state) {
        return state is StartTabInitial
            ? const SpinKitRotatingCircle(color: Colors.blue, size: 50.0)
            : Scaffold(
                body: OSMFlutter(
                  controller: (state as StartTabLoaded).mapController,
                  trackMyPosition: true,
                  initZoom: 16,
                  minZoomLevel: 8,
                  maxZoomLevel: 18,
                  stepZoom: 1.0,
                  userLocationMarker: UserLocationMaker(
                    personMarker: const MarkerIcon(
                      icon: Icon(
                        Icons.circle,
                        color: Colors.blue,
                        size: 48,
                      ),
                    ),
                    directionArrowMarker: const MarkerIcon(
                      icon: Icon(
                        Icons.navigation,
                        color: Colors.blue,
                        size: 48,
                      ),
                    ),
                  ),
                  //onLocationChanged: (geoPoint) {},
                  mapIsLoading: const Center(
                    child:
                        SpinKitRotatingCircle(color: Colors.blue, size: 50.0),
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endFloat,
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      // The modal bottom sheet does not have access to bloc it seems
                      builder: (newContext) {
                        return BlocProvider.value(
                          value: context.read<StartTabBloc>(),
                          child: _buildStartBottomSheet(context),
                        );
                      },
                    );
                  },
                  heroTag: 'to_on_going_activity',
                  child: const Icon(Icons.play_arrow_rounded),
                ),
              );
      },
    );
  }
}
