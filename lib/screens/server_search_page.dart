import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multicast_dns/multicast_dns.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/models/ipport.dart';
import 'package:smarthome/models/server_record.dart';
import 'package:version/version.dart';

class ServerSearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ServerSearchScreenState();
}

class ServerSearchScreenState extends State<ServerSearchScreen> {
  static const String name = '_smarthome._tcp';
  final MDnsClient client =
      MDnsClient(rawDatagramSocketFactory: (dynamic host, int port, {bool? reuseAddress, bool? reusePort, int? ttl}) {
    return RawDatagramSocket.bind(host, port, reuseAddress: reuseAddress ?? true, reusePort: false, ttl: ttl ?? 255);
  });
  Map<String, ServerRecord> founded = Map<String, ServerRecord>();

  late Timer timer;
  late Version currentAppVersion;

  late List<NetworkInterface> interfaces;

  Map<String, String> _chosenValue = Map();
  @override
  void dispose() {
    super.dispose();
    client.stop();
    timer.cancel();
  }

  @override
  void initState() {
    super.initState();

    client.start(interfacesFactory: getInterfaces).then((value) => onRefresh());
    timer = Timer.periodic(Duration(seconds: 10), (t) => onRefresh());
    PackageInfo.fromPlatform().then((value) => currentAppVersion = Version.parse(value.version));
  }

  Future<Iterable<NetworkInterface>> getInterfaces(InternetAddressType type) async {
    interfaces = await NetworkInterface.list(
      includeLinkLocal: false,
      type: type,
      includeLoopback: false,
    );
    return interfaces;
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
    // if (founded.values.length < 1) {
    // }

    return RefreshIndicator(
        child: Container(
          decoration: ThemeManager.getBackgroundDecoration(context),
          child: ListView(
            children: <Widget>[
                  founded.length < 1
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
                founded.values
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
                    .injectForIndex((i) => i % 2 == 0 ? null : Divider())
                    .toList(),
          ),
        ),
        onRefresh: onRefresh);
  }

  Future<void> onRefresh() async {
    if (!mounted) return;
    await for (final PtrResourceRecord ptr
        in client.lookup<PtrResourceRecord>(ResourceRecordQuery.serverPointer(name), timeout: Duration(seconds: 5))) {
      await for (final SrvResourceRecord srv
          in client.lookup<SrvResourceRecord>(ResourceRecordQuery.service(ptr.domainName))) {
        List<IpPort> ipPorts = [];
        Version ver = Version(0, 0, 1);
        bool debug = false;
        await for (final IPAddressResourceRecord ipAddr
            in client.lookup<IPAddressResourceRecord>(ResourceRecordQuery.addressIPv4(srv.target))) {
          if (await checkConnection(ipAddr, srv))
            ipPorts.add(IpPort(ipAddr.address.address, srv.port, ipAddr.address.type));
        }
        await for (final IPAddressResourceRecord ipAddr
            in client.lookup<IPAddressResourceRecord>(ResourceRecordQuery.addressIPv6(srv.target))) {
          if (await checkConnection(ipAddr, srv))
            ipPorts.add(IpPort(ipAddr.address.address, srv.port, ipAddr.address.type));
        }

        await for (final TxtResourceRecord txtRecord
            in client.lookup<TxtResourceRecord>(ResourceRecordQuery.text(srv.name))) {
          var keyValues = txtRecord.text.split("\n");
          for (var kv in keyValues) {
            var keyValue = kv.split("=");
            switch (keyValue[0]) {
              case "Min App Version":
                ver = Version.parse(keyValue[1]);
                break;
              case "Debug":
                debug = keyValue[1].toLowerCase() == "false" ? false : true;
                break;
              default:
            }
          }
          var instanceNameEndIndex = srv.name.indexOf(name);
          var instanceName = srv.name.substring(0, instanceNameEndIndex - 1);
          if (founded.containsKey(srv.name)) {
            var sr = founded[srv.name]!;
            sr.debug = debug;
            sr.reachableAddresses = ipPorts;
            sr.minAppVersion = ver;
            sr.name = instanceName;
            sr.lastChecked = DateTime.now();
          } else {
            var sr = ServerRecord(instanceName, srv.name, ipPorts, ver, debug, DateTime.now());
            founded[srv.name] = sr;
          }
        }
      }
    }

    var later = DateTime.now().add(const Duration(seconds: -20));
    for (int i = founded.length - 1; i >= 0; i--) {
      var sr = founded.values.elementAt(i);
      if (sr.lastChecked.isBefore(later)) founded.remove(founded.keys.elementAt(i));
    }

    if (!mounted) return;
    setState(() {});
  }

  List<LastCheckCacheItem> checkCache = [];
  Future<bool> checkConnection(IPAddressResourceRecord ipAddr, SrvResourceRecord srv) async {
    var item =
        checkCache.firstOrNull((element) => element.address == ipAddr.address.toString() && element.port == srv.port);
    if (item != null && item.nextCheck.isAfter(DateTime.now())) {
      return item.result;
    } else if (item == null) {
      item = LastCheckCacheItem(
          ipAddr.address.toString(), srv.port, DateTime.now().add(const Duration(minutes: 1)), false);
      checkCache.add(item);
    }

    try {
      final Socket s = await Socket.connect(ipAddr.address, srv.port, timeout: Duration(milliseconds: 500));
      s.destroy();
      item.result = true;
      item.nextCheck = DateTime.now().add(const Duration(minutes: 1));
      return true;
    } catch (e) {
      print(e);
    }

    item.result = false;
    item.nextCheck = DateTime.now().add(const Duration(minutes: 1));
    return false;
  }
}

class LastCheckCacheItem {
  String address;
  int port;
  DateTime nextCheck;
  bool result;
  LastCheckCacheItem(this.address, this.port, this.nextCheck, this.result);
}
