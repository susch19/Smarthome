import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smarthome/helper/helper_methods.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/helper/update_manager.dart';
import 'package:smarthome/models/versionAndUrl.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Über"),
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(final BuildContext context) {
    final iconColor = AdaptiveTheme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;
    return Container(
      decoration: ThemeManager.getBackgroundDecoration(context),
      child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Center(
                  child: SvgPicture.asset(
                    "assets/vectors/smarthome_icon.svg",
                    width: 200,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 8.0,
                  ),
                  child: const Center(
                    child: Text(
                      "Smarthome",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          const ListTile(
            title: Text(
              "So kostenlos! So toll! So einmalig!",
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const ListTile(
            title: Text(
              "Tolle Beschreibung dieser Smarthome App",
              textAlign: TextAlign.center,
            ),
            // "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."),
          ),
          const ListTile(
            title: Text(
              "Fragen? Antworten!",
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(),
          const ListTile(
            title: Text(
              "Entwickelt von susch19 (Sascha Hering)",
            ),
          ),
          FutureBuilder<VersionAndUrl?>(
              future: UpdateManager.getVersionAndUrl(),
              builder: (final context, final AsyncSnapshot<VersionAndUrl?> snapshot) {
                return ListTile(
                    title: Row(children: [
                      Text(UpdateManager.getVersionString(snapshot.data?.version)),
                      if (!snapshot.hasData && !snapshot.hasError)
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: CircularProgressIndicator(),
                        )
                    ]),
                    onTap: () {
                      if (snapshot.data?.url != null) {
                        HelperMethods.openUrl(snapshot.data!.url!);
                      }
                    });
              }),

          const Divider(),
          ListTile(
            leading: SvgPicture.asset(
              "assets/vectors/github.svg",
              color: iconColor,
              width: 32,
            ),
            title: const Text("Schau doch mal in den Code auf GitHub rein"),
            onTap: () => HelperMethods.openUrl("https://github.com/susch19/smarthome"),
          ),
          const Divider(),
          ListTile(
            leading: SvgPicture.asset("assets/vectors/smarthome_icon.svg", width: 32),
            title: const Text("Wer hat dieses schicke Icon gemacht? Finde es heraus!"),
            onTap: () =>
                HelperMethods.openUrl("https://iconarchive.com/show/flatwoken-icons-by-alecive/Apps-Home-icon.html"),
          ),
          // Divider(),
          // ListTile(
          //   leading: SvgPicture.asset("assets/vectors/google_play.svg", alignment: Alignment.center, width: 32),
          //   title: Text("Play Store Eintrag"),
          //   onTap: () => HelperMethods.openUrl("https://play.google.com/store/apps/details?id=de.susch19.nssl"),
          // ),
        ],
      ),
    );
  }
}
