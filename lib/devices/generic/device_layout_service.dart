import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/helper/cache_file_manager.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/helper/settings_manager.dart';
import 'package:smarthome/restapi/swagger.swagger.dart';

import 'package:path/path.dart' as path;

import 'generic_device_exporter.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'device_layout_service.g.dart';

@Riverpod(keepAlive: true)
class LayoutIcons extends _$LayoutIcons {
  @override
  FutureOr<List<LayoutResponse>> build() async {
    final api = ref.watch(apiProvider);

    final allLayouts = await api.appLayoutAllGet();
    return allLayouts.bodyOrThrow;
  }

  void updateFromServer(final List<Object?>? arguments) {
    final updateMap = arguments![0] as Map<String, dynamic>;
    final hash = arguments[1] as String;
    _updateFromServer(updateMap, hash, updateStorage: true);
  }

  Future _updateFromServer(
      final Map<String, dynamic> deviceLayoutJson, final String hash,
      {final bool updateStorage = false}) async {
    final deviceLayout = DeviceLayout.fromJson(deviceLayoutJson);

    final curState = state.valueOrNull;
    if (curState == null) return;

    final api = ref.read(apiProvider);
    final res = await api.appLayoutSingleGet(
        typeName: deviceLayout.typeName,
        iconName: deviceLayout.iconName,
        deviceId: null);
    if (res.body case final LayoutResponse layoutRes) {
      final existingLayout = curState.firstOrDefault(
          (final e) => e.layout?.uniqueName == deviceLayout.uniqueName);

      final copy = curState.toList();
      copy.remove(existingLayout);
      copy.add(layoutRes);

      state = AsyncData(copy);
    }
  }
}

@Riverpod(keepAlive: true)
class DeviceLayouts extends _$DeviceLayouts {
  static final CacheFileManager _cacheFileManager = CacheFileManager(
      path.join(Directory.systemTemp.path, "smarthome_layout_cache"), "json");
  @override
  List<DeviceLayout> build() {
    final api = ref.watch(layoutIconsProvider);

    return switch (api) {
      AsyncData(:final value) =>
        value.map((final x) => x.layout).whereType<DeviceLayout>().toList(),
      _ => [],
    };
  }

  DeviceLayout? getLayout(final int id, final String typeName) {
    final curState = state;

    final byId = curState
        .firstOrDefault((final x) => x.ids != null && x.ids!.contains(id));
    if (byId != null) return byId;
    final byName = curState.firstOrDefault((final x) =>
        x.typeName == typeName ||
        (x.typeNames != null && x.typeNames!.contains(typeName)));

    if (byName != null) return byName;
    return null;
  }
}

@riverpod
DashboardDeviceLayout? dashboardDeviceLayout(
    final Ref ref, final int id, final String typeName) {
  ref.watch(deviceLayoutsProvider);

  final ret = ref
      .read(deviceLayoutsProvider.notifier)
      .getLayout(id, typeName)
      ?.dashboardDeviceLayout;
  return ret;
}

@riverpod
List<DashboardPropertyInfo>? dashboardSpecialTypeLayout(
    final Ref ref, final int id, final String typeName) {
  final layoutProvider = ref.watch(dashboardDeviceLayoutProvider(id, typeName));
  return layoutProvider?.dashboardProperties
      .where((final element) => element.specialType != DasboardSpecialType.none)
      .toList();
}

@riverpod
List<DashboardPropertyInfo>? dashboardNoSpecialTypeLayout(
    final Ref ref, final int id, final String typeName) {
  final layoutProvider = ref.watch(dashboardDeviceLayoutProvider(id, typeName));
  return layoutProvider?.dashboardProperties
      .where((final element) => element.specialType == DasboardSpecialType.none)
      .toList();
}

@riverpod
DetailDeviceLayout? detailDeviceLayout(
    final Ref ref, final int id, final String typeName) {
  ref.watch(deviceLayoutsProvider);
  return ref
      .read(deviceLayoutsProvider.notifier)
      .getLayout(id, typeName)
      ?.detailDeviceLayout;
}

@riverpod
List<DetailPropertyInfo>? detailPropertyInfoLayout(
    final Ref ref, final int id, final String typeName) {
  final layoutProvider = ref.watch(detailDeviceLayoutProvider(id, typeName));
  final props = layoutProvider?.propertyInfos;
  return props;
}

@riverpod
DetailPropertyInfo? fabLayout(
    final Ref ref, final int id, final String typeName) {
  final layoutProvider = ref.watch(detailDeviceLayoutProvider(id, typeName));
  final props = layoutProvider?.propertyInfos;
  return props?.firstOrDefault(
      (final element) => element.editInfo?.editType == "floatingactionbutton");
}

@riverpod
List<DetailTabInfo>? detailTabInfoLayout(
    final Ref ref, final int id, final String typeName) {
  final layoutProvider = ref.watch(detailDeviceLayoutProvider(id, typeName));
  final showDebugInformation = ref.watch(debugInformationEnabledProvider);
  final tabInfos = layoutProvider?.tabInfos;
  if (tabInfos == null) return null;
  return tabInfos
      .where((final element) =>
          !element.showOnlyInDeveloperMode ||
          element.showOnlyInDeveloperMode == showDebugInformation)
      .toList();
}

@riverpod
List<HistoryPropertyInfo>? detailHistoryLayout(
    final Ref ref, final int id, final String typeName) {
  final layoutProvider = ref.watch(detailDeviceLayoutProvider(id, typeName));
  return layoutProvider?.historyProperties;
}
