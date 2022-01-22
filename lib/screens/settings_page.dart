import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/controls/checked_button.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/helper/settings_manager.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/models/ipport.dart';

import '../helper/connection_manager.dart';
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
    final theme = AdaptiveTheme.of(context);

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
                  MaterialButton(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.smartphone,
                            color: theme.theme.iconTheme.color!.withOpacity(theme.mode.isSystem ? 1 : 0.3),
                          ),
                          Text("System folgen"),
                        ],
                      ),
                      onPressed: () {
                        theme.setSystem();
                        setState(() {});
                      }),
                  MaterialButton(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(theme.mode.isLight ? Icons.light_mode : Icons.light_mode_outlined,
                              color: theme.theme.iconTheme.color!.withOpacity(theme.mode.isLight ? 1 : 0.3)),
                          Text("Helles Design"),
                        ],
                      ),
                      onPressed: () {
                        theme.setLight();
                        setState(() {});
                      }),
                  MaterialButton(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(theme.mode.isDark ? Icons.dark_mode : Icons.dark_mode_outlined,
                              color: theme.theme.iconTheme.color!.withOpacity(theme.mode.isDark ? 1 : 0.3)),
                          Text("Dunkles Design"),
                        ],
                      ),
                      onPressed: () {
                        theme.setDark();
                        setState(() {});
                      }),
                ],
              ),
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
                "Server",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            ListTile(
              title: Text("Serversuche öffnen"),
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
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Neue URL wurde gespeichert")));
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
            DeviceManager.showDebugInformation
                ? ListTile(
                    title: Text(
                      "Painless Mesh Zeit Update",
                    ),
                    onTap: () => ConnectionManager.hubConnection.invoke("UpdateTime"),
                  )
                : Container(),
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
