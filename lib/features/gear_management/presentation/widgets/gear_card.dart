import 'package:flutter/material.dart';
import 'package:movna/core/domain/entities/gear.dart';
import 'package:movna/core/presentation/utils/illustrator.dart';
import 'package:movna/core/presentation/utils/translator.dart';

class GearCard extends StatelessWidget {
  final Gear gear;
  final void Function()? onTap;

  const GearCard({Key? key, required this.gear, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(getGearTypeIcon(gear.gearType)),
        title: Text(gear.name),
        subtitle: Text(translateGearType(gear.gearType, context)),
        dense: true,
        onTap: onTap,
      ),
    );
  }
}
