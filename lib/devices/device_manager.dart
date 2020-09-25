import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:signalr_client/signalr_client.dart';
import 'package:signalr_core/signalr_core.dart';

import '../icons/smarthome_icons.dart';
import 'device_exporter.dart';


class DeviceManager {
  static final devices = List<Device>();
  static SortTypes currentSort = SortTypes.NameAsc;
  static bool showDebugInformation = false;

  static final notSubscribedDevices = List<Device>();
  static bool sub = false;

  static List<T> getDevicesOfType<T extends Device>() {
    return devices.whereType<T>().toList(); // where((x) => x.getDeviceType() == type).toList();
  }

  static Device getDeviceWithId(int id) {
    return devices.firstWhere((x) => x.id == id, orElse: () {});
  }

  static Future subToNonSubscribed(HubConnection con) async {
    if (sub) return;
    sub = true;
    while (sub) {
      if (notSubscribedDevices.length == 0) {
        sub = false;
        continue;
      }
      var removeD = List<Device>();
      for (var dev in notSubscribedDevices.toList()) {
        var list = List<int>(1);
        list[0] = (dev?.id ?? 0);
        var d = await con.invoke("Subscribe", args: [list]);
        if (d != null){
          if (dev.baseModel.friendlyName.endsWith("(NC)")) dev.baseModel.friendlyName = dev.baseModel.friendlyName.substring(0, dev.baseModel.friendlyName.length-4);
          removeD.add(dev);
        }
        else {
          if (!dev.baseModel.friendlyName.endsWith("(NC)")) dev.baseModel.friendlyName += "(NC)";
        }
      }
      for (var d in removeD) {
        notSubscribedDevices.remove(d);
      }
      await Future.delayed(Duration(seconds: 10));
    }
  }

  static void sortDevices(SharedPreferences prefs) {
    //currentSort .sort(sortDevices)
    switch(DeviceManager.currentSort){
    
      case SortTypes.NameAsc:
    devices.sort((x,b)=>x.baseModel.friendlyName.compareTo(b.baseModel.friendlyName));
        break;
      case SortTypes.NameDesc:
    devices.sort((x,b)=>b.baseModel.friendlyName.compareTo(x.baseModel.friendlyName));
        break;
      case SortTypes.TypeAsc:
    devices.sort((x,b)=>x.baseModel.runtimeType.toString().compareTo(b.runtimeType.toString()));
        break;
      case SortTypes.TypeDesc:
    devices.sort((x,b)=>b.baseModel.runtimeType.toString().compareTo(x.runtimeType.toString()));
        break;
      case SortTypes.IdAsd:
    devices.sort((x,b)=>x.baseModel.id.compareTo(b.baseModel.id));
        break;
      case SortTypes.IdDesc:
    devices.sort((x,b)=>b.baseModel.id.compareTo(x.baseModel.id));
        break;
    }
    prefs?.setInt("SortOrder", DeviceManager.currentSort.index);
  }

  static final ctorFactory =
      <String, Object Function(int id, BaseModel model, HubConnection con, SharedPreferences sp)>{
    //'LedStripMesh': (i, s, h, sp) => LedStrip(i, s, h, Icon(Icons.lightbulb_outline), sp),
    'Heater': (i, s, h, sp) => Heater(i, s as HeaterModel, h, Icon(Icons.whatshot), sp),
    'XiaomiTempSensor': (i, s, h, sp) => XiaomiTempSensor(i, s, h, Icon(SmarthomeIcons.xiaomiTempSensor), sp),
    'LedStrip': (i,s,h,sp) => LedStrip(i, s, h, Icon(Icons.lightbulb_outline), sp),
    'FloaltPanel': (i,s,h,sp) => FloaltPanel(i, s, h, Icon(Icons.crop_square), sp),
    'OsramB40RW': (i,s,h,sp) => OsramB40RW(i, s, h, Icon(Icons.lightbulb_outline), sp),
  };
  static final jsonFactory = <String, BaseModel Function(Map<String, dynamic>)>{
    //'LedStripMesh': (m) => BaseModel.fromJson(m),
    'Heater': (m) => HeaterModel.fromJson(m) as BaseModel,
    'XiaomiTempSensor': (m) => TempSensorModel.fromJson(m) as BaseModel,
    'LedStrip': (m) => BaseModel.fromJson(m),
    'FloaltPanel': (m)=> FloaltPanelModel.fromJson(m) as BaseModel,
    'OsramB40RW': (m)=> OsramB40RWModel.fromJson(m) as BaseModel,
  };

  static void stopSubbing() {
    sub = false;
  }
}

enum DeviceTypes { Heater, XiaomiTempSensor, LedStrip, FloaltPanel, OsramB40RW}

enum SortTypes { NameAsc, NameDesc, TypeAsc, TypeDesc, IdAsd, IdDesc}