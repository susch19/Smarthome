import 'package:flutter/material.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

@immutable
class GroupDevices extends ConsumerWidget {
  GroupDevices(this.groupName, this.isNewGroup, {super.key});

  final tempGroupProvider =
      StateProvider.family<List<String>, int>((final ref, final id) {
    return ref.read(Device.groupsByIdProvider(id));
  });

  final List<Device> modifiedDevices = [];
  final String groupName;
  final bool isNewGroup;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Geräte Gruppe $groupName"),
      ),
      body: Container(
        decoration: ThemeManager.getBackgroundDecoration(context),
        child: Form(
            onPopInvoked: (final didPop) => _onWillPop(context, didPop),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Consumer(
              builder: (final context, final ref, final child) {
                return ListView(
                  children: mapDevices(ref),
                );
              },
            )),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          for (final device in modifiedDevices) {
            ref.read(Device.groupsByIdProvider(device.id).notifier).state =
                ref.read(tempGroupProvider(device.id));
          }
          ref.read(deviceManagerProvider.notifier).saveDeviceGroups();
          Navigator.of(context).pop(true);
        },
      ),
    );
  }

  List<Widget> mapDevices(final WidgetRef ref) {
    final widgets = <Widget>[];
    final devicesFuture = ref.watch(deviceManagerProvider);
    if (!devicesFuture.hasValue) return [];
    final devices = devicesFuture.requireValue;

    for (final device in devices) {
      final groups = ref.watch(tempGroupProvider(device.id));
      final contains = groups.contains(groupName);
      widgets.add(ListTile(
        leading: Checkbox(
            value: contains, onChanged: (final v) => changed(v, device, ref)),
        title: Consumer(
          builder: (final context, final ref, final child) {
            final friendlyName =
                ref.watch(BaseModel.friendlyNameProvider(device.id));
            final typeName = ref.watch(BaseModel.typeNameProvider(device.id));
            return Wrap(
              children: [
                Text(friendlyName),
                const Text(": "),
                Text(typeName),
              ],
            );
          },
        ),
        onTap: () => changed(!contains, device, ref),
      ));
    }
    return widgets;
  }

  void changed(
      final bool? value, final Device<BaseModel> device, final WidgetRef ref) {
    if (value == null) return;

    if (modifiedDevices.contains(device)) {
      modifiedDevices.remove(device);
    } else {
      modifiedDevices.add(device);
    }
    final groupsState = ref.read(tempGroupProvider(device.id).notifier);
    final groups = groupsState.state.toList();
    if (value) {
      groups.add(groupName);
    } else {
      groups.remove(groupName);
    }
    groupsState.state = groups;
  }

  Future<bool> _onWillPop(final BuildContext context, final bool didPop) async {
    if (!didPop || (!isNewGroup && modifiedDevices.isEmpty)) return true;

    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle = theme.textTheme.titleMedium!
        .copyWith(color: theme.textTheme.bodySmall!.color);

    return await (showDialog<bool>(
          context: context,
          builder: (final BuildContext context) => AlertDialog(
            content: isNewGroup
                ? Text(
                    "Es wurden der neuen Gruppe keine Geräte zugeordnet.\r\nSoll die neue Gruppe verworfen werden?",
                    style: dialogTextStyle)
                : Text(
                    "Es wurden Änderungen an den Temperatur-Einstellungen vorgenommen.\r\nSollen diese verworfen werden?",
                    style: dialogTextStyle),
            actions: <Widget>[
              TextButton(
                  child: const Text("Abbrechen"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  }),
              Consumer(
                builder: (final context, final ref, final child) {
                  return TextButton(
                      child: const Text("Verwerfen"),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      });
                },
              )
            ],
          ),
        )) ??
        false;
  }
}
