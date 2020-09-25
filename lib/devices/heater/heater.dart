import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:signalr_client/signalr_client.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/controls/double_wheel.dart';
import 'package:smarthome/devices/device.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/heater/heater_config.dart';
import 'package:smarthome/models/message.dart' as sm;
import 'package:smarthome/icons/icons.dart';

import 'temp_scheduling.dart';

class Heater extends Device<HeaterModel> {
  Function func;
  Heater(int id, HeaterModel baseModel, HubConnection connection, Icon icon, SharedPreferences prefs)
      : super(id, baseModel, connection, icon, prefs);

  @override
  _HeaterState createState() => _HeaterState();

  @override
  void navigateToDevice(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => HeaterScreen(this)));
  }

  @override
  void updateFromServer(Map<String, dynamic> message) {
    baseModel = HeaterModel.fromJson(message);
    prefs?.setString("Json" + id.toString(), jsonEncode(message));
    if (func != null) func(() {});
  }

  @override
  Future sendToServer(sm.MessageType messageType, sm.Command command, List<String> parameters) async {
    super.sendToServer(messageType, command, parameters);
    var message = new sm.Message(id, messageType, command, parameters);
    await connection.invoke("Update", args: <Object>[message.toJson()]);
  }

//{"nodeId":3257168818,"subs":[{"nodeId":3257232294},{"nodeId":3257153067}]},{"nodeId":3257144719,"subs":[{"nodeId":3257232527}]}]},{"nodeId":3257231619}]},{"nodeId":3257233774}]}]}]}
  @override
  Widget dashboardView() {
    XiaomiTempSensor xs = DeviceManager.devices.firstWhere((x) => x.id == baseModel.xiaomiTempSensor, orElse: () {
      return;
    });
    return Column(
        children: (<Widget>[
              Row(
                children: [icon, Icon((baseModel.isConnected ? Icons.check : Icons.close))],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              Text(baseModel.friendlyName.toString()),
              Text((baseModel.temperature?.temperature?.toStringAsFixed(1) ?? "") +
                  " °C/" +
                  (baseModel.currentConfig == null
                      ? ""
                      : ((baseModel.currentConfig?.temperature?.toStringAsFixed(1) ?? "") + "°C"))),
              (xs == null ? Text(baseModel.xiaomiTempSensor.toString()) : Text(xs.baseModel.friendlyName)),
            ] +
            (DeviceManager.showDebugInformation ? [Text(baseModel.id.toString())] : <Widget>[])));
  }

  @override
  DeviceTypes getDeviceType() {
    return DeviceTypes.Heater;
  }
}

class _HeaterState extends State<Heater> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Column(
        children: <Widget>[
          this.widget.icon,
          Column(
              // children: this.widget.printableInformation.map((s) => Text(s)).toList(),
              ),
        ],
      ),
      onPressed: () {
        this.widget.navigateToDevice(context);
      },
    );
  }
}

class HeaterScreen extends DeviceScreen {
  Heater heater;

  HeaterScreen(this.heater);

  @override
  State<StatefulWidget> createState() => _HeaterScreenState();
}

class _HeaterScreenState extends State<HeaterScreen> {
  double temp = 11;
  String tempString() => temp.toStringAsPrecision(3) + "°C";
  TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();

