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
import 'package:smarthome/devices/base_model.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/generic/icons/icon_manager.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smarthome/restapi/swagger.swagger.dart';

part 'device.g.dart';

@riverpod
FutureOr<History> historyPropertyName(
    final Ref ref,
    final int id,
    final DateTime fromTime,
    final DateTime toTime,
    final String propertyName) async {
  final api = ref.watch(apiProvider);
  final res = await api.appHistoryRangeGet(
      id: id, from: fromTime, to: toTime, propertyName: propertyName);
  return res.bodyOrThrow;
}

@riverpod
Widget iconWidget(
    final Ref ref,
    final List<String> typeNames,
    final Device device,
    final AdaptiveThemeManager themeManager,
    final bool withMargin) {
  final brightness = ref.watch(brightnessProvider(themeManager));
  final icon = ref.watch(iconByTypeNamesProvider(typeNames));

  return device._createIcon(brightness, icon, withMargin);
}

@riverpod
Widget iconWidgetSingle(
  final Ref ref,
  final String typeName,
  final Device device,
  final AdaptiveThemeManager themeManager,
  final bool withMargin,
) {
  return ref
      .watch(iconWidgetProvider([typeName], device, themeManager, withMargin));
}

abstract class Device<T extends BaseModel> {
  static const fromJsonFactory = _$DeviceRequestFromJson;

  static Device _$DeviceRequestFromJson(final Map<String, dynamic> json) {
    final types =
        (json["typeNames"] as List).map((final x) => x.toString()).toList();
    String type = "Device";
    for (final item in types) {
      if (!stringNameJsonFactory.containsKey(item)) {
        continue;
      }
      type = item;
      break;
    }
    final id = json["id"] as int;

    final model = stringNameJsonFactory[type]!(json, types);
    final dev = deviceCtorFactory[type]!(id, types.first);
    dev.lastModel = model;
    return dev;
  }

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

  final IconData? iconData;
  final String typeName;
  final int id;
  late BaseModel? lastModel;

  final Random r = Random();

  Device(this.id, this.typeName, {this.iconData, this.lastModel});

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
  Future sendToServer(final MessageType messageType, final Command2 command,
      final List<String> parameters, final Swagger container) async {
    final message = JsonApiSmarthomeMessage(
        parameters: parameters,
        messageType: messageType,
        command: command,
        id: id);
    await container.appSmarthomePost(message: message);
  }

  static Future postMessage(
    final int id,
    final PropertyEditInformation editInfo,
    final Swagger api,
    final dynamic value, [
    final List<Object> preParameters = const [],
    final List<Object> postParamters = const [],
  ]) async {
    final editParameter = editInfo.editParameter.first;
    await api.appSmarthomePost(
        message: JsonApiSmarthomeMessage(
      parameters: [
        ...preParameters,
        value,
        ...postParamters,
      ],
      id: id,
      messageType: editParameter.messageType ?? editInfo.messageType,
      command: Command2.values[editParameter.command.index],
    ));
  }

  Future updateDeviceOnServer(
      final int id, final String friendlyName, final Swagger api) async {
    await api.appDevicePatch(
        request: DeviceRenameRequest(id: id, newName: friendlyName));
  }

  DeviceTypes getDeviceType();
  void navigateToDevice(final BuildContext context);

  void iconPressed(final BuildContext context, final WidgetRef ref) {}
}
