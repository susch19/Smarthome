// ignore_for_file: unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:signalr_client/signalr_client.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/devices/painless_led_strip/led_strip_model.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/helper/preference_manager.dart';

import '../icons/smarthome_icons.dart';
import 'device_exporter.dart';

class DeviceManager {
  static final devices = <Device>[];
  static SortTypes currentSort = SortTypes.NameAsc;
  static bool showDebugInformation = false;

  static final notSubscribedDevices = <Device>[];
  static bool sub = false;
  static Map<String, String> groupNames = Map<String, String>();
  static ValueNotifier<bool> deviceStateChanged = ValueNotifier(false);

  static void init() {
    var names = PreferencesManager.instance.getStringList("customGroupNames");

    if (names != null) {
      for (var name in names) {
        var values = name.split('\u0001');
        groupNames[values[0]] = values[1];
      }
    }
  }

  static void updateMethod(List<Object?>? arguments) {
    arguments!.forEach((a) {
      var updateMap = a as Map;
      if (updateMap["id"] == 0)
        DeviceManager.devices
            .where((x) => x.id == updateMap["id"])
            .forEach((x) => x.updateFromServer(updateMap as Map<String, dynamic>));
      else
        DeviceManager.getDeviceWithId(updateMap["id"]).updateFromServer(updateMap as Map<String, dynamic>);
    });
    deviceStateChanged.value = !deviceStateChanged.value;
  }

  static Future<dynamic> subscribeToDevice(List<int?> deviceIds) async =>
      await ConnectionManager.hubConnection.invoke("Subscribe", args: [deviceIds]);

  static void saveDeviceGroups() {
    var deviceGroups = devices.map((e) => e.id.toString() + "\u0002" + e.groups.join("\u0003")).join("\u0001");
    PreferencesManager.instance.setString("deviceGroups", deviceGroups);
  }

  static String getGroupName(String key) {
    var name = groupNames[key];
    return name ?? key;
  }

  static void changeGroupName(String key, String newName) {
    groupNames[key] = newName;

    var strs = groupNames.select((key, value) => key + "\u0001" + value);
    PreferencesManager.instance.setStringList("customGroupNames", strs);
  }

  static List<T> getDevicesOfType<T extends Device>() {
    return devices.whereType<T>().toList(); // where((x) => x.getDeviceType() == type).toList();
  }

  static Device getDeviceWithId(int? id) {
    return devices.firstWhere((x) => x.id == id);
  }

  static Future subToNonSubscribed(HubConnection? con) async {
    if (sub) return;
    sub = true;
    while (sub) {
      if (notSubscribedDevices.length == 0) {
        sub = false;
        continue;
      }
      var removeD = <Device>[];
      for (var dev in notSubscribedDevices.toList()) {
        var list = <int>[];
        list.add(dev.id ?? 0);
        var d = await con!.invoke("Subscribe", args: [list]);
        if (d != null) {
          if (dev.baseModel.friendlyName.endsWith("(NC)"))
            dev.baseModel.friendlyName = dev.baseModel.friendlyName.substring(0, dev.baseModel.friendlyName.length - 4);
          removeD.add(dev);
        } else {
          if (!dev.baseModel.friendlyName.endsWith("(NC)")) dev.baseModel.friendlyName += "(NC)";
        }
      }
      for (var d in removeD) {
        notSubscribedDevices.remove(d);
      }
      await Future.delayed(Duration(seconds: 10));
    }
  }

  static void sortDevices() {
    //currentSort .sort(sortDevices)
    switch (DeviceManager.currentSort) {
      case SortTypes.NameAsc:
        devices.sort((x, b) => x.baseModel.friendlyName.compareTo(b.baseModel.friendlyName));
        break;
      case SortTypes.NameDesc:
        devices.sort((x, b) => b.baseModel.friendlyName.compareTo(x.baseModel.friendlyName));
        break;
      case SortTypes.TypeAsc:
        devices.sort((x, b) => x.baseModel.runtimeType.toString().compareTo(b.runtimeType.toString()));
        break;
      case SortTypes.TypeDesc:
        devices.sort((x, b) => b.baseModel.runtimeType.toString().compareTo(x.runtimeType.toString()));
        break;
      case SortTypes.IdAsd:
        devices.sort((x, b) => x.baseModel.id.compareTo(b.baseModel.id));
        break;
      case SortTypes.IdDesc:
        devices.sort((x, b) => b.baseModel.id.compareTo(x.baseModel.id));
        break;
    }
    PreferencesManager.instance.setInt("SortOrder", DeviceManager.currentSort.index);
  }

