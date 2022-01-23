import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/helper/mdns_manager.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/models/server_record.dart';
import 'package:version/version.dart';

class ServerSearchScreen extends StatefulWidget {
  const ServerSearchScreen({final Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ServerSearchScreenState();
}

class ServerSearchScreenState extends State<ServerSearchScreen> {
  late Timer timer;
  late Version currentAppVersion = Version(0, 0, 1);

  final Map<String, String> _chosenValue = {};
  static List<ServerRecord> servers = [];

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  void initState() {
    super.initState();
    MdnsManager.initialize();
    timer = Timer.periodic(const Duration(seconds: 30), (final t) => refresh());
    PackageInfo.fromPlatform().then((final value) => currentAppVersion = Version.parse(value.version));
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Serversuche"),
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(final BuildContext context) {
    return RefreshIndicator(
        child: Container(
          decoration: ThemeManager.getBackgroundDecoration(context),
          child: ListView(
            children: <Widget>[
                  servers.isEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: const SizedBox(
                                width: 40.0,
                                height: 40.0,
                                child: CircularProgressIndicator(),
                              ),
                              padding: const EdgeInsets.only(top: 16.0),
                            )
                          ],
                        )
                      : Container()
                ] +
                servers
                    .map<Widget>((final e) {
                      final menuItems = e.reachableAddresses
                          .map((final a) => DropdownMenuItem(
                                value: a.ipAddress,
                                child: Text(a.ipAddress.toString()),
                              ))
                          .toList();
                      if (menuItems.isEmpty) return Container();
                      if (!_chosenValue.containsKey(e.fqdn)) _chosenValue[e.fqdn] = e.reachableAddresses[0].ipAddress;

                      return ListTile(
                        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(
                            children: [
                              Text(
                                e.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Icon(e.minAppVersion < currentAppVersion ? Icons.check : Icons.warning),
                            ],
                          ),
                          Row(
                            children: [
                              const Text("Adresse (optional): "),
                              DropdownButton(
                                value: _chosenValue[e.fqdn] ?? e.reachableAddresses[0].ipAddress,
                                items: menuItems,
                                onChanged: (final value) {
                                  setState(() {
                                    if (value is String) _chosenValue[e.fqdn] = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          Container(
                            child: e.debug ? const Text("❗ Testserver, betreten eigene Gefahr") : Container(),
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(
                                  context,
                                  e.reachableAddresses
                                      .firstWhere((final element) => element.ipAddress == _chosenValue[e.fqdn]));
                            },
                            child: const Text("Verbinden"),
                          ),
                        ]),
                      );
                    })
                    .injectForIndex((final i) => i < 1 ? null : const Divider())
                    .toList(),
          ),
        ),
        onRefresh: () async => await refresh(force: true));
  }

  Future<void> refresh({final bool force = false}) async {
    final List<ServerRecord> records = [];
    await for (final record
        in MdnsManager.getRecords(timeToLive: force ? const Duration(milliseconds: 1) : const Duration(minutes: 5))) {
      records.add(record);
    }
    servers = records;
    setState(() {});
  }
}
