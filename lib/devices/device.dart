import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:signalr_client/signalr_client.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/devices/base_model.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/models/message.dart' as sm;

abstract class Device<T extends BaseModel> extends StatefulWidget {
  final Icon icon;
  final int id;
  T baseModel;
  DeviceScreen screen;
  HubConnection connection;
  SharedPreferences prefs;

  Device(this.id, this.baseModel, this.connection, this.icon, this.prefs);

  void updateFromServer(Map<String, dynamic> message);

  Future<dynamic> getFromServer(String methodName, List<Object> args) async {
    if (connection.state == HubConnectionState.disconnected) {
      await connection.start();
    }

    return await connection.invoke(methodName, args: args);
  }

  Future sendToServer(sm.MessageType messageType, sm.Command command, List<String> parameters) async {
    if (connection.state == HubConnectionState.disconnected) {
      await connection.start();
    }
  }

  Future updateDeviceOnServer() async {
    if (connection.state == HubConnectionState.disconnected) {
      await connection.start();
    }
    return await connection.invoke("UpdateDevice", args: [baseModel.id, baseModel.friendlyName]);
  }

  DeviceTypes getDeviceType();
  void navigateToDevice(BuildContext context);

  Widget dashboardView();
}

abstract class DeviceScreen extends StatefulWidget {}
