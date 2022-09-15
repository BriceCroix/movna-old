import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:movna/core/domain/entities/activity.dart';
import 'package:movna/core/domain/entities/track_point.dart';
import 'package:movna/core/injection.dart';
import 'package:movna/core/presentation/widgets/movna_tile_layers.dart';
import 'package:movna/features/past_activity/presentation/blocs/past_activity_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PastActivityPage extends StatelessWidget {
  const PastActivityPage({Key? key, required Activity activity})
      : _activity = activity,
        super(key: key);
  final Activity _activity;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => injector<PastActivityBloc>(),
      child: PastActivityView(activity: _activity),
    );
  }
}

class PastActivityView extends StatelessWidget {
  const PastActivityView({Key? key, required Activity activity})
      : _activity = activity,
        super(key: key);
  final Activity _activity;

  Color _getUserColor(BuildContext context) =>
      Theme.of(context).colorScheme.secondary;

  @override
  Widget build(BuildContext context) {
    // Create list of points of activity for the map
    List<LatLng> points = [];
    for (TrackPoint t in _activity.trackPoints) {
      if (t.position != null) {
        points.add(LatLng(
            t.position!.latitudeInDegrees, t.position!.longitudeInDegrees));
      }
    }

    List<Marker> markers = [];
    // Add starting point
    if (points.isNotEmpty) {
      markers.add(Marker(
        point: points.first,
        builder: (context) => const Icon(
          Icons.circle_rounded,
          color: Colors.green,
        ),
      ));
    }
    // Add ending point
    if (points.isNotEmpty) {
      markers.add(Marker(
        point: points.last,
        builder: (context) => const Icon(
          Icons.circle_rounded,
          color: Colors.red,
        ),
      ));
    }
    // Find bounds of map
    double minLatitude = double.infinity;
    double minLongitude = double.infinity;
    double maxLatitude = double.negativeInfinity;
    double maxLongitude = double.negativeInfinity;
    for (LatLng p in points) {
      if (p.latitude < minLatitude) {
        minLatitude = p.latitude;
      }
      if (p.longitude < minLongitude) {
        minLongitude = p.longitude;
      }
      if (p.latitude > maxLatitude) {
        maxLatitude = p.latitude;
      }
      if (p.longitude > maxLongitude) {
        maxLongitude = p.longitude;
      }
    }
    const double dataColumnPadding = 10;
    // TODO put map boundaries according to min and max coordinates
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(AppLocalizations.of(context)!.activity)),
        //TODO : actions with three dots button to delete or modify activity
      ),
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 3 / 4,
            child: FlutterMap(
              mapController: MapController(),
              options: MapOptions(
                zoom: 16.0,
                maxZoom: 18.0,
                minZoom: 6.0,
                interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                center: (points.isNotEmpty) ? points.first : LatLng(0, 0),
                //bounds: LatLngBounds(LatLng(minLatitude, minLongitude),
                //    LatLng(maxLatitude, maxLongitude)),
              ),
              children: [
                getOpenStreetMapTileLayer(),
                PolylineLayer(
                  polylineCulling: false,
                  polylines: [
                    Polyline(
                      points: points,
                      color: _getUserColor(context),
                      strokeWidth: 4,
                    ),
                  ],
                ),
                BlocBuilder<PastActivityBloc, PastActivityState>(
                  builder: (context, state) {
                    List<Marker> markersWithUser = markers;
                    if (state is PastActivityLoaded) {
                      markersWithUser.add(Marker(
                        point: LatLng(state.position.latitudeInDegrees,
                            state.position.longitudeInDegrees),
                        builder: (context) => Icon(
                          Icons.circle_rounded,
                          color: _getUserColor(context),
                        ),
                      ));
                    }
                    return MarkerLayer(markers: markersWithUser);
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(dataColumnPadding),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.sport),
                    //TODO : translate sport
                    Text(_activity.sport.name),
                  ],
                ),
                const SizedBox(height: dataColumnPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.startTime),
                    Text(_activity.startTime.toString()),
                  ],
                ),
                const SizedBox(height: dataColumnPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.endTime),
                    Text(_activity.stopTime.toString()),
                  ],
                ),
                const SizedBox(height: dataColumnPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.duration),
                    Text(_activity.duration
                        .toString()
                        .split('.')
                        .first
                        .padLeft(8, '0')),
                  ],
                ),
                const SizedBox(height: dataColumnPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.pauseDuration),
                    Text((_activity.stopTime.difference(_activity.startTime) -
                            _activity.duration)
                        .toString()
                        .split('.')
                        .first
                        .padLeft(8, '0')),
                  ],
                ),
                const SizedBox(height: dataColumnPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.distance),
                    Text('${_activity.distanceInMeters.toStringAsFixed(0)} m'),
                  ],
                ),
                const SizedBox(height: dataColumnPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.averageSpeed),
                    Text(
                        '${_activity.averageSpeedInKilometersPerHour.toStringAsFixed(1)} km/h')
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
