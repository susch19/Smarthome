import 'package:flutter/material.dart';
// import 'package:signalr_client/signalr_client.dart';
import 'package:smarthome/controls/gradient_rounded_rect_slider_track_shape.dart';
import 'package:smarthome/devices/base_model.dart';
import 'package:smarthome/devices/device.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/painless_led_strip/led_strip_model.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/models/message.dart' as sm;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/models/message.dart';

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
          Consumer(
            builder: (final context, final ref, final child) {
              final colorMode = ref.watch(colorModeProvider(id));
              return MaterialButton(
                child: Text(
                  "An",
                  textAlign: TextAlign.center,
                  style: colorMode != "Off" && colorMode != "Mode"
                      ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                      : const TextStyle(),
                ),
                onPressed: () => sendToServer(
                    sm.MessageType.Update, sm.Command.SingleColor, ["0xFF000000"], ref.read(hubConnectionProvider)),
              );
            },
          ),
          Consumer(
            builder: (final context, final ref, final child) {
              final colorMode = ref.watch(colorModeProvider(id));
              return MaterialButton(
                child: Text(
                  "Aus",
                  textAlign: TextAlign.center,
                  style: colorMode == "Off"
                      ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                      : const TextStyle(),
                ),
                onPressed: () =>
                    sendToServer(sm.MessageType.Update, sm.Command.Off, [], ref.read(hubConnectionProvider)),
              );
            },
          ),
        ],
      ),
      Consumer(
        builder: (final context, final ref, final child) {
          final colorMode = ref.watch(colorModeProvider(id));
          return MaterialButton(
            child: Container(
                margin: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  "Essen fertig",
                  textAlign: TextAlign.center,
                  style: colorMode == "Mode"
                      ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                      : const TextStyle(),
                )),
            onPressed: () => sendToServer(sm.MessageType.Update, sm.Command.Mode, [], ref.read(hubConnectionProvider)),
          );
        },
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

final _brightnessProvider = StateProvider.family<int, Device<LedStripModel>>((final ref, final device) {
  final model = ref.watch(device.baseModelTProvider(device.id));

  return model?.brightness ?? 0;
});
final _colorModeProvider = StateProvider.family<String, Device<LedStripModel>>((final ref, final device) {
  final model = ref.watch(device.baseModelTProvider(device.id));

  return model?.colorMode ?? "Off";
});
final _delayProvider = StateProvider.family<int, Device<LedStripModel>>((final ref, final device) {
  final model = ref.watch(device.baseModelTProvider(device.id));

  return model?.delay ?? 0;
});
final _numLedsProvider = StateProvider.family<int, Device<LedStripModel>>((final ref, final device) {
  final model = ref.watch(device.baseModelTProvider(device.id));

  return model?.numberOfLeds ?? 0;
});

class _LedStripScreenState extends ConsumerState<LedStripScreen> {
  // final _brightnessProvider = StateProvider<double>((final _) => 0.0);
  // final _colorModeProvider = StateProvider<String>((final _) => "Off");

  DateTime dateTime = DateTime.now();
  static const int colordelay = 1000;

