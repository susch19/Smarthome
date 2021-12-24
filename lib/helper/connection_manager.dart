import 'dart:io';

import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/helper/preference_manager.dart';
import 'package:smarthome/helper/settings_manager.dart';
import 'package:smarthome/session/permanent_retry_policy.dart';

class ConnectionManager {
  static late HubConnection hubConnection;
  static ValueNotifier<IconData> connectionIconChanged = ValueNotifier(Icons.error_outline);

  static Future<void> startConnection() async {
    hubConnection = createHubConnection();
    hubConnection.serverTimeoutInMilliseconds = 30000;
    hubConnection.onclose((e) async {
      if (e == null) return;
      while (true) {
        if (hubConnection.state != HubConnectionState.connected) {
          connectionIconChanged.value = Icons.error_outline;

          DeviceManager.stopSubbing();
          try {
            hubConnection.stop();
            hubConnection = createHubConnection();
            await hubConnection.start();
          } catch (e) {}
          sleep(Duration(seconds: 1));
        } else {
          connectionIconChanged.value = Icons.check;
        }
        var dev = await DeviceManager.subscribeToDevice(DeviceManager.devices.map((x) => x.id).toList());
        for (var d in DeviceManager.devices) {
          if (!dev.any((x) => x["id"] == d.id)) DeviceManager.notSubscribedDevices.add(d);
        }
        DeviceManager.subToNonSubscribed(hubConnection);
        break;
      }
    });
    hubConnection.on("Update", DeviceManager.updateMethod);

    if (SettingsManager.serverUrl != "") {
      await hubConnection.start();
      connectionIconChanged.value = Icons.check;
      var ids = <int>[];
      for (var key in PreferencesManager.instance.getKeys().where((x) => x.startsWith("SHD"))) {
        var id = PreferencesManager.instance.getInt(key);
        if (id == null) continue;
        ids.add(id);
      }
      var subs = await DeviceManager.subscribeToDevice(ids);

      DeviceManager.loadDevices(subs, ids);
      DeviceManager.currentSort = SortTypes.values[PreferencesManager.instance.getInt("SortOrder") ?? 0];
      DeviceManager.sortDevices();
    }
  }

  static void newHubConnection() async {
    connectionIconChanged.value = Icons.refresh;

    hubConnection.off("Update");
    hubConnection.stop();
    hubConnection = createHubConnection();

    hubConnection.on("Update", DeviceManager.updateMethod);

    await hubConnection.start();
    connectionIconChanged.value = Icons.check;

    for (var device in DeviceManager.devices) {
      device.connection = hubConnection;
    }
    await DeviceManager.subscribeToDevice(DeviceManager.devices.map((x) => x.id).toList());
  }

  static HubConnection createHubConnection() {
    return HubConnectionBuilder()
        .withUrl(
            SettingsManager.serverUrl,
            HttpConnectionOptions(
                //accessTokenFactory: () async => await getAccessToken(PreferencesManager.instance),
                logging: (level, message) => print('$level: $message')))
        .withAutomaticReconnect(PermanentRetryPolicy())
        .build();
  }

}
