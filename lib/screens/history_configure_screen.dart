import 'package:flutter/material.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _serverDevices = FutureProvider<List<dynamic>>((final ref) async {
  final connection = ref.watch(hubConnectionConnectedProvider);
  if (connection == null) return [];

  final serverDevices = await connection.invoke("GetAllDevices", args: []);

  if (serverDevices is! List<dynamic>) return [];
  serverDevices.sort((final a, final b) => (a["typeName"] as String).compareTo(b["typeName"] as String));
  return serverDevices;
});

final _historyProperties = FutureProvider<List<dynamic>>((final ref) async {
  final connection = ref.watch(hubConnectionConnectedProvider);
  if (connection == null) return [];

  final serverDevices = await connection.invoke("GetHistoryPropertySettings", args: []);

  if (serverDevices is! List<dynamic>) return [];
  return serverDevices;
});

final _overwrittenStates = StateProvider.family<Map<String, bool>, int>(((final ref, final _) => {}));
final _overwrittenStatesGrouped = StateProvider.family<Map<String, bool>, String>(((final ref, final _) => {}));

final _serverHistoryProperties = FutureProvider<List<Map<String, dynamic>>>((final ref) async {
  final serverDevices = (await ref.watch(_serverDevices.future));
  final serverProps = (await ref.watch(_historyProperties.future));
  return serverDevices
      .cast<Map<String, dynamic>>()
      .map((final i) => i.entries
              .where((final element) =>
                  element.key != "typeNames" &&
                  element.key != "lastReceivedFormatted" &&
                  element.key != "link_Quality" &&
                  element.key != "sendPayload" &&
                  element.key != "transition_Time")
              .toMap((final element) => element.key, (final element) {
            if (element.key == "id" || element.key == "typeName" || element.key == "friendlyName") {
              return element.value;
            }
            final prop =
                serverProps.firstOrNull((final d) => d["deviceId"] == i["id"] && d["propertyName"] == element.key);
            if (prop == null) return false;
            return prop["enabled"] as bool;
          }))
      .toList();
});

class HistoryConfigureScreen extends ConsumerWidget {
  final String title;
  final bool byDeviceType;
  const HistoryConfigureScreen(this.title, this.byDeviceType, {final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: buildBody(context, ref),
    );
  }

  Widget buildBody(final BuildContext context, final WidgetRef ref) {
    final devices = ref.watch(_serverHistoryProperties);
    final connection = ref.watch(hubConnectionConnectedProvider);
    return RefreshIndicator(
      child: Container(
        decoration: ThemeManager.getBackgroundDecoration(context),
        child: ListView(
            children: devices.when(
                data: (final d) {
                  if (byDeviceType) {
                    return d
                        .groupBy((final p0) => p0["typeName"] as String)
                        .map((final key, final values) {
                          final ids = values.map((final e) => e["id"] as int).toList(growable: true);
                          final props = values
                              .mapMany((final e) => e.keys.where((final element) =>
                                  element != "id" && element != "typeName" && element != "friendlyName"))
                              .distinct()
                              .toList();
                          final exp = ExpansionTile(
                            title: Text(key),
                            children: props
                                .map((final e) => Consumer(
                                      builder: (final context, final ref, final child) {
                                        final overwrite = ref.watch(_overwrittenStatesGrouped(key));
                                        final val = values.all(
                                            (final element) => !element.containsKey(e) || element[e] as bool == true);
                                        return ListTile(
                                          title: Text(e),
                                          trailing: Checkbox(
                                            value: overwrite.containsKey(e) ? overwrite[e] : val,
                                            onChanged: (final v) {
                                              if (v == null || connection == null) return;
                                              connection.invoke("SetHistories", args: [v, ids, e]);
                                              final stateNotifier = ref.read(_overwrittenStatesGrouped(key).notifier);
                                              final newState = stateNotifier.state.entries.toMap(
                                                  (final element) => element.key, (final element) => element.value);
                                              newState[e] = v;
                                              stateNotifier.state = newState;
                                            },
                                          ),
                                        );
                                      },
                                    ))
                                .toList(),
                          );
                          return MapEntry(key, exp);
                        })
                        .values
                        .toList();
                  }

                  return d.map((final e) {
                    final id = e["id"] as int;
                    return ExpansionTile(
                      leading: Text("${e["typeName"]}"),
                      title: Text("$id : ${e["friendlyName"]}"),
                      children: e.entries
                          .where((final element) =>
                              element.key != "id" && element.key != "typeName" && element.key != "friendlyName")
                          .map((final e) => Consumer(
                                builder: (final context, final ref, final child) {
                                  final overwrite = ref.watch(_overwrittenStates(id));
                                  return ListTile(
                                    title: Text(e.key),
                                    trailing: Checkbox(
                                      value: overwrite.containsKey(e.key) ? overwrite[e.key] : e.value,
                                      onChanged: (final v) {
                                        if (v == null || connection == null) return;
                                        connection.invoke("SetHistory", args: [v, id, e.key]);
                                        final stateNotifier = ref.read(_overwrittenStates(id).notifier);
                                        final newState = stateNotifier.state.entries
                                            .toMap((final element) => element.key, (final element) => element.value);
                                        newState[e.key] = v;
                                        stateNotifier.state = newState;
                                      },
                                    ),
                                  );
                                },
                              ))
                          .toList(),
                    );
                  }).toList();
                },
                error: (final o, final s) => [const Text("Daten konnten nicht vom Server angefragt werden:\r\n")],
                loading: () => [const Text("Loading...")])),
      ),
      onRefresh: () async {
        ref.invalidate(_serverDevices);
        ref.invalidate(_historyProperties);
      },
    );
  }
}
