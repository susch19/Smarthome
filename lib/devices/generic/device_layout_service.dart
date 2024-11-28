import 'dart:convert';
import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/helper/cache_file_manager.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/helper/settings_manager.dart';
import 'package:smarthome/restapi/swagger.swagger.dart';
import 'package:tuple/tuple.dart';
import 'package:path/path.dart' as path;

import 'generic_device_exporter.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'device_layout_service.g.dart';

// final _layoutProvider =
//     StateNotifierProvider<DeviceLayoutService, List<DeviceLayout>>((final ref) {
//   return DeviceLayoutService();
// });

// final _idLayoutProvider =
//     Provider.family<DeviceLayout?, int>((final ref, final id) {
//   final layouts = ref.watch(deviceLayoutProvider);

//   return layouts
//       .firstOrNull((final element) => element.ids?.contains(id) ?? false);
// });

// final _typeNameLayoutProvider =
//     Provider.family<DeviceLayout?, String>((final ref, final typeName) {
//   final layouts = ref.watch(_layoutProvider);

//   return layouts.firstOrNull((final element) =>
//       element.typeName == typeName ||
//       (element.typeNames?.contains(typeName) ?? false));
// });

@Riverpod(keepAlive: true)
class DeviceLayouts extends _$DeviceLayouts {
  static final CacheFileManager _cacheFileManager = CacheFileManager(
      path.join(Directory.systemTemp.path, "smarthome_layout_cache"), "json");
  @override
  FutureOr<List<DeviceLayout>> build() async {
    final api = ref.watch(apiProvider);
    final ids =
        ref.watch(deviceProvider.select((x) => x.map((y) => y.id).toList()));

    api.appLayoutMultiGet(request: <LayoutRequest>[]);

    final ret = <DeviceLayout>[];
    await _cacheFileManager.ensureDirectoryExists();
    final allLayoutsString =
        await _cacheFileManager.readContentAsString("all_layouts");
    if (allLayoutsString != null) {
      final list = jsonDecode(allLayoutsString);
      _fillLayoutList(list, ret);
    }

    final connection = ref.watch(hubConnectionConnectedProvider);
    if (connection == null) return ret;
    final allLayouts = await connection.invoke("GetAllDeviceLayouts", args: []);
    if (allLayouts is List) {
      ret.clear();
      _fillLayoutList(allLayouts, ret);
      _cacheFileManager.writeContentAsString(
          "all_layouts", jsonEncode(allLayouts));
    }
    return ret;
  }

  void _fillLayoutList(List<dynamic> allLayouts, List<DeviceLayout> ret) {
    for (final element in allLayouts) {
      if (element is Map<String, dynamic>)
        ret.add(DeviceLayout.fromJson(element));
    }
  }

  DeviceLayout? getLayout(int id, String typeName) {
    final curState = state.valueOrNull;
    if (curState == null) return null;

    final byId =
        curState.firstOrNull((x) => x.ids != null && x.ids!.contains(id));
    if (byId != null) return byId;
    final byName = curState.firstOrNull((x) =>
        x.typeName == typeName ||
        (x.typeNames != null && x.typeNames!.contains(typeName)));

    if (byName != null) return byName;
    return null;
  }

  void updateFromServer(List<Object?>? arguments) {
    final updateMap = arguments![0] as Map<String, dynamic>;
    final hash = arguments[1] as String;
    _updateFromServer(updateMap, hash, updateStorage: true);
  }

  Future _updateFromServer(
      final Map<String, dynamic> deviceLayoutJson, final String hash,
      {final bool updateStorage = false}) async {
    final deviceLayout = DeviceLayout.fromJson(deviceLayoutJson);

    final currentList = state.valueOrNull;
    if (currentList == null) return;
    final existingLayout = currentList
        .firstOrNull((final e) => e.uniqueName == deviceLayout.uniqueName);
    if (existingLayout != null &&
        existingLayout.version == deviceLayout.version &&
        existingLayout == deviceLayout) {
      return;
    }
    final copy = currentList.toList();
    if (existingLayout != null) copy.remove(existingLayout);

    copy.add(deviceLayout);
    state = AsyncData(copy);
    // if (updateStorage) {
    //   await _cacheFileManager.writeContentAsString(
    //       "all_layouts", jsonEncode(copy.map((x) => x.toJson()).toList()));
    // }
  }
}

// final deviceLayoutProvider =
//     Provider.family<DeviceLayout?, Tuple2<int, String>>(
//         (final ref, final device) {
//   final deviceLayoutTypeName = ref.watch(_typeNameLayoutProvider(device.item2));
//   final deviceLayoutId = ref.watch(_idLayoutProvider(device.item1));
//   final retLayout = deviceLayoutId ?? deviceLayoutTypeName;
//   final connection = ref.watch(hubConnectionConnectedProvider);
//   if (retLayout == null) {
//     DeviceLayoutService.loadFromServer(device.item1, device.item2, connection);
//   }
//   return retLayout;
// });

@riverpod
DashboardDeviceLayout? dashboardDeviceLayout(Ref ref, int id, String typeName) {
  final layoutProvider = ref.watch(deviceLayoutsProvider);
  if (layoutProvider.value case List<DeviceLayout> layouts) {
    return ref
        .read(deviceLayoutsProvider.notifier)
        .getLayout(id, typeName)
        ?.dashboardDeviceLayout;
  }
  return null;
}