    textEditingController = TextEditingController(text: tempString());
    this.widget.heater.func = setState;
  }

  @override
  void deactivate() {
    super.deactivate();
    this.widget.heater.func = null;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    XiaomiTempSensor xs =
        DeviceManager.devices.firstWhere((x) => x.id == this.widget.heater.baseModel.xiaomiTempSensor, orElse: () {
      return;
    });

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: [
              Tab(
                icon: Text("Heater " + this.widget.heater.baseModel.friendlyName),
              ),
              Tab(icon: Icon(SmarthomeIcons.temperature)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildColumnView(width, xs),
            ((xs?.id ?? -1) > 0)
                ? XiaomiTempSensorScreen(xs, showAppBar: false)
                : Text("Kein Xiaomi Temperatursensor vorhanden")
          ],
        ),
      ),
    );
  }

  _pushTempSettings(BuildContext context) async {
    var dc = await widget.heater.getFromServer("GetConfig", [widget.heater.id]);
    List<HeaterConfig> hc;
    if (dc != "[]" && dc != null)
      hc = new List<HeaterConfig>.from(jsonDecode(dc).map((f) => HeaterConfig.fromJson(f)));
    else
      hc = new List<HeaterConfig>();

    final res = await Navigator.push(
        context,
        new MaterialPageRoute<List<HeaterConfig>>(
            builder: (BuildContext context) => TempScheduling(heaterConf: hc), fullscreenDialog: true));
    if (res == null) return;

    widget.heater.sendToServer(sm.MessageType.Options, sm.Command.Temp, res.map((f) => jsonEncode(f)).toList());
  }

  buildColumnView(double width, XiaomiTempSensor xs) {
    return Column(
      children: (DeviceManager.showDebugInformation
              ? <Widget>[
                  Row(
                    children: <Widget>[Text("Id: " + widget.heater.baseModel.id.toString())],
                  ),
                  Row(
                    children: <Widget>[Text("" + widget.heater.baseModel.firmwareVersion.toString())],
                  )
                ]
              : <Widget>[]) +
          ([
            Row(
              children: <Widget>[
                Text("Erreichbar: " + ((widget.heater.baseModel.isConnected) ?? false ? "Ja" : "Nein"))
              ],
            ),
            //Text(this.widget.heater.printableInformation.length > 0 ? this.widget.heater.printableInformation.first : ""),
            Row(
              children: <Widget>[
                Text("Ausgelesene Temperatur: "),
                Text(widget.heater.baseModel.temperature?.temperature?.toStringAsFixed(1) ?? "Keine Daten"),
                Text(widget.heater.baseModel.temperature?.temperature != null ? "°C" : ""),
              ],
            ),
            Row(
              children: <Widget>[
                Text("Zuletzt Empfangen: "),
                Text(widget.heater.baseModel.temperature == null
                    ? "Keine Daten vorliegend"
                    : DayOfWeekToStringMap[widget.heater.baseModel.temperature.dayOfWeek] +
                        " " +
                        widget.heater.baseModel.temperature.timeOfDay.format(context)),
              ],
            ),
            Row(
              children: <Widget>[
                Text("Aktuelles Ziel: "),
                Text(widget.heater.baseModel.currentConfig?.temperature == null
                    ? "Kein Ziel"
                    : widget.heater.baseModel.currentConfig.temperature.toStringAsFixed(1) +
                        "°C " +
                        "(" +
                        DayOfWeekToStringMap[widget.heater.baseModel.currentConfig.dayOfWeek] +
                        " " +
                        widget.heater.baseModel.currentConfig.timeOfDay.format(context) +
                        ")"),
              ],
            ),
            Row(
              children: <Widget>[
                Text("Kalibrierung: "),
                Text(widget.heater.baseModel.currentCalibration?.temperature == null
                    ? "Kein Ziel"
                    : widget.heater.baseModel.currentCalibration.temperature.toStringAsFixed(1) +
                        "°C " +
                        "(" +
                        DayOfWeekToStringMap[widget.heater.baseModel.currentCalibration.dayOfWeek] +
                        " " +
                        widget.heater.baseModel.currentCalibration.timeOfDay.format(context) +
                        ")"),
              ],
            ),
            Row(
              children: <Widget>[
                Text("Wunschtemperatur: "),
                WheelChooser.double(
                  onValueChanged: (s) => temp = s,
                  horizontal: true,
                  listWidth: 40.0,
                  listHeight: width / 2.5,
                  minValue: 5.0,
                  maxValue: 35.1,
                  step: 0.1,
                  initValue: (((widget.heater.baseModel).temperature?.temperature ?? 0) < 5)
                      ? 21.0
                      : (widget.heater.baseModel).temperature.temperature,
                  diameter: 2,
                  itemSize: 48,
                  selectTextStyle: TextStyle(color: Colors.black, fontSize: 14),
                  unSelectTextStyle: TextStyle(color: Colors.black45, fontSize: 11),
                ),
                MaterialButton(
                  onPressed: () =>
                      this.widget.heater.sendToServer(sm.MessageType.Update, sm.Command.Temp, <String>[temp.toString()]),
                  child: Text("SENDEN"),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text("Xiaomi Sensor:"),
                DropdownButton(
                  items: (DeviceManager.getDevicesOfType<XiaomiTempSensor>()
                      .map((f) => DropdownMenuItem(
                            child: Text("${f.baseModel.friendlyName} ${f.baseModel.temperature}°C"),
                            value: f,
                          ))
                      .toList()),
                  onChanged: (a) {
                    this.widget.heater.sendToServer(sm.MessageType.Update, sm.Command.DeviceMapping, [
                      a.id.toString(),
                      this.widget.heater.baseModel.xiaomiTempSensor == null
                          ? "0"
                          : this.widget.heater.baseModel.xiaomiTempSensor.toString()
                    ]);
                    this.widget.heater.baseModel.xiaomiTempSensor = a.id;
                  },
                  value: xs,
                ),
              ],
            ),
            FlatButton(
              onPressed: () => this.widget.heater.sendToServer(sm.MessageType.Options, sm.Command.Mode, []),
              child: Text("HeizLED an/ausschalten"),
            ),
            FlatButton(
              onPressed: () => _pushTempSettings(context),
              child: Text("Temperatur Einstellungen"),
            ),
          ]),
    );
  }
}
