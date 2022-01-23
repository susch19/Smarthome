import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/zigbee/zigbee_switch_model.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/models/message.dart' as sm;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../device_manager.dart';

class TradfriControlOutlet extends Device<ZigbeeSwitchModel> {
  TradfriControlOutlet(final int id, final String typeName, final ZigbeeSwitchModel model,
      final HubConnection connection, final IconData icon)
      : super(id, typeName, model, connection, iconData: icon);

  @override
  void navigateToDevice(final BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (final BuildContext context) => TradfriControlOutletScreen(this)));
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
    return DeviceTypes.TradfriControlOutlet;
  }
}

class TradfriControlOutletScreen extends ConsumerStatefulWidget {
  final TradfriControlOutlet device;
  const TradfriControlOutletScreen(this.device, {final Key? key}) : super(key: key);

  @override
  _TradfriControlOutletScreenState createState() => _TradfriControlOutletScreenState();
}

class _TradfriControlOutletScreenState extends ConsumerState<TradfriControlOutletScreen> {
  DateTime dateTime = DateTime.now();

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.baseModel.friendlyName),
      ),
      body: Container(
        decoration: ThemeManager.getBackgroundDecoration(context),
        child: buildBody(widget.device.baseModel),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.power_settings_new),
        onPressed: () => widget.device.sendToServer(sm.MessageType.Update, sm.Command.Off, []),
      ),
    );
  }

  Widget buildBody(final ZigbeeSwitchModel model) {
    final model = ref.watch(widget.device.baseModelTProvider(widget.device.id));
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
