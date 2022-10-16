import 'package:flutter/material.dart';
import 'package:movna/core/domain/entities/itinerary.dart';

class ItineraryCard extends StatelessWidget {
  final Itinerary itinerary;
  final void Function()? onTap;

  const ItineraryCard({Key? key, required this.itinerary, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.route_rounded),
        title: Text(itinerary.name),
        //subtitle: ,
        dense: true,
        onTap: onTap,
      ),
    );
  }
}
