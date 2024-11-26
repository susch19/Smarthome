// ignore_for_file: unused_import, constant_identifier_names

import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:signalr_client/signalr_client.dart';
// import 'package:signalr_core/signalr_core.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:smarthome/devices/generic/device_layout_service.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/devices/generic/stores/store_service.dart';
import 'package:smarthome/devices/painless_led_strip/led_strip_model.dart';
import 'package:smarthome/devices/zigbee/zigbee_switch_model.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/helper/preference_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

import '../icons/smarthome_icons.dart';
import 'device_exporter.dart';

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

final deviceProvider =
    StateNotifierProvider<DeviceManager, List<Device>>((final ref) {
  final connection = ref.watch(hubConnectionConnectedProvider);

  return DeviceManager(ref, connection);
});

final deviceByIdProvider = Provider.family<Device?, int>((final ref, final id) {
  final dm = ref.watch(deviceProvider);
  return dm.firstOrNull((final e) => e.id == id);
});

final deviceByIdValueStoreKeyProvider =
    Provider.family<Device?, Tuple2<String, int>>((final ref, final key) {
  final dm = ref.watch(deviceByIdProvider(key.item2));
  final valueStores = ref.watch(valueStoreChangedProvider(key));
  if (valueStores != null) return dm;
  return null;
});

final devicesByValueStoreKeyProvider =
    Provider.family<List<Device>, String>((final ref, final key) {
  final dm = ref.watch(deviceProvider);
  final List<Device> devices = [];
  for (final device in dm) {
    final valueStores =
        ref.watch(valueStoreChangedProvider(Tuple2(key, device.id)));
    if (valueStores != null) devices.add(device);
  }
  return devices;
});

