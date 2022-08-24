import 'package:flutter/material.dart';
import 'package:smarthome/controls/gradient_rounded_rect_slider_track_shape.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/shared_controls/shared_controls_exporter.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/models/message.dart' as sm;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../device_manager.dart';

class TradfriLedBulb extends Device<TradfriLedBulbModel> {
  TradfriLedBulb(final int id, final String typeName, final IconData icon) : super(id, typeName, iconData: icon);

  @override
  void navigateToDevice(final BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (final BuildContext context) => TradfriLedBulbScreen(this)));
  }

  @override
  Widget getRightWidgets() {
    return Consumer(
      builder: (final context, final ref, final child) {
        final color = ref.watch(TradfriLedBulbModel.colorProvider(id));

        final colorNum = int.parse(color.replaceFirst('#', ''), radix: 16);
        final r = (colorNum & 0xFF0000) >> 16;
        final g = (colorNum & 0xFF00) >> 8;
        final b = (colorNum & 0xFF) >> 0;
        return Icon(Icons.bubble_chart, color: Color.fromRGBO(r, g, b, 1), size: 24.0);
      },
    );
  }

  @override
  Widget dashboardCardBody() {
    return Wrap(
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.spaceEvenly,
      children: [
        Consumer(
          builder: (final context, final ref, final child) {
            final state = ref.watch(TradfriLedBulbModel.stateProvider(id));
            return MaterialButton(
              child: Text(
                "An",
                style: (state) ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 20) : const TextStyle(),
              ),
              onPressed: () => sendToServer(sm.MessageType.Update, sm.Command.On, [], ref.read(hubConnectionProvider)),
            );
          },
        ),
        Consumer(
          builder: (final context, final ref, final child) {
            final state = ref.watch(TradfriLedBulbModel.stateProvider(id));
            return MaterialButton(
              child: Text(
                "Aus",
                style: !(state) ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 20) : const TextStyle(),
              ),
              onPressed: () => sendToServer(sm.MessageType.Update, sm.Command.Off, [], ref.read(hubConnectionProvider)),
            );
          },
        ),
      ],
    );
  }

  @override
  DeviceTypes getDeviceType() {
    return DeviceTypes.TradfriLedBulb;
  }
}

@immutable
class TradfriLedBulbScreen extends ConsumerWidget {
  final TradfriLedBulb device;
  TradfriLedBulbScreen(this.device, {final Key? key}) : super(key: key);

  static final _rgbProvider = StateProvider.family<RGB, Device>((final ref, final device) {
    final color = ref.watch(TradfriLedBulbModel.colorProvider(device.id));

    final rgb = RGB();

    final colorNum = int.parse(color.replaceFirst('#', ''), radix: 16);

    rgb.r = (colorNum & 0xFF) >> 0;
    rgb.g = (colorNum & 0xFF00) >> 8;
    rgb.b = (colorNum & 0xFF0000) >> 16;
    return rgb;
  });

  final _brightnessProvider = StateProvider.family<int, Device<TradfriLedBulbModel>>((final ref, final device) {
    final model = ref.watch(device.baseModelTProvider(device.id));

    return model?.brightness ?? 0;
  });
  void changeBrightness(final double brightness, final WidgetRef ref) {
    device.sendToServer(
        sm.MessageType.Update, sm.Command.Brightness, [brightness.round().toString()], ref.read(hubConnectionProvider));
  }

  void changeColor(final RGB rgb, final WidgetRef ref) {
    device.sendToServer(
        sm.MessageType.Update, sm.Command.Color, ["#${rgb.hr + rgb.hg + rgb.hb}"], ref.read(hubConnectionProvider));
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: FriendlyNameDisplay(device.id),
      ),
      body: Container(
        decoration: ThemeManager.getBackgroundDecoration(context),
        child: buildBody(context, ref),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.power_settings_new),
        onPressed: () {
          final state = ref.read(TradfriLedBulbModel.stateProvider(device.id));

          device.sendToServer(
              sm.MessageType.Update, state ? sm.Command.Off : sm.Command.On, [], ref.read(hubConnectionProvider));
        },
      ),
    );
  }

  Widget buildBody(final BuildContext context, final WidgetRef ref) {
    final model = ref.watch(device.baseModelTProvider(device.id));
    if (model is! TradfriLedBulbModel) return Container();

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
              child: Consumer(builder: (final context, final ref, final child) {
                final brightness = ref.watch(_brightnessProvider(device));
                return Slider(
                  value: brightness.toDouble(),
                  onChanged: (final d) {
                    ref.read(_brightnessProvider(device).notifier).state = d.round();
                  },
                  max: 100.0,
                  divisions: 100,
                  label: '$brightness',
                  onChangeEnd: (final c) => changeBrightness(c, ref),
                );
              }),
              data: SliderTheme.of(context).copyWith(
                  trackShape: GradientRoundedRectSliderTrackShape(
                      LinearGradient(colors: [Colors.grey.shade800, Colors.white]))),
            ),
          ),
        ),
        Consumer(
          builder: (final context, final ref, final child) {
            final rgb = ref.watch(_rgbProvider(device));
            return ListTile(
                subtitle: Text("Red: ${rgb.hr} | ${rgb.r}"),
                title: Slider(
                  value: rgb.dr,
                  onChanged: (final d) {
                    ref.read(_rgbProvider(device).notifier).state = rgb.cloneWith(red: d.round());
                  },
                  onChangeEnd: (final a) => changeColor(rgb, ref),
                  max: 255.0,
                  label: 'R',
                ));
          },
        ),
        Consumer(
          builder: (final context, final ref, final child) {
            final rgb = ref.watch(_rgbProvider(device));
            return ListTile(
                subtitle: Text("Green: ${rgb.hg} | ${rgb.g}"),
                title: Slider(
                  value: rgb.dg,
                  onChanged: (final d) {
                    ref.read(_rgbProvider(device).notifier).state = rgb.cloneWith(green: d.round());
                  },
                  onChangeEnd: (final a) => changeColor(rgb, ref),
                  max: 255.0,
                  label: 'G',
                ));
          },
        ),
        Consumer(
          builder: (final context, final ref, final child) {
            final rgb = ref.watch(_rgbProvider(device));
            return ListTile(
                subtitle: Text("Blue: ${rgb.hb} | ${rgb.b}"),
                title: Slider(
                  value: rgb.db,
                  onChanged: (final d) {
                    ref.read(_rgbProvider(device).notifier).state = rgb.cloneWith(blue: d.round());
                  },
                  onChangeEnd: (final a) => changeColor(rgb, ref),
                  max: 255.0,
                  label: 'B',
                ));
          },
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

  set dr(final double val) {
    r = val.toInt();
  }

  set dg(final double val) {
    g = val.toInt();
  }

  set db(final double val) {
    b = val.toInt();
  }

  String _toRadixBase16(final int val) {
    String ret = val.toRadixString(16);
    if (ret.length == 1) ret = "0" + ret;
    return ret;
  }

  RGB();

  RGB.rgb(final int red, final int green, final int blue) {
    r = red;
    g = green;
    b = blue;
  }

  RGB.color(final Color c) {
    RGB.rgb(c.red, c.green, c.blue);
  }

  RGB cloneWith({final int red = -1, final int green = -1, final int blue = -1}) {
    final rgb = RGB();
    if (red > -1) rgb.r = red;
    if (green > -1) rgb.g = green;
    if (blue > -1) rgb.b = blue;
    return rgb;
  }

  @override
  bool operator ==(final Object other) => other is RGB && r == other.r && g == other.g && b == other.b;

  @override
  int get hashCode => Object.hash(r, g, b);
}
