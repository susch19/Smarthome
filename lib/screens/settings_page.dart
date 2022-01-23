import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/helper/settings_manager.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/models/ipport.dart';

import '../helper/connection_manager.dart';
import 'screen_export.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({final Key? key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends ConsumerState<SettingsPage> {
  bool isEnabled = false;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(final BuildContext context) {
    final theme = AdaptiveTheme.of(context);
    final hubConnection = ref.watch(hubConnectionProvider);
    // final _ = ref.watch(brightnessProvider);
    final settings = ref.watch(settingsProvider);
    _textEditingController.text = settings.serverUrl;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Serversuche"),
      ),
      body: Container(
        decoration: ThemeManager.getBackgroundDecoration(context),
        child: ListView(
          children: [
            const ListTile(
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
                        children: [
                          Icon(
                            Icons.smartphone,
                            color: theme.theme.iconTheme.color!.withOpacity(theme.mode.isSystem ? 1 : 0.3),
                          ),
                          const Text("System folgen"),
                        ],
                      ),
                      onPressed: () {
                        theme.setSystem();
                        setState(() {});
                      }),
                  MaterialButton(
                      child: Column(
                        children: [
                          Icon(theme.mode.isLight ? Icons.light_mode : Icons.light_mode_outlined,
                              color: theme.theme.iconTheme.color!.withOpacity(theme.mode.isLight ? 1 : 0.3)),
                          const Text("Helles Design"),
                        ],
                      ),
                      onPressed: () {
                        theme.setLight();
                        setState(() {});
                      }),
                  MaterialButton(
                      child: Column(
                        children: [
                          Icon(theme.mode.isDark ? Icons.dark_mode : Icons.dark_mode_outlined,
                              color: theme.theme.iconTheme.color!.withOpacity(theme.mode.isDark ? 1 : 0.3)),
                          const Text("Dunkles Design"),
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
              title: const Text("Gruppierungen ausblenden"),
              trailing: Switch(
                value: !settings.groupingEnabled,
                onChanged: (final a) {
                  SettingsManager.setGroupingEnabled(!a);
                },
              ),
            ),
            const Divider(),
            const ListTile(
              title: Text(
                "Server",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            ListTile(
              title: const Text("Serversuche öffnen"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (final c) => const ServerSearchScreen()))
                    .then((final value) {
                  if (value is IpPort) {
                    var uri = Uri.parse("http://" + value.ipAddress);
                    uri = Uri(host: uri.host, port: value.port, scheme: uri.scheme, path: "SmartHome");

                    SettingsManager.setServerUrl(uri.toString());
                    _textEditingController.text = uri.toString();
                  }
                });
              },
            ),
            ListTile(
              leading: const Text("URL"),
              title: TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(hintText: "URL vom Smarthome Server"),
                onSubmitted: (final s) {
                  SettingsManager.setServerUrl(s);
                },
              ),
              trailing: MaterialButton(
                child: const Text("Speichern"),
                onPressed: () {
                  SettingsManager.setServerUrl(_textEditingController.text);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("Neue URL wurde gespeichert")));
                },
              ),
            ),
            ListTile(
              leading: const Text("Entwickleransicht"),
              trailing: Switch(
                value: settings.showDebugInformation,
                onChanged: (final a) {
                  SettingsManager.setShowDebugInformation(a);
                },
              ),
            ),
            const Divider(),
            settings.showDebugInformation
                ? ListTile(
                    title: const Text(
                      "Painless Mesh Zeit Update",
                    ),
                    onTap: () => hubConnection.invoke("UpdateTime"),
                  )
                : Container(),
            const Divider(),
            // ListTile(
            //   title: Text(
            //     "Geräte Layouts neu laden",
            //   ),
            //   onTap: () {
            //     ConnectionManager.hubConnection.invoke("ReloadDeviceLayouts");
            //     DeviceLayoutService.instanceDeviceLayouts.clear();
            //     DeviceLayoutService.typeDeviceLayouts.clear();
            //     for (var dev in DeviceManager.devices) {
            //       dev.baseModel.cacheLoaded = false;
            //     }
            //   },
            // ),
            ListTile(
              leading: const Text("Über"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (final c) => const AboutScreen(),
                ),
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
