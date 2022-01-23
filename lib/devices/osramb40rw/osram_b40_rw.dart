import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/devices/device_manager.dart';

import '../device_manager.dart';
import '../zigbee/zigbeelamp/zigbee_lamp.dart';
import '../zigbee/zigbeelamp/zigbee_lamp_model.dart';

class OsramB40RW extends ZigbeeLamp {
  OsramB40RW(final int id, final String typeName, final ZigbeeLampModel model, final HubConnection connection, final IconData icon)
      : super(id, typeName, model, connection, icon);

  @override
  DeviceTypes getDeviceType() {
    return DeviceTypes.OsramB40RW;
  }
}
