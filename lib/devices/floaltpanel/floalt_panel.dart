// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
// import 'package:signalr_client/signalr_client.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/zigbee/zigbeelamp/zigbee_lamp.dart';

class FloaltPanel extends ZigbeeLamp {
  FloaltPanel(final int id, final String typeName, final IconData icon) : super(id, typeName, icon);

  @override
  DeviceTypes getDeviceType() {
    return DeviceTypes.FloaltPanel;
  }
}
