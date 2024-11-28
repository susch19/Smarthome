// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
// import 'package:signalr_client/signalr_client.dart';
import 'package:smarthome/controls/gradient_rounded_rect_slider_track_shape.dart';
import 'package:smarthome/devices/base_model.dart';
import 'package:smarthome/devices/device.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/zigbee/zigbee_model.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/models/message.dart' as sm;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smarthome/restapi/swagger.enums.swagger.dart';

import 'zigbee_lamp_model.dart';

class ZigbeeLamp extends Device<ZigbeeLampModel> {
  ZigbeeLamp(final int id, final String typeName, final IconData icon)
      : super(id, typeName, iconData: icon);

  final stateProvider = Provider.family<bool, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    if (baseModel is ZigbeeLampModel) return baseModel.state;
    return false;
  });

  @override
  void navigateToDevice(final BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (final BuildContext context) => ZigbeeLampScreen(this)));
  }

  @override
  Widget dashboardCardBody() {
    return Wrap(
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.spaceEvenly,
      children: [
        Consumer(
          builder: (final context, final ref, final child) {
            final state = ref.watch(stateProvider(id));
            return MaterialButton(
              child: Text(
                "An",
                style: (state)
                    ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                    : const TextStyle(),
              ),
              onPressed: () => sendToServer(MessageType.update,
                  Command.singlecolor, [], ref.read(hubConnectionProvider)),
            );
          },
        ),
        Consumer(
          builder: (final context, final ref, final child) {
            final state = ref.watch(stateProvider(id));
            return MaterialButton(
              child: Text(
                "Aus",
                style: !(state)
                    ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                    : const TextStyle(),
              ),
              onPressed: () => sendToServer(MessageType.update, Command.off, [],
                  ref.read(hubConnectionProvider)),
            );
          },
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

  final _brightnessProvider =
      StateProvider.family<int, Device<ZigbeeLampModel>>(
          (final ref, final device) {
    final model = ref.watch(device.baseModelTProvider(device.id));

    return model?.brightness ?? 0;
  });
  final _colorTemp = StateProvider.family<int, Device<ZigbeeLampModel>>(
      (final ref, final device) {
    final model = ref.watch(device.baseModelTProvider(device.id));

    return model?.colortemp ?? 0;
  });
  final _transitionTime = StateProvider.family<double, Device<ZigbeeLampModel>>(
      (final ref, final device) {
    final model = ref.watch(device.baseModelTProvider(device.id));

    return model?.transitionTime ?? 0;
  });

  void sliderChange(final Function f, final int dateTimeMilliseconds,
      [final double? val]) {
    if (DateTime.now()
        .isAfter(dateTime.add(Duration(milliseconds: dateTimeMilliseconds)))) {
      Function.apply(f, val == null ? [] : [val]);
      dateTime = DateTime.now();
    }
  }

  void changeDelay(final double? delay) {
    widget.device.sendToServer(MessageType.options, Command.delay,
        [delay.toString()], ref.read(hubConnectionProvider));
  }

  void changeBrightness(final double brightness) {
    widget.device.sendToServer(MessageType.update, Command.brightness,
        [brightness.round().toString()], ref.read(hubConnectionProvider));
  }

  void changeColorTemp(final double colorTemp) {
    widget.device.sendToServer(MessageType.update, Command.temp,
        [colorTemp.round().toString()], ref.read(hubConnectionProvider));
  }

  @override
  Widget build(final BuildContext context) {
    final friendlyName =
        ref.watch(BaseModel.friendlyNameProvider(widget.device.id));
    return Scaffold(
      appBar: AppBar(
        title: Text(friendlyName),
      ),
      body: Container(
        decoration: ThemeManager.getBackgroundDecoration(context),
        child: buildBody(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.power_settings_new),
        onPressed: () {
          final state =
              ref.read(ZigbeeLampModel.stateProvider(widget.device.id));

          widget.device.sendToServer(
              MessageType.update,
              state ? Command.off : Command.singlecolor,
              [],
              ref.read(hubConnectionProvider));
        },
      ),
    );
  }

  Widget buildBody() {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text(
              "Angeschaltet: ${ref.watch(ZigbeeLampModel.stateProvider(widget.device.id)) ? "Ja" : "Nein"}"),
        ),
        ListTile(
          title: Text(
              "Verfügbar: ${ref.watch(ZigbeeModel.availableProvider(widget.device.id)) ? "Ja" : "Nein"}"),
        ),
        ListTile(
          title: Text(
              "Verbindungsqualität: ${ref.watch(ZigbeeModel.linkQualityProvider(widget.device.id))}"),
        ),
        ListTile(
          title: Text(
              "Helligkeit ${ref.watch(ZigbeeLampModel.brightnessProvider(widget.device.id)).toStringAsFixed(0)}"),
          subtitle: GestureDetector(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                  trackShape: GradientRoundedRectSliderTrackShape(
                      LinearGradient(
                          colors: [Colors.grey.shade800, Colors.white]))),
              child: Consumer(
                builder: (final context, final ref, final child) {
                  final brightness =
                      ref.watch(_brightnessProvider(widget.device));
                  return Slider(
                    value: brightness.toDouble(),
                    onChanged: (final d) {
                      ref
                          .read(_brightnessProvider(widget.device).notifier)
                          .state = d.round();
                      sliderChange(changeBrightness, 500, d);
                    },
                    max: 100.0,
                    divisions: 100,
                    label: '$brightness',
                  );
                },
              ),
            ),
            onTapCancel: () => changeBrightness(ref
                .watch(ZigbeeLampModel.brightnessProvider(widget.device.id))
                .toDouble()),
          ),
        ),
        ListTile(
          title: Text(
              "Farbtemparatur ${(ref.watch(ZigbeeLampModel.colorTempProvider(widget.device.id)) - 204).toStringAsFixed(0)}"),
          subtitle: GestureDetector(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                  trackShape: const GradientRoundedRectSliderTrackShape(
                      LinearGradient(colors: [
                Color.fromARGB(255, 255, 209, 163),
                Color.fromARGB(255, 255, 147, 44)
              ]))),
              child: Consumer(
                builder: (final context, final ref, final child) {
                  final colorTempClampledProvider =
                      Provider<double>((final ref) {
                    final colorTemp = ref.watch(_colorTemp(widget.device));
                    return ((colorTemp - 204).clamp(0, 204)).toDouble();
                  });
                  final colorTemp = ref.watch(colorTempClampledProvider);
                  return Slider(
                    value: colorTemp,
                    onChanged: (final d) {
                      ref.read(_colorTemp(widget.device).notifier).state =
                          d.round();
                      sliderChange(changeColorTemp, 500, d + 204.0);
                    },
                    max: 204.0,
                    divisions: 204,
                    label: '${colorTemp - 204}',
                  );
                },
              ),
            ),
            onTapCancel: () => changeColorTemp(ref
                .watch(ZigbeeLampModel.colorTempProvider(widget.device.id))
                .toDouble()),
          ),
        ),
        ListTile(
          title: Text(
              "Übergangszeit ${(ref.watch(ZigbeeLampModel.transitionTimeProvider(widget.device.id)) ?? 0).toStringAsFixed(1)} Sekunden"),
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
            onTapCancel: () => changeDelay(ref.watch(
                ZigbeeLampModel.transitionTimeProvider(widget.device.id))),
          ),
        ),
      ],
    );
  }
}
