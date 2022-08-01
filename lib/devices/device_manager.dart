// ignore_for_file: unused_import, constant_identifier_names

import 'dart:convert';

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

final deviceIdProvider = StateProvider<List<int>>((final _) => []);

final deviceProvider = StateNotifierProvider<DeviceManager, List<Device>>((final ref) {
  final deviceIds = ref.watch(deviceIdProvider);
  final dm = DeviceManager(ref, deviceIds);
  return dm;
});

final deviceByIdProvider = Provider.family<Device?, int>((final ref, final id) {
  final dm = ref.watch(deviceProvider);
  return dm.firstOrNull((final e) => e.id == id);
});

final deviceByIdValueStoreKeyProvider = Provider.family<Device?, Tuple2<int, String>>((final ref, final key) {
  final dm = ref.watch(deviceByIdProvider(key.item1));
  final valueStores = ref.watch(valueStorePerIdAndNameProvider(key));
  if (valueStores != null) return dm;
  return null;
});

final devicesByValueStoreKeyProvider = Provider.family<List<Device>, String>((final ref, final key) {
  final dm = ref.watch(deviceProvider);
  final List<Device> devices = [];
  for (final device in dm) {
    final valueStores = ref.watch(valueStorePerIdAndNameProvider(Tuple2(device.id, key)));
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
      devices.sort((final x, final b) => baseModels[x.id]!.compareTo(baseModels[b.id]!));
      break;
    case SortTypes.NameDesc:
      devices.sort((final x, final b) => baseModels[b.id]!.compareTo(baseModels[x.id]!));
      break;
    case SortTypes.TypeAsc:
      devices.sort((final x, final b) => x.typeName.runtimeType.toString().compareTo(b.runtimeType.toString()));
      break;
    case SortTypes.TypeDesc:
      devices.sort((final x, final b) => b.typeName.runtimeType.toString().compareTo(x.runtimeType.toString()));
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

final deviceSortProvider = StateProvider<SortTypes>((final _) => SortTypes.NameAsc);

enum Action { removed, added }

class DiffIdModel {
  int id;
  Action action;

  DiffIdModel(this.id, this.action);
}

class DeviceManager extends StateNotifier<List<Device>> {
  DeviceManager(final Ref providerRef, final List<int> deviceIds) : super(_devices) {
    _ref = providerRef;
    _instance = this;

    final deviceIdsSet = deviceIds.toSet();
    final existingDeviceIdsSet = _devices.map((final x) => x.id).toSet();

    final newDevices = deviceIdsSet.difference(existingDeviceIdsSet);
    final removedDevices = existingDeviceIdsSet.difference(deviceIdsSet);

    _diffIds = [
      for (var id in newDevices) DiffIdModel(id, Action.added),
      for (var id in removedDevices) DiffIdModel(id, Action.removed),
    ];
    _syncDevices(providerRef);
    _clearDevicesCacheOnConnectionLost(providerRef);
  }

  late final List<DiffIdModel> _diffIds;

  static List<Device> _devices = <Device>[];
  static late DeviceManager _instance;
  static late Ref? _ref;
  static bool showDebugInformation = false;

  static final customGroupNameProvider = StateProvider.family<String, String>((final ref, final name) {
    return _groupNames[name] ?? name;
  });

  static final Map<String, String> _groupNames = <String, String>{};

  static void init() {
    final names = PreferencesManager.instance.getStringList("customGroupNames");

    if (names != null) {
      for (final name in names) {
        final values = name.split('\u0001');

        _groupNames[values[0]] = values[1];
      }
    }
  }

  static void updateMethod(final List<Object?>? arguments) {
    if (_ref == null) return;
    final baseModels = _ref!.read(baseModelProvider.notifier);
    final oldState = baseModels.state.toList();
    bool hasChanges = false;
    for (final a in arguments!) {
      final updateMap = a as Map;
      for (var i = 0; i < oldState.length; i++) {
        final oldModel = oldState[i];
        if (oldModel.id != updateMap["id"]) continue;
        final newModel = oldModel.updateFromJson(updateMap as Map<String, dynamic>);
        if (newModel != newModel) continue;
        oldState[i] = newModel;
        hasChanges = true;
      }
    }
    if (hasChanges) baseModels.state = oldState;
  }

  static void subscribeToDevice(final int device) {
    final deviceIdsState = _ref?.read(deviceIdProvider.notifier);
    if (deviceIdsState == null) return;
    deviceIdsState.state = [...deviceIdsState.state, device];
  }

  static void subscribeToDevices(final List<int> deviceIds) {
    final deviceIdsState = _ref?.read(deviceIdProvider.notifier);
    if (deviceIdsState == null) return;
    deviceIdsState.state = [...deviceIdsState.state, ...deviceIds];
  }

  static void saveDeviceGroups() {
    if (_ref == null) return;

    final deviceGroups = _instance.state
        .map((final e) => "${e.id}\u0002${_ref!.read(Device.groupsByIdProvider(e.id)).join("\u0003")}")
        .join("\u0001");
    PreferencesManager.instance.setString("deviceGroups", deviceGroups);
  }

  // static String getGroupName(final String key) {
  //   final name = groupNames[key];
  //   return name ?? key;
  // }

  static void changeGroupName(final String key, final String newName) {
    _ref!.read(customGroupNameProvider(key).notifier).state = newName;
    _groupNames[key] = newName;

    final strs = _groupNames.select((final key, final value) => "$key\u0001$value");
    PreferencesManager.instance.setStringList("customGroupNames", strs);
  }

  static List<T> getDevicesOfType<T extends Device>() {
    return _devices.whereType<T>().toList(); // where((x) => x.getDeviceType() == type).toList();
  }

  static Device getDeviceWithId(final int? id) {
    return _devices.firstWhere((final x) => x.id == id);
  }

  static final ctorFactory = <String, Object Function(int id, String typeName)>{
    //'LedStripMesh': (i, s, h, sp) => LedStrip(i, s, h, Icon(Icons.lightbulb_outline), sp),
    'Heater': (final i, final n) => Heater(i, n, Icons.whatshot),
    // 'XiaomiTempSensor': (i, s) => XiaomiTempSensor(i, n, "Temperatursensor",
    //     s as TempSensorModel, ConnectionManager.hubConnection,
    //     icon: SmarthomeIcons.xiaomiTempSensor),
    'LedStrip': (final i, final n) => LedStrip(i, n, Icons.lightbulb_outline),
    'FloaltPanel': (final i, final n) => FloaltPanel(i, n, Icons.crop_square),
    'OsramB40RW': (final i, final n) => OsramB40RW(i, n, Icons.lightbulb_outline),
    'ZigbeeLamp': (final i, final n) => ZigbeeLamp(i, n, Icons.lightbulb_outline),
    'OsramPlug': (final i, final n) => OsramPlug(i, n, Icons.radio_button_checked),
    'TradfriLedBulb': (final i, final n) => TradfriLedBulb(i, n, Icons.lightbulb_outline),
    'TradfriControlOutlet': (final i, final n) => TradfriControlOutlet(i, n, Icons.radio_button_checked),
    'TradfriMotionSensor': (final i, final n) => TradfriMotionSensor(i, n, Icons.sensors),
    'Device': (final i, final n) => GenericDevice(i, n),
  };
  static final stringNameJsonFactory = <String, BaseModel Function(Map<String, dynamic>, List<String>)>{
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
    'TradfriMotionSensor': (final m, final _) => TradfriMotionSensorModel.fromJson(m),
    'Device': (final m, final t) => BaseModel.fromJson(m, t)
  };

  void _loadDevices(final subs, final List<int> ids, final Ref ref) {
    final devices = state.toList();
    final baseModelState = ref.read(baseModelProvider.notifier);
    final baseModels = baseModelState.state.toList();
    // final futures = <Future>[];
    for (final id in ids) {
      final sub = subs.firstWhere((final x) => x["id"] == id, orElse: () => null);
      if (sub == null) continue;
      final types = PreferencesManager.instance.getStringList("Types$id") ?? <String>[];
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
          if (!stringNameJsonFactory.containsKey(item)) continue;
          type = item;
          break;
        }
      }

      try {
        if (sub == null) continue;
        model = stringNameJsonFactory[type]!(sub, types);
        final dev = ctorFactory[type]!(id, types.first);
        devices.add(dev as Device<BaseModel>);
        final toRemove = baseModels.firstOrNull((final element) => element.id == id);
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
        final dev = devices.firstOrNull((final element) => element.id.toString() == deviceId);
        if (dev != null) {
          final groupings = ref.read(Device.groupsByIdProvider(dev.id).notifier);

          groupings.state = groups;
        }
      }
    }
    final deviceIdState = ref.read(deviceIdProvider.notifier);
    baseModelState.state = baseModels;
    _devices = devices;
    deviceIdState.state = devices.map((final e) => e.id).toList();
  }

  static Future reloadCurrentDevices() async {
    if (_ref == null) return;

    final s = ConnectionManager.hubConnection.invoke("GetAllDevices", args: []);

    final serverDevices = await s;
    if (serverDevices is! List<dynamic>) return;

    final baseModelState = _ref!.read(baseModelProvider.notifier);
    final baseModels = baseModelState.state.toList();
    for (int i = baseModels.length - 1; i >= 0; i--) {
      final baseModel = baseModels[i];
      final existingDevice = serverDevices.firstOrNull((final element) => element["id"] == baseModel.id);
      if (existingDevice == null) continue;
      final newBaseModel = baseModel.updateFromJson(existingDevice);
      if (newBaseModel == baseModel) continue;
      baseModels.remove(baseModel);
      baseModels.add(newBaseModel);
    }
    baseModelState.state = baseModels;
  }

  static void removeAllDevices() {
    for (int i = _instance.state.length - 1; i >= 0; i--) {
      final d = _instance.state.elementAt(i);
      PreferencesManager.instance.remove("SHD${d.id}");
      PreferencesManager.instance.remove("Json${d.id}");
      PreferencesManager.instance.remove("Type${d.id}");
    }

    final ids = _ref?.read(deviceIdProvider.notifier);
    ids?.state = [];

    DeviceManager.saveDeviceGroups();
  }

  void _syncDevices(final Ref ref) {
    final connection = ref.watch(hubConnectionConnectedProvider);

    if (connection == null || _diffIds.isEmpty) {
      return;
    }

    final deviceIdState = ref.read(deviceIdProvider.notifier);

    if (_diffIds.any((final element) => element.action == Action.added)) {
      final deviceIds = _diffIds.where((final x) => x.action == Action.added).map((final x) => x.id).toList();
      connection.invoke("Subscribe", args: [deviceIds]).then((final subs) {
        _loadDevices(subs, deviceIds, ref);
        for (final id in deviceIds) {
          if (PreferencesManager.instance.containsKey("SHD$id")) continue;
          PreferencesManager.instance.setInt("SHD$id", id);
        }
      });
    } else if (_diffIds.any((final element) => element.action == Action.removed)) {
      final deviceIds = _diffIds.where((final x) => x.action == Action.removed).map((final x) => x.id).toList();
      connection.invoke("Unsubscribe", args: [deviceIds]).then((final value) {
        final devices = state.toList();
        for (final diffId in _diffIds) {
          devices.removeWhere((final d) => d.id == diffId.id);
        }
        _devices = devices;
        deviceIdState.state = devices.map((final e) => e.id).toList();
      });
      for (final id in deviceIds) {
        PreferencesManager.instance.remove("SHD$id");
        PreferencesManager.instance.remove("Json$id");
        PreferencesManager.instance.remove("Type$id");
        PreferencesManager.instance.remove("Types$id");
      }
    }
  }

  void _clearDevicesCacheOnConnectionLost(final Ref providerRef) {
    final state = providerRef.watch(hubConnectionStateProvider);
    if (state != HubConnectionState.Connected) {
      _devices = [];
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
