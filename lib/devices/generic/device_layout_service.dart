import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/helper/iterable_extensions.dart';

import 'generic_device_exporter.dart';

class DeviceLayoutService {
  static Map<String, DeviceLayout> typeDeviceLayouts = {};
  static Map<int, DeviceLayout> instanceDeviceLayouts = {};

  static void updateFromServer(List<Object?>? arguments) {
    arguments!.forEach((a) {
      var updateMap = a as Map<String, dynamic>;
      var deviceLayout = DeviceLayout.fromJson(updateMap);
      _updateFromServer(deviceLayout);
    });
    // for (var dev in DeviceManager.devices) {
    //   dev.baseModel.cacheLoaded = false;
    // }
  }

  static void _updateFromServer(DeviceLayout deviceLayout) {
    if (deviceLayout.ids != null) {
      for (var id in deviceLayout.ids!) {
        instanceDeviceLayouts[id] = deviceLayout;
        var dev = DeviceManager.devices.firstOrNull((element) => element.id == id);
        if (dev != null) dev.baseModel.updateUi();
      }
    }
    if (deviceLayout.typeName != null) {
      typeDeviceLayouts[deviceLayout.typeName!] = deviceLayout;
      for (var dev in DeviceManager.devices
          .where((element) => element.baseModel.typeNames.contains(deviceLayout.typeName))) dev.baseModel.updateUi();
    }
  }

  static DeviceLayout? getCachedDeviceLayout(int id, List<String> typeNames) {
    if (instanceDeviceLayouts.containsKey(id)) {
      return instanceDeviceLayouts[id];
    }
    if (typeNames.isNotEmpty) {
      for (var typeName in typeNames) {
        if (typeDeviceLayouts.containsKey(typeName)) {
          return typeDeviceLayouts[typeName];
        }
      }
    }
    return null;
  }

  static Future<DeviceLayout?> getDeviceLayout(int id, List<String> typeNames) async {
    var deviceLayout = getCachedDeviceLayout(id, typeNames);
    if (deviceLayout != null) {
      return deviceLayout;
    }

    var fromServer = await ConnectionManager.hubConnection.invoke("GetDeviceLayoutByDeviceId", args: [id]);
    if (fromServer == null && typeNames.isNotEmpty) {
      fromServer = await ConnectionManager.hubConnection.invoke("GetDeviceLayoutByName", args: [typeNames.first]);
      if (fromServer == null) return null;
    }
    deviceLayout = DeviceLayout.fromJson(fromServer as Map<String, dynamic>);
    _updateFromServer(deviceLayout);

    return deviceLayout;
  }
}
