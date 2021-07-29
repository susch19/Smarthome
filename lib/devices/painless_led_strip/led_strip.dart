import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:signalr_client/signalr_client.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/devices/base_model.dart';
import 'package:smarthome/devices/device.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/painless_led_strip/led_strip_model.dart';
import 'package:smarthome/models/message.dart' as sm;
import 'package:shared_preferences/shared_preferences.dart';

class LedStrip extends Device<LedStripModel> {
  LedStrip(int? id, BaseModel name, HubConnection connection, IconData icon, SharedPreferences? prefs)
      : super(id, name as LedStripModel, connection, icon, prefs);


  @override
  void navigateToDevice(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LedStripScreen(this)));
  }

  @override
  Widget dashboardView() {
    return Column(
      children: getDefaultHeader(
              Container(
                margin: EdgeInsets.only(right: 32.0),
              ),
              baseModel.isConnected) +
          (<Widget>[
            MaterialButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Essen fertig",
                    style: baseModel.colorMode == "Mode"
                        ? TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                        : TextStyle(),
                  ),
                ],
              ),
              onPressed: () => sendToServer(sm.MessageType.Update, sm.Command.Mode, []),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  child: Row(
                    children: [
                      Text(
                        "An",
                        style: baseModel.colorMode != "Off" && baseModel.colorMode != "Mode"
                            ? TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                            : TextStyle(),
                      ),
                    ],
                  ),
                  onPressed: () => sendToServer(sm.MessageType.Update, sm.Command.SingleColor, ["0xFF000000"]),
                ),
                MaterialButton(
                  child: Row(
                    children: [
                      Text(
                        "Aus",
                        style: baseModel.colorMode == "Off"
                            ? TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                            : TextStyle(),
                      ),
                    ],
                  ),
                  onPressed: () => sendToServer(sm.MessageType.Update, sm.Command.Off, []),
                ),
              ],
            ),
            (DeviceManager.showDebugInformation ? Text(baseModel.id.toString()) : Container())
          ]),
    ); // + printableInformation.map((f) => Text(f)).toList()));
  }

  @override
  DeviceTypes getDeviceType() {
    return DeviceTypes.LedStrip;
  }
}

class LedStripScreen extends DeviceScreen {
  final LedStrip strip;
  LedStripScreen(this.strip);

  @override
  State<StatefulWidget> createState() => _LedStripScreenState();
}

class _LedStripScreenState extends State<LedStripScreen> {
  RGBW rgbw = new RGBW();
  DateTime dateTime = DateTime.now();
  static const int colordelay = 50;
  double brightness = 255.0;
  double delay = 30.0;
  double numLeds = 94.0;
  late StreamSubscription sub;

  int get idelay => delay.toInt();
  int get ibrightness => brightness.toInt();

  @override
  void initState() {
    super.initState();
    sub = this.widget.strip.listenOnUpdateFromServer((p0) {
      setState(() {});
    });
    this.rgbw.r = (this.widget.strip.baseModel.colorNumber & 0xFF) >> 0;
    this.rgbw.g = (this.widget.strip.baseModel.colorNumber & 0xFF00) >> 8;
    this.rgbw.b = (this.widget.strip.baseModel.colorNumber & 0xFF0000) >> 16;
    this.rgbw.w = (this.widget.strip.baseModel.colorNumber & 0xFF000000) >> 24;
    brightness = this.widget.strip.baseModel.brightness.toDouble();
    delay = this.widget.strip.baseModel.delay.toDouble();
    numLeds = this.widget.strip.baseModel.numberOfLeds.toDouble();
  }

  @override
  void deactivate(){
    super.deactivate();
    sub.cancel();
  }

  void sliderChange(Function f, int dateTimeMilliseconds, [int? val]) {
    if (DateTime.now().isAfter(dateTime.add(new Duration(milliseconds: dateTimeMilliseconds)))) {
      Function.apply(f, val == null ? [] : [val]);
      dateTime = DateTime.now();
    }
  }

  void changeColor() {
    this
        .widget
        .strip
        .sendToServer(sm.MessageType.Options, sm.Command.Color, ["0x${rgbw.hw + rgbw.hb + rgbw.hg + rgbw.hr}"]);
  }

