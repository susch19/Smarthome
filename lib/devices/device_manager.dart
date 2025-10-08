// ignore_for_file: unused_import, constant_identifier_names

import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:signalr_client/signalr_client.dart';
// import 'package:signalr_core/signalr_core.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:smarthome/devices/generic/device_layout_service.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/devices/generic/stores/store_service.dart';
import 'package:smarthome/devices/painless_led_strip/led_strip_model.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/helper/firebase_manager.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/helper/preference_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../icons/smarthome_icons.dart';
import 'device_exporter.dart';

part 'device_manager.g.dart';

// final deviceIdProvider = StateProvider<List<int>>((final _) => []);
// final deviceIdProvider = StateNotifierProvider<DeviceIdManager, List<int>>((final _) => DeviceIdManager([]));

// class DeviceIdManager extends StateNotifier<List<int>> {
//   DeviceIdManager(super.state);

//   void subscribeToDevice(final int device) {
//     state = [...state, device];
//   }

//   void subscribeToDevices(final List<int> deviceIds) {
//     state = [...state, ...deviceIds];
//   }
// }

@riverpod
Device? deviceById(final Ref ref, final int id) {
  final dm = ref.watch(deviceManagerProvider);

  return switch (dm) {
    AsyncData(:final value) => value.firstOrDefault((final e) => e.id == id),
    _ => null,
  };
}

@riverpod
Device? deviceByIdValueStoreKey(
  final Ref ref,
  final String valueKey,
  final int id,
) {
  final dm = ref.watch(deviceByIdProvider(id));
  final valueStores = ref.watch(valueStoreChangedProvider(valueKey, id));
  if (valueStores != null) {
    return dm;
  }

  return null;
}

final devicesByValueStoreKeyProvider = Provider.family<List<Device>, String>((
  final ref,
  final key,
) {
  final dm = ref.watch(deviceManagerProvider);
  if (!dm.hasValue) return [];

  final List<Device> devices = [];
  for (final device in dm.value!) {
    final valueStores = ref.watch(valueStoreChangedProvider(key, device.id));
    if (valueStores != null) devices.add(device);
  }
  return devices;
});

final sortedDeviceProvider = Provider<List<Device>>((final ref) {
  final sort = ref.watch(deviceSortProvider);
  final devicesManager = ref.watch(deviceManagerProvider);
  final baseModels = ref.watch(baseModelFriendlyNamesMapProvider);
  if (!devicesManager.hasValue) return [];
  final devices = devicesManager.requireValue;

  switch (sort) {
    case SortTypes.NameAsc:
      devices.sort(
        (final x, final b) => baseModels[x.id]!.compareTo(baseModels[b.id]!),
      );
      break;
    case SortTypes.NameDesc:
      devices.sort(
        (final x, final b) => baseModels[b.id]!.compareTo(baseModels[x.id]!),
      );
      break;
    case SortTypes.TypeAsc:
      devices.sort(
        (final x, final b) => x.typeName.runtimeType.toString().compareTo(
          b.runtimeType.toString(),
        ),
      );
      break;
    case SortTypes.TypeDesc:
      devices.sort(
        (final x, final b) => b.typeName.runtimeType.toString().compareTo(
          x.runtimeType.toString(),
        ),
      );
      break;
    case SortTypes.IdAsd:
      devices.sort((final x, final b) => x.id.compareTo(b.id));
      break;
    case SortTypes.IdDesc:
      devices.sort((final x, final b) => b.id.compareTo(x.id));
      break;
  }

  return devices.toList();
});

final deviceSortProvider = StateProvider<SortTypes>(
  (final _) => SortTypes.NameAsc,
);

enum Action { removed, added }

class DiffIdModel {
  int id;
  Action action;

  DiffIdModel(this.id, this.action);
}

final deviceCtorFactory = <String, Device Function(int id, String typeName)>{
  'Heater': (final i, final n) => Heater(i, n, Icons.whatshot),
  'LedStrip': (final i, final n) => LedStrip(i, n, Icons.lightbulb_outline),
  'Device': (final i, final n) => GenericDevice(i, n),
};
final stringNameJsonFactory =
    <String, BaseModel Function(Map<String, dynamic>, List<String>)>{
      'Heater': (final m, final _) => HeaterModel.fromJson(m),
      'LedStrip': (final m, final _) => LedStripModel.fromJson(m),
      'Device': (final m, final t) => BaseModel.fromJson(m, t),
    };

@Riverpod(keepAlive: true)
class DeviceManager extends _$DeviceManager {
  HashSet<int> _deviceIds = HashSet<int>();

  // late List<DiffIdModel> _diffIds = [];

