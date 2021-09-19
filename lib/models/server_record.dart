import 'package:version/version.dart';

import 'ipport.dart';

class ServerRecord {
  bool debug;
  String name;
  String fqdn;
  Version minAppVersion;
  List<IpPort> reachableAddresses;
  DateTime lastChecked;
  ServerRecord(this.name, this.fqdn, this.reachableAddresses, this.minAppVersion, this.debug, this.lastChecked);
}