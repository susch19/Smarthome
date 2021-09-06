


import 'package:flutter/material.dart';
import 'package:smarthome/helper/theme_manager.dart';

class AboutScreen extends StatefulWidget {
  AboutScreen();

  @override
  State<StatefulWidget> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {


  @override
  void initState() {
    super.initState();
   
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  void changeColor() {}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("About the Universe")
        ),
        body: Container(
          decoration: ThemeManager.getBackgroundDecoration(context),
          child: Text("Here should be a body :)"),
        ),
    );
  }

}