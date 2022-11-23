import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:movna/core/domain/entities/activity.dart';
import 'package:movna/core/domain/entities/track_point.dart';
import 'package:movna/core/injection.dart';
import 'package:movna/core/presentation/utils/translator.dart';
import 'package:movna/core/presentation/widgets/delete_alert_dialog.dart';
import 'package:movna/core/presentation/widgets/movna_loading_spinner.dart';
import 'package:movna/core/presentation/widgets/movna_map_layers.dart';
import 'package:movna/core/presentation/widgets/presentation_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movna/features/activities_management/presentation/blocs/past_activity_bloc.dart';

/// Initial parameters of the page, only used to initialize the state.
class PastActivityPageParams {
  final Activity activity;

  PastActivityPageParams({
    required this.activity,
  });
}

class PastActivityPage extends StatelessWidget {
  const PastActivityPage({Key? key, required PastActivityPageParams params})
      : _params = params,
        super(key: key);
  final PastActivityPageParams _params;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          injector<PastActivityBloc>()..add(ParametersGiven(params: _params)),
      child: _PastActivityView(),
    );
  }
}

class _PastActivityView extends StatelessWidget {
  _PastActivityView({Key? key}) : super(key: key);

  final _mapController = MapController();

  /// The ratio of the screen height taken by the map
  static const double _mapRatio = 0.75;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PastActivityBloc, PastActivityState>(
        listener: (context, state) {
      if (state is PastActivityDone) {
        Navigator.of(context).pop();
      }
    }, builder: (context, state) {
      if (state is! PastActivityLoaded) {
        return const MovnaLoadingSpinner();
      }
      return Scaffold(
        appBar: _buildAppBar(context, state),
        body: LayoutBuilder(builder: (context, constraints) {
          double mapWidth = constraints.maxWidth;
          double mapHeight = constraints.maxHeight * _mapRatio;
          return BlocBuilder<PastActivityBloc, PastActivityState>(
            builder: (context, state) {
              if (state is! PastActivityLoaded) {
                return const MovnaLoadingSpinner();
              }
              return ListView(
                children: [
                  SizedBox(
                    height: mapHeight,
                    child: _buildMap(context, state, mapWidth, mapHeight),
                  ),
                  _buildActivityInfo(context, state),
                ],
              );
            },
          );
        }),
      );
    });
  }

  Widget _buildActionMenu(BuildContext context, PastActivityLoaded state) =>
      PopupMenuButton(
        itemBuilder: (context) {
          return [
            PopupMenuItem<PastActivityAction>(
              value: PastActivityAction.deleteActivity,
              child: Text(AppLocalizations.of(context)!.deleteActivity),
            ),
            PopupMenuItem<PastActivityAction>(
              value: PastActivityAction.createItineraryFromActivity,
              child: Text(
                  AppLocalizations.of(context)!.createItineraryFromActivity),
            ),
          ];
        },
        onSelected: (PastActivityAction value) {
          switch (value) {
            case PastActivityAction.deleteActivity:
              _showDeleteAlertDialog(context);
              break;
            case PastActivityAction.createItineraryFromActivity:
              context.read<PastActivityBloc>().add(CreateItineraryFromActivity(
                  itineraryName: AppLocalizations.of(context)!
                      .defaultItineraryName(state.activity.startTime)));
              break;
          }
        },
      );

  void _showDeleteAlertDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext newContext) => BlocProvider.value(
        value: context.read<PastActivityBloc>(),
        child: DeleteAlertDialog(
          onConfirm: () {
            context.read<PastActivityBloc>().add(DeleteActivityEvent());
            Navigator.of(context).pop();
          },
          onCancel: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, PastActivityLoaded state) => AppBar(
        title: Center(child: Text(AppLocalizations.of(context)!.activity)),
        actions: [
          _buildActionMenu(context, state),
        ],
      );

  Widget _buildMap(
    BuildContext context,
    PastActivityLoaded state,
    double mapWidth,
    double mapHeight,
  ) {
    // Find bounds of map
    double minLatitude =
        state.activity.trackPoints.isNotEmpty ? double.infinity : 0;
    double minLongitude =
        state.activity.trackPoints.isNotEmpty ? double.infinity : 0;
    double maxLatitude =
        state.activity.trackPoints.isNotEmpty ? double.negativeInfinity : 0;
    double maxLongitude =
        state.activity.trackPoints.isNotEmpty ? double.negativeInfinity : 0;
    for (TrackPoint t in state.activity.trackPoints) {
      if (t.position != null) {
        if (t.position!.latitudeInDegrees < minLatitude) {
          minLatitude = t.position!.latitudeInDegrees;
        }
        if (t.position!.longitudeInDegrees < minLongitude) {
          minLongitude = t.position!.longitudeInDegrees;
        }
        if (t.position!.latitudeInDegrees > maxLatitude) {
          maxLatitude = t.position!.latitudeInDegrees;
        }
        if (t.position!.longitudeInDegrees > maxLongitude) {
          maxLongitude = t.position!.longitudeInDegrees;
        }
      }
    }
    LatLng center = LatLng(
        (maxLatitude + minLatitude) / 2, (maxLongitude + minLongitude) / 2);
    double zoom = getMapZoom(
      mapWidth,
      mapHeight,
      minLatitude,
      maxLatitude,
      minLongitude,
      maxLongitude,
      1.2,
    );
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        zoom: zoom,
        maxZoom: 18.0,
        minZoom: 6.0,
        interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        center: center,
      ),
      children: [
        // Tile layer
        getOpenStreetMapTileLayer(),
        // Polyline layer
        getActivityPolylineLayer(activity: state.activity),
        // Markers layer
        BlocBuilder<PastActivityBloc, PastActivityState>(
          builder: (context, state) {
            if (state is PastActivityLoaded) {
              if (state.activity.trackPoints.isNotEmpty) {
                return getPathMarkerLayer(
                  start: state.activity.trackPoints.first.position,
                  user: state.position,
                  stop: state.activity.trackPoints.last.position,
                );
              } else {
                return getPathMarkerLayer(
                  user: state.position,
                );
              }
            } else {
              return const SizedBox();
            }
          },
        ),
      ],
    );
  }

  Widget _buildActivityInfo(BuildContext context, PastActivityLoaded state) {
    return Container(
      padding: const EdgeInsets.all(globalPadding),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.sport),
              Text(translateSport(state.activity.sport, context)),
            ],
          ),
          const SizedBox(height: globalPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.startTime),
              Text(state.activity.startTime.toString()),
            ],
          ),
          const SizedBox(height: globalPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.endTime),
              Text(state.activity.stopTime.toString()),
            ],
          ),
          const SizedBox(height: globalPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.duration),
              Text(state.activity.duration
                  .toString()
                  .split('.')
                  .first
                  .padLeft(8, '0')),
            ],
          ),
          const SizedBox(height: globalPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.pauseDuration),
              Text((state.activity.stopTime
                          .difference(state.activity.startTime) -
                      state.activity.duration)
                  .toString()
                  .split('.')
                  .first
                  .padLeft(8, '0')),
            ],
          ),
          const SizedBox(height: globalPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.distance),
              Text('${state.activity.distanceInMeters.toStringAsFixed(0)} m'),
            ],
          ),
          const SizedBox(height: globalPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.averageSpeed),
              Text(
                  '${state.activity.averageSpeedInKilometersPerHour.toStringAsFixed(1)} km/h')
            ],
          ),
          const SizedBox(height: globalPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.itinerary),
              Text(state.activity.itinerary != null
                  ? state.activity.itinerary!.name
                  : AppLocalizations.of(context)!.none),
            ],
          ),
        ],
      ),
    );
  }
}

enum PastActivityAction {
  deleteActivity,
  createItineraryFromActivity,
}
