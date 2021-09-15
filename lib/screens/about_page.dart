import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Über"),
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    var iconColor = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark ? Colors.white : Colors.black;
    return Container(
      decoration: ThemeManager.getBackgroundDecoration(context),
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Center(
                  child: SvgPicture.asset(
                    "assets/vectors/smarthome_icon.svg",
                    width: 200,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 8.0,
                  ),
                  child: Center(
                    child: Text(
                      "Smarthome",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              "So Kostenlos, so toll, so einmalig",
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          ListTile(
            title: Text(
              "Tolle beschreibung dieser Smarthome App",
              textAlign: TextAlign.center,
            ),
            // "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."),
          ),
          ListTile(
            title: Text(
              "Fragen? Antworten!",
              textAlign: TextAlign.center,
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              "Entwickelt von susch19 (Sascha Hering)",
            ),
          ),
          ListTile(
            title: Text("Version 0.25"),
          ),
          Divider(),
          ListTile(
            leading: SvgPicture.asset(
              "assets/vectors/github.svg",
              color: iconColor,
              width: 32,
            ),
            title: Text("Schau doch mal in den Code auf GitHub rein"),
            onTap: () {
              var urlString = "https://github.com/susch19/smarthome";
              canLaunch(urlString).then((value) {
                if (value) launch(urlString);
              });
            },
          ),
          Divider(),
          ListTile(
            leading: SvgPicture.asset("assets/vectors/smarthome_icon.svg", alignment: Alignment.center, width: 32),
            title: Text("Wer hat dieses schicke Icon gemacht? Finde es heraus!"),
            onTap: () {
              var urlString = "https://iconarchive.com/show/flatwoken-icons-by-alecive/Apps-Home-icon.html";
              canLaunch(urlString).then((value) {
                if (value) launch(urlString);
              });
            },
          ),
          Divider(),
          ListTile(
            leading: SvgPicture.asset("assets/vectors/google_play.svg", alignment: Alignment.center, width: 32),
            title: Text("Play Store Eintrag"),
            onTap: () {
              var urlString = "https://play.google.com/store/apps/details?id=de.susch19.nssl";
              canLaunch(urlString).then((value) {
                if (value) launch(urlString);
              });
            },
          ),
        ],
      ),
    );
  }
}