final dashboardSpecialTypeLayoutProvider =
    Provider.family<List<DashboardPropertyInfo>?, Tuple2<int, String>>(
        (final ref, final device) {
  final layoutProvider =
      ref.watch(dashboardDeviceLayoutProvider(device.item1, device.item2));
  return layoutProvider?.dashboardProperties
      .where((final element) => element.specialType != DasboardSpecialType.none)
      .toList();
});

final dashboardNoSpecialTypeLayoutProvider =
    Provider.family<List<DashboardPropertyInfo>?, Tuple2<int, String>>(
        (final ref, final device) {
  final layoutProvider =
      ref.watch(dashboardDeviceLayoutProvider(device.item1, device.item2));
  return layoutProvider?.dashboardProperties
      .where((final element) => element.specialType == DasboardSpecialType.none)
      .toList();
});

@riverpod
DetailDeviceLayout? detailDeviceLayout(Ref ref, int id, String typeName) {
  final layoutProvider = ref.watch(deviceLayoutsProvider);
  if (layoutProvider.value case List<DeviceLayout> layouts) {
    return ref
        .read(deviceLayoutsProvider.notifier)
        .getLayout(id, typeName)
        ?.detailDeviceLayout;
  }
  return null;
}

final detailPropertyInfoLayoutProvider =
    Provider.family<List<DetailPropertyInfo>?, Tuple2<int, String>>(
        (final ref, final device) {
  final layoutProvider =
      ref.watch(detailDeviceLayoutProvider(device.item1, device.item2));
  final props = layoutProvider?.propertyInfos;
  return props;
});

final fabLayoutProvider =
    Provider.family<DetailPropertyInfo?, Tuple2<int, String>>(
        (final ref, final device) {
  final layoutProvider =
      ref.watch(detailDeviceLayoutProvider(device.item1, device.item2));
  final props = layoutProvider?.propertyInfos;
  return props?.firstOrNull((final element) =>
      element.editInfo?.editType == EditType.floatingactionbutton);
});

final detailTabInfoLayoutProvider =
    Provider.family<List<DetailTabInfo>?, Tuple2<int, String>>(
        (final ref, final device) {
  final layoutProvider =
      ref.watch(detailDeviceLayoutProvider(device.item1, device.item2));
  final showDebugInformation = ref.watch(debugInformationEnabledProvider);
  final tabInfos = layoutProvider?.tabInfos;
  if (tabInfos == null) return null;
  return tabInfos
      .where((final element) =>
          !element.showOnlyInDeveloperMode ||
          element.showOnlyInDeveloperMode == showDebugInformation)
      .toList();
});

final detailHistoryLayoutProvider =
    Provider.family<List<HistoryPropertyInfo>?, Tuple2<int, String>>(
        (final ref, final device) {
  final layoutProvider =
      ref.watch(detailDeviceLayoutProvider(device.item1, device.item2));
  return layoutProvider?.historyProperties;
});

// class DeviceLayoutService extends StateNotifier<List<DeviceLayout>> {
//   DeviceLayoutService() : super([]) {
//     _instance = this;
//   }

//   static DeviceLayoutService? _instance;
//   static final CacheFileManager _cacheFileManager = CacheFileManager(
//       path.join(Directory.systemTemp.path, "smarthome_layout_cache"), "json");

//   static void updateFromServer(final List<Object?>? arguments) {
//     final updateMap = arguments![0] as Map<String, dynamic>;
//     final hash = arguments[1] as String;
//     // print(updateMap);
//     _updateFromServer(updateMap, hash, updateStorage: true);
//   }

//   static Future _updateFromServer(
//       final Map<String, dynamic> deviceLayoutJson, final String hash,
//       {final bool updateStorage = false}) async {
//     final instance = _instance;
//     if (instance == null) return;
//     final deviceLayout = DeviceLayout.fromJson(deviceLayoutJson);

//     final currentList = instance.state;
//     final existingLayout = currentList
//         .firstOrNull((final e) => e.uniqueName == deviceLayout.uniqueName);
//     if (existingLayout != null &&
//         existingLayout.version == deviceLayout.version &&
//         existingLayout == deviceLayout) {
//       return;
//     }
//     final copy = currentList.toList();
//     if (existingLayout != null) copy.remove(existingLayout);

//     copy.add(deviceLayout);
//     instance.state = copy;
//     if (updateStorage) {
//       await _cacheFileManager.ensureDirectoryExists();
//       await _cacheFileManager.writeHashCode(deviceLayout.uniqueName, hash);
//       await _cacheFileManager.writeContentAsString(
//           deviceLayout.uniqueName, jsonEncode(deviceLayoutJson));
//     }
//   }

//   static Future loadFromServer(final int id, final String typeName,
//       final HubConnection? connection) async {
//     if (_instance == null ||
//         connection == null ||
//         connection.state != HubConnectionState.Connected) return;

//     final bestFit =
//         await connection.invoke("GetDeviceLayoutHashByDeviceId", args: [id])
//             as Map<String, dynamic>?;

//     if (bestFit == null) return;
//     final hash = bestFit["hash"] as String;
//     final localHash = await _cacheFileManager.readHashCode(bestFit["name"]);
//     if (localHash == hash) {
//       final content =
//           await _cacheFileManager.readContentAsString(bestFit["name"]);
//       if (content != null) {
//         _updateFromServer(jsonDecode(content) as Map<String, dynamic>, hash);
//         return;
//       }
//     }

//     final fromServer =
//         await connection.invoke("GetDeviceLayoutByDeviceId", args: [id]);
//     if (fromServer == null) return;

//     _updateFromServer(fromServer as Map<String, dynamic>, hash,
//         updateStorage: true);
//   }
// }
