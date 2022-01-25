import 'package:flutter/material.dart';
// import 'package:signalr_client/signalr_client.dart';
import 'package:smarthome/controls/gradient_rounded_rect_slider_track_shape.dart';
import 'package:smarthome/devices/base_model.dart';
import 'package:smarthome/devices/device.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/painless_led_strip/led_strip_model.dart';
import 'package:smarthome/models/message.dart' as sm;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smarthome/helper/theme_manager.dart';

class LedStrip extends Device<LedStripModel> {
  LedStrip(final int id, final String typeName, final IconData icon) : super(id, typeName, iconData: icon);

  final colorModeProvider = Provider.family<String, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    if (baseModel is LedStripModel) return baseModel.colorMode;
    return "Off";
  });

  @override
  void navigateToDevice(final BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (final BuildContext context) => LedStripScreen(this)));
  }

  @override
  Widget dashboardCardBody() {
    return Column(children: <Widget>[
      Wrap(
        runAlignment: WrapAlignment.spaceEvenly,
        alignment: WrapAlignment.center,
        children: [
          MaterialButton(
            child: Consumer(
              builder: (final context, final ref, final child) {
                final colorMode = ref.watch(colorModeProvider(id));
                return Text(
                  "An",
                  textAlign: TextAlign.center,
                  style: colorMode != "Off" && colorMode != "Mode"
                      ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                      : const TextStyle(),
                );
              },
            ),
            onPressed: () => sendToServer(sm.MessageType.Update, sm.Command.SingleColor, ["0xFF000000"]),
          ),
          MaterialButton(
            child: Consumer(
              builder: (final context, final ref, final child) {
                final colorMode = ref.watch(colorModeProvider(id));
                return Text(
                  "Aus",
                  textAlign: TextAlign.center,
                  style: colorMode == "Off"
                      ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                      : const TextStyle(),
                );
              },
            ),
            onPressed: () => sendToServer(sm.MessageType.Update, sm.Command.Off, []),
          ),
        ],
      ),
      MaterialButton(
        child: Container(
          margin: const EdgeInsets.only(bottom: 4.0),
          child: Consumer(
            builder: (final context, final ref, final child) {
              final colorMode = ref.watch(colorModeProvider(id));
              return Text(
                "Essen fertig",
                textAlign: TextAlign.center,
                style: colorMode == "Mode"
                    ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                    : const TextStyle(),
              );
            },
          ),
        ),
        onPressed: () => sendToServer(sm.MessageType.Update, sm.Command.Mode, []),
      ),
      (DeviceManager.showDebugInformation ? Text(id.toString()) : Container())
    ]);
  }

  @override
  DeviceTypes getDeviceType() {
    return DeviceTypes.LedStrip;
  }
}

class LedStripScreen extends ConsumerStatefulWidget {
  final LedStrip device;
  const LedStripScreen(this.device, {final Key? key}) : super(key: key);

  @override
  _LedStripScreenState createState() => _LedStripScreenState();
}

final _rgbwProvider = StateProvider.family<RGBW, Device>((final ref, final device) {
  final model = ref.watch(device.baseModelTProvider(device.id));

  final rgbw = RGBW();
  if (model is! LedStripModel) return rgbw;

  rgbw.r = (model.colorNumber & 0xFF) >> 0;
  rgbw.g = (model.colorNumber & 0xFF00) >> 8;
  rgbw.b = (model.colorNumber & 0xFF0000) >> 16;
  rgbw.w = (model.colorNumber & 0xFF000000) >> 24;
  return rgbw;
});

class _LedStripScreenState extends ConsumerState<LedStripScreen> {
  // final _brightnessProvider = StateProvider<double>((final _) => 0.0);
  // final _colorModeProvider = StateProvider<String>((final _) => "Off");

  DateTime dateTime = DateTime.now();
  static const int colordelay = 1000;
  double brightness = 255.0;
  double delay = 30.0;
  double numLeds = 94.0;

