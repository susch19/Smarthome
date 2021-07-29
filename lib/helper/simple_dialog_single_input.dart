import 'package:flutter/material.dart';

class SimpleDialogSingleInput {

  static AlertDialog create(
      {String? hintText,
      String? labelText,
      required String title,
      String defaultText = "",
      int maxLines = 1,
      ValueChanged<String>? onSubmitted,
      BuildContext? context}) {
    var tec = new TextEditingController();
    tec.text = defaultText;

    return  new AlertDialog(
        title: new Text(title),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new TextField(
                  decoration:
                  new InputDecoration(hintText: hintText, labelText: labelText),
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
          new TextButton(
              child: new Text("Cancel"),
              onPressed: () => Navigator.pop(context!, "")),
          new TextButton(
              child: new Text("Accept"),
              onPressed: () {
                Navigator.pop(context!, "");
                onSubmitted!(tec.text);
              })
        ]);
  }
}