  static final ctorFactory = <String, Object Function(int? id, BaseModel model)>{
    //'LedStripMesh': (i, s, h, sp) => LedStrip(i, s, h, Icon(Icons.lightbulb_outline), sp),
    'Heater': (i, s) => Heater(i, "Heizung", s as HeaterModel, ConnectionManager.hubConnection, Icons.whatshot),
    'XiaomiTempSensor': (i, s) => XiaomiTempSensor(
        i, "Temperatursensor", s as TempSensorModel, ConnectionManager.hubConnection, SmarthomeIcons.xiaomiTempSensor),
    'LedStrip': (i, s) =>
        LedStrip(i, "Ledstrip", s as LedStripModel, ConnectionManager.hubConnection, Icons.lightbulb_outline),
    'FloaltPanel': (i, s) =>
        FloaltPanel(i, "Floalt Panel", s as ZigbeeLampModel, ConnectionManager.hubConnection, Icons.crop_square),
    'OsramB40RW': (i, s) =>
        OsramB40RW(i, "Osram B40", s as ZigbeeLampModel, ConnectionManager.hubConnection, Icons.lightbulb_outline),
    'ZigbeeLamp': (i, s) =>
        ZigbeeLamp(i, "Osram B40", s as ZigbeeLampModel, ConnectionManager.hubConnection, Icons.lightbulb_outline),
    'OsramPlug': (i, s) =>
        OsramPlug(i, "Osram Plug", s as OsramPlugModel, ConnectionManager.hubConnection, Icons.radio_button_checked),
    'TradfriLedBulb': (i, s) => TradfriLedBulb(
        i, "Tradfi RGB Bulb", s as TradfriLedBulbModel, ConnectionManager.hubConnection, Icons.lightbulb_outline),
    'TradfriControlOutlet': (i, s) => TradfriControlOutlet(i, "Tradfri Control Outlet", s as TradfriControlOutletModel,
        ConnectionManager.hubConnection, Icons.radio_button_checked),
    'TradfriMotionSensor': (i, s) => TradfriMotionSensor(
        i, "Tradfri Motion Sensor", s as TradfriMotionSensorModel, ConnectionManager.hubConnection, Icons.sensors)
  };
  static final stringNameJsonFactory = <String, BaseModel Function(Map<String, dynamic>)>{
    // 'LedStripMesh': (m) => LedStripModel.fromJson(m),
    'Heater': (m) => HeaterModel.fromJson(m),
    'XiaomiTempSensor': (m) => TempSensorModel.fromJson(m),
    'LedStrip': (m) => LedStripModel.fromJson(m),
    'ZigbeeLamp': (m) => ZigbeeLampModel.fromJson(m),
    'FloaltPanel': (m) => ZigbeeLampModel.fromJson(m),
    'OsramB40RW': (m) => ZigbeeLampModel.fromJson(m),
    'OsramPlug': (m) => OsramPlugModel.fromJson(m),
    'TradfriLedBulb': (m) => TradfriLedBulbModel.fromJson(m),
    'TradfriControlOutlet': (m) => TradfriControlOutletModel.fromJson(m),
    'TradfriMotionSensor': (m) => TradfriMotionSensorModel.fromJson(m)
  };

  static final jsonFactory = <Type, BaseModel Function(Map<String, dynamic>)>{
    // 'LedStripMesh': (m) => LedStripModel.fromJson(m),
    HeaterModel: (m) => HeaterModel.fromJson(m),
    TempSensorModel: (m) => TempSensorModel.fromJson(m),
    LedStripModel: (m) => LedStripModel.fromJson(m),
    ZigbeeLampModel: (m) => ZigbeeLampModel.fromJson(m),
    OsramPlugModel: (m) => OsramPlugModel.fromJson(m),
    TradfriLedBulbModel: (m) => TradfriLedBulbModel.fromJson(m),
    TradfriControlOutletModel: (m) => TradfriControlOutletModel.fromJson(m),
    TradfriMotionSensorModel: (m) => TradfriMotionSensorModel.fromJson(m)
  };

  static void stopSubbing() {
    sub = false;
  }

  static void loadDevices(subs, List<int> ids) {
    var hubConnection = ConnectionManager.hubConnection;
    for (var id in ids) {
      var sub = subs.firstWhere((x) => x["id"] == id, orElse: () => null);
      var types = PreferencesManager.instance.getStringList("Types" + id.toString());
      BaseModel? model;
      var previousModel = jsonDecode(PreferencesManager.instance.getString("Json" + id.toString())!);
      String? type;
      if (types == null || types.length == 0) {
        type = PreferencesManager.instance.getString("Type" + id.toString());
        model = stringNameJsonFactory[type!]!(previousModel);
      } else {
        for (var item in types) {
          if (!stringNameJsonFactory.containsKey(item)) continue;
          model = stringNameJsonFactory[item]!(previousModel);
          type = item;
          break;
        }
      }

      model!.isConnected = false;

      model.friendlyName += "(old)";
      if (sub != null) {
        model = stringNameJsonFactory[type]!(sub);
        try {
          var dev = ctorFactory[type]!(id, model);
          devices.add(dev as Device<BaseModel>);
        } catch (e) {}
      } else {
        var dev = ctorFactory[type]!(id, model);
        devices.add(dev as Device<BaseModel>);
        notSubscribedDevices.add(dev);
        subToNonSubscribed(hubConnection);
      }
    }
    var deviceGroups = PreferencesManager.instance.getString("deviceGroups");

    if (deviceGroups == null) return;
    var devicesGroups = deviceGroups.split("\u0001");

    for (var item in devicesGroups) {
      var deviceGroup = item.split("\u0002");
      var deviceId = deviceGroup.first;
      var groups = deviceGroup.last.split("\u0003");
      var dev = devices.firstOrNull((element) => element.id.toString() == deviceId);
      if (dev != null) {
        dev.groups.clear();
        dev.groups.addAll(groups);
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
  ZigbeeLamp
}

enum SortTypes { NameAsc, NameDesc, TypeAsc, TypeDesc, IdAsd, IdDesc }
