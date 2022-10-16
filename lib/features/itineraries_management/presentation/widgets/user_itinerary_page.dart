import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:movna/core/domain/entities/itinerary.dart';
import 'package:movna/core/domain/entities/position.dart';
import 'package:movna/core/injection.dart';
import 'package:movna/core/presentation/widgets/delete_alert_dialog.dart';
import 'package:movna/core/presentation/widgets/movna_loading_spinner.dart';
import 'package:movna/core/presentation/widgets/movna_map_layers.dart';
import 'package:movna/core/presentation/widgets/presentation_constants.dart';
import 'package:movna/features/itineraries_management/presentation/blocs/user_itinerary_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Initial parameters of the page, only used to initialize the state.
class UserItineraryPageParams {
  final Itinerary itinerary;

  UserItineraryPageParams({
    required this.itinerary,
  });
}

class UserItineraryPage extends StatelessWidget {
  const UserItineraryPage(
      {Key? key, required UserItineraryPageParams pageParams})
      : _pageParams = pageParams,
        super(key: key);
  final UserItineraryPageParams _pageParams;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<UserItineraryBloc>()
        ..add(ParametersGiven(params: _pageParams)),
      child: _UserItineraryView(),
    );
  }
}

class _UserItineraryView extends StatelessWidget {
  _UserItineraryView({Key? key}) : super(key: key);

  /// The ratio of its parent that the map can take.
  static const double _mapRatio = 0.75;
  final _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserItineraryBloc, UserItineraryState>(
      listener: (context, state) {
        if (state is UserItineraryDone) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state is! UserItineraryLoaded) {
          return const MovnaLoadingSpinner();
        }
        return Scaffold(
            appBar: _buildAppBar(context, state),
            body: LayoutBuilder(
              builder: ((context, constraints) {
                double mapWidth = constraints.maxWidth;
                double mapHeight = constraints.maxHeight * _mapRatio;
                return ListView(
                  children: [
                    SizedBox(
                      height: mapHeight,
                      child: _buildMap(context, state, mapWidth, mapHeight),
                    ),
                    _buildItineraryInfo(context, state),
                  ],
                );
              }),
            ));
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, UserItineraryLoaded state) {
    return AppBar(
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: globalPadding),
          child: GestureDetector(
            onTap: () {
              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext newContext) => BlocProvider.value(
                  value: context.read<UserItineraryBloc>(),
                  child: DeleteAlertDialog(
                    onConfirm: () {
                      context
                          .read<UserItineraryBloc>()
                          .add(DeleteItineraryEvent());
                      Navigator.of(context).pop();
                    },
                    onCancel: () => Navigator.of(context).pop(),
                  ),
                ),
              );
            },
            child: const Icon(Icons.delete_rounded),
          ),
        )
      ],
    );
  }

  Widget _buildMap(
    BuildContext context,
    UserItineraryLoaded state,
    double mapWidth,
    double mapHeight,
  ) {
    // Find bounds of map
    double minLatitude =
        state.itinerary.positions.isNotEmpty ? double.infinity : 0;
    double minLongitude =
        state.itinerary.positions.isNotEmpty ? double.infinity : 0;
    double maxLatitude =
        state.itinerary.positions.isNotEmpty ? double.negativeInfinity : 0;
    double maxLongitude =
        state.itinerary.positions.isNotEmpty ? double.negativeInfinity : 0;
    for (Position p in state.itinerary.positions) {
      if (p.latitudeInDegrees < minLatitude) {
        minLatitude = p.latitudeInDegrees;
      }
      if (p.longitudeInDegrees < minLongitude) {
        minLongitude = p.longitudeInDegrees;
      }
      if (p.latitudeInDegrees > maxLatitude) {
        maxLatitude = p.latitudeInDegrees;
      }
      if (p.longitudeInDegrees > maxLongitude) {
        maxLongitude = p.longitudeInDegrees;
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
        // See this for zoom to scale : https://wiki.openstreetmap.org/wiki/Slippy_map_tilenames#Zoom_levels
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
        getItineraryPolylineLayer(state.itinerary),
        // Markers layer
        BlocBuilder<UserItineraryBloc, UserItineraryState>(
          builder: (context, state) {
            if (state is UserItineraryLoaded) {
              if (state.itinerary.positions.isNotEmpty) {
                return getPathMarkerLayer(
                  start: state.itinerary.positions.first,
                  user: state.userPosition,
                  stop: state.itinerary.positions.last,
                );
              } else {
                return getPathMarkerLayer(
                  user: state.userPosition,
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

  Widget _buildItineraryInfo(BuildContext context, UserItineraryLoaded state) {
    return Container(
      padding: const EdgeInsets.all(globalPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.name),
              Text(state.itinerary.name),
            ],
          ),
          const SizedBox(height: globalPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.distance),
              Text('${state.itinerary.distanceInMeters.toStringAsFixed(0)} m'),
            ],
          ),
          //TODO : get number of time itinerary was used, best time, etc...
        ],
      ),
    );
  }
}
