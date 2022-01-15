import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/devices/device_manager.dart';

import '../device_manager.dart';
import '../zigbee/zigbeelamp/zigbee_lamp.dart';
import '../zigbee/zigbeelamp/zigbee_lamp_model.dart';

class OsramB40RW extends ZigbeeLamp {
  OsramB40RW(int? id, String typeName, ZigbeeLampModel model,
      HubConnection connection, IconData icon)
      : super(id, typeName, model, connection, icon);

  @override
  DeviceTypes getDeviceType() {
    return DeviceTypes.OsramB40RW;
  }
}
