import 'dart:convert';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
// import 'package:signalr_client/signalr_client.dart';
import 'package:smarthome/controls/blurry_card.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/generic/stores/store_service.dart';
import 'package:smarthome/devices/generic/stores/value_store.dart';
import 'package:smarthome/devices/heater/heater_config.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/icons/smarthome_icons.dart';
import 'package:smarthome/models/message.dart' as sm;
import 'package:smarthome/icons/icons.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tuple/tuple.dart';

import 'temp_scheduling.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Heater extends Device<HeaterModel> {
  Heater(final int id, final String typeName, final IconData icon) : super(id, typeName, iconData: icon);

  @override
  void navigateToDevice(final BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (final BuildContext context) => HeaterScreen(this)));
  }

  // @override
  // BaseModel updateFromServer(final Map<String, dynamic> message) {
  //   PreferencesManager.instance.setString("Json" + id.toString(), jsonEncode(message));
  //   return super.updateFromServer(message);
  // }

  @override
  Widget getRightWidgets() {
    return Column(
      children: [
        Consumer(builder: (final context, final ref, final child) {
          return Icon(
            ref.watch(HeaterModel.disableHeatingProvider(id)) ? Icons.power_off_outlined : Icons.power_outlined,
            size: 20,
          );
        }),
      ],
    );
  }

  @override
  Widget dashboardCardBody() {
    // XiaomiTempSensor xs = DeviceManager.devices.firstWhere((x) => x.id == baseModel.xiaomiTempSensor, orElse: () {
    //   return XiaomiTempSensor(0, TempSensorModel(0, "", false), connection, icon);
    // }) as XiaomiTempSensor;
    return Column(
      children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Consumer(
                builder: (final context, final ref, final child) => Text(
                  (ref.watch(HeaterModel.temperatureProvider(id))?.temperature.toStringAsFixed(1) ?? ""),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
              const Text(
                " °C",
                style: TextStyle(fontSize: 18),
              ),
            ]),
            Container(
              height: 2,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Consumer(
                builder: (final context, final ref, final child) {
                  final currentConfig = ref.watch(HeaterModel.currentConfigProvider(id));
                  return Text(
                    currentConfig == null ? "" : ((currentConfig.temperature.toStringAsFixed(1))),
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  );
                },
              ),
              const Text(
                "°C",
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ]),
            !DeviceManager.showDebugInformation
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Consumer(
                        builder: (final context, final ref, final child) {
                          return Text(ref.watch(HeaterModel.versionProvider(id)));
                        },
                      )
                    ],
                  ),
            // (xs.id == 0 ? Text(baseModel.xiaomiTempSensor.toString()) : Text(xs.baseModel.friendlyName)),
          ] +
          (DeviceManager.showDebugInformation ? [Text(id.toString())] : <Widget>[]),
    );
  }

  @override
  DeviceTypes getDeviceType() {
    return DeviceTypes.Heater;
  }
}

class HeaterScreen extends ConsumerStatefulWidget {
  final Heater device;

  const HeaterScreen(this.device, {final Key? key}) : super(key: key);

  @override
  _HeaterScreenState createState() => _HeaterScreenState();
}

class _HeaterScreenState extends ConsumerState<HeaterScreen> {
  double? temp = 11;
  String tempString() => temp!.toStringAsFixed(1) + "°C";
  TextEditingController? textEditingController;
  String _annotationValue = '9.0';
  double _value = 9.0;
  late Heater heater;