  void changeDelay(int delay) {
    this.widget.strip.sendToServer(sm.MessageType.Options, sm.Command.Delay, ["$delay"]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text("LED Strip "),
      ),
      body: ListView(
        children: <Widget>[
          new ListTile(
            leading: this.widget.strip.baseModel.colorMode == "Off" ? Icon(Icons.check) : Text(""),
            title: new MaterialButton(
              child: const Text(
                'Off',
              ),
              onPressed: () => this.widget.strip.sendToServer(sm.MessageType.Update, sm.Command.Off, []),
            ),
            trailing: Text(""),
          ),
          new ListTile(
            leading: this.widget.strip.baseModel.colorMode == "RGB" ? Icon(Icons.check) : Text(""),
            title: new MaterialButton(
              child: const Text(
                'Fast RGB',
              ),
              onPressed: () => this.widget.strip.sendToServer(sm.MessageType.Update, sm.Command.RGB, []),
            ),
            trailing: Text(""),
          ),
          new ListTile(
            leading: this.widget.strip.baseModel.colorMode == "Mode" ? Icon(Icons.check) : Text(""),
            title: new MaterialButton(
              child: const Text(
                'Flicker',
              ),
              onPressed: () => this.widget.strip.sendToServer(sm.MessageType.Update, sm.Command.Mode, []),
            ),
            trailing: Text(""),
          ),
          new ListTile(
            leading: this.widget.strip.baseModel.colorMode == "Strobo" ? Icon(Icons.check) : Text(""),
            title: new MaterialButton(
              child: const Text(
                'Strobo',
              ),
              onPressed: () => this.widget.strip.sendToServer(sm.MessageType.Update, sm.Command.Strobo, []),
            ),
            trailing: Text(""),
          ),
          new ListTile(
            leading: this.widget.strip.baseModel.colorMode == "RGBCycle" ? Icon(Icons.check) : Text(""),
            title: new MaterialButton(
              child: const Text(
                'RGBCycle',
              ),
              onPressed: () => this.widget.strip.sendToServer(sm.MessageType.Update, sm.Command.RGBCycle, []),
            ),
            trailing: Text(""),
          ),
          new ListTile(
            leading: this.widget.strip.baseModel.colorMode == "LightWander" ? Icon(Icons.check) : Text(""),
            title: new MaterialButton(
              child: const Text(
                'Wander',
              ),
              onPressed: () => this.widget.strip.sendToServer(sm.MessageType.Update, sm.Command.LightWander, []),
            ),
            trailing: Text(""),
          ),
          new ListTile(
            leading: this.widget.strip.baseModel.colorMode == "RGBWander" ? Icon(Icons.check) : Text(""),
            title: new MaterialButton(
              child: const Text(
                'Wander RGB',
              ),
              onPressed: () => this.widget.strip.sendToServer(sm.MessageType.Update, sm.Command.RGBWander, []),
            ),
            trailing: Text(""),
          ),
          new ListTile(
            leading: (this.widget.strip.baseModel.colorMode == "SingleColor" &&
                    this.widget.strip.baseModel.colorNumber == 0xFF000000)
                ? Icon(Icons.check)
                : Text(""),
            title: new MaterialButton(
                child: const Text(
                  'White',
                ),
                onPressed: () {
                  this.widget.strip.sendToServer(sm.MessageType.Update, sm.Command.SingleColor, ["0xFF000000"]);
                }),
            trailing: Text(""),
          ),
          new ListTile(
            leading: this.widget.strip.baseModel.reverse ? Icon(Icons.check) : Text(""),
            title: new MaterialButton(
              child: const Text(
                'Reverse',
              ),
              onPressed: () => this.widget.strip.sendToServer(sm.MessageType.Options, sm.Command.Reverse, []),
            ),
            trailing: Text(""),
          ),
          new ExpansionTile(
            leading: (this.widget.strip.baseModel.colorMode == "SingleColor" &&
                    this.widget.strip.baseModel.colorNumber != 0xFF000000)
                ? Icon(Icons.check)
                : Text(""),
            title: const Text(
              'SingleColor',
            ),
            children: <Widget>[
              new ListTile(
                subtitle: new Text("Red: ${rgbw.hr} | ${rgbw.r}"),
                title: new Slider(
                  value: rgbw.dr,
                  onChanged: (d) {
                    setState(() => rgbw.dr = d);
                    sliderChange(changeColor, colordelay);
                  },
                  min: 0.0,
                  max: 255.0,
                  label: 'R',
                ),
              ),
              new ListTile(
                subtitle: new Text("Green: ${rgbw.hg} | ${rgbw.g}"),
                title: new Slider(
                  value: rgbw.dg,
                  onChanged: (d) {
                    setState(() => rgbw.dg = d);
                    sliderChange(changeColor, colordelay);
                  },
                  min: 0.0,
                  max: 255.0,
                  label: 'G',
                ),
              ),
              new ListTile(
                subtitle: new Text("Blue: ${rgbw.hb} | ${rgbw.b}"),
                title: new Slider(
                  value: rgbw.db,
                  onChanged: (d) {
                    setState(() => rgbw.db = d);
                    sliderChange(changeColor, colordelay);
                  },
                  min: 0.0,
                  max: 255.0,
                  label: 'B',
                ),
              ),
              new ListTile(
                subtitle: new Text("White: ${rgbw.hw} | ${rgbw.w}"),
                title: new Slider(
                  value: rgbw.dw,
                  onChanged: (d) {
                    setState(() => rgbw.dw = d);
                    sliderChange(changeColor, colordelay);
                  },
                  min: 0.0,
                  max: 255.0,
                  label: 'W',
                ),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    'Color: ${rgbw.hw + rgbw.hb + rgbw.hg + rgbw.hr}',
                  ),
                  new MaterialButton(
                    child: new Text(
                      'SingleColor',
                    ),
                    onPressed: () => this.widget.strip.sendToServer(
                        sm.MessageType.Update, sm.Command.SingleColor, ["0x${rgbw.hw + rgbw.hb + rgbw.hg + rgbw.hr}"]),
                  ),
                ],
              )
            ],
          ),
          new ListTile(
            subtitle: new Text("Delay ${idelay.toString()}ms"),
            title: new GestureDetector(
              child: new Slider(
                value: delay,
                onChanged: (d) {
                  setState(() => delay = d);
                  sliderChange(changeDelay, idelay, idelay);
                },
                min: 0.0,
                max: 1000.0,
                label: '${delay.round()}',
              ),
              onTapCancel: () => changeDelay(idelay),
            ),
          ),
          new ListTile(
            subtitle: new Text("Brightness ${brightness.toInt().toString()}"),
            title: new GestureDetector(
              child: new Slider(
                value: brightness,
                onChanged: (d) {
                  setState(() => brightness = d);
                  this.widget.strip.sendToServer(
                      sm.MessageType.Options, sm.Command.Brightness, ["0x${(brightness.toInt()).toRadixString(16)}"]);
                },
                min: 0.0,
                max: 255.0,
                label: '${brightness.round()}',
              ),
            ),
          ),
          new ListTile(
            subtitle: new Text("Num Leds ${numLeds.toInt().toString()}"),
            title: new GestureDetector(
              child: new Slider(
                value: numLeds,
                onChanged: (d) {
                  setState(() => numLeds = d);
                  this.widget.strip.sendToServer(
                      sm.MessageType.Options, sm.Command.Calibration, ["0x${(numLeds.toInt()).toRadixString(16)}"]);
                },
                min: 0.0,
                max: 255.0,
                label: '${numLeds.round()}',
              ),
            ),
          ),
          // ListTile(
          //   title: Text(this.widget.strip.baseModel.toJson().toString())
          // ),
        ],
      ),
    );
  }
}

