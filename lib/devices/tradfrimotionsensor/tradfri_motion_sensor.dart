import 'dart:async';

import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/devices/device.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/icons/icons.dart';
import '../device_manager.dart';
import 'tradfri_motion_sensor_model.dart';
import '../../helper/datetime_helper.dart';

class TradfriMotionSensor extends Device<TradfriMotionSensorModel> {
  TradfriMotionSensor(int? id, String typeName, TradfriMotionSensorModel model, HubConnection connection, IconData icon)
      : super(id, typeName, model, connection, icon);

  @override
  void navigateToDevice(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TradfriMotionSensorScreen(this)));
  }

  @override
  Widget? lowerLeftWidget() {
    return Icon(
      (baseModel.battery > 80
          ? SmarthomeIcons.bat4
          : (baseModel.battery > 60
              ? SmarthomeIcons.bat3
              : (baseModel.battery > 40
                  ? SmarthomeIcons.bat2
                  : (baseModel.battery > 20 ? SmarthomeIcons.bat1 : SmarthomeIcons.bat_charge)))),
      size: 20,
    );
  }

  @override
  Widget dashboardCardBody() {
    return Column(
        children: (<Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text((baseModel.occupancy ? "Blockiert" : "Frei"),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              ]),
              Container(
                height: 2,
              ),
              Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.spaceEvenly,
                children: [
                  Text(
                      (baseModel.lastReceived.millisecondsSinceEpoch == -62135600400000
                          ? ""
                          : baseModel.lastReceived.subtract(Duration(seconds: baseModel.noMotion)).toDate()),
                      style: TextStyle()),
                ],
              ),
            ] +
            (DeviceManager.showDebugInformation
                ? <Widget>[
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(baseModel.lastReceived.toDate()),
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(baseModel.id.toRadixString(16))]),
                  ]
                : <Widget>[])));
  }

  @override
  DeviceTypes getDeviceType() {
    return DeviceTypes.TradfriMotionSensor;
  }
}

class TradfriMotionSensorScreen extends DeviceScreen {
  final TradfriMotionSensor tradfriMotionSensor;
  TradfriMotionSensorScreen(this.tradfriMotionSensor);

  @override
  State<StatefulWidget> createState() => _TradfriMotionSensorScreenState();
}

class _TradfriMotionSensorScreenState extends State<TradfriMotionSensorScreen> {
  DateTime dateTime = DateTime.now();
  late StreamSubscription sub;

  @override
  void initState() {
    super.initState();
    sub = this.widget.tradfriMotionSensor.listenOnUpdateFromServer((p0) {
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
        title: new Text(this.widget.tradfriMotionSensor.baseModel.friendlyName),
      ),
      body: Container(
        decoration: ThemeManager.getBackgroundDecoration(context),
        child: buildBody(this.widget.tradfriMotionSensor.baseModel),
      ),
    );
  }

  Widget buildBody(TradfriMotionSensorModel model) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text("Blockiert: " + (model.occupancy ? "Ja" : "Nein")),
        ),
        ListTile(
          title: Text("Letzte Bewegung: " + model.lastReceived.subtract(Duration(seconds: model.noMotion)).toDate()),
        ),
        ListTile(
          title: Text("Battery: " + model.battery.toStringAsFixed(0) + " %"),
        ),
        ListTile(
          title: Text("Verfügbar: " + (model.available ? "Ja" : "Nein")),
        ),
        ListTile(
          title: Text("Verbindungsqualität: " + (model.linkQuality.toString())),
        ),
        ListTile(
          title: Text("Zuletzt empfangen: " + model.lastReceived.toDate()),
        ),
      ],
    );
  }
}
