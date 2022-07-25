import 'package:flutter/material.dart';
import 'package:smarthome/devices/device_manager.dart';

import '../device_manager.dart';
import '../zigbee/zigbeelamp/zigbee_lamp.dart';

class OsramB40RW extends ZigbeeLamp {
  OsramB40RW(final int id, final String typeName, final IconData icon) : super(id, typeName, icon);

  @override
  DeviceTypes getDeviceType() {
    return DeviceTypes.OsramB40RW;
  }
}