class ForInput {
  TextEditingController textEditingController = new TextEditingController();
  String errorText = '';
  GlobalKey key = new GlobalKey();
  InputDecoration? decoration;
  FocusNode focusNode = new FocusNode();
}

class RGBW {
  int r = 0;
  int g = 0;
  int b = 0;
  int w = 0;

  double get dr => r.toDouble();
  double get dg => g.toDouble();
  double get db => b.toDouble();
  double get dw => w.toDouble();
  String get hr => _toRadixBase16(r);
  String get hg => _toRadixBase16(g);
  String get hb => _toRadixBase16(b);
  String get hw => _toRadixBase16(w);

  set dr(double val) {
    r = val.toInt();
  }

  set dg(double val) {
    g = val.toInt();
  }

  set db(double val) {
    b = val.toInt();
  }

  set dw(double val) {
    w = val.toInt();
  }

  String _toRadixBase16(int val) {
    String ret = val.toRadixString(16);
    if (ret.length == 1) ret = "0" + ret;
    return ret;
  }

  RGBW();

  RGBW.rgb(int red, int green, int blue) {
    r = red;
    g = green;
    b = blue;
  }

  RGBW.rgbw(int red, int green, int blue, int white) {
    RGBW.rgb(red, green, blue);
    w = white;
  }

  RGBW.color(Color c) {
    RGBW.rgb(c.red, c.green, c.blue);
  }
}
