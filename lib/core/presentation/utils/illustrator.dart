import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:movna/core/domain/entities/gear_type.dart';
import 'package:movna/core/domain/entities/sport.dart';

IconData getSportIcon(Sport sport) {
  switch (sport) {
    case Sport.walk:
      return Icons.directions_walk_rounded;
    case Sport.walkNordic:
      return Icons.directions_walk_rounded;
    case Sport.hiking:
      return Icons.hiking_rounded;
    case Sport.biking:
    case Sport.bikingRoad:
    case Sport.bikingMountain:
    case Sport.bikingElectric:
      return Icons.directions_bike_rounded;
    case Sport.running:
    case Sport.runningTrail:
      return Icons.directions_run_rounded;
    case Sport.skiingCrossCountry:
    case Sport.skiingOffPiste:
      return Icons.downhill_skiing_rounded;
    case Sport.snowboard:
      return Icons.snowboarding_rounded;
    case Sport.crossSkating:
      return Icons.skateboarding_rounded;
    case Sport.iceSkating:
      return Icons.ice_skating_rounded;
    case Sport.swimming:
      return Icons.pool_rounded;
    case Sport.scubaDiving:
      return Icons.scuba_diving_rounded;
    case Sport.kayak:
    case Sport.paddle:
      return Icons.kayaking_rounded;
    case Sport.surf:
      return Icons.surfing_rounded;
    case Sport.windsurfing:
    case Sport.kitesurfing:
      return Icons.kitesurfing_rounded;
    case Sport.scooter:
      return Icons.electric_scooter_rounded;
    case Sport.skateboarding:
      return Icons.skateboarding_rounded;
    case Sport.rollerblading:
      return Icons.roller_skating_rounded;
    case Sport.horseRiding:
      return MdiIcons.horseHuman;
    case Sport.other:
    default:
      return Icons.question_mark_rounded;
  }
}

IconData getGearTypeIcon(GearType gearType){
  switch(gearType){
    case GearType.shoes:
      return MdiIcons.shoeFormal;
    case GearType.bike:
      return MdiIcons.bicycle;
    case GearType.electricBike:
      return MdiIcons.bicycleElectric;
    case GearType.skis:
      return Icons.downhill_skiing_rounded;
    case GearType.snowboard:
      return Icons.snowboarding_rounded;
    case GearType.iceSkates:
      return Icons.ice_skating_rounded;
    case GearType.flippers:
      return MdiIcons.divingFlippers;
    case GearType.kayak:
      return MdiIcons.sailBoat;
    case GearType.paddleBoard:
      return MdiIcons.sailBoat;
    case GearType.surfBoard:
      return MdiIcons.sailBoat;
    case GearType.windsurfBoard:
      return MdiIcons.sailBoat;
    case GearType.scooter:
      return MdiIcons.scooter;
    case GearType.skateboard:
      return MdiIcons.skateboard;
    case GearType.rollerblades:
      return MdiIcons.rollerblade;
    case GearType.horse:
      return MdiIcons.horse;
    case GearType.other:
    default:
      return Icons.question_mark_rounded;
  }
}