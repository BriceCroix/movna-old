import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

const String movnaPackageName = 'dev.procyoncithara.movna';

TileLayer getOpenStreetMapTileLayer(){
  return
    TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: movnaPackageName,
    );
}

SizedBox getEmptyTileLayer(){
  return const SizedBox();
}