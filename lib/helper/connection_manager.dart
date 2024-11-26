import 'dart:io';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:signalr_core/signalr_core.dart';
// import 'package:signalr_core/signalr_core.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:logging/logging.dart';
import 'package:smarthome/devices/base_model.dart';
import 'package:smarthome/devices/device.dart';
import 'package:smarthome/devices/generic/device_layout_service.dart';
import 'package:smarthome/devices/generic/stores/store_service.dart';
import 'package:smarthome/helper/settings_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smarthome/restapi/swagger.swagger.dart' as sw;
import 'package:signalr_netcore/iretry_policy.dart';

part 'connection_manager.g.dart';

// final hubConnectionStateProvider = StateProvider<HubConnectionState?>((final ref) {
//   return null;
// });

// final hubConnectionProvider = Provider<HubConnection>((ref) {
//   final cont = ref.watch(hubConnectionContainerProvider);
//   return cont.connection ?? _emptyHubConnection;
// });

final hubConnectionConnectedProvider = Provider<HubConnection?>((final ref) {
  final val = ref.watch(connectionManagerProvider);
  final hubConnection = val.valueOrNull;
  if (hubConnection == null) return null;
  // if (hubConnectionState == HubConnectionState.connected) return hubConnection;
  if (hubConnection.connectionState == HubConnectionState.Connected) {
    return hubConnection.connection;
  }
  return null;
});

// final _emptyHubConnection =
//     HubConnectionBuilder().withUrl("http://localhost:5056/SmartHome").build();

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

@Riverpod(keepAlive: true)
int _dummyApiRefresh(final Ref ref) =>
    DateTime.timestamp().millisecondsSinceEpoch;

@Riverpod(keepAlive: true)
class ConnectionManager extends _$ConnectionManager {
  static ValueNotifier<IconData> connectionIconChanged =
      ValueNotifier(Icons.error_outline);

  @override
  FutureOr<HubConnectionContainer> build() async {
    final serverUrl = ref.watch(serverUrlProvider);
    final newConnectionState = createHubConnection(serverUrl);
    final connection = newConnectionState.connection;
    if (connection == null) return HubConnectionContainer(connection, null);
    ref.onDispose(() {
      connection.off("Update");
      connection.off("UpdateUi");
    });
    connection.serverTimeoutInMilliseconds = 30000;

    connection.onreconnecting(onReconnecting);

    connection.onreconnected(({final String? connectionId}) {
      connectionIconChanged.value = Icons.check;

      connection.on("Update", _updateState);
      connection.on(
          "UpdateUi", ref.read(layoutIconsProvider.notifier).updateFromServer);
      ref.invalidate(_dummyApiRefreshProvider);
      state = AsyncData(HubConnectionContainer(connection, connection.state));
    });
    connection.onclose(({final Exception? error}) async {
      final e = error;
      if (e == null) return;
      state = AsyncData(HubConnectionContainer(connection, connection.state));
      while (true) {
        if (newConnectionState.connectionState !=
            HubConnectionState.Connected) {
          connectionIconChanged.value = Icons.error_outline;

          try {
            connection.stop();
            final newConnection =
                createHubConnection(ref.read(serverUrlProvider));
            await newConnection.connection?.start();
            state =
                AsyncData(HubConnectionContainer(connection, connection.state));
          } catch (e) {}
          sleep(const Duration(seconds: 1));
        } else {
          connectionIconChanged.value = Icons.check;
        }
        // var currentDevices = _ref.read(deviceManagerProvider);

        // var dev = await DeviceManager.subscribeToDevice((currentDevices).map((x) => x.id).toList());
        // for (var d in currentDevices) {
        //   if (!dev.any((x) => x["id"] == d.id)) DeviceManager.notSubscribedDevices.add(d);
        // }
        // DeviceManager.subToNonSubscribed(_instance.state);
        break;
      }
    });
    connection.on("Update", _updateState);
    connection.on(
        "UpdateUi", ref.read(layoutIconsProvider.notifier).updateFromServer);
    if (serverUrl != "") {
      await connection.start();
      ref.invalidate(_dummyApiRefreshProvider);
      connectionIconChanged.value = Icons.check;
    }
    return HubConnectionContainer(connection, connection.state);
  }

