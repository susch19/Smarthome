// ignore_for_file: unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:signalr_client/signalr_client.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/devices/painless_led_strip/led_strip_model.dart';
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

  static void init() {
    var names = PreferencesManager.instance.getStringList("customGroupNames");

    if (names != null) {
      for (var name in names) {
        var values = name.split('\u0001');
        groupNames[values[0]] = values[1];
      }
    }
  }

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

  static final ctorFactory = <String, Object Function(int? id, BaseModel model, HubConnection con)>{
    //'LedStripMesh': (i, s, h, sp) => LedStrip(i, s, h, Icon(Icons.lightbulb_outline), sp),
    'Heater': (i, s, h) => Heater(i, "Heizung", s as HeaterModel, h, Icons.whatshot),
    'XiaomiTempSensor': (i, s, h) =>
        XiaomiTempSensor(i, "Temperatursensor", s as TempSensorModel, h, SmarthomeIcons.xiaomiTempSensor),
    'LedStrip': (i, s, h) => LedStrip(i, "Ledstrip", s as LedStripModel, h, Icons.lightbulb_outline),
    'FloaltPanel': (i, s, h) => FloaltPanel(i, "Floalt Panel", s as FloaltPanelModel, h, Icons.crop_square),
    'OsramB40RW': (i, s, h) => OsramB40RW(i, "Osram B40", s as OsramB40RWModel, h, Icons.lightbulb_outline),
    'OsramPlug': (i, s, h) => OsramPlug(i, "Osram Plug", s as OsramPlugModel, h, Icons.radio_button_checked),
    'TradfriLedBulb': (i, s, h) =>
        TradfriLedBulb(i, "Tradfi RGB Bulb", s as TradfriLedBulbModel, h, Icons.lightbulb_outline),
    'TradfriControlOutlet': (i, s, h) => TradfriControlOutlet(
        i, "Tradfri Control Outlet", s as TradfriControlOutletModel, h, Icons.radio_button_checked),
    'TradfriMotionSensor': (i, s, h) =>
        TradfriMotionSensor(i, "Tradfri Motion Sensor", s as TradfriMotionSensorModel, h, Icons.sensors)
  };
  static final stringNameJsonFactory = <String, BaseModel Function(Map<String, dynamic>)>{
    // 'LedStripMesh': (m) => LedStripModel.fromJson(m),
    'Heater': (m) => HeaterModel.fromJson(m),
    'XiaomiTempSensor': (m) => TempSensorModel.fromJson(m),
    'LedStrip': (m) => LedStripModel.fromJson(m),
    'FloaltPanel': (m) => FloaltPanelModel.fromJson(m),
    'OsramB40RW': (m) => OsramB40RWModel.fromJson(m),
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
    FloaltPanelModel: (m) => FloaltPanelModel.fromJson(m),
    OsramB40RWModel: (m) => OsramB40RWModel.fromJson(m),
    OsramPlugModel: (m) => OsramPlugModel.fromJson(m),
    TradfriLedBulbModel: (m) => TradfriLedBulbModel.fromJson(m),
    TradfriControlOutletModel: (m) => TradfriControlOutletModel.fromJson(m),
    TradfriMotionSensorModel: (m) => TradfriMotionSensorModel.fromJson(m)
  };

  static void stopSubbing() {
    sub = false;
  }

  static void loadDevices(subs, List<int> ids, HubConnection hubConnection) {
    for (var id in ids) {
      var sub = subs.firstWhere((x) => x["id"] == id, orElse: () => null);
      var type = PreferencesManager.instance.getString("Type" + id.toString());
      BaseModel model =
          stringNameJsonFactory[type!]!(jsonDecode(PreferencesManager.instance.getString("Json" + id.toString())!));
      model.isConnected = false;

      model.friendlyName += "(old)";
      if (sub != null) {
        model = stringNameJsonFactory[type]!(sub);
        try {
          var dev = ctorFactory[type]!(id, model, hubConnection);
          devices.add(dev as Device<BaseModel>);
        } catch (e) {}
      } else {
        var dev = ctorFactory[type]!(id, model, hubConnection);
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
  TradfriMotionSensor
}

enum SortTypes { NameAsc, NameDesc, TypeAsc, TypeDesc, IdAsd, IdDesc }
