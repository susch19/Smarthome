import 'package:flutter/material.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/zigbee/zigbee_switch_model.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/models/message.dart' as sm;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../device_manager.dart';

class TradfriControlOutlet extends Device<ZigbeeSwitchModel> {
  TradfriControlOutlet(final int id, final String typeName, final IconData icon) : super(id, typeName, iconData: icon);

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
        Consumer(
          builder: (final context, final ref, final child) {
            final state = ref.watch(ZigbeeSwitchModel.stateProvider(id));
            return MaterialButton(
              child: Text(
                "An",
                style: (state) ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 20) : const TextStyle(),
              ),
              onPressed: () =>
                  sendToServer(sm.MessageType.Update, sm.Command.SingleColor, [], ref.read(hubConnectionProvider)),
            );
          },
        ),
        Consumer(
          builder: (final context, final ref, final child) {
            final state = ref.watch(ZigbeeSwitchModel.stateProvider(id));
            return MaterialButton(
              child: Text(
                "Aus",
                style: !(state) ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 20) : const TextStyle(),
              ),
              onPressed: () => sendToServer(sm.MessageType.Update, sm.Command.Off, [], ref.read(hubConnectionProvider)),
            );
          },
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
    final friendlyName = ref.watch(BaseModel.friendlyNameProvider(widget.device.id));
    return Scaffold(
      appBar: AppBar(
        title: Text(friendlyName),
      ),
      body: Container(
        decoration: ThemeManager.getBackgroundDecoration(context),
        child: buildBody(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.power_settings_new),
        onPressed: () =>
            widget.device.sendToServer(sm.MessageType.Update, sm.Command.Off, [], ref.read(hubConnectionProvider)),
      ),
    );
  }

  Widget buildBody() {
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
