// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
// import 'package:signalr_client/signalr_client.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/controls/gradient_rounded_rect_slider_track_shape.dart';
import 'package:smarthome/devices/base_model.dart';
import 'package:smarthome/devices/device.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/models/message.dart' as sm;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../device_manager.dart';
import 'zigbee_lamp_model.dart';

class ZigbeeLamp extends Device<ZigbeeLampModel> {
  ZigbeeLamp(final int id, final String typeName, final ZigbeeLampModel model, final HubConnection connection,
      final IconData icon)
      : super(id, typeName, model, connection, iconData: icon);

  @override
  void navigateToDevice(final BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (final BuildContext context) => ZigbeeLampScreen(this)));
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
            style: baseModel.state ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 20) : const TextStyle(),
          ),
          onPressed: () => sendToServer(sm.MessageType.Update, sm.Command.SingleColor, []),
        ),
        MaterialButton(
          child: Text(
            "Aus",
            style: !baseModel.state ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 20) : const TextStyle(),
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

class ZigbeeLampScreen extends ConsumerStatefulWidget {
  final ZigbeeLamp device;
  const ZigbeeLampScreen(this.device, {final Key? key}) : super(key: key);

  @override
  _ZigbeeLampScreenState createState() => _ZigbeeLampScreenState();
}

class _ZigbeeLampScreenState extends ConsumerState<ZigbeeLampScreen> {
  DateTime dateTime = DateTime.now();

  final _brightnessProvider = StateProvider.family<int, Device<ZigbeeLampModel>>((final ref, final device) {
    final model = ref.watch(device.baseModelTProvider(device.id));

    return model?.brightness ?? 0;
  });
  final _colorTemp = StateProvider.family<int, Device<ZigbeeLampModel>>((final ref, final device) {
    final model = ref.watch(device.baseModelTProvider(device.id));

    return model?.colorTemp ?? 0;
  });
  final _transitionTime = StateProvider.family<double, Device<ZigbeeLampModel>>((final ref, final device) {
    final model = ref.watch(device.baseModelTProvider(device.id));

    return model?.transitionTime ?? 0;
  });

  void sliderChange(final Function f, final int dateTimeMilliseconds, [final double? val]) {
    if (DateTime.now().isAfter(dateTime.add(Duration(milliseconds: dateTimeMilliseconds)))) {
      Function.apply(f, val == null ? [] : [val]);
      dateTime = DateTime.now();
    }
  }

  void changeDelay(final double? delay) {
    widget.device.sendToServer(sm.MessageType.Options, sm.Command.Delay, [delay.toString()]);
  }

  void changeBrightness(final double brightness) {
    widget.device.sendToServer(sm.MessageType.Update, sm.Command.Brightness, [brightness.round().toString()]);
  }

  void changeColorTemp(final double colorTemp) {
    widget.device.sendToServer(sm.MessageType.Update, sm.Command.Temp, [colorTemp.round().toString()]);
  }

  @override
  Widget build(final BuildContext context) {
    final friendlyName = ref.watch(baseModelFriendlyNameProvider(widget.device.id));
    return Scaffold(
      appBar: AppBar(
        title: Text(friendlyName ?? ""),
      ),
      body: Container(
        decoration: ThemeManager.getBackgroundDecoration(context),
        child: buildBody(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.power_settings_new),
        onPressed: () {
          final model = ref.read(widget.device.baseModelTProvider(widget.device.id));
          if (model is! ZigbeeLampModel) return;

          widget.device.sendToServer(sm.MessageType.Update, model.state ? sm.Command.Off : sm.Command.SingleColor, []);
        },
      ),
    );
  }

  Widget buildBody() {
    final model = ref.watch(widget.device.baseModelTProvider(widget.device.id));
    if (model is! ZigbeeLampModel) return Container();

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
              child: Consumer(
                builder: (final context, final ref, final child) {
                  final brightness = ref.watch(_brightnessProvider(widget.device));
                  return Slider(
                    value: brightness.toDouble(),
                    onChanged: (final d) {
                      ref.read(_brightnessProvider(widget.device).notifier).state = d.round();
                      sliderChange(changeBrightness, 500, d);
                    },
                    max: 100.0,
                    divisions: 100,
                    label: '$brightness',
                  );
                },
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
              child: Consumer(
                builder: (final context, final ref, final child) {
                  final _colorTempClampledProvider = Provider<double>((final ref) {
                    final colorTemp = ref.watch(_colorTemp(widget.device));
                    return ((colorTemp - 204).clamp(0, 204)).toDouble();
                  });
                  final colorTemp = ref.watch(_colorTempClampledProvider);
                  return Slider(
                    value: colorTemp,
                    onChanged: (final d) {
                      ref.read(_colorTemp(widget.device).notifier).state = d.round();
                      sliderChange(changeColorTemp, 500, d + 204.0);
                    },
                    max: 204.0,
                    divisions: 204,
                    label: '${colorTemp - 204}',
                  );
                },
              ),
              data: SliderTheme.of(context).copyWith(
                  trackShape: const GradientRoundedRectSliderTrackShape(
                      LinearGradient(colors: [Color.fromARGB(255, 255, 209, 163), Color.fromARGB(255, 255, 147, 44)]))),
            ),
            onTapCancel: () => changeColorTemp(model.colorTemp.toDouble()),
          ),
        ),
        ListTile(
          title: Text("Übergangszeit " + model.transitionTime.toStringAsFixed(1) + " Sekunden"),
          subtitle: GestureDetector(
            child: Consumer(builder: (final context, final ref, final child) {
              final transitionTime = ref.watch(_transitionTime(widget.device));
              return Slider(
                value: transitionTime,
                onChanged: (final d) {
                  ref.read(_transitionTime(widget.device).notifier).state = d;
                  sliderChange(changeDelay, 500, d);
                },
                max: 10.0,
                divisions: 100,
                label: '$transitionTime',
              );
            }),
            onTapCancel: () => changeDelay(model.transitionTime),
          ),
        ),
      ],
    );
  }
}
