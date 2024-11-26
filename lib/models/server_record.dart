import 'package:version/version.dart';

import 'ipport.dart';

class ServerRecord {
  bool debug;
  String clusterId;
  String name;
  String fqdn;
  Version minAppVersion;
  List<IpPort> reachableAddresses;
  DateTime lastChecked;

  ServerRecord(
    this.name,
    this.clusterId,
    this.fqdn,
    this.reachableAddresses,
    this.minAppVersion,
    this.debug,
    this.lastChecked,
  );
}
