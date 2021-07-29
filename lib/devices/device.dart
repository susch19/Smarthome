import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:signalr_client/signalr_client.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/controls/cicle_painter.dart';
import 'package:smarthome/devices/base_model.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/models/message.dart' as sm;

abstract class Device<T extends BaseModel> extends StatefulWidget {
  final IconData icon;
  final int? id;
  T baseModel;
  HubConnection connection;
  final SharedPreferences? prefs;

  bool? hasServerResponded;

  Device(this.id, this.baseModel, this.connection, this.icon, this.prefs);

  List<Widget> getDefaultHeader(Widget topRight, bool isConnected) {
    return [
      Row(
        children: [
          Container(
              margin: EdgeInsets.only(left: 16.0, top: 4.0),
              child: CustomPaint(
                  painter: CirclePainter(8, isConnected ? Colors.green : Colors.red, Offset(-2, -2)))
              ),
          Expanded(
            child: 
            Container(margin: EdgeInsets.only(top:4.0, bottom: 4.0), child:
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(icon)],
            ),
            ),
          ),
          topRight
         
        ],
      ),
      Text(baseModel.friendlyName.toString(), style: TextStyle(), softWrap: true,textAlign: TextAlign.center, )
    ];
  }

  void updateFromServer(Map<String, dynamic> message) {}

  Future<dynamic> getFromServer(String methodName, List<Object?> args) async {
    if (connection.state == HubConnectionState.disconnected) {
      await connection.start();
    }

    return await connection.invoke(methodName, args: args);
  }

  Future sendToServer(sm.MessageType messageType, sm.Command command, List<String>? parameters) async {
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
