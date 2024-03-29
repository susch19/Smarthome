import 'dart:io';
import 'dart:ui';

// import 'package:file_picker/file_picker.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:signalr_client/signalr_client.dart';
// import 'package:signalr_core/signalr_core.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:smarthome/dashboard/group_devices.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'dart:async';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/device_overview_model.dart';
import 'package:smarthome/devices/generic/device_layout_service.dart';
import 'package:smarthome/devices/generic/stores/store_service.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/helper/preference_manager.dart';
import 'package:smarthome/helper/settings_manager.dart';
import 'package:smarthome/helper/simple_dialog_single_input.dart';
import 'package:flutter/foundation.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/helper/update_manager.dart';
import 'package:smarthome/screens/screen_export.dart';
import 'package:smarthome/screens/settings_page.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuple/tuple.dart';

import 'controls/expandable_fab.dart';
import 'helper/connection_manager.dart';

part 'main.g.dart';

//Implement https://developer.android.com/develop/ui/views/device-control as a seperate build
//Because having support for android kitkat is still wanted

final _brightnessChangeProvider =
    ChangeNotifierProvider.family<AdaptiveThemeModeWatcher, AdaptiveThemeManager>((final ref, final b) {
  return AdaptiveThemeModeWatcher(b);
});

final _addItemSelectorProvider = StateProvider.family<bool, int>((final ref, final arg) => false);

@riverpod
Brightness brightness(final BrightnessRef ref, final AdaptiveThemeManager b) {
  final brightness = ref.watch(_brightnessChangeProvider(b)).brightness;
  return brightness;
}

final _searchProvider = StateProvider<String>(((final ref) => ""));

final searchTextProvider = StateProvider<String>(((final ref) {
  final enabled = ref.watch(searchEnabledProvider);
  final text = ref.watch(_searchProvider);
  if (!enabled) return "";
  return text;
}));
final searchEnabledProvider = StateProvider<bool>(((final ref) => false));

@riverpod
Widget getTitleWidget(final GetTitleWidgetRef ref) {
  final enabled = ref.watch(searchEnabledProvider);

  if (!enabled) return const Text("Smart Home App");

  return TextField(
      decoration: const InputDecoration(hintText: "Suche"),
      // onSubmitted: (x) => _searchProducts(x, 1),
      autofocus: true,
      onChanged: (final s) => ref.watch(searchTextProvider.notifier).state = s);
}

@riverpod
List<Device> filteredDevices(final FilteredDevicesRef ref) {
  final searchText = ref.watch(searchTextProvider).toLowerCase();

  final devices = ref.watch(sortedDeviceProvider);
  if (searchText.isEmpty) return devices;

  return devices
      .where((final element) =>
          element.typeName.toLowerCase().contains(searchText) ||
          (ref.read(element.baseModelTProvider(element.id))?.friendlyName.toLowerCase().contains(searchText) ?? false))
      .toList();
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
      };
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  // prefs.clear();

  PreferencesManager.instance = PreferencesManager(prefs);

  final savedThemeMode = await AdaptiveTheme.getThemeMode() ?? AdaptiveThemeMode.system;
  DeviceManager.init();
  Intl.defaultLocale = "de-DE";
  initializeDateFormatting("de-DE").then((final _) {
    // ConnectionManager.startConnection();
    runApp(ProviderScope(
      child: OKToast(
        backgroundColor: Colors.grey.withOpacity(0.3),
        position: ToastPosition.bottom,
        child: MyApp(savedThemeMode),
      ),
    ));
  });
  UpdateManager.initialize();
}

class AdaptiveThemeModeWatcher extends ChangeNotifier {
  late Brightness brightness;

  final AdaptiveThemeManager _themeManager;
  AdaptiveThemeModeWatcher(this._themeManager) {
    _themeManager.modeChangeNotifier.addListener(modeChanged);
    brightness = _themeManager.brightness!;
  }

  void modeChanged() {
    final newBrightness = _themeManager.brightness;
    if (newBrightness != brightness) {
      brightness = newBrightness!;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _themeManager.modeChangeNotifier.removeListener(modeChanged);
    super.dispose();
  }
}

class MyApp extends StatelessWidget {
  const MyApp(this.savedThemeMode, {final Key? key}) : super(key: key);

