import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:movna/core/domain/entities/activity.dart';
import 'package:movna/core/domain/entities/track_point.dart';
import 'package:movna/core/injection.dart';
import 'package:movna/core/presentation/utils/translator.dart';
import 'package:movna/core/presentation/widgets/movna_map_layers.dart';
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
  PastActivityView({Key? key, required Activity activity})
      : _activity = activity,
        super(key: key);
  final Activity _activity;

  final _mapController = MapController();

  /// The ratio of the screen height taken by the map
  static const double _mapRatio = 0.75;

  /// Computes adequate zoom level according to extremum coordinates to show.
  /// a [paddingFactor] above 1.0 allows not to have the extremum points on the border of the map, a typical value is 1.2.
  double _getZoom(BuildContext context, double minLatitude, double maxLatitude,
      double minLongitude, double maxLongitude, double paddingFactor) {
    // Explanation about zoom values
    // https://wiki.openstreetmap.org/wiki/Slippy_map_tilenames#Zoom_levels
    // https://wiki.openstreetmap.org/wiki/Zoom_levels

    // A huge thanks to Igor Brejc who gave their method at :
    // https://gis.stackexchange.com/questions/19632/how-to-calculate-the-optimal-zoom-level-to-display-two-or-more-points-on-a-map

    double mapWidth = MediaQuery.of(context).size.width;
    double mapHeight = MediaQuery.of(context).size.height * _mapRatio;

    double ry1 = math.log((math.sin(minLatitude * math.pi / 180) + 1) /
        math.cos(minLatitude * math.pi / 180));
    double ry2 = math.log((math.sin(maxLatitude * math.pi / 180) + 1) /
        math.cos(maxLatitude * math.pi / 180));
    double ryc = (ry1 + ry2) / 2;
    double sinhRyc = (math.exp(ryc) - math.exp(-ryc)) / 2;
    double centerY = math.atan(sinhRyc) * 180 / math.pi;

    double resolutionHorizontal = (maxLongitude - minLongitude) / mapWidth;

    double vy0 = math.log(math.tan(math.pi * (0.25 + centerY / 360)));
    double vy1 = math.log(math.tan(math.pi * (0.25 + maxLatitude / 360)));
    double viewHeightHalf = mapHeight / 2;
    double zoomFactorPowered =
        viewHeightHalf / (40.7436654315252 * (vy1 - vy0));
    double resolutionVertical = 360.0 / (zoomFactorPowered * 256);

    double resolution =
        math.max(resolutionHorizontal, resolutionVertical) * paddingFactor;
    late double zoom;
    if (resolution > 0) {
      zoom = math.log(360 / (resolution * 256)) / math.log(2);
    } else {
      zoom = 20;
    }

    return zoom;
  }

  @override
  Widget build(BuildContext context) {
    // Find bounds of map
    double minLatitude = _activity.trackPoints.isNotEmpty ? double.infinity : 0;
    double minLongitude =
        _activity.trackPoints.isNotEmpty ? double.infinity : 0;
    double maxLatitude =
        _activity.trackPoints.isNotEmpty ? double.negativeInfinity : 0;
    double maxLongitude =
        _activity.trackPoints.isNotEmpty ? double.negativeInfinity : 0;
    for (TrackPoint t in _activity.trackPoints) {
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
    double zoom = _getZoom(
        context, minLatitude, maxLatitude, minLongitude, maxLongitude, 1.2);

    /// The padding to use for the activity data under the map
    const double dataColumnPadding = 10;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(AppLocalizations.of(context)!.activity)),
        //TODO : actions with three dots button to delete or modify activity
      ),
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * _mapRatio,
            child: FlutterMap(
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
                getActivityPolylineLayer(activity: _activity),
                // Markers layer
                BlocBuilder<PastActivityBloc, PastActivityState>(
                  builder: (context, state) {
                    if (_activity.trackPoints.isNotEmpty) {
                      return getActivityMarkerLayer(
                        start: _activity.trackPoints.first.position,
                        user: (state is PastActivityLoaded)
                            ? state.position
                            : null,
                        stop: _activity.trackPoints.last.position,
                      );
                    } else {
                      return getActivityMarkerLayer(
                        user: (state is PastActivityLoaded)
                            ? state.position
                            : null,
                      );
                    }
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
                    Text(translateSport(_activity.sport, context)),
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
