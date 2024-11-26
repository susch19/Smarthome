// ignore_for_file: unnecessary_null_comparison

// import 'package:signalr_client/signalr_client.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/zigbee/zigbeelamp/zigbee_lamp.dart';

class FloaltPanel extends ZigbeeLamp {
  FloaltPanel(super.id, super.typeName, super.icon);

  @override
  DeviceTypes getDeviceType() {
    return DeviceTypes.FloaltPanel;
  }
}