  void onReconnecting({final Exception? error}) {
    connectionIconChanged.value = Icons.error_outline;
    final connection = state.valueOrNull?.connection;
    if (connection == null) return;
    connection.off("Update");
    connection.off("UpdateUi");
    state = AsyncData(HubConnectionContainer(connection, connection.state));
    // _instance.state = _emptyHubConnection;
  }

  Future newHubConnection() async {
    connectionIconChanged.value = Icons.refresh;
    final current = state.valueOrNull;
    if (current != null) {
      current.connection?.off("Update");
      current.connection?.off("UpdateUi");
      current.connection?.stop();
    }
    final serverUrl = ref.read(serverUrlProvider);

    final newState = createHubConnection(serverUrl);
    newState.connection?.on("Update", _updateState);
    newState.connection?.on(
        "UpdateUi", ref.read(layoutIconsProvider.notifier).updateFromServer);

    await newState.connection?.start();
    connectionIconChanged.value = Icons.check;
    state = AsyncData(HubConnectionContainer(
        newState.connection, newState.connection?.state));
  }

  HubConnectionContainer createHubConnection(final String serverUrl) {
    Logger.root.level = Level.ALL;
// Writes the log messages to the console
    Logger.root.onRecord.listen((final LogRecord rec) {
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
    });
    return HubConnectionContainer(
        HubConnectionBuilder()
            .withUrl(serverUrl,
                options: HttpConnectionOptions(
                    logger: Logger("SignalR - transport"),
                    requestTimeout: 30000,
                    transport: HttpTransportType.WebSockets))
            // .withHubProtocol(SmarthomeProtocol())
            .withAutomaticReconnect(
              reconnectPolicy: PermanentRetryPolicy(),
            )
            .build(),
        HubConnectionState.Disconnected);
  }

  Future _updateState(final List<Object?>? arguments) async {
    final oldState = ref.read(baseModelsProvider).toList();

    bool hasChanges = false;
    for (final a in arguments!) {
      final updateMap = a as Map;
      for (var i = 0; i < oldState.length; i++) {
        final oldModel = oldState[i];
        if (oldModel.id != updateMap["id"]) continue;
        final typesUntypes = updateMap["typeNames"] as List? ?? [];
        final types = typesUntypes.map((final x) => x.toString()).toList();
        ref
            .read(stateServiceProvider.notifier)
            .updateAndGetStores(oldModel.id, updateMap as Map<String, dynamic>);

        final newModel =
            oldModel.mergeWith(BaseModel.fromJson(updateMap, types));
        if (oldState[i] != newModel) {
          oldState[i] = newModel;
          hasChanges = true;
        }
        for (final element in updateMap.keys) {
          final now = DateTime.now();
          final from = DateTime.utc(now.year, now.month, now.day)
              .subtract(now.timeZoneOffset);
          if (ref.exists(historyPropertyNameProvider(
              newModel.id, from, from.add(Duration(days: 1)), element))) {
            ref.invalidate(historyPropertyNameProvider(
                newModel.id, from, from.add(Duration(days: 1)), element));
          }
        }
      }
    }
    if (hasChanges) {
      ref.read(baseModelsProvider.notifier).storeModels(oldState);
    }
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
    ref.watch(_dummyApiRefreshProvider);
    final serverUrl = ref.watch(serverUrlProvider);
    final parsed = Uri.parse(serverUrl);
    final uri =
        Uri(scheme: parsed.scheme, host: parsed.host, port: parsed.port);

    return sw.Swagger.create(baseUrl: uri);
  }
}
