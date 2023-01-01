import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:movna/core/domain/entities/activity.dart';
import 'package:movna/core/domain/entities/itinerary.dart';
import 'package:movna/core/domain/entities/position.dart';
import 'package:movna/core/domain/entities/track_point.dart';
import 'package:movna/core/presentation/widgets/colors.dart';

const String movnaPackageName = 'dev.procyoncithara.movna';

TileLayer getOpenStreetMapTileLayer() {
  return TileLayer(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    userAgentPackageName: movnaPackageName,
  );
}

Polyline _buildItineraryPolyline(Itinerary itinerary) {
  return Polyline(
    points: itinerary.positions
        .map((e) => LatLng(e.latitudeInDegrees, e.longitudeInDegrees))
        .toList(),
    color: itineraryPathColor,
    strokeWidth: 4,
  );
}

/// Creates a FlutterMap polyline layer to represent an itinerary.
PolylineLayer getItineraryPolylineLayer(Itinerary itinerary) => PolylineLayer(
      polylineCulling: false,
      polylines: [_buildItineraryPolyline(itinerary)],
    );

/// Creates a FlutterMap polyline layer to display the activity path over its
/// itinerary path if available.
PolylineLayer getActivityPolylineLayer({required Activity activity}) {
  const double strokeWidth = 4;
  List<Polyline> polylines = [];

  if (activity.itinerary != null) {
    polylines.add(_buildItineraryPolyline(activity.itinerary!));
  }

  // Create activity path polyline
  for (var iSegment = 0;
      iSegment < activity.trackPointsSegments.length;
      iSegment++) {
    // Actual path
    final segment = activity.trackPointsSegments[iSegment];
    List<LatLng> activityPoints = [];
    for (TrackPoint t in segment) {
      if (t.position != null) {
        activityPoints.add(LatLng(
            t.position!.latitudeInDegrees, t.position!.longitudeInDegrees));
      }
    }
    polylines.add(Polyline(
      points: activityPoints,
      color: userPositionColor,
      strokeWidth: strokeWidth,
    ));

    // Pause path
    if (iSegment < activity.trackPointsSegments.length - 1) {
      final nextSegment = activity.trackPointsSegments[iSegment + 1];
      if (segment.last.position != null && nextSegment.first.position != null) {
        polylines.add(Polyline(
          points: [
            LatLng(segment.last.position!.latitudeInDegrees,
                segment.last.position!.longitudeInDegrees),
            LatLng(nextSegment.first.position!.latitudeInDegrees,
                nextSegment.first.position!.longitudeInDegrees),
          ],
          color: pauseColor,
          strokeWidth: strokeWidth,
        ));
      }
    }
  }

  return PolylineLayer(
    polylineCulling: false,
    polylines: polylines,
  );
}

MarkerLayer getPathMarkerLayer(
    {Position? start, Position? user, Position? stop}) {
  List<Marker> markers = [];
  // Add starting point
  if (start != null) {
    markers.add(Marker(
      point: LatLng(start.latitudeInDegrees, start.longitudeInDegrees),
      builder: (context) => const Icon(
        Icons.circle_rounded,
        color: startColor,
      ),
    ));
  }
  // Add ending point
  if (stop != null) {
    markers.add(Marker(
      point: LatLng(stop.latitudeInDegrees, stop.longitudeInDegrees),
      builder: (context) => const Icon(
        Icons.circle_rounded,
        color: stopColor,
      ),
    ));
  }
  // Add user point
  if (user != null) {
    markers.add(Marker(
      point: LatLng(user.latitudeInDegrees, user.longitudeInDegrees),
      builder: (context) => const Icon(
        Icons.circle_rounded,
        color: userPositionColor,
      ),
    ));
  }
  return MarkerLayer(markers: markers);
}

/// Computes adequate zoom level according to extremum coordinates to show.
/// [mapHeight] and [mapWidth] are the size of the map widget in virtual pixels.
/// a [paddingFactor] above 1.0 allows not to have the extremum points on the border of the map, a typical value is 1.2.
double getMapZoom(
  double mapWidth,
  double mapHeight,
  double minLatitude,
  double maxLatitude,
  double minLongitude,
  double maxLongitude,
  double paddingFactor,
) {
  // Explanation about zoom values
  // https://wiki.openstreetmap.org/wiki/Slippy_map_tilenames#Zoom_levels
  // https://wiki.openstreetmap.org/wiki/Zoom_levels

  // A huge thanks to Igor Brejc who gave their method at :
  // https://gis.stackexchange.com/questions/19632/how-to-calculate-the-optimal-zoom-level-to-display-two-or-more-points-on-a-map

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
  double zoomFactorPowered = viewHeightHalf / (40.7436654315252 * (vy1 - vy0));
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
