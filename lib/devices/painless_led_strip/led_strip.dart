import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:signalr_client/signalr_client.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/controls/gradient_rounded_rect_slider_track_shape.dart';
import 'package:smarthome/devices/base_model.dart';
import 'package:smarthome/devices/device.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/painless_led_strip/led_strip_model.dart';
import 'package:smarthome/models/message.dart' as sm;

import 'package:smarthome/helper/theme_manager.dart';

class LedStrip extends Device<LedStripModel> {
  LedStrip(int? id, String typeName, BaseModel name, HubConnection connection,
      IconData icon)
      : super(id, typeName, name as LedStripModel, connection, iconData: icon);

  @override
  void navigateToDevice(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => LedStripScreen(this)));
  }

  @override
  Widget dashboardCardBody() {
    return Column(children: <Widget>[
      Wrap(
        runAlignment: WrapAlignment.spaceEvenly,
        alignment: WrapAlignment.center,
        children: [
          MaterialButton(
            child: Text(
              "An",
              textAlign: TextAlign.center,
              style:
                  baseModel.colorMode != "Off" && baseModel.colorMode != "Mode"
                      ? TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                      : TextStyle(),
            ),
            onPressed: () => sendToServer(
                sm.MessageType.Update, sm.Command.SingleColor, ["0xFF000000"]),
          ),
          MaterialButton(
            child: Text(
              "Aus",
              textAlign: TextAlign.center,
              style: baseModel.colorMode == "Off"
                  ? TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                  : TextStyle(),
            ),
            onPressed: () =>
                sendToServer(sm.MessageType.Update, sm.Command.Off, []),
          ),
        ],
      ),
      MaterialButton(
        child: Container(
          margin: EdgeInsets.only(bottom: 4.0),
          child: Text(
            "Essen fertig",
            textAlign: TextAlign.center,
            style: baseModel.colorMode == "Mode"
                ? TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                : TextStyle(),
          ),
        ),
        onPressed: () =>
            sendToServer(sm.MessageType.Update, sm.Command.Mode, []),
      ),
      (DeviceManager.showDebugInformation
          ? Text(baseModel.id.toString())
          : Container())
    ]);
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

  static const TextStyle selectedTextStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 18);

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
  void deactivate() {
    super.deactivate();
    sub.cancel();
  }

  void sliderChange(Function f, int dateTimeMilliseconds, [int? val]) {
    if (DateTime.now().isAfter(
        dateTime.add(new Duration(milliseconds: dateTimeMilliseconds)))) {
      Function.apply(f, val == null ? [] : [val]);
      dateTime = DateTime.now();
    }
  }

  void changeColor() {
    this.widget.strip.sendToServer(sm.MessageType.Options, sm.Command.Color,
        ["0x${rgbw.hw + rgbw.hb + rgbw.hg + rgbw.hr}"]);
  }

  void changeDelay(int delay) {
    this
        .widget
        .strip
        .sendToServer(sm.MessageType.Options, sm.Command.Delay, ["$delay"]);
  }

  void changeBrightness(int delay) {
    this.widget.strip.sendToServer(sm.MessageType.Options,
        sm.Command.Brightness, ["0x${(brightness.toInt()).toRadixString(16)}"]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text("LED Strip "),
      ),
      body: Container(
        decoration: ThemeManager.getBackgroundDecoration(context),
        child: ListView(
          children: <Widget>[
            new ListTile(
              // leading: this.widget.strip.baseModel.colorMode == "Off" ? Icon(Icons.check) : Text(""),
              title: Center(
                child: this.widget.strip.baseModel.colorMode == "Off"
                    ? const Text(
                        'Off',
                        style: selectedTextStyle,
                      )
                    : Text("Off"),
              ),
              onTap: () => this
                  .widget
                  .strip
                  .sendToServer(sm.MessageType.Update, sm.Command.Off, []),
              trailing: Text(""),
            ),
            new ListTile(
              // leading: this.widget.strip.baseModel.colorMode == "RGB" ? Icon(Icons.check) : Text(""),
              title: Center(
                child: this.widget.strip.baseModel.colorMode == "RGB"
                    ? const Text(
                        'Fast RGB',
                        style: selectedTextStyle,
                      )
                    : Text("Fast RGB"),
              ),
              onTap: () => this
                  .widget
                  .strip
                  .sendToServer(sm.MessageType.Update, sm.Command.RGB, []),
              trailing: Text(""),
            ),
            new ListTile(
              title: Center(
                child: this.widget.strip.baseModel.colorMode == "Mode"
                    ? const Text(
                        'Flicker',
                        style: selectedTextStyle,
                      )
                    : Text("Flicker"),
              ),
              onTap: () => this
                  .widget
                  .strip
                  .sendToServer(sm.MessageType.Update, sm.Command.Mode, []),
              trailing: Text(""),
            ),
            new ListTile(
              title: Center(
                child: this.widget.strip.baseModel.colorMode == "Strobo"
                    ? const Text(
                        'Strobo',
                        style: selectedTextStyle,
                      )
                    : Text("Strobo"),
              ),
              onTap: () => this
                  .widget
                  .strip
                  .sendToServer(sm.MessageType.Update, sm.Command.Strobo, []),
              trailing: Text(""),
            ),
            new ListTile(
              title: Center(
                child: this.widget.strip.baseModel.colorMode == "RGBCycle"
                    ? const Text(
                        'RGBCycle',
                        style: selectedTextStyle,
                      )
                    : Text("RGBCycle"),
              ),
              onTap: () => this
                  .widget
                  .strip
                  .sendToServer(sm.MessageType.Update, sm.Command.RGBCycle, []),
              trailing: Text(""),
            ),
            new ListTile(
              title: Center(
                child: this.widget.strip.baseModel.colorMode == "LightWander"
                    ? const Text(
                        'Wander',
                        style: selectedTextStyle,
                      )
                    : Text("Wander"),
              ),
              onTap: () => this.widget.strip.sendToServer(
                  sm.MessageType.Update, sm.Command.LightWander, []),
              trailing: Text(""),
            ),
            new ListTile(
              title: Center(
                child: this.widget.strip.baseModel.colorMode == "RGBWander"
                    ? const Text(
                        'Wander RGB',
                        style: selectedTextStyle,
                      )
                    : Text("Wander RGB"),
              ),
              onTap: () => this.widget.strip.sendToServer(
                  sm.MessageType.Update, sm.Command.RGBWander, []),
              trailing: Text(""),
            ),
            new ListTile(
              title: Center(
                child: (this.widget.strip.baseModel.colorMode ==
                            "SingleColor" &&
                        this.widget.strip.baseModel.colorNumber == 0xFF000000)
                    ? const Text(
                        'White',
                        style: selectedTextStyle,
                      )
                    : Text("White"),
              ),
              onTap: () {
                this.widget.strip.sendToServer(sm.MessageType.Update,
                    sm.Command.SingleColor, ["0xFF000000"]);
              },
              trailing: Text(""),
            ),
            new ListTile(
              title: Center(
                child: this.widget.strip.baseModel.reverse
                    ? const Text(
                        'Reverse',
                        style: selectedTextStyle,
                      )
                    : Text("Reverse"),
              ),
              onTap: () => this
                  .widget
                  .strip
                  .sendToServer(sm.MessageType.Options, sm.Command.Reverse, []),
              trailing: Text(""),
            ),
            new ExpansionTile(
              title: (this.widget.strip.baseModel.colorMode == "SingleColor" &&
                      this.widget.strip.baseModel.colorNumber != 0xFF000000)
                  ? const Text(
                      'SingleColor',
                      style: selectedTextStyle,
                    )
                  : Text("SingleColor"),
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
                          sm.MessageType.Update,
                          sm.Command.SingleColor,
                          ["0x${rgbw.hw + rgbw.hb + rgbw.hg + rgbw.hr}"]),
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
              title: GestureDetector(
                child: SliderTheme(
                  child: Slider(
                    value: brightness,
                    onChanged: (d) {
                      setState(() => brightness = d);
                      sliderChange(changeBrightness, 500, ibrightness);
                    },
                    min: 0.0,
                    max: 255.0,
                    label: '${brightness.round()}',
                  ),
                  data: SliderTheme.of(context).copyWith(
                      trackShape: GradientRoundedRectSliderTrackShape(
                          LinearGradient(
                              colors: [Colors.grey.shade800, Colors.white]))),
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
                        sm.MessageType.Options,
                        sm.Command.Calibration,
                        ["0x${(numLeds.toInt()).toRadixString(16)}"]);
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
