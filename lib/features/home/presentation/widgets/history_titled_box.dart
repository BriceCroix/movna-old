import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryTitledBox extends StatelessWidget {
  final void Function()? onMorePressed;
  final String title;
  final Widget child;

  const HistoryTitledBox(
      {Key? key, this.onMorePressed, required this.title, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              onPressed: onMorePressed,
              icon: const Icon(Icons.add),
              label: Text(AppLocalizations.of(context)!.more),
            )
          ],
        ),
      ),
      const Divider(
        indent: 30,
        endIndent: 30,
      ),
      Expanded(child: child),
    ]);
  }
}
