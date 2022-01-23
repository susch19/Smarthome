import 'package:flutter/material.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class GroupDevices extends ConsumerWidget {
  final MapEntry<String, List<Device<BaseModel>>> groupDevices;

  GroupDevices(this.groupDevices, this.groupName, {final Key? key}) : super(key: key);

  final List<Device> modifiedDevices = [];
  final String groupName;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Geräte Gruppe " + groupName),
      ),
      body: Container(
        decoration: ThemeManager.getBackgroundDecoration(context),
        child: Form(
          onWillPop: () => _onWillPop(context),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: mapDevices(ref),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          DeviceManager.saveDeviceGroups();
          Navigator.of(context).pop(true);
        },
      ),
    );
  }

  List<Widget> mapDevices(final WidgetRef ref) {
    final widgets = <Widget>[];
    final devices = ref.watch(deviceProvider);

    for (final device in devices) {
      final contains = groupDevices.value.contains(device);
      widgets.add(ListTile(
        leading: Checkbox(value: contains, onChanged: (final v) => changed(v, device)),
        title: Consumer(
          builder: (final context, final ref, final child) {
            final friendlyName = ref.watch(baseModelFriendlyNameProvider(device.id));
            final typeName = ref.watch(baseModelTypeNameProvider(device.id));
            return Wrap(
              children: [
                Text(friendlyName ?? ""),
                const Text(": "),
                Text(typeName),
              ],
            );
          },
        ),
        onTap: () => changed(!contains, device),
      ));
    }
    return widgets;
  }

  void changed(final bool? value, final Device<BaseModel> device) {
    if (value == null) return;

    if (modifiedDevices.contains(device)) {
      modifiedDevices.remove(device);
    } else {
      modifiedDevices.add(device);
    }

    if (value) {
      device.groups.add(groupDevices.key);
      groupDevices.value.add(device);
    } else {
      device.groups.remove(groupDevices.key);
      groupDevices.value.remove(device);
    }
  }

  Future<bool> _onWillPop(final BuildContext context) async {
    final bool isNewGroup = groupDevices.value.isEmpty;

    if (!isNewGroup && modifiedDevices.isEmpty) return true;

    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle = theme.textTheme.subtitle1!.copyWith(color: theme.textTheme.caption!.color);

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
                      TextButton(
                          child: const Text("Verwerfen"),
                          onPressed: () {
                            for (final device in modifiedDevices) {
                              if (device.groups.contains(groupName)) {
                                device.groups.remove(groupName);
                              } else {
                                device.groups.add(groupName);
                              }
                            }
                            Navigator.of(context).pop(true);
                          })
                    ]))) ??
        false;
  }
}
