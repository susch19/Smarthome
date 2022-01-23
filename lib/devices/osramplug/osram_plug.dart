import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/devices/base_model.dart';
import 'package:smarthome/devices/device.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/zigbee/zigbee_switch_model.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/models/message.dart' as sm;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../device_manager.dart';

class OsramPlug extends Device<ZigbeeSwitchModel> {
  OsramPlug(final int id, final String typeName, final ZigbeeSwitchModel model, final HubConnection connection,
      final IconData icon)
      : super(id, typeName, model, connection, iconData: icon);

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
          child: Text(
            "An",
            style: baseModel.state ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 20) : const TextStyle(),
          ),
          onPressed: () => sendToServer(sm.MessageType.Update, sm.Command.On, []),
        ),
        MaterialButton(
          child: Text(
            "Aus",
            style: !baseModel.state ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 20) : const TextStyle(),
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
    final friendlyName = ref.watch(baseModelFriendlyNameProvider(device.id));
    return Scaffold(
      appBar: AppBar(
        title: Text(friendlyName ?? ""),
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
    final model = ref.watch(device.baseModelTProvider(device.id));
    if (model is! ZigbeeSwitchModel) return Container();

    return ListView(
      children: <Widget>[
        ListTile(
          title: Text("Angeschaltet: " + (model.state ? "Ja" : "Nein")),
        ),
        ListTile(
          title: Text("Verfügbar: " + (model.available ? "Ja" : "Nein")),
        ),
        ListTile(
          title: Text("Verbindungsqualität: " + (model.linkQuality.toString())),
        ),
      ],
    );
  }
}
