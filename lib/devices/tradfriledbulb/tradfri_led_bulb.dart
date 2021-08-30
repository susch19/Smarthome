import 'dart:async';

import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/controls/cicle_painter.dart';
import 'package:smarthome/controls/gradient_rounded_rect_slider_track_shape.dart';
import 'package:smarthome/devices/device.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/models/message.dart' as sm;

import '../device_manager.dart';
import 'tradfri_led_bulb_model.dart';

class TradfriLedBulb extends Device<TradfriLedBulbModel> {
  TradfriLedBulb(int? id, String typeName, TradfriLedBulbModel model, HubConnection connection, IconData icon)
      : super(id, typeName, model, connection, icon);

  @override
  void navigateToDevice(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TradfriLedBulbScreen(this)));
  }

  @override
  Widget? lowerLeftWidget() {
    if (baseModel.color != null) {
      var colorNum = int.parse(baseModel.color!.replaceFirst('#', ''), radix: 16);
      var r = (colorNum & 0xFF0000) >> 16;
      var g = (colorNum & 0xFF00) >> 8;
      var b = (colorNum & 0xFF) >> 0;
      return CustomPaint(
        painter: CirclePainter(10, Color.fromRGBO(r, g, b, 1), Offset(0, 10)),
      );
    }
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
        DeviceManager.showDebugInformation ? Text(id.toString()) : Container()
      ],
    );
  }

  @override
  DeviceTypes getDeviceType() {
    return DeviceTypes.TradfriLedBulb;
  }
}

class TradfriLedBulbScreen extends DeviceScreen {
  final TradfriLedBulb tradfriLedBulb;
  TradfriLedBulbScreen(this.tradfriLedBulb);

  @override
  State<StatefulWidget> createState() => _TradfriLedBulbScreenState();
}

class _TradfriLedBulbScreenState extends State<TradfriLedBulbScreen> {
  DateTime dateTime = DateTime.now();
  late StreamSubscription sub;
  RGB rgb = RGB();

  @override
  void initState() {
    super.initState();
    sub = this.widget.tradfriLedBulb.listenOnUpdateFromServer((p0) {
      setState(() {});
    });
    if (this.widget.tradfriLedBulb.baseModel.color != null) {
      var colorNum = int.parse(this.widget.tradfriLedBulb.baseModel.color!.replaceFirst('#', ''), radix: 16);
      this.rgb.r = (colorNum & 0xFF0000) >> 16;
      this.rgb.g = (colorNum & 0xFF00) >> 8;
      this.rgb.b = (colorNum & 0xFF) >> 0;
    }
    brightness = this.widget.tradfriLedBulb.baseModel.brightness.toDouble();
  }

  @override
  void deactivate() {
    super.deactivate();
    sub.cancel();
  }

  void changeBrightness(double brightness) {
    this
        .widget
        .tradfriLedBulb
        .sendToServer(sm.MessageType.Update, sm.Command.Brightness, [brightness.round().toString()]);
  }

  double brightness = 255.0;

  int get ibrightness => brightness.toInt();

  void changeColor() {
    this.widget.tradfriLedBulb.sendToServer(sm.MessageType.Update, sm.Command.Color, ["#${rgb.hr + rgb.hg + rgb.hb}"]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text(this.widget.tradfriLedBulb.baseModel.friendlyName),
      ),
      body: Container(
        decoration: ThemeManager.getBackgroundDecoration(context),
        child: buildBody(this.widget.tradfriLedBulb.baseModel),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.power_settings_new),
        onPressed: () => this.widget.tradfriLedBulb.sendToServer(sm.MessageType.Update, sm.Command.Off, []),
      ),
    );
  }

  Widget buildBody(TradfriLedBulbModel model) {
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
            child: SliderTheme(
              child: Slider(
                value: model.brightness.toDouble(),
                onChanged: (d) {
                  setState(() => model.brightness = d.round());
                },
                min: 0.0,
                max: 100.0,
                divisions: 100,
                label: '${model.brightness}',
                onChangeEnd: (c) => changeBrightness(model.brightness.toDouble()),
              ),
              data: SliderTheme.of(context).copyWith(
                  trackShape: GradientRoundedRectSliderTrackShape(
                      LinearGradient(colors: [Colors.grey.shade800, Colors.white]))),
            ),
          ),
        ),
        new ListTile(
          subtitle: new Text("Red: ${rgb.hr} | ${rgb.r}"),
          title: new Slider(
            value: rgb.dr,
            onChanged: (d) {
              setState(() => rgb.dr = d);
            },
            onChangeEnd: (a) => changeColor(),
            min: 0.0,
            max: 255.0,
            label: 'R',
          ),
        ),
        new ListTile(
          subtitle: new Text("Green: ${rgb.hg} | ${rgb.g}"),
          title: new Slider(
            value: rgb.dg,
            onChanged: (d) {
              setState(() => rgb.dg = d);
            },
            onChangeEnd: (a) => changeColor(),
            min: 0.0,
            max: 255.0,
            label: 'G',
          ),
        ),
        new ListTile(
          subtitle: new Text("Blue: ${rgb.hb} | ${rgb.b}"),
          title: new Slider(
            value: rgb.db,
            onChanged: (d) {
              setState(() => rgb.db = d);
            },
            onChangeEnd: (a) => changeColor(),
            min: 0.0,
            max: 255.0,
            label: 'B',
          ),
        ),
      ],
    );
  }
}

class RGB {
  int r = 0;
  int g = 0;
  int b = 0;

  double get dr => r.toDouble();
  double get dg => g.toDouble();
  double get db => b.toDouble();
  String get hr => _toRadixBase16(r);
  String get hg => _toRadixBase16(g);
  String get hb => _toRadixBase16(b);

  set dr(double val) {
    r = val.toInt();
  }

  set dg(double val) {
    g = val.toInt();
  }

  set db(double val) {
    b = val.toInt();
  }

  String _toRadixBase16(int val) {
    String ret = val.toRadixString(16);
    if (ret.length == 1) ret = "0" + ret;
    return ret;
  }

  RGB();

  RGB.rgb(int red, int green, int blue) {
    r = red;
    g = green;
    b = blue;
  }

  RGB.color(Color c) {
    RGB.rgb(c.red, c.green, c.blue);
  }
}
