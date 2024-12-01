import 'dart:async';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smarthome/controls/expandable_fab.dart';
import 'package:smarthome/dashboard/group_devices.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/device_overview_model.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/helper/preference_manager.dart';
import 'package:smarthome/helper/settings_manager.dart';
import 'package:smarthome/helper/simple_dialog_single_input.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/helper/update_manager.dart';
import 'package:smarthome/main.dart';
import 'package:smarthome/restapi/swagger.swagger.dart';
import 'package:smarthome/screens/screen_export.dart';
import 'package:smarthome/screens/settings_page.dart';

final _groupCollapsedProvider =
    StateProvider.family<bool, String>((final _, final __) => false);
final _addItemSelectorProvider =
    StateProvider.family<bool, int>((final ref, final arg) => false);

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, this.title});
  final String? title;

  Widget buildBodyGrouped(final BuildContext context, final WidgetRef ref) {
    final deviceGroupsRaw = ref.watch(filteredDevicesProvider);
    final deviceGroupsMap = deviceGroupsRaw
        .groupManyBy((final x) => ref.watch(Device.groupsByIdProvider(x.id)));
    final deviceGroups = deviceGroupsMap.entries
        .sorted((final a, final b) => b.value.length.compareTo(a.value.length));

    final versionAndUrl = ref.watch(versionAndUrlProvider);
    if (versionAndUrl != null) {
      WidgetsBinding.instance.addPostFrameCallback((final _) async {
        await UpdateManager.displayNotificationDialog(context, versionAndUrl);
      });
    }

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
              margin:
                  const EdgeInsets.only(left: 2, top: 4, right: 2, bottom: 2),
              child: getDashboardCard(deviceGroup, ref),
            );
          },
        );
      },
    );
  }

  Widget buildBody(final BuildContext context, final WidgetRef ref) {
    final devices = ref.watch(filteredDevicesProvider);

    return Consumer(
      builder: (final context, final ref, final child) {
        return MasonryGridView.extent(
          maxCrossAxisExtent: ref.watch(maxCrossAxisExtentProvider),
          itemCount: devices.length,
          itemBuilder: (final context, final i) {
            final device = devices[i];
            //TODO Why was this here?
            // if (device is GenericDevice) {
            //   final developerMode =
            //       ref.watch(debugInformationEnabledProvider);
            //   final layout = ref.watch(deviceLayoutsProvider(
            //       Tuple2(device.id, device.typeName)));
            //   if (layout == null ||
            //       (!developerMode && layout.showOnlyInDeveloperMode))
            //     return const SizedBox();
            // }
            return Container(
              margin:
                  const EdgeInsets.only(left: 2, top: 4, right: 2, bottom: 2),
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
                        final groupName = ref.watch(
                            DeviceManager.customGroupNameProvider(
                                deviceGroup.key));
                        return MaterialButton(
                          onPressed: (() {
                            final oldCollapsed = ref.read(
                                _groupCollapsedProvider(deviceGroup.key)
                                    .notifier);
                            oldCollapsed.state = !oldCollapsed.state;
                          }),
                          child: Text(
                            groupName,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        );
                      },
                    )),
                    Consumer(
                      builder: (final context, final ref, final child) {
                        return PopupMenuButton<String>(
                          onSelected: (final o) =>
                              groupOption(context, ref, o, deviceGroup),
                          itemBuilder: (final BuildContext context) =>
                              <PopupMenuItem<String>>[
                            const PopupMenuItem<String>(
                                value: 'Rename', child: Text("Umbenennen")),
                            const PopupMenuItem<String>(
                                value: 'Delete', child: Text("Entfernen")),
                            const PopupMenuItem<String>(
                                value: 'Edit', child: Text("Geräte zuordnen")),
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
                            //TODO Why was this here?
                            // if (e is GenericDevice) {
                            //   final developerMode =
                            //       ref.watch(debugInformationEnabledProvider);
                            //   final layout = ref.watch(deviceLayoutProvider(
                            //       Tuple2(e.id, e.typeName)));
                            //   if (layout == null ||
                            //       (!developerMode &&
                            //           layout.showOnlyInDeveloperMode)) {
                            //     return const SizedBox();
                            //   }
                            // }

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

  void groupOption(
      final BuildContext context,
      final WidgetRef ref,
      final String value,
      final MapEntry<String, List<Device<BaseModel>>> deviceGroup) {
    switch (value) {
      case 'Rename':
        final sd = SimpleDialogSingleInput.create(
            hintText: "Name der Gruppe",
            labelText: "Name",
            acceptButtonText: "Umbenennen",
            cancelButtonText: "Abbrechen",
            defaultText: ref
                .read(DeviceManager.customGroupNameProvider(deviceGroup.key)),
            onSubmitted: (final s) {
              ref
                  .read(deviceManagerProvider.notifier)
                  .changeGroupName(deviceGroup.key, s);
            },
            title: "Gruppenname ändern",
            context: context);
        showDialog(
            builder: (final BuildContext context) => sd, context: context);
        break;
      case 'Delete':
        for (final element in deviceGroup.value) {
          final groupsState =
              ref.read(Device.groupsByIdProvider(element.id).notifier);
          final groups = groupsState.state.toList();

          groups.remove(deviceGroup.key);
          if (groups.isEmpty) {
            removeDevice(context, ref, element.id, pop: false);
          }
          groupsState.state = groups;
        }
        ref.read(deviceManagerProvider.notifier).saveDeviceGroups();

        break;
      case 'Edit':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (final c) => GroupDevices(deviceGroup.key, false)));

        break;

      default:
        break;
    }
  }

  Future addDevice(
      final DeviceOverviewModel device, final WidgetRef ref) async {
    for (final item in device.typeNames) {
      if (await tryCreateDevice(device, item, ref)) return;
    }
  }

  Future<bool> tryCreateDevice(final DeviceOverviewModel device,
      final String item, final WidgetRef ref) async {
    if (!deviceCtorFactory.containsKey(item) ||
        !stringNameJsonFactory.containsKey(item)) {
      return false;
    }

    ref.read(deviceManagerProvider.notifier).subscribeToDevice(device.id);
    return true;
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final _ = ref.watch(brightnessProvider(AdaptiveTheme.of(context)));
    final settings = ref.watch(groupingEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        title: ref.watch(getTitleWidgetProvider),
        leading: IconButton(
            icon: Icon(ref.watch(infoIconProvider)),
            onPressed: () => refresh(ref)),
        actions: <Widget>[
          // ref.watch(showPinProvider).when(
          //       data: (final data) {
          //         final showPin = data.item1;
          //         if (!showPin) return const SizedBox();

          //         final pinned = data.item2;
          //         return IconButton(
          //             onPressed: () => pinned ? stopKioskMode() : startKioskMode(),
          //             icon: const Icon(Icons.pin_drop_outlined));
          //       },
          //       error: (final error, final stackTrace) => const SizedBox(),
          //       loading: () => const SizedBox(),
          //     ),
          IconButton(
              onPressed: () {
                final notifier = ref.watch(searchEnabledProvider.notifier);
                notifier.state = !notifier.state;
              },
              icon: ref.watch(searchEnabledProvider)
                  ? const Icon(Icons.cancel_outlined)
                  : const Icon(Icons.search)),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (final v) => selectedSort(ref, v),
            itemBuilder: (final BuildContext context) =>
                <PopupMenuItem<String>>[
              const PopupMenuItem<String>(value: 'Name', child: Text("Name")),
              const PopupMenuItem<String>(
                  value: 'Typ', child: Text("Gerätetyp")),
              const PopupMenuItem<String>(value: 'Id', child: Text("Id")),
            ],
          ),
          PopupMenuButton<String>(
            onSelected: (final v) => selectedOption(context, v, ref),
            itemBuilder: (final BuildContext context) =>
                <PopupMenuItem<String>>[
              const PopupMenuItem<String>(
                  value: 'RemoveAll', child: Text("Entferne alle Geräte")),
              const PopupMenuItem<String>(
                  value: 'Settings', child: Text("Einstellungen")),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: ThemeManager.getBackgroundDecoration(context),
        child: RefreshIndicator(
          child: ConstrainedBox(
            constraints: BoxConstraints.tight(Size.infinite),
            child: OrientationBuilder(
              builder: (final context, final orientation) => settings
                  ? buildBodyGrouped(context, ref)
                  : buildBody(context, ref),
            ),
          ),
          onRefresh: () async => ref.invalidate(connectionManagerProvider),
        ),
      ),
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

  void selectedOption(
      final BuildContext context, final String value, final WidgetRef ref) {
    switch (value) {
      case "Debug":
        DeviceManager.showDebugInformation =
            !DeviceManager.showDebugInformation;
        break;
      case "Theme":
        AdaptiveTheme.of(context).toggleThemeMode();
        break;
      case "RemoveAll":
        ref.read(deviceManagerProvider.notifier).removeAllDevices();
        break;
      case "Info":
        Navigator.push(context,
            MaterialPageRoute(builder: (final c) => const AboutPage()));
        break;
      case 'Settings':
        Navigator.push(context,
            MaterialPageRoute(builder: (final c) => const SettingsPage()));
        break;
    }
  }

  void deviceAction(
      final BuildContext context, final WidgetRef ref, final Device d) {
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
          return Text(
              "Gerät ${ref.watch(BaseModel.friendlyNameProvider(d.id))}");
        },
      ),
      children: actions,
    );
    showDialog(context: context, builder: (final b) => dialog);
  }

  void removeDevice(
      final BuildContext context, final WidgetRef ref, final int id,
      {final bool pop = true}) {
    if (pop) Navigator.pop(context);

    final devices = ref.read(deviceManagerProvider.notifier);
    devices.removeDevice(id);
  }

  renameDevice(
      final BuildContext context, final WidgetRef ref, final Device x) {
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
              x.updateDeviceOnServer(x.id, s, ref.read(apiProvider));
            })).then((final x) => Navigator.of(context).pop());
  }

  void selectedSort(final WidgetRef ref, final String value) {
    final currentSortState = ref.watch(deviceSortProvider.notifier);
    SortTypes newSort = currentSortState.state;
    switch (value) {
      case "Name":
        newSort = newSort == SortTypes.NameAsc
            ? SortTypes.NameDesc
            : SortTypes.NameAsc;
        break;
      case "Typ":
        newSort = newSort == SortTypes.TypeAsc
            ? SortTypes.TypeDesc
            : SortTypes.TypeAsc;
        break;
      case "Id":
        newSort =
            newSort == SortTypes.IdAsd ? SortTypes.IdDesc : SortTypes.IdAsd;
        break;
    }
    currentSortState.state = newSort;
    PreferencesManager.instance.setInt("SortOrder", newSort.index);
  }

  Future addNewDevice(final BuildContext context, final WidgetRef ref) async {
    // if (ConnectionManager.hubConnection.state != HubConnectionState.connected) {
    final connection = ref.watch(apiProvider);

    final serverDevices = await connection.appDeviceOverviewGet();

    final serverDevicesList = serverDevices.bodyOrThrow;

    final devicesFuture = ref.read(deviceManagerProvider);
    if (!devicesFuture.hasValue) return;
    final devices = devicesFuture.requireValue;
    final devicesToSelect = <Widget>[];
    for (final dev in serverDevicesList) {
      if (!devices.any((final x) => x.id == dev.id)) {
        devicesToSelect.add(
          Consumer(
            builder: (final context, final ref, final child) {
              final selected = ref.watch(_addItemSelectorProvider(dev.id));
              return SimpleDialogOption(
                child: CheckboxListTile(
                  value: selected,
                  onChanged: (final c) {
                    ref.read(_addItemSelectorProvider(dev.id).notifier).state =
                        !selected;
                  },
                  title: Text(dev.friendlyName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(dev.typeName),
                ),
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
    }
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

    final dialog = SimpleDialog(
      title: Text((devicesToSelect.isEmpty
          ? "No new Devices found"
          : "Add new Smarthome Device")),
      children: devicesToSelect,
    );
    await showDialog(context: context, builder: (final b) => dialog);
  }

  void subscribeTo(final BuildContext context, final WidgetRef ref,
      final List<DeviceOverview> serverDevicesList) {
    final List<int> selectedIds = [];
    for (final dev in serverDevicesList) {
      final notifier = ref.read(_addItemSelectorProvider(dev.id).notifier);
      if (notifier.state) {
        selectedIds.add(dev.id);
        notifier.state = false;
      }
    }
    ref.read(deviceManagerProvider.notifier).subscribeToDevices(selectedIds);
    Navigator.pop(context);
  }

  void refresh(final WidgetRef ref) {
    ref
        .read(connectionManagerProvider.notifier)
        .newHubConnection()
        .then((final value) async {
      await ref.read(deviceManagerProvider.notifier).reloadCurrentDevices();
    });
  }

  void addGroup(final BuildContext context) {
    final sd = SimpleDialogSingleInput.create(
        hintText: "Name der neuen Gruppe",
        labelText: "Name",
        acceptButtonText: "Erstellen",
        cancelButtonText: "Abbrechen",
        onSubmitted: (final s) {
          Navigator.push(context,
              MaterialPageRoute(builder: (final c) => GroupDevices(s, true)));
        },
        title: "Neue Gruppe",
        context: context);
    showDialog(builder: (final BuildContext context) => sd, context: context);
  }
}
