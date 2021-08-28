import 'package:flutter/material.dart';

class SimpleDialogSingleInput {
  static AlertDialog create(
      {String? hintText,
      String? labelText,
      String cancelButtonText = "Cancel",
      String acceptButtonText = "Accept",
      required String title,
      String defaultText = "",
      int maxLines = 1,
      ValueChanged<String>? onSubmitted,
      BuildContext? context}) {
    var tec = TextEditingController();
    tec.text = defaultText;

    return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                  decoration: InputDecoration(hintText: hintText, labelText: labelText),
                  controller: tec,
                  maxLines: maxLines,
                  autofocus: true,
                  onSubmitted: (s) {
                    Navigator.pop(context!);
                    onSubmitted!(s);
                  }),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(child: Text(cancelButtonText), onPressed: () => Navigator.pop(context!, "")),
          TextButton(
              child: Text(acceptButtonText),
              onPressed: () {
                Navigator.pop(context!, "");
                onSubmitted!(tec.text);
              })
        ]);
  }
}
