import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:multicast_dns/multicast_dns.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/models/ipport.dart';
import 'package:smarthome/models/server_record.dart';
import 'package:version/version.dart';

class MdnsManager {
  static const String name = '_smarthome._tcp';

  static final MDnsClient _client =
      MDnsClient(rawDatagramSocketFactory: (dynamic host, int port, {bool? reuseAddress, bool? reusePort, int? ttl}) {
    return RawDatagramSocket.bind(host, port, reuseAddress: reuseAddress ?? true, reusePort: false, ttl: ttl ?? 255);
  });
  static bool _isInitialized = false;
  static Map<String, ServerRecord> _founded = Map<String, ServerRecord>();
  static late List<NetworkInterface> _interfaces;
  static List<LastCheckCacheItem> _checkCache = [];
  static DateTime _lastSearched = DateTime.fromMillisecondsSinceEpoch(0);

  static void initialize() {
    if (kIsWeb || _isInitialized) return;
    _client.start(interfacesFactory: getInterfaces).then((value) {
      _isInitialized = true;
    });
  }

  static void stop() {
    _client.stop();
    _isInitialized = false;
  }

  static Future<Iterable<NetworkInterface>> getInterfaces(InternetAddressType type) async {
    _interfaces = await NetworkInterface.list(
      includeLinkLocal: false,
      type: type,
      includeLoopback: false,
    );
    return _interfaces;
  }

  static Stream<ServerRecord> getRecords({Duration timeToLive = const Duration(minutes: 5)}) async* {
    if (_lastSearched.difference(DateTime.now()).abs() < timeToLive) {
      for (var cached in _founded.values) {
        if (cached.lastChecked.add(timeToLive).isAfter(DateTime.now())) yield cached;
      }
      return;
    }

    await for (final PtrResourceRecord ptr
        in _client.lookup<PtrResourceRecord>(ResourceRecordQuery.serverPointer(name))) {
      await for (final SrvResourceRecord srv
          in _client.lookup<SrvResourceRecord>(ResourceRecordQuery.service(ptr.domainName))) {
        var instanceNameEndIndex = srv.name.indexOf(name);
        var instanceName = srv.name.substring(0, instanceNameEndIndex - 1);
        List<IpPort> ipPorts = [];
        Version ver = Version(0, 0, 1);
        bool debug = false;
        String clusterId = instanceName;

        await for (final IPAddressResourceRecord ipAddr
            in _client.lookup<IPAddressResourceRecord>(ResourceRecordQuery.addressIPv4(srv.target))) {
          if (await checkConnection(ipAddr, srv))
            ipPorts.add(IpPort(ipAddr.address.address, srv.port, ipAddr.address.type));
        }

        await for (final IPAddressResourceRecord ipAddr
            in _client.lookup<IPAddressResourceRecord>(ResourceRecordQuery.addressIPv6(srv.target))) {
          if (await checkConnection(ipAddr, srv))
            ipPorts.add(IpPort(ipAddr.address.address, srv.port, ipAddr.address.type));
        }

        await for (final TxtResourceRecord txtRecord
            in _client.lookup<TxtResourceRecord>(ResourceRecordQuery.text(srv.name))) {
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
              case "ClusertId":
                clusterId = keyValue[1];
                break;
              default:
            }
          }
          if (_founded.containsKey(srv.name)) {
            var sr = _founded[srv.name]!;
            if (sr.lastChecked.difference(DateTime.now()).abs() > const Duration(seconds: 2)) {
              sr.debug = debug;
              sr.reachableAddresses = ipPorts;
              sr.minAppVersion = ver;
              sr.name = instanceName;
              sr.clusterId = clusterId;
              sr.lastChecked = DateTime.now();
              yield sr;
            }
          } else {
            var sr = ServerRecord(instanceName, clusterId, srv.name, ipPorts, ver, debug, DateTime.now());
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

  static Future<bool> checkConnection(IPAddressResourceRecord ipAddr, SrvResourceRecord srv) async {
    var item =
        _checkCache.firstOrNull((element) => element.address == ipAddr.address.toString() && element.port == srv.port);
    if (item != null && item.nextCheck.isAfter(DateTime.now())) {
      return item.result;
    } else if (item == null) {
      item = LastCheckCacheItem(
          ipAddr.address.toString(), srv.port, DateTime.now().add(const Duration(minutes: 1)), false);
      _checkCache.add(item);
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