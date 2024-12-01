import 'package:flutter/material.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/zigbee/zigbee_switch_model.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../restapi/swagger.enums.swagger.dart';

class TradfriControlOutlet extends Device<ZigbeeSwitchModel> {
  TradfriControlOutlet(super.id, super.typeName, final IconData icon)
      : super(iconData: icon);

  @override
  void navigateToDevice(final BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (final BuildContext context) =>
                TradfriControlOutletScreen(this)));
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
                style: (state)
                    ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                    : const TextStyle(),
              ),
              onPressed: () => sendToServer(MessageType.update,
                  Command2.singlecolor, [], ref.read(apiProvider)),
            );
          },
        ),
        Consumer(
          builder: (final context, final ref, final child) {
            final state = ref.watch(ZigbeeSwitchModel.stateProvider(id));
            return MaterialButton(
              child: Text(
                "Aus",
                style: !(state)
                    ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                    : const TextStyle(),
              ),
              onPressed: () => sendToServer(
                  MessageType.update, Command2.off, [], ref.read(apiProvider)),
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
  const TradfriControlOutletScreen(this.device, {super.key});

  @override
  _TradfriControlOutletScreenState createState() =>
      _TradfriControlOutletScreenState();
}

class _TradfriControlOutletScreenState
    extends ConsumerState<TradfriControlOutletScreen> {
  DateTime dateTime = DateTime.now();

  @override
  Widget build(final BuildContext context) {
    final friendlyName =
        ref.watch(BaseModel.friendlyNameProvider(widget.device.id));
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
          onPressed: () {
            final state =
                ref.watch(ZigbeeSwitchModel.stateProvider(widget.device.id));
            widget.device.sendToServer(MessageType.update,
                state ? Command2.off : Command2.on, [], ref.read(apiProvider));
          }),
    );
  }

  Widget buildBody() {
    final model = ref.watch(widget.device.baseModelTProvider(widget.device.id));
    if (model is! ZigbeeSwitchModel) return const SizedBox();

    return ListView(
      children: <Widget>[
        ListTile(
          title: Text("Angeschaltet: ${model.state ? "Ja" : "Nein"}"),
        ),
        ListTile(
          title: Text("Verfügbar: ${model.available ? "Ja" : "Nein"}"),
        ),
        ListTile(
          title: Text("Verbindungsqualität: ${model.linkQuality}"),
        ),
      ],
    );
  }
}