  static late PreferencesManager prefManager;
  final AdaptiveThemeMode savedThemeMode;

  @override
  Widget build(final BuildContext context) {
    return AdaptiveTheme(
        light: ThemeManager.getLightTheme(),
        dark: ThemeManager.getDarkTheme(),
        initial: savedThemeMode,
        builder: (final theme, final darkTheme) => MaterialApp(
              scrollBehavior: CustomScrollBehavior(),
              title: 'Smarthome',
              theme: theme,
              darkTheme: darkTheme,
              home: const MyHomePage(title: 'Smarthome Home Page'),
            ));
  }
}

class InfoIconProvider extends StateNotifier<IconData> with WidgetsBindingObserver {
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
    if (kIsWeb || !(defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS)) {
      return;
    }

    if (state == AppLifecycleState.resumed) {
      ref.read(hubConnectionProvider.notifier).newHubConnection();
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

final infoIconProvider = StateNotifierProvider<InfoIconProvider, IconData>(
  (final ref) => InfoIconProvider(ref),
);

final maxCrossAxisExtentProvider = StateProvider<double>((final _) =>
    PreferencesManager.instance.getDouble("DashboardCardSize") ?? (!kIsWeb && Platform.isAndroid ? 370 : 300));

final _groupCollapsedProvider = StateProvider.family<bool, String>((final _, final __) => false);

class MyHomePage extends ConsumerWidget {
  const MyHomePage({final Key? key, this.title}) : super(key: key);
  final String? title;

  Widget buildBodyGrouped(final BuildContext context, final WidgetRef ref) {
    final deviceGroupsRaw = ref.watch(filteredDevicesProvider);
    final deviceGroupsMap = deviceGroupsRaw.groupManyBy((final x) => ref.watch(Device.groupsByIdProvider(x.id)));
    final deviceGroups = deviceGroupsMap.entries.sorted((final a, final b) => b.value.length.compareTo(a.value.length));

    final versionAndUrl = ref.watch(versionAndUrlProvider);
    if (versionAndUrl != null) {
      WidgetsBinding.instance.addPostFrameCallback((final _) async {
        await UpdateManager.displayNotificationDialog(context, versionAndUrl);
      });
    }

    return Container(
      decoration: ThemeManager.getBackgroundDecoration(context),
      child: RefreshIndicator(
        child: ConstrainedBox(
          constraints: BoxConstraints.tight(Size.infinite),
          child: OrientationBuilder(
            builder: (final context, final orientation) {
              return Consumer(
                builder: (final context, final ref, final child) {
                  return MasonryGridView.extent(
                    maxCrossAxisExtent: ref.watch(maxCrossAxisExtentProvider),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    itemCount: deviceGroups.length,
                    itemBuilder: (final context, final i) {
                      final deviceGroup = deviceGroups.elementAt(i);
                      //if (deviceGroup == null) return const Text("Empty Entry");
                      return Container(
                        margin: const EdgeInsets.only(left: 2, top: 4, right: 2, bottom: 2),
                        child: getDashboardCard(deviceGroup, ref),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
        onRefresh: () async => refresh(ref),
      ),
    );
  }

  Widget buildBody(final BuildContext context, final WidgetRef ref) {
    ref.watch(valueStoreProvider);
    final devices = ref.watch(filteredDevicesProvider);
    return Container(
      decoration: ThemeManager.getBackgroundDecoration(context),
      child: RefreshIndicator(
        child: ConstrainedBox(
          constraints: BoxConstraints.tight(Size.infinite),
          child: OrientationBuilder(
            builder: (final context, final orientation) {
              return Consumer(
                builder: (final context, final ref, final child) {
                  return MasonryGridView.extent(
                    maxCrossAxisExtent: ref.watch(maxCrossAxisExtentProvider),
                    itemCount: devices.length,
                    itemBuilder: (final context, final i) {
                      final device = devices[i];
                      if (device is GenericDevice) {
                        final developerMode = ref.watch(debugInformationEnabledProvider);
                        final layout = ref.watch(deviceLayoutProvider(Tuple2(device.id, device.typeName)));
                        if (layout == null || (!developerMode && layout.showOnlyInDeveloperMode)) return Container();
                      }
                      return Container(
                        margin: const EdgeInsets.only(left: 2, top: 4, right: 2, bottom: 2),
                        child: device.dashboardView(
                          () {
                            deviceAction(context, ref, device);
                          },
                        ),
                      );
                    },
                    // staggeredTileBuilder: (final int index) => const StaggeredTile.fit(1)
                  );
                },
              );
            },
          ),
        ),
        onRefresh: () async => refresh(ref),
      ),
    );
  }

  Widget getDashboardCard(
    final MapEntry<String, List<Device<BaseModel>>> deviceGroup,
    final WidgetRef ref,
  ) {
    final collapsed = ref.watch(_groupCollapsedProvider(deviceGroup.key));

    return Column(
        children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Consumer(
                      builder: (final context, final ref, final child) {
                        final groupName = ref.watch(DeviceManager.customGroupNameProvider(deviceGroup.key));
                        return MaterialButton(
                          onPressed: (() {
                            final oldCollapsed = ref.read(_groupCollapsedProvider(deviceGroup.key).notifier);
                            oldCollapsed.state = !oldCollapsed.state;
                          }),
                          child: Text(
                            groupName,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        );
                      },
                    )),
                    Consumer(
                      builder: (final context, final ref, final child) {
                        return PopupMenuButton<String>(
                          onSelected: (final o) => groupOption(context, ref, o, deviceGroup),
                          itemBuilder: (final BuildContext context) => <PopupMenuItem<String>>[
                            const PopupMenuItem<String>(value: 'Rename', child: Text("Umbenennen")),
                            const PopupMenuItem<String>(value: 'Delete', child: Text("Entfernen")),
                            const PopupMenuItem<String>(value: 'Edit', child: Text("Geräte zuordnen")),
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            ] +
            (collapsed
                ? []
                : deviceGroup.value
                    .map<Widget>((final e) => Consumer(
                          builder: (final context, final ref, final child) {
                            if (e is GenericDevice) {
                              final developerMode = ref.watch(debugInformationEnabledProvider);
                              final layout = ref.watch(deviceLayoutProvider(Tuple2(e.id, e.typeName)));
                              if (layout == null || (!developerMode && layout.showOnlyInDeveloperMode)) {
                                return Container();
                              }
                            }

                            return Container(
                              margin: const EdgeInsets.only(),
                              child: e.dashboardView(
                                () {
                                  deviceAction(context, ref, e);
                                },
                              ),
                            );
                          },
                        ))
                    .toList()));
  }

  void groupOption(final BuildContext context, final WidgetRef ref, final String value,
      final MapEntry<String, List<Device<BaseModel>>> deviceGroup) {
    switch (value) {
      case 'Rename':
        final sd = SimpleDialogSingleInput.create(
            hintText: "Name der Gruppe",
            labelText: "Name",
            acceptButtonText: "Umbenennen",
            cancelButtonText: "Abbrechen",
            defaultText: ref.read(DeviceManager.customGroupNameProvider(deviceGroup.key)),
            onSubmitted: (final s) {
              ref.read(deviceProvider.notifier).changeGroupName(deviceGroup.key, s);
            },
            title: "Gruppenname ändern",
            context: context);
        showDialog(builder: (final BuildContext context) => sd, context: context);
        break;
      case 'Delete':
        for (final element in deviceGroup.value) {
          final groupsState = ref.read(Device.groupsByIdProvider(element.id).notifier);
          final groups = groupsState.state.toList();

          groups.remove(deviceGroup.key);
          if (groups.isEmpty) removeDevice(context, ref, element.id, pop: false);
          groupsState.state = groups;
        }
        ref.read(deviceProvider.notifier).saveDeviceGroups();

        break;
      case 'Edit':
        Navigator.push(context, MaterialPageRoute(builder: (final c) => GroupDevices(deviceGroup.key, false)));

        break;

      default:
        break;
    }
  }

  Future addDevice(final DeviceOverviewModel device, final WidgetRef ref) async {
    for (final item in device.typeNames) {
      if (await tryCreateDevice(device, item, ref)) return;
    }
  }

  Future<bool> tryCreateDevice(final DeviceOverviewModel device, final String item, final WidgetRef ref) async {
    if (!DeviceManager.ctorFactory.containsKey(item) || !DeviceManager.stringNameJsonFactory.containsKey(item)) {
      return false;
    }

    ref.read(deviceProvider.notifier).subscribeToDevice(device.id);
    return true;
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final _ = ref.watch(brightnessProvider(AdaptiveTheme.of(context)));
    final settings = ref.watch(groupingEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        title: ref.watch(getTitleWidgetProvider),
        leading: IconButton(icon: Icon(ref.watch(infoIconProvider)), onPressed: () => refresh(ref)),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                final notifier = ref.watch(searchEnabledProvider.notifier);
                notifier.state = !notifier.state;
              },
              icon: ref.watch(searchEnabledProvider) ? const Icon(Icons.cancel_outlined) : const Icon(Icons.search)),
          PopupMenuButton<String>(
            child: const Icon(Icons.sort),
            onSelected: (final v) => selectedSort(ref, v),
            itemBuilder: (final BuildContext context) => <PopupMenuItem<String>>[
              const PopupMenuItem<String>(value: 'Name', child: Text("Name")),
              const PopupMenuItem<String>(value: 'Typ', child: Text("Gerätetyp")),
              const PopupMenuItem<String>(value: 'Id', child: Text("Id")),
            ],
          ),
          PopupMenuButton<String>(
            onSelected: (final v) => selectedOption(context, v, ref),
            itemBuilder: (final BuildContext context) => <PopupMenuItem<String>>[
              const PopupMenuItem<String>(value: 'RemoveAll', child: Text("Entferne alle Geräte")),
              const PopupMenuItem<String>(value: 'Settings', child: Text("Einstellungen")),
            ],
          ),
        ],
      ),
      body: settings ? buildBodyGrouped(context, ref) : buildBody(context, ref),
      floatingActionButton: ExpandableFab(
        distance: 64.0,
        children: [
          ActionButton(
            onPressed: () => addNewDevice(context, ref),
            icon: const Icon(Icons.add),
          ),
          ActionButton(
            onPressed: () => addGroup(context),
            icon: const Icon(Icons.group_rounded),
          ),
        ],
      ),
    );
  }

  void selectedOption(final BuildContext context, final String value, final WidgetRef ref) {
    switch (value) {
      case "Debug":
        DeviceManager.showDebugInformation = !DeviceManager.showDebugInformation;
        break;
      case "Theme":
        AdaptiveTheme.of(context).toggleThemeMode();
        break;
      case "RemoveAll":
        ref.read(deviceProvider.notifier).removeAllDevices();
        break;
      case "Info":
        Navigator.push(context, MaterialPageRoute(builder: (final c) => const AboutPage()));
        break;
      case 'Settings':
        Navigator.push(context, MaterialPageRoute(builder: (final c) => const SettingsPage()));
        break;
    }
  }

  void deviceAction(final BuildContext context, final WidgetRef ref, final Device d) {
    final actions = <Widget>[];

    actions.add(
      SimpleDialogOption(
        child: const Text("Umbenennen"),
        onPressed: () => renameDevice(context, ref, d),
      ),
    );
    actions.add(
      SimpleDialogOption(
        child: const Text("Entfernen"),
        onPressed: () => removeDevice(context, ref, d.id),
      ),
    );

    final dialog = SimpleDialog(
      title: Consumer(
        builder: (final context, final ref, final child) {
          return Text("Gerät ${ref.watch(BaseModel.friendlyNameProvider(d.id))}");
        },
      ),
      children: actions,
    );
    showDialog(context: context, builder: (final b) => dialog);
  }

  void removeDevice(final BuildContext context, final WidgetRef ref, final int id, {final bool pop = true}) {
    if (pop) Navigator.pop(context);

    final devices = ref.read(deviceProvider.notifier);
    devices.removeDevice(id);
  }

  renameDevice(final BuildContext context, final WidgetRef ref, final Device x) {
    showDialog(
        context: context,
        builder: (final BuildContext context) => SimpleDialogSingleInput.create(
            context: context,
            title: "Gerät benennen",
            hintText: "Name für das Gerät",
            labelText: "Name",
            defaultText: ref.read(BaseModel.friendlyNameProvider(x.id)),
            maxLines: 2,
            onSubmitted: (final s) async {
              x.updateDeviceOnServer(x.id, s, ref.read(hubConnectionProvider));
            })).then((final x) => Navigator.of(context).pop());
  }

  void selectedSort(final WidgetRef ref, final String value) {
    final currentSortState = ref.watch(deviceSortProvider.notifier);
    SortTypes newSort = currentSortState.state;
    switch (value) {
      case "Name":
        newSort = newSort == SortTypes.NameAsc ? SortTypes.NameDesc : SortTypes.NameAsc;
        break;
      case "Typ":
        newSort = newSort == SortTypes.TypeAsc ? SortTypes.TypeDesc : SortTypes.TypeAsc;
        break;
      case "Id":
        newSort = newSort == SortTypes.IdAsd ? SortTypes.IdDesc : SortTypes.IdAsd;
        break;
    }
    currentSortState.state = newSort;
    PreferencesManager.instance.setInt("SortOrder", newSort.index);
  }

  Future addNewDevice(final BuildContext context, final WidgetRef ref) async {
    // if (ConnectionManager.hubConnection.state != HubConnectionState.connected) {
    final connection = ref.watch(hubConnectionConnectedProvider);
    if (connection == null) {
      return;
    }

    final serverDevices = (await connection.invoke("GetDeviceOverview", args: [])) as List<dynamic>;
    final serverDevicesList = serverDevices.map((final e) => DeviceOverviewModel.fromJson(e)).toList();

    final devices = ref.read(deviceProvider);
    final devicesToSelect = <Widget>[];
    for (final dev in serverDevicesList) {
      if (!devices.any((final x) => x.id == dev.id)) {
        devicesToSelect.add(
          Consumer(
            builder: (final context, final ref, final child) {
              final selected = ref.watch(_addItemSelectorProvider(dev.id));
              return SimpleDialogOption(
                child: Row(
                  children: [
                    Checkbox(
                        value: selected,
                        onChanged: (c) {
                          ref.watch(_addItemSelectorProvider(dev.id).notifier).state = !selected;
                        }),
                    Text(dev.friendlyName ?? dev.id.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(": ${dev.typeName}")
                  ],
                ),
                onPressed: () async {
                  ref.watch(_addItemSelectorProvider(dev.id).notifier).state = !selected;
                },
              );
            },
          ),
        );
      }
    }
    if (devicesToSelect.length > 1) {
      devicesToSelect.insert(
        0,
        SimpleDialogOption(
          child: const Text("Select all"),
          onPressed: () async {
            for (final dev in serverDevicesList) {
              ref.watch(_addItemSelectorProvider(dev.id).notifier).state = true;
            }
          },
        ),
      );
      devicesToSelect.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SimpleDialogOption(
              child: MaterialButton(
                onPressed: () => subscribeTo(context, ref, serverDevicesList),
                child: const Text("Subscribe to selected"),
              ),
              onPressed: () {
                subscribeTo(context, ref, serverDevicesList);
              },
            ),
          ],
        ),
      );
    }

    final dialog = SimpleDialog(
      title: Text((devicesToSelect.isEmpty ? "No new Devices found" : "Add new Smarthome Device")),
      children: devicesToSelect,
    );
    showDialog(context: context, builder: (final b) => dialog);
  }

  void subscribeTo(final BuildContext context, final WidgetRef ref, final List<DeviceOverviewModel> serverDevicesList) {
    final List<int> selectedIds = [];
    for (final dev in serverDevicesList) {
      final notifier = ref.read(_addItemSelectorProvider(dev.id).notifier);
      if (notifier.state) {
        selectedIds.add(dev.id);
        notifier.state = false;
      }
    }
    ref.read(deviceProvider.notifier).subscribeToDevices(selectedIds);
    Navigator.pop(context);
  }

  void refresh(final WidgetRef ref) {
    ref.read(hubConnectionProvider.notifier).newHubConnection().then((final value) async {
      await ref.read(deviceProvider.notifier).reloadCurrentDevices();
    });
  }

  void addGroup(final BuildContext context) {
    final sd = SimpleDialogSingleInput.create(
        hintText: "Name der neuen Gruppe",
        labelText: "Name",
        acceptButtonText: "Erstellen",
        cancelButtonText: "Abbrechen",
        onSubmitted: (final s) {
          Navigator.push(context, MaterialPageRoute(builder: (final c) => GroupDevices(s, true)));
        },
        title: "Neue Gruppe",
        context: context);
    showDialog(builder: (final BuildContext context) => sd, context: context);
  }
}
