import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:movna/core/domain/entities/activity.dart';
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

/// Creates a FlutterMap polyline layer to display the activity path over its
/// itinerary path if available.
PolylineLayer getActivityPolylineLayer({
  required Activity activity}
) {
  List<Polyline> polyline = [];

  if(activity.itinerary != null){
    // Create itinerary polyline
    List<LatLng> itineraryPoints = [];
    for (Position p in activity.itinerary!.positions) {
        itineraryPoints.add(LatLng(
            p.latitudeInDegrees, p.longitudeInDegrees));
    }
    polyline.add(Polyline(
      points: itineraryPoints,
      color: itineraryPathColor,
      strokeWidth: 4,
    ));
  }

  // Create activity path polyline
  List<LatLng> activityPoints = [];
  for (TrackPoint t in activity.trackPoints) {
    if (t.position != null) {
      activityPoints.add(LatLng(
          t.position!.latitudeInDegrees, t.position!.longitudeInDegrees));
    }
  }
  polyline.add(Polyline(
    points: activityPoints,
    color: userPositionColor,
    strokeWidth: 4,
  ));

  return PolylineLayer(
    polylineCulling: false,
    polylines: polyline,
  );
}

MarkerLayer getActivityMarkerLayer({Position? start, Position? user, Position? stop}){
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


