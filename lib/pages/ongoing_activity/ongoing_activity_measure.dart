import 'package:flutter/material.dart';

class OngoingActivityMeasure extends StatelessWidget {
  final double value;
  final String unit;
  final String legend;

  const OngoingActivityMeasure(
      {Key? key, required this.value, required this.legend, required this.unit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              value.toStringAsFixed(1),
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text(" $unit")
          ],
        ),
        Text(
          legend,
          style: const TextStyle(fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
