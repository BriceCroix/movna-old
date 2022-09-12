import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:latlong2/latlong.dart';
import 'package:movna/core/domain/entities/sport.dart';
import 'package:movna/core/injection.dart';
import 'package:movna/core/presentation/widgets/movna_tile_layers.dart';
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
                  Text(AppLocalizations.of(context)!.sport),
                  DropdownButton<Sport>(
                    value: state.settings.sport,
                    onChanged: (Sport? value) {
                      if(value != null) {
                        context
                            .read<StartTabBloc>()
                            .add(SportSettingChanged(sport: value));
                      }
                    },
                    items: Sport.values.map<DropdownMenuItem<Sport>>((Sport value) {
                      return DropdownMenuItem<Sport>(
                        value: value,
                        //TODO : translate name
                        child: Text(value.name),
                      );
                    }).toList(),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.automaticPause),
                  Checkbox(
                    tristate: false,
                    value: state.settings.automaticPause,
                    onChanged: (bool? value) => context
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
                    onChanged: (bool? value) => context
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
      buildWhen: (previous, current) =>
          (previous is! StartTabLoaded && current is StartTabLoaded),
      builder: (context, state) {
        return state is! StartTabLoaded
            ? const SpinKitRotatingCircle(color: Colors.blue, size: 50.0)
            : Scaffold(
                body: FlutterMap(
                  mapController: MapController(),
                  options: MapOptions(
                    zoom: 16.0,
                    maxZoom: 18.0,
                    minZoom: 6.0,
                    interactiveFlags:
                        InteractiveFlag.all & ~InteractiveFlag.rotate,
                    center: LatLng(state.position.latitudeInDegrees,
                        state.position.longitudeInDegrees),
                  ),
                  children: [
                    getOpenStreetMapTileLayer(),
                    BlocBuilder<StartTabBloc, StartTabState>(
                      builder: (context, state) {
                        StartTabLoaded stateLoaded = (state as StartTabLoaded);
                        return MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(
                                stateLoaded.position.latitudeInDegrees,
                                stateLoaded.position.longitudeInDegrees,
                              ),
                              builder: (context) => const Icon(
                                Icons.circle_rounded,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
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
