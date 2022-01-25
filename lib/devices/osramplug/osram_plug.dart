import 'package:flutter/material.dart';
import 'package:smarthome/devices/base_model.dart';
import 'package:smarthome/devices/device.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/zigbee/zigbee_model.dart';
import 'package:smarthome/devices/zigbee/zigbee_switch_model.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/models/message.dart' as sm;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../device_manager.dart';

class OsramPlug extends Device<ZigbeeSwitchModel> {
  OsramPlug(final int id, final String typeName, final IconData icon) : super(id, typeName, iconData: icon);

  @override
  void navigateToDevice(final BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (final BuildContext context) => OsramPlugScreen(this)));
  }

  @override
  Widget dashboardCardBody() {
    return Wrap(
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.spaceEvenly,
      children: [
        MaterialButton(
          child: Consumer(
            builder: (final context, final ref, final child) {
              final state = ref.watch(ZigbeeSwitchModel.stateProvider(id));
              return Text(
                "An",
                style: (state) ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 20) : const TextStyle(),
              );
            },
          ),
          onPressed: () => sendToServer(sm.MessageType.Update, sm.Command.On, []),
        ),
        MaterialButton(
          child: Consumer(
            builder: (final context, final ref, final child) {
              final state = ref.watch(ZigbeeSwitchModel.stateProvider(id));
              return Text(
                "Aus",
                style: !(state) ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 20) : const TextStyle(),
              );
            },
          ),
          onPressed: () => sendToServer(sm.MessageType.Update, sm.Command.Off, []),
        ),
      ],
    );
  }

  @override
  DeviceTypes getDeviceType() {
    return DeviceTypes.OsramPlug;
  }
}

class OsramPlugScreen extends ConsumerWidget {
  final OsramPlug device;
  const OsramPlugScreen(this.device, {final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final friendlyName = ref.watch(BaseModel.friendlyNameProvider(device.id));
    return Scaffold(
      appBar: AppBar(
        title: Text(friendlyName),
      ),
      body: Container(
        decoration: ThemeManager.getBackgroundDecoration(context),
        child: buildBody(ref),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.power_settings_new),
        onPressed: () => device.sendToServer(sm.MessageType.Update, sm.Command.Off, []),
      ),
    );
  }

  Widget buildBody(final WidgetRef ref) {
    final state = ref.watch(ZigbeeSwitchModel.stateProvider(device.id));
    final available = ref.watch(ZigbeeModel.availableProvider(device.id));
    final linkQuality = ref.watch(ZigbeeModel.linkQualityProvider(device.id));

    return ListView(
      children: <Widget>[
        ListTile(
          title: Text("Angeschaltet: " + (state ? "Ja" : "Nein")),
        ),
        ListTile(
          title: Text("Verfügbar: " + (available ? "Ja" : "Nein")),
        ),
        ListTile(
          title: Text("Verbindungsqualität: " + (linkQuality.toString())),
        ),
      ],
    );
  }
}
