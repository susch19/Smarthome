import 'package:flutter/material.dart';

class SimpleDialog {
  static AlertDialog create({
    required final BuildContext context,
    final String title = "",
    final String content = "",
    final String cancelButtonText = "Cancel",
    final String okButtonText = "Ok",
    final Function? onSubmitted,
    final Function? onCancel,
  }) =>
      AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text(content)],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text(cancelButtonText),
                onPressed: () {
                  Navigator.pop(context, false);
                  onCancel?.call();
                }),
            TextButton(
                child: Text(okButtonText),
                onPressed: () {
                  Navigator.pop(context, true);
                  onSubmitted?.call();
                })
          ]);
}
