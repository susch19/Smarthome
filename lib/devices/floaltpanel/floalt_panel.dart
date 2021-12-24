// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
// import 'package:signalr_client/signalr_client.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/zigbee/zigbeelamp/zigbee_lamp.dart';
import 'package:smarthome/devices/zigbee/zigbeelamp/zigbee_lamp_model.dart';

import '../device_manager.dart';

class FloaltPanel extends ZigbeeLamp {
  FloaltPanel(int? id, String typeName, ZigbeeLampModel model, HubConnection connection, IconData icon)
      : super(id, typeName, model, connection, icon);

  @override
  DeviceTypes getDeviceType() {
    return DeviceTypes.FloaltPanel;
  }
}
