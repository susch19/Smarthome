import 'package:flutter/material.dart';

class SimpleDialog {
  static AlertDialog create({
    required final BuildContext context,
    String title = "",
    String content = "",
    String cancelButtonText = "Cancel",
    String okButtonText = "Ok",
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
                  Navigator.pop(context, "");
                  onCancel?.call();
                }),
            TextButton(
                child: Text(okButtonText),
                onPressed: () {
                  Navigator.pop(context, "");
                  onSubmitted?.call();
                })
          ]);
}
