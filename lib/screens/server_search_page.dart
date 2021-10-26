import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multicast_dns/multicast_dns.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/helper/mdns_manager.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/models/ipport.dart';
import 'package:smarthome/models/server_record.dart';
import 'package:version/version.dart';

class ServerSearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ServerSearchScreenState();
}

class ServerSearchScreenState extends State<ServerSearchScreen> {
  late Timer timer;
  late Version currentAppVersion = Version(0,0,1);

  Map<String, String> _chosenValue = Map();
  static List<ServerRecord> servers = [];

  late Stream<PtrResourceRecord> sub;
  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  void initState() {
    super.initState();
    MdnsManager.initialize();
    timer = Timer.periodic(Duration(seconds: 30), (t) => refresh());
    PackageInfo.fromPlatform().then((value) => currentAppVersion = Version.parse(value.version));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Serversuche"),
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return RefreshIndicator(
        child: Container(
          decoration: ThemeManager.getBackgroundDecoration(context),
          child: ListView(
            children: <Widget>[
                  servers.length < 1
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: SizedBox(
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
                    .map<Widget>((e) {
                      var menuItems = e.reachableAddresses
                          .map((a) => DropdownMenuItem(
                                value: a.ipAddress,
                                child: Text(a.ipAddress.toString()),
                              ))
                          .toList();
                      if (menuItems.length < 1) return Container();
                      if (!_chosenValue.containsKey(e.fqdn)) _chosenValue[e.fqdn] = e.reachableAddresses[0].ipAddress;

                      return ListTile(
                        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(
                            children: [
                              Text(
                                e.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Icon(e.minAppVersion < currentAppVersion ? Icons.check : Icons.warning),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Adresse (optional): "),
                              DropdownButton(
                                value: _chosenValue[e.fqdn] ?? e.reachableAddresses[0].ipAddress,
                                items: menuItems,
                                onChanged: (value) {
                                  setState(() {
                                    if (value is String) _chosenValue[e.fqdn] = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          Container(
                            child: e.debug ? Text("❗ Testserver, betreten eigene Gefahr") : Container(),
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(
                                  context,
                                  e.reachableAddresses
                                      .firstWhere((element) => element.ipAddress == _chosenValue[e.fqdn]));
                            },
                            child: Text("Verbinden"),
                          ),
                        ]),
                      );
                    })
                    .injectForIndex((i) => i < 1 ? null : Divider())
                    .toList(),
          ),
        ),
        onRefresh: () async => await refresh(force: true));
  }

  Future<void> refresh({bool force = false}) async {
    List<ServerRecord> records = [];
    await for (var record
        in MdnsManager.getRecords(timeToLive: force ? const Duration(milliseconds: 1) : const Duration(minutes: 5))) {
      records.add(record);
    }
    servers = records;
    setState(() {});
  }
}