  static const TextStyle selectedTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 18);

  void _sliderChange<T>(final WidgetRef ref, final Function f, final int dateTimeMilliseconds, final T val) {
    final sendToServer = DateTime.now().isAfter(dateTime.add(Duration(milliseconds: dateTimeMilliseconds)));
    if (sendToServer) {
      dateTime = DateTime.now();
    }
    Function.apply(f, [ref, val, sendToServer]);
  }

  void _colorModeChange(final WidgetRef ref, final Command newMode, [final bool sendToServer = true]) {
    final oldMode = ref.watch(_colorModeProvider(widget.device).notifier);
    oldMode.state = newMode.name;

    if (sendToServer) widget.device.sendToServer(sm.MessageType.Update, newMode, [], ref.read(hubConnectionProvider));
  }

  void _changeColor(final WidgetRef ref, final RGBW rgbw, [final bool sendToServer = true]) {
    final oldMode = ref.watch(_rgbwProvider(widget.device).notifier);
    oldMode.state = rgbw;
    if (sendToServer) {
      widget.device.sendToServer(sm.MessageType.Options, sm.Command.Color,
          ["0x${rgbw.hw + rgbw.hb + rgbw.hg + rgbw.hr}"], ref.read(hubConnectionProvider));
    }
  }

  void _changeDelay(final WidgetRef ref, final int delay, [final bool sendToServer = true]) {
    if (sendToServer) {
      widget.device.sendToServer(
          sm.MessageType.Options, sm.Command.Delay, ["0x${delay.toRadixString(16)}"], ref.read(hubConnectionProvider));
    }
    final oldDelay = ref.watch(_delayProvider(widget.device).notifier);
    oldDelay.state = delay;
  }

  void _changeNumLeds(final WidgetRef ref, final int numLeds, [final bool sendToServer = true]) {
    if (sendToServer) {
      widget.device.sendToServer(sm.MessageType.Options, sm.Command.Calibration,
          ["0x${(numLeds.toInt()).toRadixString(16)}"], ref.read(hubConnectionProvider));
    }
    final oldNumLeds = ref.watch(_numLedsProvider(widget.device).notifier);
    oldNumLeds.state = numLeds;
  }

  void _changeBrightness(final WidgetRef ref, final int brightness, [final bool sendToServer = true]) {
    if (sendToServer) {
      widget.device.sendToServer(sm.MessageType.Options, sm.Command.Brightness,
          ["0x${(brightness.toInt()).toRadixString(16)}"], ref.read(hubConnectionProvider));
    }
    final oldBrightness = ref.watch(_brightnessProvider(widget.device).notifier);
    oldBrightness.state = brightness;
  }

  @override
  Widget build(final BuildContext context) {
    final model = ref.read(widget.device.baseModelTProvider(widget.device.id));
    if (model is! LedStripModel) return Container();
    return Scaffold(
      appBar: AppBar(
        title: const Text("LED Strip "),
      ),
      body: Container(
        decoration: ThemeManager.getBackgroundDecoration(context),
        child: ListView(
          children: <Widget>[
            Consumer(
              builder: (final context, final ref, final child) {
                final colorMode = ref.watch(_colorModeProvider(widget.device));
                return ListView(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      title: Center(
                        child: colorMode == "Off"
                            ? const Text(
                                'Off',
                                style: selectedTextStyle,
                              )
                            : const Text("Off"),
                      ),
                      onTap: () => _colorModeChange(ref, sm.Command.Off),
                      trailing: const Text(""),
                    ),
                    ListTile(
                      title: Center(
                        child: colorMode == "RGB"
                            ? const Text(
                                'Fast RGB',
                                style: selectedTextStyle,
                              )
                            : const Text("Fast RGB"),
                      ),
                      onTap: () => _colorModeChange(ref, sm.Command.RGB),
                      trailing: const Text(""),
                    ),
                    ListTile(
                      title: Center(
                        child: colorMode == "Mode"
                            ? const Text(
                                'Flicker',
                                style: selectedTextStyle,
                              )
                            : const Text("Flicker"),
                      ),
                      onTap: () => _colorModeChange(ref, sm.Command.Mode),
                      trailing: const Text(""),
                    ),
                    ListTile(
                      title: Center(
                        child: colorMode == "Strobo"
                            ? const Text(
                                'Strobo',
                                style: selectedTextStyle,
                              )
                            : const Text("Strobo"),
                      ),
                      onTap: () => _colorModeChange(ref, sm.Command.Strobo),
                      trailing: const Text(""),
                    ),
                    ListTile(
                      title: Center(
                        child: colorMode == "RGBCycle"
                            ? const Text(
                                'RGBCycle',
                                style: selectedTextStyle,
                              )
                            : const Text("RGBCycle"),
                      ),
                      onTap: () => _colorModeChange(ref, sm.Command.RGBCycle),
                      trailing: const Text(""),
                    ),
                    ListTile(
                      title: Center(
                        child: colorMode == "LightWander"
                            ? const Text(
                                'Wander',
                                style: selectedTextStyle,
                              )
                            : const Text("Wander"),
                      ),
                      onTap: () => _colorModeChange(ref, sm.Command.LightWander),
                      trailing: const Text(""),
                    ),
                    ListTile(
                      title: Center(
                        child: colorMode == "RGBWander"
                            ? const Text(
                                'Wander RGB',
                                style: selectedTextStyle,
                              )
                            : const Text("Wander RGB"),
                      ),
                      onTap: () => _colorModeChange(ref, sm.Command.RGBWander),
                      trailing: const Text(""),
                    ),
                  ],
                );
              },
            ),
            Consumer(
              builder: (final context, final ref, final child) {
                final colorMode = ref.watch(
                    widget.device.baseModelTProvider(widget.device.id).select((final value) => value!.colorMode));
                final colorNumber = ref.watch(
                    widget.device.baseModelTProvider(widget.device.id).select((final value) => value!.colorNumber));
                return ListTile(
                  title: Center(
                    child: (colorMode == "SingleColor" && colorNumber == 0xFF000000)
                        ? const Text(
                            'White',
                            style: selectedTextStyle,
                          )
                        : const Text("White"),
                  ),
                  onTap: () {
                    widget.device.sendToServer(
                        sm.MessageType.Update, sm.Command.SingleColor, ["0xFF000000"], ref.read(hubConnectionProvider));
                  },
                  trailing: const Text(""),
                );
              },
            ),
            Consumer(
              builder: (final context, final ref, final child) {
                final reversed = ref
                    .watch(widget.device.baseModelTProvider(widget.device.id).select((final value) => value!.reverse));
                return ListTile(
                  title: Center(
                    child: reversed
                        ? const Text(
                            'Reverse',
                            style: selectedTextStyle,
                          )
                        : const Text("Reverse"),
                  ),
                  onTap: () => widget.device
                      .sendToServer(sm.MessageType.Options, sm.Command.Reverse, [], ref.read(hubConnectionProvider)),
                  trailing: const Text(""),
                );
              },
            ),
            Consumer(
              builder: (final context, final ref, final child) {
                final rgbw = ref.watch(_rgbwProvider(widget.device));
                final colorMode = ref.watch(
                    widget.device.baseModelTProvider(widget.device.id).select((final value) => value!.colorMode));
                return ExpansionTile(
                  title: (colorMode == "SingleColor" && model.colorNumber != 0xFF000000)
                      ? const Text(
                          'SingleColor',
                          style: selectedTextStyle,
                        )
                      : const Text("SingleColor"),
                  children: <Widget>[
                    ListTile(
                        subtitle: Text("Red: ${rgbw.hr} | ${rgbw.r}"),
                        title: Slider(
                          value: rgbw.dr,
                          onChanged: (final d) {
                            final newRGBW = rgbw.copyWith(red: d.round());
                            ref.read(_rgbwProvider(widget.device).notifier).state = newRGBW;
                            _sliderChange(ref, _changeColor, colordelay, newRGBW);
                          },
                          onChangeEnd: (final d) {
                            final newRGBW = rgbw.copyWith(red: d.round());
                            _changeColor(ref, newRGBW);
                          },
                          max: 255.0,
                          label: 'R',
                        )),
                    ListTile(
                        subtitle: Text("Green: ${rgbw.hg} | ${rgbw.g}"),
                        title: Slider(
                          value: rgbw.dg,
                          onChanged: (final d) {
                            final newRGBW = rgbw.copyWith(green: d.round());
                            ref.read(_rgbwProvider(widget.device).notifier).state = newRGBW;
                            _sliderChange(ref, _changeColor, colordelay, newRGBW);
                          },
                          onChangeEnd: (final d) {
                            final newRGBW = rgbw.copyWith(green: d.round());
                            _changeColor(ref, newRGBW);
                          },
                          max: 255.0,
                          label: 'G',
                        )),
                    ListTile(
                        subtitle: Text("Blue: ${rgbw.hb} | ${rgbw.b}"),
                        title: Slider(
                          value: rgbw.db,
                          onChanged: (final d) {
                            final newRGBW = rgbw.copyWith(blue: d.round());
                            ref.read(_rgbwProvider(widget.device).notifier).state = newRGBW;
                            _sliderChange(ref, _changeColor, colordelay, newRGBW);
                          },
                          onChangeEnd: (final d) {
                            final newRGBW = rgbw.copyWith(blue: d.round());
                            _changeColor(ref, newRGBW);
                          },
                          max: 255.0,
                          label: 'B',
                        )),
                    ListTile(
                        subtitle: Text("White: ${rgbw.hw} | ${rgbw.w}"),
                        title: Slider(
                          value: rgbw.dw,
                          onChanged: (final d) {
                            final newRGBW = rgbw.copyWith(white: d.round());
                            ref.read(_rgbwProvider(widget.device).notifier).state = newRGBW;
                            _sliderChange(ref, _changeColor, colordelay, newRGBW);
                          },
                          onChangeEnd: (final d) {
                            final newRGBW = rgbw.copyWith(white: d.round());
                            _changeColor(ref, newRGBW);
                          },
                          max: 255.0,
                          label: 'W',
                        )),
                    Row(
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
                              ["0x${rgbw.hw + rgbw.hb + rgbw.hg + rgbw.hr}"], ref.read(hubConnectionProvider)),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),

            Consumer(builder: (final context, final ref, final child) {
              final delay = ref.watch(_delayProvider(widget.device));
              return ListTile(
                subtitle: Text("Delay ${delay.toString()}ms"),
                title: Slider(
                  value: delay.toDouble(),
                  onChanged: (final d) {
                    _sliderChange(ref, _changeDelay, 1000, d.round());
                  },
                  onChangeEnd: (final d) => _changeDelay(ref, d.round()),
                  max: 1000.0,
                  label: '${delay.round()}',
                ),
              );
            }),
            Consumer(
              builder: (final context, final ref, final child) {
                final res = ref.watch(_brightnessProvider(widget.device));
                return ListTile(
                  subtitle: Text("Brightness ${res.toInt().toString()}"),
                  title: GestureDetector(
                    child: SliderTheme(
                      child: Slider(
                        value: res.toDouble(),
                        onChanged: (final d) {
                          // setState(() => brightness = d);
                          _sliderChange(ref, _changeBrightness, 500, d.round());
                        },
                        max: 255.0,
                        label: '${res.round()}',
                      ),
                      data: SliderTheme.of(context).copyWith(
                          trackShape: GradientRoundedRectSliderTrackShape(
                              LinearGradient(colors: [Colors.grey.shade800, Colors.white]))),
                    ),
                  ),
                );
              },
            ),
            Consumer(
              builder: (final context, final ref, final child) {
                final numLeds = ref.watch(_numLedsProvider(widget.device));
                return ListTile(
                  subtitle: Text("Num Leds ${numLeds.toInt().toString()}"),
                  title: GestureDetector(
                    child: Slider(
                      onChangeEnd: (final value) => _changeNumLeds(ref, value.round()),
                      value: numLeds.toDouble(),
                      onChanged: (final d) => _changeNumLeds(ref, d.round(), false),
                      max: 255.0,
                      label: '${numLeds.round()}',
                    ),
                  ),
                );
              },
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
