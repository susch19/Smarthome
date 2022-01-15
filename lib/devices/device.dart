import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:signalr_client/signalr_client.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/controls/dashboard_card.dart';
import 'package:smarthome/devices/base_model.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/generic/icon_manager.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/models/message.dart' as sm;

abstract class Device<T extends BaseModel> {
  Widget get icon => createIcon();
  Uint8List? iconBytes;
  IconData? iconData;
  final String typeName;
  final int? id;
  T baseModel;
  HubConnection connection;
  final List<String> groups = [];

  Map<bool, Widget> widgetCache = Map<bool, Widget>();

  @protected
  StreamController<T> controller = StreamController<T>.broadcast();

  final Random r = Random();

  @mustCallSuper
  Device(this.id, this.typeName, this.baseModel, this.connection, {IconData? iconData, Uint8List? iconBytes}) {
    if (iconData != null)
      this.iconData = iconData;
    else {
      if (baseModel.typeNames.isNotEmpty) {
        IconManager.getIconForTypeNames(baseModel.typeNames, this.connection)
            .then((iconBytes) => this.iconBytes = iconBytes);
      }
    }
    // groups.add("All");
    groups.add(baseModel.friendlyName.split(' ').first);
    // var rand = r.nextInt(6);
    // groups.add("Random" + rand.toString());
  }

  Widget createIcon() {
    if (iconData != null)
      return Icon(
        iconData,
      );
    if (iconBytes != null) {
      if (widgetCache.containsKey(ThemeManager.isLightTheme)) return widgetCache[ThemeManager.isLightTheme]!;
      return widgetCache[ThemeManager.isLightTheme] = createIconFromSvgByteList(iconBytes!);
    }
    return Container();
  }

  Widget createIconFromSvgByteList(Uint8List list) {
    return Expanded(
        child: Center(
      child: SvgPicture.memory(
        list,
        color: ThemeManager.isLightTheme ? Colors.black : Colors.white,
      ),
    ));
  }

  bool get isConnected => baseModel.isConnected;

  StreamSubscription<T> listenOnUpdateFromServer(void Function(T)? onData) {
    return controller.stream.listen(onData);
  }

  Widget rightWidgets() {
    return Container();
  }

  Widget dashboardCardBody() => const Text("");

  Widget dashboardView(void Function() onLongPress) {
    return StatelessDashboardCard(
      device: this,
      onLongPress: onLongPress,
      tag: this.id!,
      icon: this.icon,
    );
  }

  @mustCallSuper
  void updateFromServer(Map<String, dynamic> message) {
    baseModel.updateFromJson(message);
    controller.add(baseModel);
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
