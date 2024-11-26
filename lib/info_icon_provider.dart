import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:smarthome/helper/connection_manager.dart';

class InfoIconProvider extends StateNotifier<IconData>
    with WidgetsBindingObserver {
  final Ref ref;
  InfoIconProvider(this.ref) : super(Icons.refresh) {
    final connection = ref.watch(hubConnectionProvider);

    // if (connection == HubConnectionState.disconnected) {
    if (connection.connectionState == HubConnectionState.Disconnected) {
      state = Icons.warning;
      // } else if (connection == HubConnectionState.connected) {
    } else if (connection.connectionState == HubConnectionState.Connected) {
      state = Icons.check;
    }

    WidgetsBinding.instance.addObserver(this);
    ConnectionManager.connectionIconChanged.addListener(() {
      if (!mounted) return;
      state = ConnectionManager.connectionIconChanged.value;
    });
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (kIsWeb ||
        !(defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      return;
    }

    if (state == AppLifecycleState.resumed) {
      // ref.read(hubConnectionProvider.notifier).newHubConnection();
    } else if (state == AppLifecycleState.paused) {
      this.state = Icons.error_outline;
      final connection = ref.watch(hubConnectionProvider);
      // if (connectionState == HubConnectionState.connected) ConnectionManager.hubConnection.stop();
      connection.connection?.stop();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
