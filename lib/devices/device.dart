import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:signalr_client/signalr_client.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/controls/dashboard_card.dart';
import 'package:smarthome/devices/base_model.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/models/message.dart' as sm;

abstract class Device<T extends BaseModel> {
  final IconData icon;
  final int? id;
  T baseModel;
  HubConnection connection;

  @protected
  StreamController<T> controller = StreamController<T>.broadcast();

  Device(this.id, this.baseModel, this.connection, this.icon);

  bool get isConnected => baseModel.isConnected;

  StreamSubscription<T> listenOnUpdateFromServer(void Function(T)? onData) {
    return controller.stream.listen(onData);
  }

  Widget? lowerLeftWidget() {
    return null;
  }

  Widget dashboardCardBody() => const Text("");

  Widget dashboardView(void Function() onLongPress) {
    return StatelessDashboardCard(device: this, onLongPress: onLongPress,tag: this.id!);
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
    var jsonMsg = message.toJson();
    await connection.invoke("Update", args: <Object>[jsonMsg]);
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
}

abstract class DeviceScreen extends StatefulWidget {}
