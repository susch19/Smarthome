import 'package:flutter/material.dart';

class SimpleDialogSingleInput {
  static AlertDialog create(
      {final String? hintText,
      final String? labelText,
      final String cancelButtonText = "Cancel",
      final String acceptButtonText = "Accept",
      required final String title,
      final String defaultText = "",
      final int maxLines = 1,
      final ValueChanged<String>? onSubmitted,
      final BuildContext? context}) {
    final tec = TextEditingController();
    tec.text = defaultText;

    return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                  decoration:
                      InputDecoration(hintText: hintText, labelText: labelText),
                  controller: tec,
                  maxLines: maxLines,
                  autofocus: true,
                  onSubmitted: (final s) {
                    Navigator.pop(context!);
                    onSubmitted!(s);
                  }),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
              child: Text(cancelButtonText),
              onPressed: () => Navigator.pop(context!, "")),
          TextButton(
              child: Text(acceptButtonText),
              onPressed: () {
                Navigator.pop(context!, "");
                onSubmitted!(tec.text);
              })
        ]);
  }
}
