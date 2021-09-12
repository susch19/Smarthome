import 'dart:async';

import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/devices/device.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/models/message.dart' as sm;

import '../device_manager.dart';
import 'tradfri_control_outlet_model.dart';

class TradfriControlOutlet extends Device<TradfriControlOutletModel> {
  TradfriControlOutlet(
      int? id, String typeName, TradfriControlOutletModel model, HubConnection connection, IconData icon)
      : super(id, typeName, model, connection, icon);

  @override
  void navigateToDevice(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TradfriControlOutletScreen(this)));
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
            style: baseModel.state ? TextStyle(fontWeight: FontWeight.bold, fontSize: 20) : TextStyle(),
          ),
          onPressed: () => sendToServer(sm.MessageType.Update, sm.Command.On, []),
        ),
        MaterialButton(
          child: Text(
            "Aus",
            style: !baseModel.state ? TextStyle(fontWeight: FontWeight.bold, fontSize: 20) : TextStyle(),
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

class TradfriControlOutletScreen extends DeviceScreen {
  final TradfriControlOutlet tradfriControlOutlet;
  TradfriControlOutletScreen(this.tradfriControlOutlet);

  @override
  State<StatefulWidget> createState() => _TradfriControlOutletScreenState();
}

class _TradfriControlOutletScreenState extends State<TradfriControlOutletScreen> {
  DateTime dateTime = DateTime.now();
  late StreamSubscription sub;

  @override
  void initState() {
    super.initState();
    sub = this.widget.tradfriControlOutlet.listenOnUpdateFromServer((p0) {
      setState(() {});
    });
  }

  @override
  void deactivate() {
    super.deactivate();
    sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text(this.widget.tradfriControlOutlet.baseModel.friendlyName),
      ),
      body: Container(
        decoration: ThemeManager.getBackgroundDecoration(context),
        child: buildBody(this.widget.tradfriControlOutlet.baseModel),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.power_settings_new),
        onPressed: () => this.widget.tradfriControlOutlet.sendToServer(sm.MessageType.Update, sm.Command.Off, []),
      ),
    );
  }

  Widget buildBody(TradfriControlOutletModel model) {
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
