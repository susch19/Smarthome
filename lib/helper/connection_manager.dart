import 'dart:io';

import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/generic/device_layout_service.dart';
import 'package:smarthome/helper/preference_manager.dart';
import 'package:smarthome/helper/settings_manager.dart';
import 'package:smarthome/session/permanent_retry_policy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hubConnectionStateProvider = Provider((final ref) {
  final hubConnection = ref.watch(hubConnectionProvider);
  return hubConnection.state;
});

final hubConnectionConnectedProvider = Provider<HubConnection?>((final ref) {
  final hubConnection = ref.watch(hubConnectionProvider);
  final hubConnectionState = ref.watch(hubConnectionStateProvider);

  if (hubConnectionState == HubConnectionState.connected) return hubConnection;
  return null;
});

final _emptyHubConnection = HubConnectionBuilder().withUrl("http://localhost:5056/SmartHome").build();

final hubConnectionProvider =
    StateNotifierProvider<ConnectionManager, HubConnection>((final ref) => ConnectionManager(ref, _emptyHubConnection));

class ConnectionManager extends StateNotifier<HubConnection> {
  static ValueNotifier<IconData> connectionIconChanged = ValueNotifier(Icons.error_outline);
  static late HubConnection hubConnection;

  static late ConnectionManager _instance;

  ConnectionManager(final Ref ref, final HubConnection state) : super(state) {
    hubConnection = state;
    _instance = this;
    ConnectionManager.startConnection(ref);
  }

  static Future<void> startConnection(final Ref ref) async {
    hubConnection = createHubConnection(ref: ref);
    hubConnection.serverTimeoutInMilliseconds = 30000;
    hubConnection.onreconnecting((final exception) {
      connectionIconChanged.value = Icons.error_outline;
      _instance.state = _emptyHubConnection;
    });
    hubConnection.onreconnected((final exception) {
      connectionIconChanged.value = Icons.check;
      _instance.state = hubConnection;
    });
    hubConnection.onclose((final e) async {
      if (e == null) return;
      while (true) {
        if (hubConnection.state != HubConnectionState.connected) {
          connectionIconChanged.value = Icons.error_outline;

          DeviceManager.stopSubbing();
          try {
            hubConnection.stop();
            hubConnection = createHubConnection(ref: ref);
            await hubConnection.start();
          } catch (e) {}
          sleep(const Duration(seconds: 1));
        } else {
          connectionIconChanged.value = Icons.check;
        }
        // var currentDevices = _ref.read(deviceProvider);

        // var dev = await DeviceManager.subscribeToDevice((currentDevices).map((x) => x.id).toList());
        // for (var d in currentDevices) {
        //   if (!dev.any((x) => x["id"] == d.id)) DeviceManager.notSubscribedDevices.add(d);
        // }
        // DeviceManager.subToNonSubscribed(_instance.state);
        break;
      }
    });
    hubConnection.on("Update", DeviceManager.updateMethod);
    hubConnection.on("UpdateUi", DeviceLayoutService.updateFromServer);
    final serverUrl = ref.read(serverUrlProvider);
    if (serverUrl != "") {
      await hubConnection.start();
      _instance.state = hubConnection;
      connectionIconChanged.value = Icons.check;
      final ids = <int>[];
      for (final key in PreferencesManager.instance.getKeys().where((final x) => x.startsWith("SHD"))) {
        final id = PreferencesManager.instance.getInt(key);
        if (id == null) continue;
        ids.add(id);
      }
      DeviceManager.subscribeToDevices(ids);
    }
  }

  static Future newHubConnection({final Ref? ref, final WidgetRef? widgetRef}) async {
    connectionIconChanged.value = Icons.refresh;

    hubConnection = _instance.state;
    hubConnection.off("Update");
    hubConnection.off("UpdateUi");
    hubConnection.stop();
    _instance.state = _emptyHubConnection;
    hubConnection = createHubConnection(ref: ref, widgetRef: widgetRef);
    hubConnection.on("Update", DeviceManager.updateMethod);
    hubConnection.on("UpdateUi", DeviceLayoutService.updateFromServer);

    await hubConnection.start();
    _instance.state = hubConnection;
    connectionIconChanged.value = Icons.check;

    // var devices = _ref.read(deviceProvider);

    // for (var device in devices) {
    //   device.connection = _instance.state;
    // }
    // await DeviceManager.subscribeToDevice(devices.map((x) => x.id).toList());
  }

  static HubConnection createHubConnection({final Ref? ref, final WidgetRef? widgetRef}) {
    final serverUrl = ref?.watch(serverUrlProvider) ?? widgetRef?.watch(serverUrlProvider);
    return HubConnectionBuilder()
        .withUrl(
            serverUrl ?? fallbackServerUrl,
            HttpConnectionOptions(
                //accessTokenFactory: () async => await getAccessToken(PreferencesManager.instance),
                logging: (final level, final message) => print('$level: $message')))
        .withAutomaticReconnect(PermanentRetryPolicy())
        .build();
  }
}