  static bool showDebugInformation = false;

  late HubConnection? _connection;

  static final Map<String, String> _groupNames = <String, String>{};
  static final customGroupNameProvider = StateProvider.family<String, String>((
    final ref,
    final name,
  ) {
    return _groupNames[name] ?? name;
  });

  @override
  FutureOr<List<Device<BaseModel>>> build() async {
    final manager = ref.watch(connectionManagerProvider);
    if (!manager.hasValue) return [];
    final connection = manager.requireValue.connection;
    if (connection == null) return [];

    _connection = connection;

    final ids = HashSet<int>();
    for (final key in PreferencesManager.instance.getKeys().where(
      (final x) => x.startsWith("SHD"),
    )) {
      final id = PreferencesManager.instance.getInt(key);
      if (id == null) continue;
      ids.add(id);
    }
    _deviceIds = ids;
    return await _syncDevices(
      [],
      ids.map((final x) => DiffIdModel(x, Action.added)).toList(),
    );
  }

  static void init() {
    final names = PreferencesManager.instance.getStringList("customGroupNames");

    if (names != null) {
      for (final name in names) {
        final values = name.split('\u0001');

        _groupNames[values[0]] = values[1];
      }
    }
  }

  Future subscribeToDevice(final int id) async {
    if (!_deviceIds.add(id)) return;
    await _syncDevices(state.value ?? [], [DiffIdModel(id, Action.added)]);
  }

  Future subscribeToDevices(final List<int> deviceIds) async {
    final diffs = <DiffIdModel>[];
    for (final id in deviceIds) {
      if (_deviceIds.add(id)) diffs.add(DiffIdModel(id, Action.added));
    }
    if (diffs.isEmpty) return;

    await _syncDevices(state.value ?? [], diffs);
  }

  Future removeDevice(final int id) async {
    if (!_deviceIds.remove(id)) return;
    await _syncDevices(state.value ?? [], [DiffIdModel(id, Action.removed)]);
  }

  void saveDeviceGroups() {
    final current = state.value;
    if (current == null) return;

    final deviceGroups = current
        .map(
          (final e) =>
              "${e.id}\u0002${ref.read(Device.groupsByIdProvider(e.id)).join("\u0003")}",
        )
        .join("\u0001");
    PreferencesManager.instance.setString("deviceGroups", deviceGroups);
  }

  // static String getGroupName(final String key) {
  //   final name = groupNames[key];
  //   return name ?? key;
  // }

  void changeGroupName(final String key, final String newName) {
    ref.read(customGroupNameProvider(key).notifier).state = newName;
    _groupNames[key] = newName;

    final strs = _groupNames.select(
      (final key, final value) => "$key\u0001$value",
    );
    PreferencesManager.instance.setStringList("customGroupNames", strs);
  }

  List<Device<BaseModel>> _loadDevices(final List subs, final List<int> ids) {
    final List<BaseModel> baseModels = ref.read(baseModelsProvider).toList();

    final devices = <Device>[];
    // final futures = <Future>[];
    for (final id in ids) {
      final sub = subs.firstOrDefault((final x) => x["id"] == id);
      if (sub == null) {
        continue;
      }
      final types =
          PreferencesManager.instance.getStringList("Types$id") ?? <String>[];
      BaseModel? model;
      String? type;
      if (types.isEmpty) {
        for (final item in sub["typeNames"]) {
          types.add(item.toString());
        }
      }
      final preferenceId = "Types$id";
      if (!PreferencesManager.instance.containsKey(preferenceId)) {
        PreferencesManager.instance.setStringList(preferenceId, types);
      }

      if (types.isEmpty) {
        type = PreferencesManager.instance.getString("Type$id");
      } else {
        for (final item in types) {
          if (!stringNameJsonFactory.containsKey(item)) {
            continue;
          }
          type = item;
          break;
        }
      }
      try {
        model = stringNameJsonFactory[type]!(sub, types);
        final dev = deviceCtorFactory[type]!(id, types.first);
        devices.add(dev);
        ref.read(stateServiceProvider.notifier).updateAndGetStores(id, sub);
        if (sub["dynamicStateData"] case final Map<String, dynamic>? extData
            when extData != null) {
          ref
              .read(stateServiceProvider.notifier)
              .updateAndGetStores(id, extData);
        }
        final toRemove = baseModels.firstOrDefault(
          (final element) => element.id == id,
        );
        if (toRemove != null) {
          baseModels.remove(toRemove);
        }
        baseModels.add(model);
        // final _ = ref.read(deviceInstanceLayoutProvider(id));
        // futures.add(DeviceLayoutService.loadInitialLayoutAsync(id, types));
      } catch (e) {
        print(e);
      }
    }
    final deviceGroups = PreferencesManager.instance.getString("deviceGroups");

    if (deviceGroups != null) {
      final devicesGroups = deviceGroups.split("\u0001");

      for (final item in devicesGroups) {
        final deviceGroup = item.split("\u0002");
        final deviceId = deviceGroup.first;
        final groups = deviceGroup.last.split("\u0003");
        final dev = devices.firstOrDefault(
          (final element) => element.id.toString() == deviceId,
        );
        if (dev != null) {
          try {
            final groupings = ref.read(
              Device.groupsByIdProvider(dev.id).notifier,
            );

            groupings.state = groups;
          } catch (ex) {
            print(ex);
          }
        }
      }
    }
    // try {
    //   final deviceIdState = ref.read(deviceIdProvider.notifier);
    //   deviceIdState.state = devices.map((final e) => e.id).toList();
    // } catch (ex) {
    //   print(ex);
    //   return;
    // }

    ref.read(baseModelsProvider.notifier).storeModels(baseModels);
    return devices;
  }

