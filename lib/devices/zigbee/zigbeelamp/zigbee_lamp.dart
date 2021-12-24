// ignore_for_file: unnecessary_null_comparison

import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:signalr_client/signalr_client.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/controls/gradient_rounded_rect_slider_track_shape.dart';
import 'package:smarthome/devices/device.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/models/message.dart' as sm;

import '../../device_manager.dart';
import 'zigbee_lamp_model.dart';

class ZigbeeLamp extends Device<ZigbeeLampModel> {
  ZigbeeLamp(int? id, String typeName, ZigbeeLampModel model, HubConnection connection, IconData icon)
      : super(id, typeName, model, connection, icon);

  @override
  void navigateToDevice(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ZigbeeLampScreen(this)));
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
          onPressed: () => sendToServer(sm.MessageType.Update, sm.Command.SingleColor, []),
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
    return DeviceTypes.ZigbeeLamp;
  }
}

class ZigbeeLampScreen extends DeviceScreen {
  final ZigbeeLamp zigbeeLamp;
  ZigbeeLampScreen(this.zigbeeLamp);

  @override
  State<StatefulWidget> createState() => _ZigbeeLampScreenState();
}

class _ZigbeeLampScreenState extends State<ZigbeeLampScreen> {
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
    sub = this.widget.zigbeeLamp.listenOnUpdateFromServer((p0) {
      setState(() {});
    });
  }

  @override
  void deactivate() {
    super.deactivate();
    sub.cancel();
  }

  void changeDelay(double? delay) {
    this.widget.zigbeeLamp.sendToServer(sm.MessageType.Options, sm.Command.Delay, [delay.toString()]);
  }

  void changeBrightness(double brightness) {
    this.widget.zigbeeLamp.sendToServer(sm.MessageType.Update, sm.Command.Brightness, [brightness.round().toString()]);
  }

  void changeColorTemp(double colorTemp) {
    this.widget.zigbeeLamp.sendToServer(sm.MessageType.Update, sm.Command.Temp, [colorTemp.round().toString()]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text(this.widget.zigbeeLamp.baseModel.friendlyName),
      ),
      body: Container(
        decoration: ThemeManager.getBackgroundDecoration(context),
        child: buildBody(this.widget.zigbeeLamp.baseModel),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.power_settings_new),
        onPressed: () => this.widget.zigbeeLamp.sendToServer(sm.MessageType.Update, sm.Command.Off, []),
      ),
    );
  }

  Widget buildBody(ZigbeeLampModel model) {
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
          title: Text("Helligkeit " + model.brightness.toStringAsFixed(0)),
          subtitle: GestureDetector(
            child: SliderTheme(
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
              data: SliderTheme.of(context).copyWith(
                  trackShape: GradientRoundedRectSliderTrackShape(
                      LinearGradient(colors: [Colors.grey.shade800, Colors.white]))),
            ),
            onTapCancel: () => changeBrightness(model.brightness.toDouble()),
          ),
        ),
        ListTile(
          title: Text("Farbtemparatur " + (model.colorTemp - 204).toStringAsFixed(0)),
          subtitle: GestureDetector(
            child: SliderTheme(
              child: Slider(
                value: ((model.colorTemp - 204).clamp(0, 204)).toDouble(),
                onChanged: (d) {
                  setState(() => model.colorTemp = d.round() + 204);
                  sliderChange(changeColorTemp, 500, d + 204.0);
                },
                min: 0.0,
                max: 204.0,
                divisions: 204,
                label: '${model.colorTemp - 204}',
              ),
              data: SliderTheme.of(context).copyWith(
                  trackShape: GradientRoundedRectSliderTrackShape(
                      LinearGradient(colors: [Color.fromARGB(255, 255, 209, 163), Color.fromARGB(255, 255, 147, 44)]))),
            ),
            onTapCancel: () => changeColorTemp(model.colorTemp.toDouble()),
          ),
        ),
        ListTile(
          title: Text("Übergangszeit " + model.transitionTime.toStringAsFixed(1) + " Sekunden"),
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
