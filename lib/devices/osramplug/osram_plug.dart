import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:signalr_client/signalr_client.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/devices/device.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/models/message.dart' as sm;

import '../device_manager.dart';
import 'osram_plug_model.dart';

class OsramPlug extends Device<OsramPlugModel> {
  OsramPlug(int? id, String typeName, OsramPlugModel model, HubConnection connection, IconData icon)
      : super(id, typeName, model, connection, icon);

  @override
  void navigateToDevice(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => OsramPlugScreen(this)));
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
    return DeviceTypes.OsramPlug;
  }
}

class OsramPlugScreen extends DeviceScreen {
  final OsramPlug osramPlug;
  OsramPlugScreen(this.osramPlug);

  @override
  State<StatefulWidget> createState() => _OsramPlugScreenState();
}

class _OsramPlugScreenState extends State<OsramPlugScreen> {
  DateTime dateTime = DateTime.now();
  late StreamSubscription sub;

  void sliderChange(Function f, int dateTimeMilliseconds, [double? val]) {
    if (DateTime.now().isAfter(dateTime.add(new Duration(milliseconds: dateTimeMilliseconds)))) {
      Function.apply(f, val == null ? [] : [val]);
      dateTime = DateTime.now();
    }
  }

  @override
  void initState() {
    super.initState();
    sub = this.widget.osramPlug.listenOnUpdateFromServer((p0) {
      setState(() {});
    });
  }

  @override
  void deactivate() {
    super.deactivate();
    sub.cancel();
  }

  void changeDelay(double? delay) {
    this.widget.osramPlug.sendToServer(sm.MessageType.Options, sm.Command.Delay, [delay.toString()]);
  }

  void changeBrightness(double brightness) {
    this.widget.osramPlug.sendToServer(sm.MessageType.Update, sm.Command.Brightness, [brightness.round().toString()]);
  }

  void changeColorTemp(double colorTemp) {
    this.widget.osramPlug.sendToServer(sm.MessageType.Update, sm.Command.Temp, [colorTemp.round().toString()]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text(this.widget.osramPlug.baseModel.friendlyName),
      ),
      body: Container(
        decoration: ThemeManager.getBackgroundDecoration(context),
        child: buildBody(this.widget.osramPlug.baseModel),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.power_settings_new),
        onPressed: () => this.widget.osramPlug.sendToServer(sm.MessageType.Update, sm.Command.Off, []),
      ),
    );
  }

  Widget buildBody(OsramPlugModel model) {
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
