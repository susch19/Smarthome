import 'dart:convert';
import 'dart:io';

import 'package:smarthome/helper/cache_file_manager.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:tuple/tuple.dart';
import 'package:path/path.dart' as path;
import 'package:synchronized/synchronized.dart';

import 'generic_device_exporter.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final _layoutProvider = StateProvider<List<DeviceLayout>>((final ref) {
  DeviceLayoutService(ref);
  return [];
});

final _idLayoutProvider = Provider.family<DeviceLayout?, int>((final ref, final id) {
  final layouts = ref.watch(_layoutProvider);

  return layouts.firstOrNull((final element) => element.ids?.contains(id) ?? false);
});

final _typeNameLayoutProvider = Provider.family<DeviceLayout?, String>((final ref, final typeName) {
  final layouts = ref.watch(_layoutProvider);

  return layouts.firstOrNull((final element) => element.typeName == typeName);
});

final deviceLayoutProvider = Provider.family<DeviceLayout?, Tuple2<int, String>>((final ref, final device) {
  final deviceLayoutId = ref.watch(_idLayoutProvider(device.item1));
  final deviceLayoutTypeName = ref.watch(_typeNameLayoutProvider(device.item2));
  final retLayout = deviceLayoutId ?? deviceLayoutTypeName;
  if (retLayout == null) {
    DeviceLayoutService.loadFromServer(device.item1);
  }
  return retLayout;
});

final dashboardDeviceLayoutProvider =
    Provider.family<DashboardDeviceLayout?, Tuple2<int, String>>((final ref, final device) {
  final layoutProvider = ref.watch(deviceLayoutProvider(device));
  return layoutProvider?.dashboardDeviceLayout;
});

final dashboardSpecialTypeLayoutProvider =
    Provider.family<List<DashboardPropertyInfo>?, Tuple2<int, String>>((final ref, final device) {
  final layoutProvider = ref.watch(dashboardDeviceLayoutProvider(device));
  return layoutProvider?.dashboardProperties.where((final element) => element.specialType != SpecialType.none).toList();
});

final dashboardNoSpecialTypeLayoutProvider =
    Provider.family<List<DashboardPropertyInfo>?, Tuple2<int, String>>((final ref, final device) {
  final layoutProvider = ref.watch(dashboardDeviceLayoutProvider(device));
  return layoutProvider?.dashboardProperties.where((final element) => element.specialType == SpecialType.none).toList();
});

final detailDeviceLayoutProvider = Provider.family<DetailDeviceLayout?, Tuple2<int, String>>((final ref, final device) {
  final layoutProvider = ref.watch(deviceLayoutProvider(device));
  return layoutProvider?.detailDeviceLayout;
});

final detailPropertyInfoLayoutProvider =
    Provider.family<List<DetailPropertyInfo>?, Tuple2<int, String>>((final ref, final device) {
  final layoutProvider = ref.watch(detailDeviceLayoutProvider(device));
  return layoutProvider?.propertyInfos;
});

final detailTabInfoLayoutProvider =
    Provider.family<List<DetailTabInfo>?, Tuple2<int, String>>((final ref, final device) {
  final layoutProvider = ref.watch(detailDeviceLayoutProvider(device));
  return layoutProvider?.tabInfos;
});

final detailHistoryLayoutProvider =
    Provider.family<List<HistoryPropertyInfo>?, Tuple2<int, String>>((final ref, final device) {
  final layoutProvider = ref.watch(detailDeviceLayoutProvider(device));
  return layoutProvider?.historyProperties;
});

class DeviceLayoutService {
  DeviceLayoutService(this._ref) {
    _instance = this;
  }

  final Ref _ref;
  static DeviceLayoutService? _instance;
  static final CacheFileManager _cacheFileManager =
      CacheFileManager(path.join(Directory.systemTemp.path, "smarthome_layout_cache"), "json");
  static final lock = Lock();

  static void updateFromServer(final List<Object?>? arguments) {
    final updateMap = arguments![0] as Map<String, dynamic>;
    final hash = arguments[1] as String;
    _updateFromServer(updateMap, hash, updateStorage: true);
  }

  static Future _updateFromServer(final Map<String, dynamic> deviceLayoutJson, final String hash,
      {final bool updateStorage = false}) async {
    if (_instance == null) return;
    final layoutProvider = _instance!._ref.read(_layoutProvider.notifier);
    final deviceLayout = DeviceLayout.fromJson(deviceLayoutJson);

    final currentList = layoutProvider.state.toList();
    final existingLayout = currentList.firstOrNull((final e) => e.uniqueName == deviceLayout.uniqueName);
    if (existingLayout.hashCode == deviceLayout.hashCode) return;
    if (existingLayout != null) currentList.remove(existingLayout);

    currentList.add(deviceLayout);
    if (updateStorage) {
      await _cacheFileManager.ensureDirectoryExists();
      await _cacheFileManager.writeHashCode(deviceLayout.uniqueName, hash);
      await _cacheFileManager.writeContentAsString(deviceLayout.uniqueName, jsonEncode(deviceLayoutJson));
    }
    layoutProvider.state = currentList;
  }

  static Future<void> loadFromServer(final int id) async {
    if (_instance == null) return;

    final bestFit = await ConnectionManager.hubConnection.invoke("GetDeviceLayoutHashByDeviceId", args: [id])
        as Map<String, dynamic>?;
    if (bestFit == null) return;
    await lock.synchronized(() async {
      final hash = bestFit["hash"] as String;
      final localHash = await _cacheFileManager.readHashCode(bestFit["name"]);
      if (localHash == hash) {
        final content = await _cacheFileManager.readContentAsString(bestFit["name"]);
        if (content != null) {
          _updateFromServer(jsonDecode(content) as Map<String, dynamic>, hash);
          return;
        }
      }

      final fromServer = await ConnectionManager.hubConnection.invoke("GetDeviceLayoutByDeviceId", args: [id]);
      if (fromServer == null) return;

      _updateFromServer(fromServer as Map<String, dynamic>, hash, updateStorage: true);
    });
  }
}
