import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// If [child] is scrollable, make sure to wrap it in an Expanded widget
class TitledBox extends StatelessWidget {
  final void Function()? onMorePressed;
  final String title;
  final Widget child;

  const TitledBox(
      {Key? key, this.onMorePressed, required this.title, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              onMorePressed != null
                  ? ElevatedButton.icon(
                      onPressed: onMorePressed,
                      icon: const Icon(Icons.add_rounded),
                      label: Text(AppLocalizations.of(context)!.more),
                    )
                  : const SizedBox(),
            ],
          ),
          const Divider(
            indent: 30,
            endIndent: 30,
          ),
          child,
        ],
      ),
    );
  }
}
