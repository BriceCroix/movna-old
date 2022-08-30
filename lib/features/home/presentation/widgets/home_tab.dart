import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movna/features/ongoing_activity/presentation/ongoing_activity_page.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController(
      initMapWithUserPosition: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OSMFlutter(
        controller: _mapController,
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
          child: SpinKitRotatingCircle(
            color: Colors.blue,
            size: 50.0,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OngoingActivityPage()),
          );
        },
        heroTag: "to_on_going_activity",
        child: const Icon(Icons.play_arrow_rounded),
      ),
    );
  }
}
