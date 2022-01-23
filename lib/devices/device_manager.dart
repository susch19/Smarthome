// ignore_for_file: unused_import, constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:signalr_client/signalr_client.dart';
import 'package:signalr_core/signalr_core.dart';
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

  switch (sort) {
    case SortTypes.NameAsc:
      devices.sort((final x, final b) => x.baseModel.friendlyName.compareTo(b.baseModel.friendlyName));
      break;
    case SortTypes.NameDesc:
      devices.sort((final x, final b) => b.baseModel.friendlyName.compareTo(x.baseModel.friendlyName));
      break;
    case SortTypes.TypeAsc:
      devices.sort((final x, final b) => x.baseModel.runtimeType.toString().compareTo(b.runtimeType.toString()));
      break;
    case SortTypes.TypeDesc:
      devices.sort((final x, final b) => b.baseModel.runtimeType.toString().compareTo(x.runtimeType.toString()));
      break;
    case SortTypes.IdAsd:
      devices.sort((final x, final b) => x.baseModel.id.compareTo(b.baseModel.id));
      break;
    case SortTypes.IdDesc:
      devices.sort((final x, final b) => b.baseModel.id.compareTo(x.baseModel.id));
      break;
  }

  return devices;
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
  static final notSubscribedDevices = <int>[];

  static late DeviceManager _instance;
  static Ref? _ref;

  static bool showDebugInformation = false;

  static bool sub = false;
  static Map<String, String> groupNames = <String, String>{};
  static ValueNotifier<bool> deviceStateChanged = ValueNotifier(false);

  static void init() {
    final names = PreferencesManager.instance.getStringList("customGroupNames");

    if (names != null) {
      for (final name in names) {
        final values = name.split('\u0001');
        groupNames[values[0]] = values[1];
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
    final deviceGroups =
        _instance.state.map((final e) => e.id.toString() + "\u0002" + e.groups.join("\u0003")).join("\u0001");
    PreferencesManager.instance.setString("deviceGroups", deviceGroups);
  }

  static String getGroupName(final String key) {
    final name = groupNames[key];
    return name ?? key;
  }

  static void changeGroupName(final String key, final String newName) {
    groupNames[key] = newName;

    final strs = groupNames.select((final key, final value) => key + "\u0001" + value);
    PreferencesManager.instance.setStringList("customGroupNames", strs);
  }

  static List<T> getDevicesOfType<T extends Device>() {
    return _devices.whereType<T>().toList(); // where((x) => x.getDeviceType() == type).toList();
  }

  static Device getDeviceWithId(final int? id) {
    return _devices.firstWhere((final x) => x.id == id);
  }

  static void sortDevices(final SortTypes value) {
    if (_ref == null) return;

    _ref!.read(deviceSortProvider.notifier).state = value;

    PreferencesManager.instance.setInt("SortOrder", value.index);
  }

  static final ctorFactory = <String, Object Function(int id, BaseModel model)>{
    //'LedStripMesh': (i, s, h, sp) => LedStrip(i, s, h, Icon(Icons.lightbulb_outline), sp),
    'Heater': (final i, final s) =>
        Heater(i, "Heizung", s as HeaterModel, ConnectionManager.hubConnection, Icons.whatshot),
    // 'XiaomiTempSensor': (i, s) => XiaomiTempSensor(i, "Temperatursensor",
    //     s as TempSensorModel, ConnectionManager.hubConnection,
    //     icon: SmarthomeIcons.xiaomiTempSensor),
    'LedStrip': (final i, final s) =>
        LedStrip(i, "Ledstrip", s as LedStripModel, ConnectionManager.hubConnection, Icons.lightbulb_outline),
    'FloaltPanel': (final i, final s) =>
        FloaltPanel(i, "Floalt Panel", s as ZigbeeLampModel, ConnectionManager.hubConnection, Icons.crop_square),
    'OsramB40RW': (final i, final s) =>
        OsramB40RW(i, "Osram B40", s as ZigbeeLampModel, ConnectionManager.hubConnection, Icons.lightbulb_outline),
    'ZigbeeLamp': (final i, final s) =>
        ZigbeeLamp(i, "Osram B40", s as ZigbeeLampModel, ConnectionManager.hubConnection, Icons.lightbulb_outline),
    'OsramPlug': (final i, final s) =>
        OsramPlug(i, "Osram Plug", s as ZigbeeSwitchModel, ConnectionManager.hubConnection, Icons.radio_button_checked),
    'TradfriLedBulb': (final i, final s) => TradfriLedBulb(
        i, "Tradfi RGB Bulb", s as TradfriLedBulbModel, ConnectionManager.hubConnection, Icons.lightbulb_outline),
    'TradfriControlOutlet': (final i, final s) => TradfriControlOutlet(i, "Tradfri Control Outlet",
        s as ZigbeeSwitchModel, ConnectionManager.hubConnection, Icons.radio_button_checked),
    'TradfriMotionSensor': (final i, final s) => TradfriMotionSensor(
        i, "Tradfri Motion Sensor", s as TradfriMotionSensorModel, ConnectionManager.hubConnection, Icons.sensors),
    'Device': (final i, final s) => GenericDevice(i, "Generic Device", s, ConnectionManager.hubConnection),
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

  static void stopSubbing() {
    sub = false;
  }

  void _loadDevices(final subs, final List<int> ids, final Ref ref) {
    final devices = state.toList();
    // final futures = <Future>[];
    for (final id in ids) {
      final sub = subs.firstWhere((final x) => x["id"] == id, orElse: () => null);
      final types = PreferencesManager.instance.getStringList("Types" + id.toString()) ?? <String>[];
      BaseModel? model;
      String? type;
      if (types.isEmpty) {
        for (final item in sub["typeNames"]) {
          types.add(item.toString());
        }
      }
      final preferenceId = "Types" + id.toString();
      if (!PreferencesManager.instance.containsKey(preferenceId)) {
        PreferencesManager.instance.setStringList(preferenceId, types);
      }

      if (types.isEmpty) {
        type = PreferencesManager.instance.getString("Type" + id.toString());
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
        final dev = ctorFactory[type]!(id, model);
        devices.add(dev as Device<BaseModel>);
        // final _ = ref.read(deviceInstanceLayoutProvider(id));
        // futures.add(DeviceLayoutService.loadInitialLayoutAsync(id, types));
      } catch (e) {
        print(e);
      }
    }
    final deviceGroups = PreferencesManager.instance.getString("deviceGroups");

    if (deviceGroups == null) return;
    final devicesGroups = deviceGroups.split("\u0001");

    for (final item in devicesGroups) {
      final deviceGroup = item.split("\u0002");
      final deviceId = deviceGroup.first;
      final groups = deviceGroup.last.split("\u0003");
      final dev = devices.firstOrNull((final element) => element.id.toString() == deviceId);
      if (dev != null) {
        dev.groups.clear();
        dev.groups.addAll(groups);
      }
    }
    final deviceIdState = ref.read(deviceIdProvider.notifier);
    final baseModelState = ref.read(baseModelProvider.notifier);
    baseModelState.state = devices.map((final e) => e.baseModel).toList();
    _devices = devices;
    deviceIdState.state = devices.map((final e) => e.id).toList();
  }

  static Future reloadCurrentDevices() async {
    final s = ConnectionManager.hubConnection.invoke("GetAllDevices", args: []);

    final List<dynamic> serverDevices = await s;
    final devices = _instance.state;
    for (final device in devices) {
      final existingDevice = serverDevices.firstOrNull((final element) => element["id"] == device.id);
      if (existingDevice == null) continue;
      device.baseModel.updateFromJson(existingDevice);
    }
  }

  static void removeAllDevices() {
    for (int i = _instance.state.length - 1; i >= 0; i--) {
      final d = _instance.state.elementAt(i);
      PreferencesManager.instance.remove("SHD" + d.id.toString());
      PreferencesManager.instance.remove("Json" + d.id.toString());
      PreferencesManager.instance.remove("Type" + d.id.toString());
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
          if (PreferencesManager.instance.containsKey("SHD" + id.toString())) continue;
          PreferencesManager.instance.setInt("SHD" + id.toString(), id);
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
        PreferencesManager.instance.remove("SHD" + id.toString());
        PreferencesManager.instance.remove("Json" + id.toString());
        PreferencesManager.instance.remove("Type" + id.toString());
        PreferencesManager.instance.remove("Types" + id.toString());
      }
    }
  }

  void _clearDevicesCacheOnConnectionLost(final Ref providerRef) {
    final state = providerRef.watch(hubConnectionStateProvider);
    if (state != HubConnectionState.connected) {
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
