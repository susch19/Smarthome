import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quiver/core.dart';
// import 'package:signalr_client/signalr_client.dart';
// import 'package:signalr_core/signalr_core.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:smarthome/controls/dashboard_card.dart';
import 'package:smarthome/devices/base_model.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/generic/icons/icon_manager.dart';
import 'package:smarthome/devices/zigbee/iobroker_history_model.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/main.dart';
import 'package:smarthome/models/message.dart' as sm;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

final historyPropertyProvider =
    FutureProvider.family<List<IoBrokerHistoryModel>, Tuple2<int, String>>((final ref, final id) async {
  final hubConnection = ref.watch(hubConnectionConnectedProvider);

  if (hubConnection != null) {
    final result = await hubConnection.invoke("GetIoBrokerHistories", args: [id.item1, id.item2]);
    final resList = result as List<dynamic>;
    return resList.map((final e) => IoBrokerHistoryModel.fromJson(e)).toList();
  }
  return [];
});

final historyPropertyNameProvider =
    Provider.family<AsyncValue<IoBrokerHistoryModel?>, Tuple3<int, String, String>>((final ref, final id) {
  final historyData = ref.watch(historyPropertyProvider(Tuple2(id.item1, id.item2)));

  return historyData.whenData((final value) => value.firstOrNull((final element) => element.propertyName == id.item3));
});

final _iconWidgetProvider =
    Provider.autoDispose.family<Widget, Tuple3<List<String>, Device, AdaptiveThemeManager>>((final ref, final id) {
  final brightness = ref.watch(brightnessProvider(id.item3));
  final iconByName = ref.watch(iconByTypeNamesProvider(id.item1));

  return id.item2._createIcon(brightness, iconByName);
});

final iconWidgetProvider = Provider.autoDispose
    .family<Widget, Tuple3<List<String>, Device, AdaptiveThemeManager>>((final ref, final deviceTypeName) {
  final iconByName = ref.watch(_iconWidgetProvider(deviceTypeName));
  return iconByName;
});

final iconWidgetSingleProvider = Provider.autoDispose
    .family<Widget, Tuple3<String, Device, AdaptiveThemeManager>>((final ref, final deviveTypeName) {
  final iconByName =
      ref.watch(_iconWidgetProvider(Tuple3([deviveTypeName.item1], deviveTypeName.item2, deviveTypeName.item3)));
  return iconByName;
});

abstract class Device<T extends BaseModel> {
  final baseModelTProvider = Provider.family<T?, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    if (baseModel is T) return baseModel;
    return null;
  });

  static final groupsByIdProvider = StateProvider.family<List<String>, int>((final ref, final id) {
    final friendlyNameSplit = ref.watch(BaseModel.friendlyNameProvider(id)).split(" ");
    return [friendlyNameSplit.first];
  });

  IconData? iconData;
  final String typeName;
  final int id;

  final Random r = Random();

  @mustCallSuper
  Device(this.id, this.typeName, {final IconData? iconData, final Uint8List? iconBytes}) {
    if (iconData != null) {
      this.iconData = iconData;
    }
  }

  Widget _createIcon(final Brightness themeMode, final Uint8List? iconBytes) {
    if (iconData != null) {
      return Icon(
        iconData,
      );
    }
    if (iconBytes != null) {
      return createIconFromSvgByteList(iconBytes, themeMode);
    }
    return Container();
  }

  Widget createIconFromSvgByteList(final Uint8List list, final Brightness brightness) {
    return Center(
      child: SvgPicture.memory(
        list,
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ),
    );
  }

  Widget getRightWidgets() {
    return Container();
  }

  Widget dashboardCardBody() => const Text("");

  Widget dashboardView(final void Function() onLongPress) {
    return StatelessDashboardCard(
      device: this,
      onLongPress: onLongPress,
      tag: id,
    );
  }

  // @mustCallSuper
  // BaseModel updateFromServer(final Map<String, dynamic> message) {
  //   return baseModel.updateFromJson(message);
  // }

  Future<dynamic> getFromServer(
      final String methodName, final List<Object>? args, final HubConnectionContainer container) async {
    if (container.connectionState != HubConnectionState.Connected || container.connection == null) {
      return;
    }

    return await container.connection!.invoke(methodName, args: args);
  }

  @override
  bool operator ==(final Object other) => other is Device && other.id == id && other.typeName == typeName;

  @override
  int get hashCode => hash2(id, typeName);

  @mustCallSuper
  Future sendToServer(final sm.MessageType messageType, final sm.Command command, final List<String>? parameters,
      final HubConnectionContainer container) async {
    if (container.connectionState != HubConnectionState.Connected || container.connection == null) {
      return;
    }

    final message = sm.Message(id, messageType, command, parameters);
    final jsonMsg = message.toJson();
    await container.connection!.invoke("Update", args: <Object>[jsonMsg]);
  }

  Future updateDeviceOnServer(final int id, final String friendlyName, final HubConnectionContainer container) async {
    if (container.connectionState != HubConnectionState.Connected || container.connection == null) {
      return;
    }
    return await container.connection!.invoke("UpdateDevice", args: [id, friendlyName]);
  }

  DeviceTypes getDeviceType();
  void navigateToDevice(final BuildContext context);
}
