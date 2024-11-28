import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:signalr_core/signalr_core.dart';
// import 'package:signalr_core/signalr_core.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:logging/logging.dart';
import 'package:smarthome/devices/base_model.dart';
import 'package:smarthome/devices/generic/device_layout_service.dart';
import 'package:smarthome/helper/settings_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smarthome/restapi/swagger.swagger.dart' as sw;
import '../signalr/smarthome_protocol.dart';
import 'package:http/http.dart' as http;
import 'package:signalr_netcore/iretry_policy.dart';

part 'connection_manager.g.dart';

// final hubConnectionStateProvider = StateProvider<HubConnectionState?>((final ref) {
//   return null;
// });

final hubConnectionProvider =
    StateNotifierProvider<ConnectionManager, HubConnectionContainer>(
        (final ref) {
  ref.onDispose(() => _emptyHubConnection.stop());
  return ConnectionManager(ref, _emptyHubConnection);
});

// final hubConnectionProvider = Provider<HubConnection>((ref) {
//   final cont = ref.watch(hubConnectionContainerProvider);
//   return cont.connection ?? _emptyHubConnection;
// });

final hubConnectionConnectedProvider = Provider<HubConnection?>((final ref) {
  final hubConnection = ref.watch(hubConnectionProvider);

  // if (hubConnectionState == HubConnectionState.connected) return hubConnection;
  if (hubConnection.connectionState == HubConnectionState.Connected) {
    return hubConnection.connection;
  }
  return null;
});

final _emptyHubConnection =
    HubConnectionBuilder().withUrl("http://localhost:5056/SmartHome").build();

// final apiProvider = Provider<ApiService>((final ref) => ApiService());

// class ApiService {
//   Future<AppCloudConfiguration?> getSecurityConfig(
//       final String host, final int port) async {
//     try {
//       final uri =
//           Uri(scheme: "http", host: host, port: port, path: "/Security");
//       print(uri);
//       final response = await http.get(uri).timeout(const Duration(seconds: 10));
//       if (response.statusCode == 200) {
//         return AppCloudConfiguration.fromJson(jsonDecode(response.body));
//       }
//     } catch (ex) {}
//     return null;
//   }
// }

@immutable
class HubConnectionContainer {
  final HubConnection? connection;
  final HubConnectionState? connectionState;
  const HubConnectionContainer(this.connection, this.connectionState);
}

class ConnectionManager extends StateNotifier<HubConnectionContainer> {
  static ValueNotifier<IconData> connectionIconChanged =
      ValueNotifier(Icons.error_outline);

  Ref ref;

