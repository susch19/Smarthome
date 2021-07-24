import 'package:flutter/material.dart';

class _SystemPadding extends StatelessWidget {
  final Widget? child;

  _SystemPadding({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 0),
        child: child);
  }
}
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
          new FlatButton(
              child: new Text("Cancel"),
              onPressed: () => Navigator.pop(context!, "")),
          new FlatButton(
              child: new Text("Accept"),
              onPressed: () {
                Navigator.pop(context!, "");
                onSubmitted!(tec.text);
              })
        ]);
  }
}