import 'package:flutter/material.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/helper/theme_manager.dart';

class GroupDevices extends StatefulWidget {
  final MapEntry<String, List<Device<BaseModel>>> groupDevices;

  GroupDevices(this.groupDevices);

  @override
  State<StatefulWidget> createState() => GroupDevicesState();
}

class GroupDevicesState extends State<GroupDevices> {
  final List<Device> modifiedDevices = [];
  String groupName = "";

  @override
  void initState() {
    super.initState();
    groupName = this.widget.groupDevices.key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Geräte Gruppe " + groupName),
      ),
      body: Container(
        decoration: ThemeManager.getBackgroundDecoration(context),
        child: new Form(
          onWillPop: _onWillPop,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: mapDevices(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          DeviceManager.saveDeviceGroups();
          Navigator.of(context).pop(true);
        },
      ),
    );
  }

  List<Widget> mapDevices() {
    var widgets = <Widget>[];
    var localCopy = DeviceManager.devices;
    localCopy.sort(
        (x, b) => x.baseModel.friendlyName.compareTo(b.baseModel.friendlyName));
    for (var device in DeviceManager.devices) {
      var contains = this.widget.groupDevices.value.contains(device);
      widgets.add(ListTile(
        leading:
            Checkbox(value: contains, onChanged: (v) => changed(v, device)),
        title: Wrap(
          children: [
            device.icon,
            Text(device.baseModel.friendlyName),
            Text(": "),
            Text(device.typeName),
          ],
        ),
        onTap: () => changed(!contains, device),
      ));
    }
    return widgets;
  }

  void changed(bool? value, Device<BaseModel> device) {
    if (value == null) return;

    if (modifiedDevices.contains(device))
      modifiedDevices.remove(device);
    else
      modifiedDevices.add(device);

    if (value) {
      device.groups.add(this.widget.groupDevices.key);
      this.widget.groupDevices.value.add(device);
    } else {
      device.groups.remove(this.widget.groupDevices.key);
      this.widget.groupDevices.value.remove(device);
    }
    setState(() {});
  }

  Future<bool> _onWillPop() async {
    bool isNewGroup = this.widget.groupDevices.value.length == 0;

    if (!isNewGroup && modifiedDevices.length == 0) return true;

    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle = theme.textTheme.subtitle1!
        .copyWith(color: theme.textTheme.caption!.color);

    return await (showDialog<bool>(
            context: context,
            builder: (BuildContext context) => new AlertDialog(
                    content: isNewGroup
                        ? Text(
                            "Es wurden der neuen Gruppe keine Geräte zugeordnet.\r\n\Soll die neue Gruppe verworfen werden?",
                            style: dialogTextStyle)
                        : Text(
                            "Es wurden Änderungen an den Temperatur-Einstellungen vorgenommen.\r\nSollen diese verworfen werden?",
                            style: dialogTextStyle),
                    actions: <Widget>[
                      TextButton(
                          child: Text("Abbrechen"),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          }),
                      TextButton(
                          child: Text("Verwerfen"),
                          onPressed: () {
                            modifiedDevices.forEach((device) {
                              if (device.groups.contains(groupName))
                                device.groups.remove(groupName);
                              else
                                device.groups.add(groupName);
                            });
                            Navigator.of(context).pop(true);
                          })
                    ]))) ??
        false;
  }
}