final sortedDeviceProvider = Provider<List<Device>>((final ref) {
  final sort = ref.watch(deviceSortProvider);
  final devices = ref.watch(deviceProvider);
  final baseModels = ref.watch(baseModelFriendlyNamesMapProvider);

  switch (sort) {
    case SortTypes.NameAsc:
      devices.sort(
          (final x, final b) => baseModels[x.id]!.compareTo(baseModels[b.id]!));
      break;
    case SortTypes.NameDesc:
      devices.sort(
          (final x, final b) => baseModels[b.id]!.compareTo(baseModels[x.id]!));
      break;
    case SortTypes.TypeAsc:
      devices.sort((final x, final b) => x.typeName.runtimeType
          .toString()
          .compareTo(b.runtimeType.toString()));
      break;
    case SortTypes.TypeDesc:
      devices.sort((final x, final b) => b.typeName.runtimeType
          .toString()
          .compareTo(x.runtimeType.toString()));
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

final deviceSortProvider =
    StateProvider<SortTypes>((final _) => SortTypes.NameAsc);

enum Action { removed, added }

class DiffIdModel {
  int id;
  Action action;

  DiffIdModel(this.id, this.action);
}

class DeviceManager extends StateNotifier<List<Device>> {
  HashSet<int> _deviceIds = HashSet<int>();

  static DeviceManager? instance;

  late List<DiffIdModel> _diffIds = [];

  late Ref? _ref;
  static bool showDebugInformation = false;

  final HubConnection? _connection;

  DeviceManager(final Ref providerRef, this._connection) : super([]) {
    _ref = providerRef;
    instance = this;
    _fetchIds();
  }

  static final customGroupNameProvider =
      StateProvider.family<String, String>((final ref, final name) {
    return _groupNames[name] ?? name;
  });

  static final Map<String, String> _groupNames = <String, String>{};

  void _fetchIds() {
    final ref = _ref;
    final connection = _connection;
    if (ref == null || connection == null) return;
    final ids = HashSet<int>();
    for (final key in PreferencesManager.instance
        .getKeys()
        .where((final x) => x.startsWith("SHD"))) {
      final id = PreferencesManager.instance.getInt(key);
      if (id == null) continue;
      ids.add(id);
    }
    _deviceIds = ids;
    _syncDevices();
    // _clearDevicesCacheOnConnectionLost();
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

  void subscribeToDevice(final int device) {
    _deviceIds.add(device);
    _syncDevices();
  }

  void subscribeToDevices(final List<int> deviceIds) {
    _deviceIds.addAll(deviceIds);
    _syncDevices();
  }

  removeDevice(final int id) {
    _deviceIds.remove(id);
    _syncDevices();
  }

  void saveDeviceGroups() {
    if (_ref == null) return;

    final deviceGroups = state
        .map((final e) =>
            "${e.id}\u0002${_ref!.read(Device.groupsByIdProvider(e.id)).join("\u0003")}")
        .join("\u0001");
    PreferencesManager.instance.setString("deviceGroups", deviceGroups);
  }

  // static String getGroupName(final String key) {
  //   final name = groupNames[key];
  //   return name ?? key;
  // }

  void changeGroupName(final String key, final String newName) {
    _ref!.read(customGroupNameProvider(key).notifier).state = newName;
    _groupNames[key] = newName;

    final strs =
        _groupNames.select((final key, final value) => "$key\u0001$value");
    PreferencesManager.instance.setStringList("customGroupNames", strs);
  }

  static List<T> getDevicesOfType<T extends Device>() {
    return instance!.state
        .whereType<T>()
        .toList(); // where((x) => x.getDeviceType() == type).toList();
  }

  static Device getDeviceWithId(final int? id) {
    return instance!.state.firstWhere((final x) => x.id == id);
  }

  static final ctorFactory = <String, Object Function(int id, String typeName)>{
    //'LedStripMesh': (i, s, h, sp) => LedStrip(i, s, h, Icon(Icons.lightbulb_outline), sp),
    'Heater': (final i, final n) => Heater(i, n, Icons.whatshot),
    // 'XiaomiTempSensor': (i, s) => XiaomiTempSensor(i, n, "Temperatursensor",
    //     s as TempSensorModel, ConnectionManager.hubConnection,
    //     icon: SmarthomeIcons.xiaomiTempSensor),
    'LedStrip': (final i, final n) => LedStrip(i, n, Icons.lightbulb_outline),
    'FloaltPanel': (final i, final n) => FloaltPanel(i, n, Icons.crop_square),
    'OsramB40RW': (final i, final n) =>
        OsramB40RW(i, n, Icons.lightbulb_outline),
    'ZigbeeLamp': (final i, final n) =>
        ZigbeeLamp(i, n, Icons.lightbulb_outline),
    'OsramPlug': (final i, final n) =>
        OsramPlug(i, n, Icons.radio_button_checked),
    'TradfriLedBulb': (final i, final n) =>
        TradfriLedBulb(i, n, Icons.lightbulb_outline),
    'TradfriControlOutlet': (final i, final n) =>
        TradfriControlOutlet(i, n, Icons.radio_button_checked),
    'TradfriMotionSensor': (final i, final n) =>
        TradfriMotionSensor(i, n, Icons.sensors),
    'Device': (final i, final n) => GenericDevice(i, n),
  };
  static final stringNameJsonFactory =
      <String, BaseModel Function(Map<String, dynamic>, List<String>)>{
    // 'LedStripMesh': (m) => LedStripModel.fromJson(m),
    'Heater': (final m, final _) => HeaterModel.fromJson(m),
    // 'XiaomiTempSensor': (m) => TempSensorModel.fromJson(m),
    'LedStrip': (final m, final _) => LedStripModel.fromJson(m),
    'ZigbeeLamp': (final m, final _) => ZigbeeLampModel.fromJson(m),
    'FloaltPanel': (final m, final _) => ZigbeeLampModel.fromJson(m),
    'OsramB40RW': (final m, final _) => ZigbeeLampModel.fromJson(m),
    'OsramPlug': (final m, final _) => ZigbeeSwitchModel.fromJson(m),
    'TradfriLedBulb': (final m, final _) => TradfriLedBulbModel.fromJson(m),
    'TradfriControlOutlet': (final m, final _) => ZigbeeSwitchModel.fromJson(m),
    'TradfriMotionSensor': (final m, final _) =>
        TradfriMotionSensorModel.fromJson(m),
    'Device': (final m, final t) => BaseModel.fromJson(m, t)
  };

  void _loadDevices(final subs, final List<int> ids) {
    final ref = _ref;
    if (ref == null) return;
    final devices = state.toList();
    final List<BaseModel> baseModels = ref.read(baseModelsProvider).toList();

    // final futures = <Future>[];
    for (final id in ids) {
      final sub =
          subs.firstWhere((final x) => x["id"] == id, orElse: () => null);
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
        final dev = ctorFactory[type]!(id, types.first);
        devices.add(dev as Device<BaseModel>);
        final toRemove =
            baseModels.firstOrNull((final element) => element.id == id);
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
        final dev = devices
            .firstOrNull((final element) => element.id.toString() == deviceId);
        if (dev != null) {
          try {
            final groupings =
                ref.read(Device.groupsByIdProvider(dev.id).notifier);

            groupings.state = groups;
          } catch (ex) {
            print(ex);
            return;
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

    try {
      state = devices;
    } catch (ex) {
      print(ex);
      return;
    }
  }

  Future reloadCurrentDevices() async {
    final ref = _ref;
    final connection = _connection;
    if (ref == null || connection == null) return;

    final s = connection.invoke("GetAllDevices", args: []);

    final serverDevices = await s;
    if (serverDevices is! List<dynamic>) return;

    final baseModels = ref.read(baseModelsProvider).toList();
    for (int i = baseModels.length - 1; i >= 0; i--) {
      final baseModel = baseModels[i];
      final existingDevice = serverDevices
          .firstOrNull((final element) => element["id"] == baseModel.id);
      if (existingDevice == null) continue;
      final newBaseModel = baseModel.updateFromJson(existingDevice);
      if (newBaseModel == baseModel) continue;
      baseModels.remove(baseModel);
      baseModels.add(newBaseModel);
    }
    ref.read(baseModelsProvider.notifier).storeModels(baseModels);
  }

  void removeAllDevices() {
    for (int i = state.length - 1; i >= 0; i--) {
      final d = state.elementAt(i);
      PreferencesManager.instance.remove("SHD${d.id}");
      PreferencesManager.instance.remove("Json${d.id}");
      PreferencesManager.instance.remove("Type${d.id}");
    }
    _deviceIds.clear();
    _syncDevices();

    saveDeviceGroups();
  }

  void _syncDevices() {
    final ref = _ref;
    final connection = _connection;
    if (ref == null ||
        connection == null ||
        connection.state != HubConnectionState.Connected) return;
    final deviceIds = _deviceIds;

    final deviceIdsSet = deviceIds.toSet();
    final existingDeviceIdsSet = state.map((final x) => x.id).toSet();

    final newDevices = deviceIdsSet.difference(existingDeviceIdsSet);
    final removedDevices = existingDeviceIdsSet.difference(deviceIdsSet);

    _diffIds = [
      for (final id in newDevices) DiffIdModel(id, Action.added),
      for (final id in removedDevices) DiffIdModel(id, Action.removed),
    ];

    ref.watch(valueStoreProvider);
    if (_diffIds.isEmpty) {
      return;
    }

    if (_diffIds.any((final element) => element.action == Action.added)) {
      final deviceIds = _diffIds
          .where((final x) => x.action == Action.added)
          .map((final x) => x.id)
          .toList();
      connection.invoke("Subscribe", args: [deviceIds]).then((final subs) {
        _loadDevices(subs, deviceIds);
        for (final id in deviceIds) {
          if (PreferencesManager.instance.containsKey("SHD$id")) continue;
          PreferencesManager.instance.setInt("SHD$id", id);
        }
      });
    }
    if (_diffIds.any((final element) => element.action == Action.removed)) {
      final deviceIds = _diffIds
          .where((final x) => x.action == Action.removed)
          .map((final x) => x.id)
          .toList();
      connection.invoke("Unsubscribe", args: [deviceIds]).then((final value) {
        final devices = state.toList();
        for (final diffId in _diffIds) {
          devices.removeWhere((final d) => d.id == diffId.id);
        }
        state = devices;
      });
      for (final id in deviceIds) {
        PreferencesManager.instance.remove("SHD$id");
        PreferencesManager.instance.remove("Json$id");
        PreferencesManager.instance.remove("Type$id");
        PreferencesManager.instance.remove("Types$id");
      }
    }
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
  Generic
}

enum SortTypes { NameAsc, NameDesc, TypeAsc, TypeDesc, IdAsd, IdDesc }