  Future reloadCurrentDevices() async {
    final baseModels = ref.read(baseModelsProvider).toList();
    if (baseModels.isNotEmpty) {
      final api = ref.read(apiProvider);

      final res = await api.appDeviceGet();
      final devices = res.bodyOrThrow;
      for (int i = baseModels.length - 1; i >= 0; i--) {
        final baseModel = baseModels[i];
        final existingDevice = devices.firstOrDefault(
          (final element) => element.id == baseModel.id,
        );
        if (existingDevice == null) continue;

        baseModels.remove(baseModel);
        baseModels.add(existingDevice.lastModel!);
      }
      ref.read(baseModelsProvider.notifier).storeModels(baseModels);
    }
  }

  void removeAllDevices() {
    final devices = state.value?.map((final x) => x.id).toList() ?? _deviceIds;
    if (devices.isEmpty) {
      _deviceIds.clear();
      return;
    }
    for (int i = devices.length - 1; i >= 0; i--) {
      final d = devices.elementAt(i);
      PreferencesManager.instance.remove("SHD$d");
      PreferencesManager.instance.remove("Json$d");
      PreferencesManager.instance.remove("Type$d");
    }
    _deviceIds.clear();
    _syncDevices(
      [],
      devices.map((final x) => DiffIdModel(x, Action.removed)).toList(),
    );

    saveDeviceGroups();
  }

  Future<List<Device<BaseModel>>> _syncDevices(
    final List<Device<BaseModel>> current,
    final List<DiffIdModel> diffIds,
  ) async {
    final connection = _connection;
    if (connection == null ||
        connection.state != HubConnectionState.Connected) {
      return current;
    }

    if (diffIds.any((final element) => element.action == Action.added)) {
      final deviceIds = diffIds
          .where((final x) => x.action == Action.added)
          .map((final x) => x.id)
          .toList();
      final subs = await connection.invoke("Subscribe", args: [deviceIds]);
      current.addAll(_loadDevices(subs as List, deviceIds));
      for (final id in deviceIds) {
        if (PreferencesManager.instance.containsKey("SHD$id")) continue;
        PreferencesManager.instance.setInt("SHD$id", id);
        if (Platform.isAndroid || Platform.isIOS) {
          FirebaseMessaging.instance.subscribeToTopic("device_$id");
        }
      }
    }
    if (diffIds.any((final element) => element.action == Action.removed)) {
      final deviceIds = diffIds
          .where((final x) => x.action == Action.removed)
          .map((final x) => x.id)
          .toList();
      await connection.invoke("Unsubscribe", args: [deviceIds]);

      for (final diffId in diffIds) {
        current.removeWhere((final d) => d.id == diffId.id);
        if (Platform.isAndroid || Platform.isIOS) {
          FirebaseMessaging.instance.unsubscribeFromTopic("device_$diffId");
        }
      }

      for (final id in deviceIds) {
        PreferencesManager.instance.remove("SHD$id");
        PreferencesManager.instance.remove("Json$id");
        PreferencesManager.instance.remove("Type$id");
        PreferencesManager.instance.remove("Types$id");
      }
    }
    return current;
  }
}

enum DeviceTypes {
  Heater,
  XiaomiTempSensor,
  LedStrip,
  FloaltPanel,
  OsramB40RW,
  OsramPlug,
  TradfriLedBulb,
  TradfriControlOutlet,
  TradfriMotionSensor,
  ZigbeeLamp,
  Generic,
}

enum SortTypes { NameAsc, NameDesc, TypeAsc, TypeDesc, IdAsd, IdDesc }