  static const TextStyle selectedTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 18);

  int get idelay => delay.toInt();
  int get ibrightness => brightness.toInt();

  @override
  void initState() {
    super.initState();
    final baseModel = ref.watch(widget.device.baseModelTProvider(widget.device.id));
    if (baseModel is LedStripModel) {
      brightness = baseModel.brightness.toDouble();
      delay = baseModel.delay.toDouble();
      numLeds = baseModel.numberOfLeds.toDouble();
    }
  }

  void sliderChange<T>(final Function f, final int dateTimeMilliseconds, final T val) {
    if (DateTime.now().isAfter(dateTime.add(Duration(milliseconds: dateTimeMilliseconds)))) {
      Function.apply(f, [val]);
      dateTime = DateTime.now();
    }
  }

  void changeColor(final RGBW rgbw) {
    widget.device
        .sendToServer(sm.MessageType.Options, sm.Command.Color, ["0x${rgbw.hw + rgbw.hb + rgbw.hg + rgbw.hr}"]);
  }

  void changeDelay(final int delay) {
    widget.device.sendToServer(sm.MessageType.Options, sm.Command.Delay, ["$delay"]);
  }

  void changeBrightness(final int delay) {
    widget.device
        .sendToServer(sm.MessageType.Options, sm.Command.Brightness, ["0x${(brightness.toInt()).toRadixString(16)}"]);
  }

  @override
  Widget build(final BuildContext context) {
    final model = ref.watch(widget.device.baseModelTProvider(widget.device.id));
    if (model is! LedStripModel) return Container();
    return Scaffold(
      appBar: AppBar(
        title: const Text("LED Strip "),
      ),
      body: Container(
        decoration: ThemeManager.getBackgroundDecoration(context),
        child: ListView(
          children: <Widget>[
            ListTile(
              // leading: this.model.colorMode == "Off" ? Icon(Icons.check) : Text(""),
              title: Center(
                child: model.colorMode == "Off"
                    ? const Text(
                        'Off',
                        style: selectedTextStyle,
                      )
                    : const Text("Off"),
              ),
              onTap: () => widget.device.sendToServer(sm.MessageType.Update, sm.Command.Off, []),
              trailing: const Text(""),
            ),
            ListTile(
              // leading: this.model.colorMode == "RGB" ? Icon(Icons.check) : Text(""),
              title: Center(
                child: model.colorMode == "RGB"
                    ? const Text(
                        'Fast RGB',
                        style: selectedTextStyle,
                      )
                    : const Text("Fast RGB"),
              ),
              onTap: () => widget.device.sendToServer(sm.MessageType.Update, sm.Command.RGB, []),
              trailing: const Text(""),
            ),
            ListTile(
              title: Center(
                child: model.colorMode == "Mode"
                    ? const Text(
                        'Flicker',
                        style: selectedTextStyle,
                      )
                    : const Text("Flicker"),
              ),
              onTap: () => widget.device.sendToServer(sm.MessageType.Update, sm.Command.Mode, []),
              trailing: const Text(""),
            ),
            ListTile(
              title: Center(
                child: model.colorMode == "Strobo"
                    ? const Text(
                        'Strobo',
                        style: selectedTextStyle,
                      )
                    : const Text("Strobo"),
              ),
              onTap: () => widget.device.sendToServer(sm.MessageType.Update, sm.Command.Strobo, []),
              trailing: const Text(""),
            ),
            ListTile(
              title: Center(
                child: model.colorMode == "RGBCycle"
                    ? const Text(
                        'RGBCycle',
                        style: selectedTextStyle,
                      )
                    : const Text("RGBCycle"),
              ),
              onTap: () => widget.device.sendToServer(sm.MessageType.Update, sm.Command.RGBCycle, []),
              trailing: const Text(""),
            ),
            ListTile(
              title: Center(
                child: model.colorMode == "LightWander"
                    ? const Text(
                        'Wander',
                        style: selectedTextStyle,
                      )
                    : const Text("Wander"),
              ),
              onTap: () => widget.device.sendToServer(sm.MessageType.Update, sm.Command.LightWander, []),
              trailing: const Text(""),
            ),
            ListTile(
              title: Center(
                child: model.colorMode == "RGBWander"
                    ? const Text(
                        'Wander RGB',
                        style: selectedTextStyle,
                      )
                    : const Text("Wander RGB"),
              ),
              onTap: () => widget.device.sendToServer(sm.MessageType.Update, sm.Command.RGBWander, []),
              trailing: const Text(""),
            ),
            ListTile(
              title: Center(
                child: (model.colorMode == "SingleColor" && model.colorNumber == 0xFF000000)
                    ? const Text(
                        'White',
                        style: selectedTextStyle,
                      )
                    : const Text("White"),
              ),
              onTap: () {
                widget.device.sendToServer(sm.MessageType.Update, sm.Command.SingleColor, ["0xFF000000"]);
              },
              trailing: const Text(""),
            ),
            ListTile(
              title: Center(
                child: model.reverse
                    ? const Text(
                        'Reverse',
                        style: selectedTextStyle,
                      )
                    : const Text("Reverse"),
              ),
              onTap: () => widget.device.sendToServer(sm.MessageType.Options, sm.Command.Reverse, []),
              trailing: const Text(""),
            ),
            ExpansionTile(
              title: (model.colorMode == "SingleColor" && model.colorNumber != 0xFF000000)
                  ? const Text(
                      'SingleColor',
                      style: selectedTextStyle,
                    )
                  : const Text("SingleColor"),
              children: <Widget>[
                Consumer(
                  builder: (final context, final ref, final child) {
                    final rgbw = ref.watch(_rgbwProvider(widget.device));
                    return ListTile(
                        subtitle: Text("Red: ${rgbw.hr} | ${rgbw.r}"),
                        title: Slider(
                          value: rgbw.dr,
                          onChanged: (final d) {
                            final newRGBW = rgbw.copyWith(red: d.round());
                            ref.read(_rgbwProvider(widget.device).notifier).state = newRGBW;
                            sliderChange(changeColor, colordelay, newRGBW);
                          },
                          onChangeEnd: (final d) {
                            final newRGBW = rgbw.copyWith(red: d.round());
                            ref.read(_rgbwProvider(widget.device).notifier).state = newRGBW;
                            changeColor(newRGBW);
                          },
                          max: 255.0,
                          label: 'R',
                        ));
                  },
                ),
                Consumer(
                  builder: (final context, final ref, final child) {
                    final rgbw = ref.watch(_rgbwProvider(widget.device));
                    return ListTile(
                        subtitle: Text("Green: ${rgbw.hg} | ${rgbw.g}"),
                        title: Slider(
                          value: rgbw.dg,
                          onChanged: (final d) {
                            final newRGBW = rgbw.copyWith(red: d.round());
                            ref.read(_rgbwProvider(widget.device).notifier).state = newRGBW;
                            sliderChange(changeColor, colordelay, newRGBW);
                          },
                          onChangeEnd: (final d) {
                            final newRGBW = rgbw.copyWith(green: d.round());
                            ref.read(_rgbwProvider(widget.device).notifier).state = newRGBW;
                            changeColor(newRGBW);
                          },
                          max: 255.0,
                          label: 'G',
                        ));
                  },
                ),
                Consumer(
                  builder: (final context, final ref, final child) {
                    final rgbw = ref.watch(_rgbwProvider(widget.device));
                    return ListTile(
                        subtitle: Text("Blue: ${rgbw.hb} | ${rgbw.b}"),
                        title: Slider(
                          value: rgbw.db,
                          onChanged: (final d) {
                            final newRGBW = rgbw.copyWith(red: d.round());
                            ref.read(_rgbwProvider(widget.device).notifier).state = newRGBW;
                            sliderChange(changeColor, colordelay, newRGBW);
                          },
                          onChangeEnd: (final d) {
                            final newRGBW = rgbw.copyWith(blue: d.round());
                            ref.read(_rgbwProvider(widget.device).notifier).state = newRGBW;
                            changeColor(newRGBW);
                          },
                          max: 255.0,
                          label: 'B',
                        ));
                  },
                ),
                Consumer(
                  builder: (final context, final ref, final child) {
                    final rgbw = ref.watch(_rgbwProvider(widget.device));
                    return ListTile(
                        subtitle: Text("White: ${rgbw.hw} | ${rgbw.w}"),
                        title: Slider(
                          value: rgbw.dw,
                          onChanged: (final d) {
                            final newRGBW = rgbw.copyWith(red: d.round());
                            ref.read(_rgbwProvider(widget.device).notifier).state = newRGBW;
                            sliderChange(changeColor, colordelay, newRGBW);
                          },
                          onChangeEnd: (final d) {
                            final newRGBW = rgbw.copyWith(white: d.round());
                            ref.read(_rgbwProvider(widget.device).notifier).state = newRGBW;
                            changeColor(newRGBW);
                          },
                          max: 255.0,
                          label: 'W',
                        ));
                  },
                ),
                Consumer(
                  builder: (final context, final ref, final child) {
                    final rgbw = ref.watch(_rgbwProvider(widget.device));
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Color: ${rgbw.hw + rgbw.hb + rgbw.hg + rgbw.hr}',
                        ),
                        MaterialButton(
                          child: const Text(
                            'SingleColor',
                          ),
                          onPressed: () => widget.device.sendToServer(sm.MessageType.Update, sm.Command.SingleColor,
                              ["0x${rgbw.hw + rgbw.hb + rgbw.hg + rgbw.hr}"]),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            ListTile(
              subtitle: Text("Delay ${idelay.toString()}ms"),
              title: GestureDetector(
                child: Slider(
                  value: delay,
                  onChanged: (final d) {
                    // setState(() => delay = d);
                    sliderChange(changeDelay, idelay, idelay);
                  },
                  max: 1000.0,
                  label: '${delay.round()}',
                ),
                onTapCancel: () => changeDelay(idelay),
              ),
            ),
            ListTile(
              subtitle: Text("Brightness ${brightness.toInt().toString()}"),
              title: GestureDetector(
                child: SliderTheme(
                  child: Slider(
                    value: brightness,
                    onChanged: (final d) {
                      // setState(() => brightness = d);
                      sliderChange(changeBrightness, 500, ibrightness);
                    },
                    max: 255.0,
                    label: '${brightness.round()}',
                  ),
                  data: SliderTheme.of(context).copyWith(
                      trackShape: GradientRoundedRectSliderTrackShape(
                          LinearGradient(colors: [Colors.grey.shade800, Colors.white]))),
                ),
              ),
            ),
            ListTile(
              subtitle: Text("Num Leds ${numLeds.toInt().toString()}"),
              title: GestureDetector(
                child: Slider(
                  value: numLeds,
                  onChanged: (final d) {
                    // setState(() => numLeds = d);
                    widget.device.sendToServer(
                        sm.MessageType.Options, sm.Command.Calibration, ["0x${(numLeds.toInt()).toRadixString(16)}"]);
                  },
                  max: 255.0,
                  label: '${numLeds.round()}',
                ),
              ),
            ),
            // ListTile(
            //   title: Text(this.model.toJson().toString())
            // ),
          ],
        ),
      ),
    );
  }
}

class ForInput {
  TextEditingController textEditingController = TextEditingController();
  String errorText = '';
  GlobalKey key = GlobalKey();
  InputDecoration? decoration;
  FocusNode focusNode = FocusNode();
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

  set dr(final double val) {
    r = val.toInt();
  }

  set dg(final double val) {
    g = val.toInt();
  }

  set db(final double val) {
    b = val.toInt();
  }

  set dw(final double val) {
    w = val.toInt();
  }

  String _toRadixBase16(final int val) {
    String ret = val.toRadixString(16);
    if (ret.length == 1) ret = "0" + ret;
    return ret;
  }

  RGBW();

  RGBW.rgb(final int red, final int green, final int blue) {
    r = red;
    g = green;
    b = blue;
  }

  RGBW.rgbw(final int red, final int green, final int blue, final int white) {
    r = red;
    g = green;
    b = blue;
    w = white;
  }

  RGBW.color(final Color c) {
    RGBW.rgb(c.red, c.green, c.blue);
  }

  RGBW copyWith({final int? red, final int? green, final int? blue, final int? white}) {
    return RGBW.rgbw(red ?? r, green ?? g, blue ?? b, white ?? w);
  }
}
