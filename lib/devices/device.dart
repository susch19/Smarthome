import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quiver/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:signalr_client/signalr_client.dart';
// import 'package:signalr_core/signalr_core.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:smarthome/controls/dashboard_card.dart';
import 'package:smarthome/devices/base_model.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/generic/icons/icon_manager.dart';
import 'package:smarthome/devices/zigbee/iobroker_history_model.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/main.dart';
import 'package:smarthome/models/message.dart' as sm;
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'device.g.dart';

@riverpod
FutureOr<List<HistoryModel>> historyProperty(
    final Ref ref, final int id, final String dt) async {
  final hubConnection = ref.watch(hubConnectionConnectedProvider);

  if (hubConnection != null) {
    final result =
        await hubConnection.invoke("GetIoBrokerHistories", args: [id, dt]);
    final resList = result as List<dynamic>;
    return resList.map((final e) => HistoryModel.fromJson(e)).toList();
  }
  return [];
}

@riverpod
FutureOr<HistoryModel> historyPropertyName(
    final Ref ref,
    final int id,
    final DateTime fromTime,
    final DateTime toTime,
    final String propertyName) async {
  final hubConnection = ref.watch(hubConnectionConnectedProvider);

  if (hubConnection != null) {
    final result = await hubConnection.invoke("GetIoBrokerHistoryRange", args: [
      id,
      fromTime.toIso8601String(),
      toTime.toIso8601String(),
      propertyName
    ]);
    final e = result as Map<String, dynamic>;
    return HistoryModel.fromJson(e);
  }
  return HistoryModel();
}

@riverpod
Widget iconWidget(
    final Ref ref,
    final List<String> typeNames,
    final Device device,
    final AdaptiveThemeManager themeManager,
    final bool withMargin) {
  final brightness = ref.watch(brightnessProvider(themeManager));
  final iconByName = ref.watch(iconByTypeNamesProvider(typeNames));
  if (iconByName.hasValue) {
    print("this has an value");
  } else {
    print("no value");
  }

  return device._createIcon(brightness, iconByName.valueOrNull, withMargin);
}

@riverpod
Widget iconWidgetSingle(
    final Ref ref,
    final String typeName,
    final Device device,
    final AdaptiveThemeManager themeManager,
    final bool withMargin) {
  return ref
      .watch(iconWidgetProvider([typeName], device, themeManager, withMargin));
}

abstract class Device<T extends BaseModel> {
  final baseModelTProvider = Provider.family<T?, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    if (baseModel is T) return baseModel;
    return null;
  });

  static final groupsByIdProvider =
      StateProvider.family<List<String>, int>((final ref, final id) {
    final friendlyNameSplit =
        ref.watch(BaseModel.friendlyNameProvider(id)).split(" ");
    return [friendlyNameSplit.first];
  });

  IconData? iconData;
  final String typeName;
  final int id;

  final Random r = Random();

  Device(this.id, this.typeName,
      {final IconData? iconData, final Uint8List? iconBytes}) {
    if (iconData != null) {
      this.iconData = iconData;
    }
  }

  Widget _createIcon(final Brightness themeMode, final Uint8List? iconBytes,
      final bool withMargin) {
    if (iconData != null) {
      return Icon(
        iconData,
      );
    }
    if (iconBytes != null) {
      return createIconFromSvgByteList(iconBytes, themeMode, withMargin);
    }
    return const SizedBox();
  }

  Widget createIconFromSvgByteList(final Uint8List list,
      final Brightness brightness, final bool withMargin) {
    if (withMargin) {
      return Container(
        margin: const EdgeInsets.all(8),
        child: Center(
          child: SvgPicture.memory(
            list,
            colorFilter: ColorFilter.mode(
                brightness == Brightness.light ? Colors.black : Colors.white,
                BlendMode.srcIn),
          ),
        ),
      );
    } else {
      return Center(
        child: SvgPicture.memory(
          list,
          colorFilter: ColorFilter.mode(
              brightness == Brightness.light ? Colors.black : Colors.white,
              BlendMode.srcIn),
        ),
      );
    }
  }

  Widget getRightWidgets() {
    return const SizedBox();
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

  Future<dynamic> getFromServer(final String methodName,
      final List<Object>? args, final HubConnectionContainer container) async {
    if (container.connectionState != HubConnectionState.Connected ||
        container.connection == null) {
      return;
    }

    return await container.connection!.invoke(methodName, args: args);
  }

  @override
  bool operator ==(final Object other) =>
      other is Device && other.id == id && other.typeName == typeName;

  @override
  int get hashCode => hash2(id, typeName);

  @mustCallSuper
  Future sendToServer(
      final sm.MessageType messageType,
      final sm.Command command,
      final List<String>? parameters,
      final HubConnectionContainer container) async {
    if (container.connectionState != HubConnectionState.Connected ||
        container.connection == null) {
      return;
    }

    final message = sm.Message(id, messageType, command.index, parameters);
    final jsonMsg = message.toJson();
    await container.connection!.invoke("Update", args: <Object>[jsonMsg]);
  }

  Future updateDeviceOnServer(final int id, final String friendlyName,
      final HubConnectionContainer container) async {
    if (container.connectionState != HubConnectionState.Connected ||
        container.connection == null) {
      return;
    }
    return await container.connection!
        .invoke("UpdateDevice", args: [id, friendlyName]);
  }

  DeviceTypes getDeviceType();
  void navigateToDevice(final BuildContext context);
}
