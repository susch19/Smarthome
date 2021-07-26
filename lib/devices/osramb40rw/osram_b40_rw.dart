import 'package:flutter/material.dart';
// import 'package:signalr_client/signalr_client.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/devices/device.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/models/message.dart' as sm;
import 'package:shared_preferences/shared_preferences.dart';

import '../device_manager.dart';
import 'osram_b40_rw_model.dart';

class OsramB40RW extends Device<OsramB40RWModel> {
  OsramB40RW(int? id, OsramB40RWModel model, HubConnection connection, IconData icon, SharedPreferences? prefs)
      : super(id, model, connection, icon, prefs);

  Function? func;

  @override
  State<StatefulWidget> createState() => _OsramB40RWState();

  @override
  Future sendToServer(sm.MessageType messageType, sm.Command command, [List<String>? parameters]) async {
    await super.sendToServer(messageType, command, parameters);
    var message = new sm.Message(id, messageType, command, parameters);
    var s = message.toJson();
    await connection.invoke("Update", args: <Object>[message.toJson()]);
  }

  @override
  void updateFromServer(Map<String, dynamic> message) {
     baseModel = OsramB40RWModel.fromJson(message);
    if (func != null) func!(() {});
  }

  @override
  void navigateToDevice(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => OsramB40RWScreen(this)));
  }

  @override
  Widget dashboardView() {
    return Column(
        children: getDefaultHeader(Container(
            margin: EdgeInsets.only(right: 32.0),
          ), baseModel.available)
          +(<Widget>[
    
      MaterialButton(
        child: Text("An/Aus"),
        onPressed: () async => await sendToServer(sm.MessageType.Update, sm.Command.Off),
      )
    ]));
  }

  @override
  DeviceTypes getDeviceType() {
    return DeviceTypes.OsramB40RW;
  }
}

class _OsramB40RWState extends State<OsramB40RW> {
  @override
  Widget build(BuildContext context) => OsramB40RWScreen(this.widget);
}

class OsramB40RWScreen extends DeviceScreen {
  final OsramB40RW osramB40RW;
  OsramB40RWScreen(this.osramB40RW);

  @override
  State<StatefulWidget> createState() => _OsramB40RWScreenState();
}

class _OsramB40RWScreenState extends State<OsramB40RWScreen> {
  DateTime dateTime = DateTime.now();

  void sliderChange(Function f, int dateTimeMilliseconds, [double? val]) {
    if (DateTime.now().isAfter(dateTime.add(new Duration(milliseconds: dateTimeMilliseconds)))) {
      Function.apply(f, val == null ? [] : [val]);
      dateTime = DateTime.now();
    }
  }

  @override
  void initState() {
    super.initState();
    this.widget.osramB40RW.func = setState;
  }

  @override
  void deactivate() {
    super.deactivate();
    this.widget.osramB40RW.func = null;
  }

  void changeDelay(double? delay) {
    this.widget.osramB40RW.sendToServer(sm.MessageType.Options, sm.Command.Delay, [delay.toString()]);
  }

  void changeBrightness(double brightness) {
    this.widget.osramB40RW.sendToServer(sm.MessageType.Update, sm.Command.Brightness, [brightness.round().toString()]);
  }

  void changeColorTemp(double colorTemp) {
    this.widget.osramB40RW.sendToServer(sm.MessageType.Update, sm.Command.Temp, [colorTemp.round().toString()]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text(this.widget.osramB40RW.baseModel.friendlyName),
      ),
      body: buildBody(this.widget.osramB40RW.baseModel),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.power_settings_new
        ),
        onPressed: () => this.widget.osramB40RW.sendToServer(sm.MessageType.Update, sm.Command.Off, []),
      ),
    );
  }

  Widget buildBody(OsramB40RWModel model) {
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
        ListTile(
          title: Text("Helligkeit aktuell " + model.brightness.toStringAsFixed(0)),
          subtitle: GestureDetector(
            child: Slider(
              value: model.brightness.toDouble(), // 153 - 370
              onChanged: (d) {
                setState(() => model.brightness = d.round());
                sliderChange(changeBrightness, 500, d);
              },
              min: 0.0,
              max: 100.0,
              divisions: 100,
              label: '${model.brightness}',
            ),
            onTapCancel: () => changeBrightness(model.brightness.toDouble()),
          ),
        ),
        ListTile(
          title: Text("Farbtemparatur aktuell " + (model.colorTemp - 153).toStringAsFixed(0)),
          subtitle: GestureDetector(
            child: Slider(
              value: ((model.colorTemp- 153).clamp(0, 217)).toDouble(),
              onChanged: (d) {
                setState(() => model.colorTemp = d.round() + 153);
                sliderChange(changeColorTemp, 500, d + 153.0);
              },
              min: 0.0,
              max: 217.0,
              divisions: 217,
              label: '${(model.colorTemp- 153).clamp(0, 217)}',
            ),
            onTapCancel: () => changeColorTemp(model.colorTemp.toDouble()),
          ),
        ),
        ListTile(
          title: Text("Übergangszeit aktuell " + model.transitionTime.toStringAsFixed(1) + " Sekunden"),
          subtitle: GestureDetector(
            child: Slider(
              value: model.transitionTime,
              onChanged: (d) {
                setState(() => model.transitionTime = d);
                sliderChange(changeDelay, 500, d);
              },
              min: 0.0,
              max: 10.0,
              divisions: 100,
              label: '${model.transitionTime}',
            ),
            onTapCancel: () => changeDelay(model.transitionTime),
          ),
        ),
      ],
    );
  }
}