  @override
  void initState() {
    heater = widget.device;
    final currentConfig = ref.read(HeaterModel.currentConfigProvider(widget.device.id));

    handlePointerValueChanged(currentConfig?.temperature ?? 21);
    textEditingController = TextEditingController(text: tempString());
    // _setPointerValue(this.widget.heater.baseModel.currentConfig?.temperature ?? 21.0);
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    final xiaomiTempSensor = ref.watch(HeaterModel.xiaomiProvider(widget.device.id));
    final tempSensorDevice = ref.watch(valueStoreChangedProvider(Tuple2("temperature", xiaomiTempSensor ?? -1)));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: [
              Consumer(
                builder: (final context, final ref, final child) {
                  final typeNames = ref.watch(BaseModel.typeNamesProvider(widget.device.id));
                  final icon =
                      ref.watch(iconWidgetProvider(Tuple3(typeNames ?? [], widget.device, AdaptiveTheme.of(context))));
                  return Tab(icon: icon);
                },
              ),
              const Tab(
                icon: Icon(Icons.settings),
              ),
              // Tab(icon: Icon(SmarthomeIcons.temperature)),
            ],
          ),
        ),
        body: // buildColumnView(width, xs),
            Container(
          decoration: ThemeManager.getBackgroundDecoration(context),
          child: TabBarView(
            children: [
              buildColumnView(width, tempSensorDevice is ValueStore<double> ? tempSensorDevice.currentValue : 21.0),
              buildSettingsView(width),
              // ((xs.id) > 0)
              //     ? XiaomiTempSensorScreen(xs, showAppBar: false)
              //     : const Text("Kein Xiaomi Temperatursensor vorhanden")
            ],
          ),
        ),
      ),
    );
  }

  _pushTempSettings(final BuildContext context) async {
    final res = await Navigator.push(
        context,
        MaterialPageRoute<Tuple2<bool, List<HeaterConfig>>>(
            builder: (final BuildContext context) => TempScheduling(widget.device.id), fullscreenDialog: true));
    if (res == null || !res.item1) return;

    widget.device.sendToServer(sm.MessageType.Options, sm.Command.Temp,
        res.item2.map((final f) => jsonEncode(f)).toList(), ref.read(hubConnectionProvider));
  }

  buildColumnView(final double width, final double value) {
    return Column(
      children: [
        BlurryCard(
          margin: const EdgeInsets.only(left: 8, right: 8, top: 8.0),
          child: Row(
            children: [
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), child: const Icon(Icons.person)),
              Consumer(
                builder: (final context, final ref, final child) {
                  return Text(ref.watch(BaseModel.friendlyNameProvider(widget.device.id)));
                },
              ),
            ],
          ),
        ),
        BlurryCard(
          margin: const EdgeInsets.only(left: 8, right: 8, top: 8.0),
          child: Row(
            children: [
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), child: const Icon(Icons.timer)),
              const Text("Zuletzt Empfangen: "),
              Consumer(
                builder: (final context, final ref, final child) {
                  final temperature = ref.watch(HeaterModel.temperatureProvider(widget.device.id));
                  return Text(temperature == null
                      ? "Keine Daten vorliegend"
                      : dayOfWeekToStringMap[temperature.dayOfWeek]! + " " + temperature.timeOfDay.format(context));
                },
              ),
            ],
          ),
        ),
        BlurryCard(
          margin: const EdgeInsets.only(left: 8, right: 8, top: 8.0),
          child: Row(
            children: [
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), child: const Icon(Icons.receipt)),
              const Text("Kalibrierung: "),
              Consumer(builder: (final context, final ref, final child) {
                final currentCalibration = ref.watch(HeaterModel.currentCalibrationProvider(widget.device.id));
                return Text(currentCalibration?.temperature == null
                    ? "Kein Ziel"
                    : currentCalibration!.temperature.toStringAsFixed(1) +
                        "°C " +
                        "(" +
                        dayOfWeekToStringMap[currentCalibration.dayOfWeek]! +
                        " " +
                        currentCalibration.timeOfDay.format(context) +
                        ")");
              }),
            ],
          ),
        ),
        getTempGauge(value)
      ],
    );
  }

  void handlePointerValueChanged(final double value) {
    _setPointerValue(value);
  }

  void handlePointerValueChangedEnd(final double value) {
    handlePointerValueChanged(value);
    widget.device.sendToServer(
        sm.MessageType.Update, sm.Command.Temp, <String>[_annotationValue], ref.read(hubConnectionProvider));
  }

  void handlePointerValueChanging(final ValueChangingArgs args) {
    final model = ref.read(BaseModel.byIdProvider(widget.device.id));
    if (model is! HeaterModel || model.currentConfig == null) return;
    _setPointerValue(model.currentConfig!.temperature);
  }

  /// method to set the pointer value
  void _setPointerValue(final double value) {
    setState(() {
      _value = (value.clamp(5, 35) * 10).roundToDouble() / 10;

      _annotationValue = _value.toStringAsFixed(1);
    });
  }

  buildSettingsView(final double width) {
    return Column(
      children: [
        BlurryCard(
          margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: Row(
            children: [
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: const Icon(SmarthomeIcons.temperature)),
              const Text("Sensor: "),
              TemperatureSensorDropdown(widget.device)
            ],
          ),
        ),
        BlurryCard(
          margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: Row(
            children: [
              Consumer(
                builder: (final context, final ref, final child) {
                  final heaterIcon = ref.watch(iconWidgetSingleProvider(
                      Tuple3(widget.device.typeName, widget.device, AdaptiveTheme.of(context))));
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: heaterIcon,
                  );
                },
              ),
              const Text("Heizung: "),
              Consumer(builder: (final context, final ref, final child) {
                final disableHeater = ref.watch(HeaterModel.disableHeatingProvider(widget.device.id));
                return Switch(
                  value: !disableHeater,
                  onChanged: (final val) {
                    sm.Command command;
                    if (val) {
                      command = sm.Command.On;
                    } else {
                      command = sm.Command.Off;
                    }
                    widget.device.sendToServer(sm.MessageType.Update, command, [], ref.read(hubConnectionProvider));
                  },
                );
              }),
            ],
          ),
        ),
        BlurryCard(
          margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: const Icon(SmarthomeIcons.lamp),
              ),
              const Text("Blaue Led: "),
              Consumer(
                builder: (final context, final ref, final child) {
                  final disableLed = ref.watch(HeaterModel.disableLedProvider(widget.device.id));
                  return Switch(
                    value: !disableLed,
                    onChanged: (final val) {
                      sm.Command command;
                      if (val) {
                        command = sm.Command.On;
                      } else {
                        command = sm.Command.Off;
                      }
                      widget.device.sendToServer(sm.MessageType.Options, command, [], ref.read(hubConnectionProvider));
                    },
                  );
                },
              ),
            ],
          ),
        ),
        BlurryCard(
          margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: MaterialButton(
            onPressed: () => _pushTempSettings(context),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: const Icon(Icons.settings),
                ),
                TextButton(
                  onPressed: () => _pushTempSettings(context),
                  child: const Text("Temperatur Einstellungen"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getTempGauge(final double value) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _annotationValue,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              const Text(
                ' °C',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(),
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                startAngle: 150,
                endAngle: 30,
                radiusFactor: 0.9,
                minimum: 5,
                maximum: 35,
                interval: 1,
                axisLineStyle: const AxisLineStyle(
                    gradient: SweepGradient(colors: [Colors.blue, Colors.amber, Colors.red], stops: [0.3, 0.5, 1]),
                    color: Colors.red,
                    thickness: 0.04,
                    thicknessUnit: GaugeSizeUnit.factor),
                tickOffset: 0.02,
                ticksPosition: ElementsPosition.outside,
                labelOffset: 0.05,
                offsetUnit: GaugeSizeUnit.factor,
                showAxisLine: false,
                showLabels: false,
                labelsPosition: ElementsPosition.outside,
                minorTicksPerInterval: 10,
                minorTickStyle: const MinorTickStyle(length: 0.1),
                majorTickStyle: const MajorTickStyle(length: 0.05, lengthUnit: GaugeSizeUnit.factor),
              ),
              RadialAxis(
                startAngle: 150,
                endAngle: 30,
                radiusFactor: 1,
                minimum: 5,
                maximum: 35,
                interval: 5,
                axisLineStyle: const AxisLineStyle(
                    gradient: SweepGradient(colors: [Colors.blue, Colors.amber, Colors.red], stops: [0.3, 0.5, 1]),
                    color: Colors.red,
                    thickness: 0.04,
                    thicknessUnit: GaugeSizeUnit.factor),
                tickOffset: 0.02,
                ticksPosition: ElementsPosition.outside,
                labelOffset: 0.05,
                offsetUnit: GaugeSizeUnit.factor,
                onAxisTapped: handlePointerValueChangedEnd,
                labelsPosition: ElementsPosition.outside,
                minorTicksPerInterval: 0,
                minorTickStyle: const MinorTickStyle(length: 0.1),
                majorTickStyle: const MajorTickStyle(length: 0.05, lengthUnit: GaugeSizeUnit.factor),
                pointers: <GaugePointer>[
                  MarkerPointer(
                    value: _value,
                    elevation: 1,
                    markerOffset: -20,
                    markerHeight: 25,
                    markerWidth: 20,
                    enableDragging: true,
                    onValueChanged: handlePointerValueChanged,
                    onValueChangeEnd: handlePointerValueChangedEnd,
                    onValueChanging: handlePointerValueChanging,
                    borderColor: Colors.black,
                    borderWidth: 1,
                    color: Colors.white,
                  ),
                  MarkerPointer(
                    value: value,
                    elevation: 10,
                    markerOffset: 5,
                    markerType: MarkerType.triangle,
                    markerHeight: 15,
                    markerWidth: 15,
                    color: Colors.red,
                  ),
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                      widget: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Ausgelesen"),
                          Container(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                // Text("Ausgelesen: "),
                                // Icon(Icons.search),
                                Consumer(
                                  builder: (final context, final ref, final child) {
                                    final temperature = ref.watch(HeaterModel.temperatureProvider(widget.device.id));
                                    return temperature?.temperature == null
                                        ? const Text("Kein Messergebnis", style: TextStyle(fontSize: 24))
                                        : Row(children: [
                                            Text(
                                              temperature!.temperature.toStringAsFixed(1),
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                                            ),
                                            Text(
                                                "°C " "(" +
                                                    dayOfWeekToStringMap[temperature.dayOfWeek]! +
                                                    " " +
                                                    temperature.timeOfDay.format(context) +
                                                    ")",
                                                style: const TextStyle(fontSize: 24))
                                          ]);
                                  },
                                )
                              ],
                            ),
                          ),
                          const Text("Ziel"),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              // Text("Ziel: "),
                              // Icon(Icons.),

                              Consumer(
                                builder: (final context, final ref, final child) {
                                  final currentConfig = ref.watch(HeaterModel.currentConfigProvider(widget.device.id));
                                  return currentConfig?.temperature == null
                                      ? const Text("Keins", style: TextStyle(fontSize: 24))
                                      : Row(
                                          children: [
                                            Text(
                                              currentConfig!.temperature.toStringAsFixed(1),
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                                            ),
                                            Text(
                                              "°C " "(" +
                                                  dayOfWeekToStringMap[currentConfig.dayOfWeek]! +
                                                  " " +
                                                  currentConfig.timeOfDay.format(context) +
                                                  ")",
                                              style: const TextStyle(fontSize: 24),
                                            ),
                                          ],
                                        );
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                      // positionFactor: 0.7,
                      angle: 180)
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

@immutable
class TemperatureSensorDropdown extends ConsumerWidget {
  final Heater device;
  const TemperatureSensorDropdown(this.device, {final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final possibleDevices = ref.watch(devicesByValueStoreKeyProvider("temperature"));
    final model = ref.watch(device.baseModelTProvider(device.id));
    if (model is! HeaterModel) return Container();
    final currentDevice = ref.watch(deviceByIdProvider(model.xiaomiTempSensor ?? -1));
    return DropdownButton(
      items: (possibleDevices
          .map((final f) => DropdownMenuItem(
                value: f,
                child: Consumer(
                  builder: (final context, final ref, final child) {
                    final friendlyName = ref.watch(BaseModel.friendlyNameProvider(f.id));
                    return Text(friendlyName);
                  },
                ),
              ))
          .toList()),
      onChanged: (final dynamic a) {
        device.sendToServer(sm.MessageType.Update, sm.Command.DeviceMapping,
            [a.id.toString(), currentDevice?.id.toString() ?? "0"], ref.read(hubConnectionProvider));
        final models = ref.read(baseModelProvider.notifier);
        final newList = models.state.toList();
        newList.remove(model);
        newList.add(model.copyWith(xiaomiTempSensor: a.id));
        models.state = newList;
      },
      value: currentDevice,
    );
  }
}
