import 'package:smarthome/devices/device_manager.dart';

import '../zigbee/zigbeelamp/zigbee_lamp.dart';

class OsramB40RW extends ZigbeeLamp {
  OsramB40RW(super.id, super.typeName, super.icon);

  @override
  DeviceTypes getDeviceType() {
    return DeviceTypes.OsramB40RW;
  }
}