  ConnectionManager(this.ref, final HubConnection con)
      : super(HubConnectionContainer(con, con.state)) {
    startConnection();
  }
  Future<void> startConnection() async {
    if (state.connectionState == HubConnectionState.Connected)
      state.connection?.stop();
    final newConnectionState = createHubConnection();
    final connection = newConnectionState.connection;
    if (connection == null) return;
    connection.serverTimeoutInMilliseconds = 30000;

    void onReconnecting({final Exception? error}) {
      connectionIconChanged.value = Icons.error_outline;
      connection.off("Update");
      connection.off("UpdateUi");
      state = HubConnectionContainer(connection, connection.state);
      // _instance.state = _emptyHubConnection;
    }

    connection.onreconnecting(onReconnecting);

    connection.onreconnected(({final String? connectionId}) {
      connectionIconChanged.value = Icons.check;

      connection.on("Update", update);
      connection.on("UpdateUi",
          ref.read(deviceLayoutsProvider.notifier).updateFromServer);
      state = HubConnectionContainer(connection, connection.state);
    });
    connection.onclose(({final Exception? error}) async {
      final e = error;
      if (e == null) return;
      state = HubConnectionContainer(connection, connection.state);
      while (true) {
        if (newConnectionState.connectionState !=
            HubConnectionState.Connected) {
          connectionIconChanged.value = Icons.error_outline;

          try {
            connection.stop();
            final newConnection = createHubConnection();
            await newConnection.connection?.start();
            state = HubConnectionContainer(connection, connection.state);
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
    connection.on("Update", update);
    connection.on(
        "UpdateUi", ref.read(deviceLayoutsProvider.notifier).updateFromServer);
    final serverUrl = ref.watch(serverUrlProvider);
    if (serverUrl != "") {
      await connection.start();
      connectionIconChanged.value = Icons.check;
      state = HubConnectionContainer(connection, connection.state);
    }
  }

  Future newHubConnection() async {
    connectionIconChanged.value = Icons.refresh;

    state.connection?.off("Update");
    state.connection?.off("UpdateUi");
    state.connection?.stop();
    state = HubConnectionContainer(state.connection, state.connection?.state);

    final newState = createHubConnection();
    newState.connection?.on("Update", update);
    newState.connection?.on(
        "UpdateUi", ref.read(deviceLayoutsProvider.notifier).updateFromServer);

    await newState.connection?.start();
    connectionIconChanged.value = Icons.check;
    state =
        HubConnectionContainer(newState.connection, newState.connection?.state);
  }

  HubConnectionContainer createHubConnection() {
    Logger.root.level = Level.ALL;
// Writes the log messages to the console
    Logger.root.onRecord.listen((final LogRecord rec) {
      // print('${rec.level.name}: ${rec.time}: ${rec.message}');
    });
    final serverUrl = ref.watch(serverUrlProvider);
    return HubConnectionContainer(
        HubConnectionBuilder()
            .withUrl(serverUrl,
                options: HttpConnectionOptions(
                    logger: Logger("SignalR - transport"),
                    requestTimeout: 30000,
                    transport: HttpTransportType.WebSockets))
            .withHubProtocol(SmarthomeProtocol())
            .withAutomaticReconnect(
              reconnectPolicy: PermanentRetryPolicy(),
            )
            .build(),
        HubConnectionState.Disconnected);
  }

  Future update(final List<Object?>? arguments) async {
    final oldState = ref.read(baseModelsProvider).toList();

    bool hasChanges = false;
    for (final a in arguments!) {
      final updateMap = a as Map;
      for (var i = 0; i < oldState.length; i++) {
        final oldModel = oldState[i];
        if (oldModel.id != updateMap["id"]) continue;
        final newModel =
            oldModel.updateFromJson(updateMap as Map<String, dynamic>);
        if (oldState[i] == newModel) continue;
        oldState[i] = newModel;
        hasChanges = true;
        for (final element in updateMap.keys) {
          final now = DateTime.now();
          final from = DateTime.utc(now.year, now.month, now.day)
              .subtract(now.timeZoneOffset);
          //Circular dependency error
          // WidgetsBinding.instance.addPostFrameCallback((_) => ref.invalidate(
          //     historyPropertyNameProvider(Tuple4(
          //         newModel.id, from, from.add(Duration(days: 1)), element))));
        }
      }
    }
    if (hasChanges) ref.read(baseModelsProvider.notifier).storeModels(oldState);
  }
}

class PermanentRetryPolicy extends IRetryPolicy {
  static const List<int> retryTimes = [
    100,
    200,
    500,
    1000,
    2500,
    5000,
    7500,
    10000,
    15000,
    20000,
    25000,
    30000
  ];

  @override
  int? nextRetryDelayInMilliseconds(final RetryContext retryContext) {
    final retryCount = retryContext.previousRetryCount;
    if (retryCount >= retryTimes.length) return retryTimes.last;
    return retryTimes[retryCount];
  }
}

@Riverpod(keepAlive: true)
class Api extends _$Api {
  @override
  sw.Swagger build() {
    final serverUrl = ref.watch(serverUrlProvider);
    final parsed = Uri.parse(serverUrl);
    final uri =
        Uri(scheme: parsed.scheme, host: parsed.host, port: parsed.port);

    return sw.Swagger.create(baseUrl: uri);
  }
}
