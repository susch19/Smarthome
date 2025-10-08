import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/helper/mdns_manager.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/models/server_record.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final _currentAppVersionProvider =
    FutureProvider<PackageInfo>((final ref) async {
  return await PackageInfo.fromPlatform();
});

final serverRecordsProvider =
    FutureProvider.autoDispose<List<ServerRecord>>((final ref) async {
  final records = ServerSearchScreen.refresh(force: true);
  return records;
});

final _chosenValueProvider =
    StateProvider.family<String, String>((final ref, final value) {
  return "";
});

class ServerSearchScreen extends ConsumerWidget {
  const ServerSearchScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Serversuche"),
      ),
      body: buildBody(context, ref),
    );
  }

  Widget buildBody(final BuildContext context, final WidgetRef ref) {
    final serverRecordsFinal = ref.watch(serverRecordsProvider);
    final appVersion = ref.watch(_currentAppVersionProvider);
    return RefreshIndicator(
      child: Container(
        decoration: ThemeManager.getBackgroundDecoration(context),
        child: ListView(
          children: serverRecordsFinal.when(
              data: (final data) => data
                  .map((final e) => mapServerValue(e, context, appVersion))
                  .toList()
                  .injectForIndex((final i) => i < 1 ? null : const Divider())
                  .toList(),
              error: (final _, final __) => [const SizedBox()],
              loading: () => [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: const SizedBox(
                            width: 40.0,
                            height: 40.0,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      ],
                    )
                  ]),
        ),
      ),
      onRefresh: () async => ref.refresh(serverRecordsProvider),
    );
  }

  Widget mapServerValue(final ServerRecord e, final BuildContext context,
      final AsyncValue<PackageInfo> appVersion) {
    final menuItems = e.reachableAddresses
        .map((final a) => DropdownMenuItem(
              value: a.ipAddress,
              child: Text(a.ipAddress.toString()),
            ))
        .toList();
    if (menuItems.isEmpty) return const SizedBox();

    return ListTile(
      title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Text(
              e.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            appVersion.when(
                data: (final data) =>
                    Icon(e.minAppVersion < data ? Icons.check : Icons.warning),
                error: (final error, final stackTrace) =>
                    Text(error.toString()),
                loading: () => const Text("Loading...")),
          ],
        ),
        Row(
          children: [
            const Text("Adresse (optional): "),
            Consumer(
              builder: (final context, final ref, final child) {
                final value = ref.watch(_chosenValueProvider(e.fqdn));

                return DropdownButton(
                  value:
                      value == "" ? e.reachableAddresses[0].ipAddress : value,
                  items: menuItems,
                  onChanged: (final value) {
                    if (value is! String) return;
                    ref.read(_chosenValueProvider(e.fqdn).notifier).state =
                        value;
                  },
                );
              },
            )
          ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: e.debug
              ? const Text("❗ Testserver, betreten auf eigene Gefahr")
              : const SizedBox(),
        ),
        Consumer(
          builder: (final context, final ref, final child) {
            return ElevatedButton(
              onPressed: () {
                final value = ref.read(_chosenValueProvider(e.fqdn));
                Navigator.pop(
                    context,
                    e.reachableAddresses.firstWhere(
                      (final element) => element.ipAddress == value,
                      orElse: () => e.reachableAddresses.first,
                    ));
              },
              child: const Text("Verbinden"),
            );
          },
        )
      ]),
    );
  }

  static Future<List<ServerRecord>> refresh({final bool force = false}) async {
    final List<ServerRecord> records = [];
    if (!MdnsManager.initialized) await MdnsManager.initialize();

    await for (final record in MdnsManager.getRecords(
        timeToLive: force
            ? const Duration(milliseconds: 1)
            : const Duration(minutes: 5))) {
      records.add(record);
    }
    return records;
  }
}
