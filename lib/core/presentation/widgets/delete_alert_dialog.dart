import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeleteAlertDialog extends StatelessWidget {
  const DeleteAlertDialog(
      {Key? key, this.onCancel, this.onConfirm})
      : super(key: key);

  final void Function()? onConfirm;
  final void Function()? onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.deleteAlertTitle),
      content: SingleChildScrollView(
          child: Text(AppLocalizations.of(context)!.deleteAlertText)),
      actions: <Widget>[
        TextButton(
          onPressed: onCancel,
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text(AppLocalizations.of(context)!.confirm),
        ),
      ],
    );
  }
}
