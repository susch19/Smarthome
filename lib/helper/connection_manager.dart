import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
// import 'package:signalr_core/signalr_core.dart';
// import 'package:signalr_core/signalr_core.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:logging/logging.dart';
import 'package:smarthome/cloud/app_cloud_configuration.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/generic/device_layout_service.dart';
import 'package:smarthome/helper/preference_manager.dart';
import 'package:smarthome/helper/settings_manager.dart';
import 'package:smarthome/session/permanent_retry_policy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signalr_netcore/json_hub_protocol.dart';
import 'package:signalr_netcore/msgpack_hub_protocol.dart';
import '../signalr/smarthome_protocol.dart';
import 'package:http/http.dart' as http;

final hubConnectionStateProvider = Provider((final ref) {
  final hubConnection = ref.watch(hubConnectionProvider);
  return hubConnection.state;
});

final hubConnectionConnectedProvider = Provider<HubConnection?>((final ref) {
  final hubConnection = ref.watch(hubConnectionProvider);
  final hubConnectionState = ref.watch(hubConnectionStateProvider);
  ref.onDispose(() {
    hubConnection.stop();
  });
  // if (hubConnectionState == HubConnectionState.connected) return hubConnection;
  if (hubConnectionState == HubConnectionState.Connected) return hubConnection;
  return null;
});

final _emptyHubConnection = HubConnectionBuilder().withUrl("http://localhost:5056/SmartHome").build();

final hubConnectionProvider = StateNotifierProvider<ConnectionManager, HubConnection>((final ref) {
  ref.onDispose(() => _emptyHubConnection.stop());
  return ConnectionManager(ref, _emptyHubConnection);
});
final apiProvider = Provider<ApiService>((ref) => ApiService());

final cloudConfigProvider = FutureProvider<AppCloudConfiguration?>((final ref) async {
  final api = ref.watch(apiProvider);
  final urlString = ref.watch(serverUrlProvider);
  final url = Uri.parse(urlString);
  final res = await api.getSecurityConfig(url.host, url.port);
  if (res != null) {
    PreferencesManager.instance.setString("cloudConfig", jsonEncode(res));
    return res;
  } else {
    final cc = PreferencesManager.instance.getString("cloudConfig");
    if (cc != null && cc.isNotEmpty) {
      return AppCloudConfiguration.fromJson(jsonDecode(cc))..loadedFromPersistentStorage = true;
    }
  }
  return null;
});

class ApiService {
  Future<AppCloudConfiguration?> getSecurityConfig(final String host, final int port) async {
    try {
      final response =
          await http.get(Uri(scheme: "http", host: host, port: port, path: "/Security")).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        return AppCloudConfiguration.fromJson(jsonDecode(response.body));
      }
    } catch (ex) {}
    return null;
  }
}

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
    if (hubConnection.state == HubConnectionState.Connected) hubConnection.stop();
    final cloudConfig = await ref.watch(cloudConfigProvider.future);
    SmarthomeProtocol.cloudConfig = cloudConfig;
    hubConnection = createHubConnection(cloudConfig, ref: ref);
    hubConnection.serverTimeoutInMilliseconds = 30000;

    onReconnecting({final Exception? error}) {
      connectionIconChanged.value = Icons.error_outline;
      _instance.state = _emptyHubConnection;
    }

    hubConnection.onreconnecting(onReconnecting);

    hubConnection.onreconnected(({final String? connectionId}) {
      connectionIconChanged.value = Icons.check;
      _instance.state = hubConnection;
    });
    hubConnection.onclose(({final Exception? error}) async {
      final e = error;
      if (e == null) return;
      while (true) {
        if (hubConnection.state != HubConnectionState.Connected) {
          connectionIconChanged.value = Icons.error_outline;

          try {
            hubConnection.stop();
            hubConnection = createHubConnection(cloudConfig, ref: ref);
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
    hubConnection = createHubConnection(SmarthomeProtocol.cloudConfig, ref: ref, widgetRef: widgetRef);
    hubConnection.on("Update", DeviceManager.updateMethod);
    hubConnection.on("UpdateUi", DeviceLayoutService.updateFromServer);

    await hubConnection.start();
    _instance.state = hubConnection;
    connectionIconChanged.value = Icons.check;
  }

  static HubConnection createHubConnection(final AppCloudConfiguration? cloudConfig,
      {final Ref? ref, final WidgetRef? widgetRef}) {
    Logger.root.level = Level.ALL;
// Writes the log messages to the console
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
    });
    final serverUrl = ref?.watch(serverUrlProvider) ?? widgetRef?.watch(serverUrlProvider) ?? fallbackServerUrl;
    final serverUri = Uri.parse(serverUrl);
    return HubConnectionBuilder()
        .withUrl(
            cloudConfig?.loadedFromPersistentStorage ?? false
                ? Uri(
                        host: cloudConfig!.host,
                        port: cloudConfig.port,
                        pathSegments: [
                          ...serverUri.pathSegments,
                          ...(serverUri.pathSegments.any((element) => element == cloudConfig.id)
                              ? []
                              : [cloudConfig.id])
                        ],
                        scheme: "http")
                    .toString()
                : serverUrl,
            // HttpConnectionOptions(
            //accessTokenFactory: () async => await getAccessToken(PreferencesManager.instance),
            // logging: (final level, final message) => print('$level: $message')),
            options: HttpConnectionOptions(
                logger: Logger("SignalR - transport"), requestTimeout: 30000, transport: HttpTransportType.WebSockets))
        .configureLogging(Logger("SignalR - hub"))
        .withHubProtocol(JsonHubProtocol())
        // .withHubProtocol(SmarthomeProtocol())

        // .withHubProtocol(MessagePackHubProtocol())
        // .withAutomaticReconnect(PermanentRetryPolicy())
        .withAutomaticReconnect(
            retryDelays: [0, 100, 200, 500, 1000, 2500, 5000, 7500, 10000, 15000, 20000, 25000, 30000]).build();
  }
}
