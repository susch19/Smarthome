import 'package:flutter/material.dart';
import 'package:signalr_client/signalr_client.dart';
import 'package:smarthome/devices/device.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/models/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../device_manager.dart';
import 'floalt_panel_model.dart';

class FloaltPanel extends Device<FloaltPanelModel> {
  FloaltPanel(int id, FloaltPanelModel model, HubConnection connection, Icon icon, SharedPreferences prefs)
      : super(id, model, connection, icon, prefs);

  Function func;

  @override
  State<StatefulWidget> createState() => _FloaltPanelState();

  @override
  Future sendToServer(MessageType messageType, Command command, [List<String> parameters]) async {
    await super.sendToServer(messageType, command, parameters);
    var message = new Message(id, messageType, command, parameters);
    var s = message.toJson();
    await connection.invoke("Update", args: <Object>[message.toJson()]);
  }

  @override
  void updateFromServer(Map<String, dynamic> message) {
    baseModel = FloaltPanelModel.fromJson(message);
    if (func != null) func(() {});
  }

  @override
  void navigateToDevice(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FloaltPanelScreen(this)));
  }

  @override
  Widget dashboardView() {
    return Column(
        children: (<Widget>[
      Row(children:[icon, Icon((baseModel.isConnected ? Icons.check : Icons.close))], mainAxisAlignment: MainAxisAlignment.center,),
      Text(baseModel?.friendlyName ?? baseModel?.id.toString() ?? ""),
      MaterialButton(
        child: Text("An/Aus"),
        onPressed: () async => await sendToServer(MessageType.Update, Command.Off),
      )
    ]));
  }

  @override
  DeviceTypes getDeviceType() {
    return DeviceTypes.FloaltPanel;
  }
}

class _FloaltPanelState extends State<FloaltPanel> {
  @override
  Widget build(BuildContext context) => FloaltPanelScreen(this.widget);
}

class FloaltPanelScreen extends DeviceScreen {
  final FloaltPanel floaltPanel;
  FloaltPanelScreen(this.floaltPanel);

  @override
  State<StatefulWidget> createState() => _FloaltPanelScreenState();
}

class _FloaltPanelScreenState extends State<FloaltPanelScreen> {
  DateTime dateTime = DateTime.now();

  void sliderChange(Function f, int dateTimeMilliseconds, [double val]) {
    if (DateTime.now().isAfter(dateTime.add(new Duration(milliseconds: dateTimeMilliseconds)))) {
      Function.apply(f, val == null ? [] : [val]);
      dateTime = DateTime.now();
    }
  }

  @override
  void initState() {
    super.initState();
    this.widget.floaltPanel.func = setState;
  }

  @override
  void deactivate() {
    super.deactivate();
    this.widget.floaltPanel.func = null;
  }

  void changeDelay(double delay) {
    this.widget.floaltPanel.sendToServer(MessageType.Options, Command.Delay, [delay.toString()]);
  }

  void changeBrightness(double brightness) {
    this.widget.floaltPanel.sendToServer(MessageType.Update, Command.Brightness, [brightness.round().toString()]);
  }

  void changeColorTemp(double colorTemp) {
    this.widget.floaltPanel.sendToServer(MessageType.Update, Command.Temp, [colorTemp.round().toString()]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text(this.widget.floaltPanel.baseModel.friendlyName),
      ),
      body: buildBody(this.widget.floaltPanel.baseModel),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.power_settings_new
        ),
        onPressed: () => this.widget.floaltPanel.sendToServer(MessageType.Update, Command.Off, []),
      ),
    );
  }

  Widget buildBody(FloaltPanelModel model) {
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
              value: model.brightness.toDouble(),
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
          title: Text("Farbtemparatur aktuell " + (model.colorTemp - 204).toStringAsFixed(0)),
          subtitle: GestureDetector(
            child: Slider(
              value: (model.colorTemp - 204).toDouble(),
              onChanged: (d) {
                setState(() => model.colorTemp = d.round() + 204);
                sliderChange(changeColorTemp, 500, d + 204.0);
              },
              min: 0.0,
              max: 204.0,
              divisions: 204,
              label: '${model.colorTemp - 204}',
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
