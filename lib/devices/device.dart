import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:signalr_client/signalr_client.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/controls/cicle_painter.dart';
import 'package:smarthome/devices/base_model.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/models/message.dart' as sm;

abstract class Device<T extends BaseModel> {
  final IconData icon;
  final int? id;
  T baseModel;
  HubConnection connection;
  final SharedPreferences? prefs;

  @protected
  StreamController<T> controller = StreamController<T>.broadcast();

  Device(this.id, this.baseModel, this.connection, this.icon, this.prefs);

  StreamSubscription<T> listenOnUpdateFromServer(void Function(T)? onData) {
    return controller.stream.listen(onData);
  }

  List<Widget> getDefaultHeader(Widget topRight, bool isConnected) {
    return [
      Row(
        children: [
          Container(
              margin: EdgeInsets.only(left: 16.0, top: 4.0),
              child: CustomPaint(painter: CirclePainter(8, isConnected ? Colors.green : Colors.red, Offset(-2, -2)))),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(icon)],
              ),
            ),
          ),
          topRight
        ],
      ),
      Text(
        baseModel.friendlyName.toString(),
        style: TextStyle(),
        softWrap: true,
        textAlign: TextAlign.center,
      )
    ];
  }

  @mustCallSuper
  void updateFromServer(Map<String, dynamic> message) {
    var func = DeviceManager.jsonFactory[T];
    if (func != null) {
      baseModel = func(message) as T;
      controller.add(baseModel);
    }
  }

  Future<dynamic> getFromServer(String methodName, List<Object?> args) async {
    if (connection.state == HubConnectionState.disconnected) {
      await connection.start();
    }

    return await connection.invoke(methodName, args: args);
  }

@mustCallSuper
  Future sendToServer(sm.MessageType messageType, sm.Command command, List<String>? parameters) async {
    if (connection.state == HubConnectionState.disconnected) {
      await connection.start();
    }
    var message = new sm.Message(id, messageType, command, parameters);
    await connection.invoke("Update", args: <Object>[message.toJson()]);
  }

  Future updateDeviceOnServer() async {
    if (connection.state == HubConnectionState.disconnected) {
      await connection.start();
    }
    return await connection.invoke("UpdateDevice", args: [baseModel.id, baseModel.friendlyName]);
  }

  void stop() {
    controller.close();
  }

  DeviceTypes getDeviceType();
  void navigateToDevice(BuildContext context);

  Widget dashboardView();
}

abstract class DeviceScreen extends StatefulWidget {}
