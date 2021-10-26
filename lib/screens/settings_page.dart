import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/helper/preference_manager.dart';
import 'package:smarthome/helper/settings_manager.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/models/ipport.dart';

import 'screen_export.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool isEnabled = false;
  TextEditingController _textEditingController = TextEditingController(text: SettingsManager.serverUrl);

  String serverUrl = SettingsManager.serverUrl;

  bool isGrouped = SettingsManager.groupingEnabled;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Serversuche"),
      ),
      body: Container(
        decoration: ThemeManager.getBackgroundDecoration(context),
        child: ListView(
          children: [
            ListTile(
              title: Text(
                "Darstellung",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  // MaterialButton(
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       Icon(Icons.phone_android_outlined),
                  //       Text("System folgen"),
                  //     ],
                  //   ),
                  //   onPressed: () =>
                  //       ThemeManager.setThemeMode(context, AdaptiveThemeMode.system, setState: () => setState(() {})),
                  // ),
                  MaterialButton(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.light_mode),
                        Text("Helles Design"),
                      ],
                    ),
                    onPressed: () => ThemeManager.setThemeMode(context, AdaptiveThemeMode.light, setState: () => setState(() {})),
                  ),
                  MaterialButton(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.dark_mode_outlined),
                        Text("Dunkles Design"),
                      ],
                    ),
                    onPressed: () => ThemeManager.setThemeMode(context, AdaptiveThemeMode.dark, setState: () => setState(() {})),
                  ),
                ],
              ),
              // title: Text("Dunklen Modus anschalten"),
              // trailing: Switch(
              //   value: !ThemeManager.isLightTheme,
              //   onChanged: (a) {
              //     ThemeManager.toogleThemeMode(context);
              //     setState(() {});
              //   },
              // ),
            ),
            ListTile(
              title: Text("Gruppierungen ausblenden"),
              trailing: Switch(
                value: !SettingsManager.groupingEnabled,
                onChanged: (a) {
                  setState(() {
                    SettingsManager.setGroupingEnabled(a);
                  });
                },
              ),
            ),
            Divider(),
            ListTile(
              title: Text(
                "",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            ListTile(
              title: Text("Serversuche"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => ServerSearchScreen())).then((value) {
                  if (value is IpPort) {
                    var uri = Uri.parse("http://" + value.ipAddress);
                    uri = Uri(host: uri.host, port: value.port, scheme: uri.scheme, path: "SmartHome");
                    serverUrl = uri.toString();
                    SettingsManager.setServerUrl(serverUrl);
                    _textEditingController.text = serverUrl;
                    setState(() {});
                  }
                });
              },
            ),
            ListTile(
              leading: Text("URL"),
              title: TextField(
                controller: _textEditingController,
                decoration: InputDecoration(hintText: "URL vom Smarthome Server"),
                onSubmitted: (s) {
                  serverUrl = s;
                  SettingsManager.setServerUrl(serverUrl);
                },
              ),
              trailing: MaterialButton(
                child: Text("Speichern"),
                onPressed: () {
                  serverUrl = _textEditingController.text;
                  SettingsManager.setServerUrl(serverUrl);
                },
              ),
            ),
            ListTile(
              leading: Text("Entwickleransicht"),
              trailing: Switch(
                value: DeviceManager.showDebugInformation,
                onChanged: (a) {
                  DeviceManager.showDebugInformation = !DeviceManager.showDebugInformation;
                  setState(() {});
                },
              ),
            ),
            Divider(),
            ListTile(
              leading: Text("Über"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => AboutScreen(),
                ),
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
