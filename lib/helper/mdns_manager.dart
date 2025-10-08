import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:multicast_dns/multicast_dns.dart';
// import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/models/ipport.dart';
import 'package:smarthome/models/server_record.dart';
import 'package:version/version.dart';
import 'package:signalr_netcore/signalr_client.dart';

class MdnsManager {
  static const String name = '_smarthome._tcp';

  static final MDnsClient _client = MDnsClient(rawDatagramSocketFactory:
      (final dynamic host, final int port,
          {final bool? reuseAddress, final bool? reusePort, final int? ttl}) {
    return RawDatagramSocket.bind(host, port,
        reuseAddress: reuseAddress ?? true, ttl: ttl ?? 255);
  });
  static bool get initialized => _isInitialized;
  static bool _isInitialized = false;
  static final Map<String, ServerRecord> _founded = <String, ServerRecord>{};
  static late List<NetworkInterface> _interfaces;
  static DateTime _lastSearched = DateTime.fromMillisecondsSinceEpoch(0);

  static Future initialize() async {
    if (kIsWeb || _isInitialized) return;
    await _client.start(interfacesFactory: getInterfaces);
    _isInitialized = true;
  }

  static void stop() {
    _client.stop();
    _isInitialized = false;
  }

  static Future<Iterable<NetworkInterface>> getInterfaces(
      final InternetAddressType type) async {
    _interfaces = await NetworkInterface.list(
      type: type,
    );
    return _interfaces;
  }

  static Stream<ServerRecord> getRecords(
      {final Duration timeToLive = const Duration(minutes: 5)}) async* {
    if (_lastSearched.difference(DateTime.now()).abs() < timeToLive) {
      for (final cached in _founded.values) {
        if (cached.lastChecked.add(timeToLive).isAfter(DateTime.now())) {
          yield cached;
        }
      }
      return;
    }

    await for (final PtrResourceRecord ptr in _client
        .lookup<PtrResourceRecord>(ResourceRecordQuery.serverPointer(name))) {
      await for (final SrvResourceRecord srv
          in _client.lookup<SrvResourceRecord>(
              ResourceRecordQuery.service(ptr.domainName))) {
        final instanceNameEndIndex = srv.name.indexOf(name);
        final instanceName = srv.name.substring(0, instanceNameEndIndex - 1);
        final List<IpPort> ipPorts = [];
        Version ver = Version(0, 0, 1);
        bool debug = false;
        String clusterId = instanceName;

        await for (final IPAddressResourceRecord ipAddr
            in _client.lookup<IPAddressResourceRecord>(
                ResourceRecordQuery.addressIPv4(srv.target))) {
          if (await checkConnection(ipAddr, srv)) {
            ipPorts.add(
                IpPort(ipAddr.address.address, srv.port, ipAddr.address.type));
          }
        }

        await for (final IPAddressResourceRecord ipAddr
            in _client.lookup<IPAddressResourceRecord>(
                ResourceRecordQuery.addressIPv6(srv.target))) {
          if (await checkConnection(ipAddr, srv)) {
            ipPorts.add(
                IpPort(ipAddr.address.address, srv.port, ipAddr.address.type));
          }
        }

        await for (final TxtResourceRecord txtRecord in _client
            .lookup<TxtResourceRecord>(ResourceRecordQuery.text(srv.name))) {
          final keyValues = txtRecord.text.split("\n");
          for (final kv in keyValues) {
            final keyValue = kv.split("=");
            switch (keyValue[0]) {
              case "Min App Version":
                ver = Version.parse(keyValue[1]);
                break;
              case "Debug":
                debug = keyValue[1].toLowerCase() == "false" ? false : true;
                break;
              case "ClusertId":
                clusterId = keyValue[1];
                break;
              default:
            }
          }
          if (_founded.containsKey(srv.name)) {
            final sr = _founded[srv.name]!;
            if (sr.lastChecked.difference(DateTime.now()).abs() >
                const Duration(seconds: 2)) {
              sr.debug = debug;
              sr.reachableAddresses = ipPorts;
              sr.minAppVersion = ver;
              sr.name = instanceName;
              sr.clusterId = clusterId;
              sr.lastChecked = DateTime.now();
              yield sr;
            }
          } else {
            final sr = ServerRecord(instanceName, clusterId, srv.name, ipPorts,
                ver, debug, DateTime.now());
            _founded[srv.name] = sr;
            yield sr;
          }
        }
      }
    }

    _lastSearched = DateTime.now();
    // var later = DateTime.now().add(const Duration(seconds: -20));
    // for (int i = founded.length - 1; i >= 0; i--) {
    //   var sr = founded.values.elementAt(i);
    //   if (sr.lastChecked.isBefore(later)) founded.remove(founded.keys.elementAt(i));
    // }
  }

  static Future<bool> checkConnection(
      final IPAddressResourceRecord ipAddr, final SrvResourceRecord srv) async {
    try {
      final isIpv6 = ipAddr.address.type.name == "IPv6";
      // if (isIpv6) {
      //   item.nextCheck = DateTime.now().add(const Duration(minutes: 1));
      //   return item.result = false;
      // }
      final hc = HubConnectionBuilder()
          .withUrl(
            "http://${isIpv6 ? "[" : ""}${ipAddr.address.address}${isIpv6 ? "]" : ""}:${srv.port}/SmartHome",
            // options: HttpConnectionOptions(
            //     //accessTokenFactory: () async => await getAccessToken(PreferencesManager.instance),
            //     logging: (final level, final message) => print('$level: $message')))
          )
          .build();
      await hc.start();

      // item.result = hc.state == HubConnectionState.connected;
      // item.nextCheck = DateTime.now().add(const Duration(minutes: 1));
      await hc.stop();

      return true;
    } catch (e) {
      print(e);
    }

    // item.result = false;
    // item.nextCheck = DateTime.now().add(const Duration(minutes: 1));
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
