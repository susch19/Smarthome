import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:signalr_client/signalr_client.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/controls/blurry_card.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/heater/heater_config.dart';
import 'package:smarthome/helper/preference_manager.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/icons/smarthome_icons.dart';
import 'package:smarthome/models/message.dart' as sm;
import 'package:smarthome/icons/icons.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'temp_scheduling.dart';

class Heater extends Device<HeaterModel> {
  Heater(int? id, String typeName, HeaterModel baseModel, HubConnection connection, IconData icon)
      : super(id, typeName, baseModel, connection, icon);

  @override
  void navigateToDevice(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => HeaterScreen(this)));
  }

  void updateFromServer(Map<String, dynamic> message) {
    super.updateFromServer(message);
    PreferencesManager.instance.setString("Json" + id.toString(), jsonEncode(message));
  }

  @override
  Widget? lowerLeftWidget() {
    return Icon(
      baseModel.disableHeating ?? false ? Icons.power_off_outlined : Icons.power_outlined,
      size: 20,
    );
  }

  @override
  Widget dashboardCardBody() {
    // XiaomiTempSensor xs = DeviceManager.devices.firstWhere((x) => x.id == baseModel.xiaomiTempSensor, orElse: () {
    //   return XiaomiTempSensor(0, TempSensorModel(0, "", false), connection, icon);
    // }) as XiaomiTempSensor;
    return Column(
      children: <Widget>[
            Row(children: [
              Text(
                (baseModel.temperature?.temperature.toStringAsFixed(1) ?? ""),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Text(
                " °C",
                style: TextStyle(fontSize: 18),
              ),
            ], mainAxisAlignment: MainAxisAlignment.center),
            Container(
              height: 2,
            ),
            Row(children: [
              Text(
                baseModel.currentConfig == null
                    ? ""
                    : ((baseModel.currentConfig?.temperature.toStringAsFixed(1) ?? "")),
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Text(
                "°C",
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ], mainAxisAlignment: MainAxisAlignment.center),
            !DeviceManager.showDebugInformation
                ? Container()
                : Row(
                    children: [Text(baseModel.firmwareVersion.toString())],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
            // (xs.id == 0 ? Text(baseModel.xiaomiTempSensor.toString()) : Text(xs.baseModel.friendlyName)),
          ] +
          (DeviceManager.showDebugInformation ? [Text(baseModel.id.toString())] : <Widget>[]),
    );
  }

  @override
  DeviceTypes getDeviceType() {
    return DeviceTypes.Heater;
  }
}

class HeaterScreen extends DeviceScreen {
  final Heater heater;

  HeaterScreen(this.heater);

  @override
  State<StatefulWidget> createState() => _HeaterScreenState();
}

class _HeaterScreenState extends State<HeaterScreen> {
  double? temp = 11;
  String tempString() => temp!.toStringAsFixed(1) + "°C";
  TextEditingController? textEditingController;
  String _annotationValue = '9.0';
  double _value = 9.0;
  late Heater heater;
  late StreamSubscription sub;

  @override
  void initState() {
    heater = this.widget.heater;
    sub = heater.listenOnUpdateFromServer((heaterModel) {
      handlePointerValueChanged(heaterModel.currentConfig!.temperature);
      setState(() {});
    });

    handlePointerValueChanged(this.widget.heater.baseModel.currentConfig?.temperature ?? 21);
    textEditingController = TextEditingController(text: tempString());
    // _setPointerValue(this.widget.heater.baseModel.currentConfig?.temperature ?? 21.0);
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
    sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    XiaomiTempSensor xs =
        DeviceManager.devices.firstWhere((x) => x.id == this.widget.heater.baseModel.xiaomiTempSensor, orElse: () {
      return XiaomiTempSensor(
          -1,
          "",
          TempSensorModel(-1, "", false)..temperature = this.widget.heater.baseModel.temperature?.temperature ?? 21,
          this.widget.heater.connection,
          this.widget.heater.icon);
    }) as XiaomiTempSensor;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: [
              Tab(
                icon: Icon(this.widget.heater.icon),
              ),
              Tab(
                icon: Icon(Icons.settings),
              ),
              Tab(icon: Icon(SmarthomeIcons.temperature)),
            ],
          ),
        ),
        body: // buildColumnView(width, xs),
            Container(
          decoration: ThemeManager.getBackgroundDecoration(context),
          child: TabBarView(
            children: [
              buildColumnView(width, xs),
              buildSettingsView(width, xs),
              ((xs.id ?? -1) > 0)
                  ? XiaomiTempSensorScreen(xs, showAppBar: false)
                  : Text("Kein Xiaomi Temperatursensor vorhanden")
            ],
          ),
        ),
      ),
    );
  }

  _pushTempSettings(BuildContext context) async {
    var dc = await widget.heater.getFromServer("GetConfig", [widget.heater.id]);
    List<HeaterConfig> heaterConfigs;
    if (dc != "[]" && dc != null)
      heaterConfigs = new List<HeaterConfig>.from(jsonDecode(dc).map((f) => HeaterConfig.fromJson(f)));
    else
      heaterConfigs = <HeaterConfig>[];

    final res = await Navigator.push(
        context,
        new MaterialPageRoute<Tuple<bool, List<HeaterConfig>>>(
            builder: (BuildContext context) => TempScheduling(heaterConfigs), fullscreenDialog: true));
    if (res == null || !res.item1) return;

    widget.heater.sendToServer(sm.MessageType.Options, sm.Command.Temp, res.item2.map((f) => jsonEncode(f)).toList());
  }

  buildColumnView(double width, XiaomiTempSensor xs) {
    return Column(
      children: [
        BlurryCard(
          margin: EdgeInsets.only(left: 8, right: 8, top: 8.0),
          child: Row(
            children: [
              Container(margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), child: Icon(Icons.person)),
              Text(widget.heater.baseModel.friendlyName),
            ],
          ),
        ),
        BlurryCard(
          margin: EdgeInsets.only(left: 8, right: 8, top: 8.0),
          child: Row(
            children: [
              Container(margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), child: Icon(Icons.timer)),
              Text("Zuletzt Empfangen: "),
              Text(widget.heater.baseModel.temperature == null
                  ? "Keine Daten vorliegend"
                  : DayOfWeekToStringMap[widget.heater.baseModel.temperature!.dayOfWeek]! +
                      " " +
                      widget.heater.baseModel.temperature!.timeOfDay.format(context)),
            ],
          ),
        ),
        BlurryCard(
          margin: EdgeInsets.only(left: 8, right: 8, top: 8.0),
          child: Row(
            children: [
              Container(margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), child: Icon(Icons.receipt)),
              Text("Kalibrierung: "),
              Text(widget.heater.baseModel.currentCalibration?.temperature == null
                  ? "Kein Ziel"
                  : widget.heater.baseModel.currentCalibration!.temperature.toStringAsFixed(1) +
                      "°C " +
                      "(" +
                      DayOfWeekToStringMap[widget.heater.baseModel.currentCalibration!.dayOfWeek]! +
                      " " +
                      widget.heater.baseModel.currentCalibration!.timeOfDay.format(context) +
                      ")"),
            ],
          ),
        ),
        getTempGauge(xs)
      ],
    );
  }

  void handlePointerValueChanged(double value) {
    _setPointerValue(value);
  }

  void handlePointerValueChangedEnd(double value) {
    handlePointerValueChanged(value);
    this.widget.heater.sendToServer(sm.MessageType.Update, sm.Command.Temp, <String>[_annotationValue]);
  }

  void handlePointerValueChanging(ValueChangingArgs args) {
    // if ((args.value.toInt() - _value).abs() > 2.4) {
    // args.cancel = true;
    _setPointerValue(heater.baseModel.currentConfig!.temperature);
    // }
  }

  /// method to set the pointer value
  void _setPointerValue(double value) {
    setState(() {
      _value = (value.clamp(5, 35) * 10).roundToDouble() / 10;

      _annotationValue = '${_value.toStringAsFixed(1)}';
    });
  }

  buildSettingsView(double width, XiaomiTempSensor xs) {
    return Column(
      children: [
        BlurryCard(
          margin: EdgeInsets.only(left: 8, right: 8, top: 8),
          child: Row(
            children: [
              Container(
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: Icon(SmarthomeIcons.temperature)),
              Text("Sensor: "),
              DropdownButton(
                items: (DeviceManager.getDevicesOfType<XiaomiTempSensor>()
                    .map((f) => DropdownMenuItem(
                          child: Text("${f.baseModel.friendlyName} ${f.baseModel.temperature}°C"),
                          value: f,
                        ))
                    .toList()),
                onChanged: (dynamic a) {
                  this.widget.heater.sendToServer(sm.MessageType.Update, sm.Command.DeviceMapping, [
                    a.id.toString(),
                    this.widget.heater.baseModel.xiaomiTempSensor == null
                        ? "0"
                        : this.widget.heater.baseModel.xiaomiTempSensor.toString()
                  ]);
                  this.widget.heater.baseModel.xiaomiTempSensor = a.id;
                  setState(() {});
                },
                value: ((xs.id ?? -1) < 0 ? null : xs),
              ),
            ],
          ),
        ),
        BlurryCard(
          margin: EdgeInsets.only(left: 8, right: 8, top: 8),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Icon(this.widget.heater.icon),
              ),
              Text("Heizung: "),
              Switch(
                value: !this.widget.heater.baseModel.disableHeating!,
                onChanged: (val) {
                  sm.Command command;
                  if (val)
                    command = sm.Command.On;
                  else
                    command = sm.Command.Off;
                  this.widget.heater.sendToServer(sm.MessageType.Update, command, []);
                },
              ),
            ],
          ),
        ),
        BlurryCard(
          margin: EdgeInsets.only(left: 8, right: 8, top: 8),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Icon(SmarthomeIcons.lamp),
              ),
              Text("Blaue Led: "),
              Switch(
                value: !this.widget.heater.baseModel.disableLed!,
                onChanged: (val) {
                  sm.Command command;
                  if (val)
                    command = sm.Command.On;
                  else
                    command = sm.Command.Off;
                  this.widget.heater.sendToServer(sm.MessageType.Options, command, []);
                },
              ),
            ],
          ),
        ),
        BlurryCard(
          margin: EdgeInsets.only(left: 8, right: 8, top: 8),
          child: MaterialButton(
            onPressed: () => _pushTempSettings(context),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 4.0),
                  child: Icon(Icons.settings),
                ),
                TextButton(
                  onPressed: () => _pushTempSettings(context),
                  child: Text("Temperatur Einstellungen"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getTempGauge(XiaomiTempSensor xs) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _annotationValue,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              Text(
                ' °C',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 0.0),
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                showFirstLabel: true,
                startAngle: 150,
                endAngle: 30,
                radiusFactor: 0.9,
                minimum: 5,
                maximum: 35,
                interval: 1,
                canScaleToFit: false,
                axisLineStyle: const AxisLineStyle(
                    gradient: SweepGradient(colors: [Colors.blue, Colors.amber, Colors.red], stops: [0.3, 0.5, 1]),
                    color: Colors.red,
                    thickness: 0.04,
                    thicknessUnit: GaugeSizeUnit.factor,
                    cornerStyle: CornerStyle.bothFlat),
                tickOffset: 0.02,
                showTicks: true,
                ticksPosition: ElementsPosition.outside,
                labelOffset: 0.05,
                offsetUnit: GaugeSizeUnit.factor,
                showAxisLine: false,
                showLabels: false,
                labelsPosition: ElementsPosition.outside,
                minorTicksPerInterval: 10,
                minorTickStyle: const MinorTickStyle(length: 0.1, lengthUnit: GaugeSizeUnit.logicalPixel),
                majorTickStyle: const MajorTickStyle(length: 0.05, lengthUnit: GaugeSizeUnit.factor),
              ),
              RadialAxis(
                showFirstLabel: true,
                startAngle: 150,
                endAngle: 30,
                radiusFactor: 1,
                minimum: 5,
                maximum: 35,
                interval: 5,
                canScaleToFit: false,
                axisLineStyle: const AxisLineStyle(
                    gradient: SweepGradient(colors: [Colors.blue, Colors.amber, Colors.red], stops: [0.3, 0.5, 1]),
                    color: Colors.red,
                    thickness: 0.04,
                    thicknessUnit: GaugeSizeUnit.factor,
                    cornerStyle: CornerStyle.bothFlat),
                tickOffset: 0.02,
                showTicks: true,
                ticksPosition: ElementsPosition.outside,
                labelOffset: 0.05,
                offsetUnit: GaugeSizeUnit.factor,
                onAxisTapped: handlePointerValueChangedEnd,
                showAxisLine: true,
                labelsPosition: ElementsPosition.outside,
                minorTicksPerInterval: 0,
                minorTickStyle: const MinorTickStyle(length: 0.1, lengthUnit: GaugeSizeUnit.logicalPixel),
                majorTickStyle: const MajorTickStyle(length: 0.05, lengthUnit: GaugeSizeUnit.factor),
                pointers: <GaugePointer>[
                  MarkerPointer(
                    value: _value,
                    elevation: 1,
                    markerOffset: -20,
                    markerType: MarkerType.invertedTriangle,
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
                    value: xs.baseModel.temperature,
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
                          Text("Ausgelesen"),
                          Container(
                            margin: EdgeInsets.only(bottom: 16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                // Text("Ausgelesen: "),
                                // Icon(Icons.search),
                                widget.heater.baseModel.temperature?.temperature == null
                                    ? Text("Kein Messergebnis", style: TextStyle(fontSize: 24))
                                    : Row(children: [
                                        Text(
                                          widget.heater.baseModel.temperature!.temperature.toStringAsFixed(1),
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                                        ),
                                        Text(
                                            "°C " +
                                                "(" +
                                                DayOfWeekToStringMap[widget.heater.baseModel.temperature!.dayOfWeek]! +
                                                " " +
                                                widget.heater.baseModel.temperature!.timeOfDay.format(context) +
                                                ")",
                                            style: TextStyle(fontSize: 24))
                                      ])
                              ],
                            ),
                          ),
                          Text("Ziel"),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              // Text("Ziel: "),
                              // Icon(Icons.),
                              widget.heater.baseModel.currentConfig?.temperature == null
                                  ? Text("Keins", style: TextStyle(fontSize: 24))
                                  : Row(
                                      children: [
                                        Text(
                                          widget.heater.baseModel.currentConfig!.temperature.toStringAsFixed(1),
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                                        ),
                                        Text(
                                          "°C " +
                                              "(" +
                                              DayOfWeekToStringMap[widget.heater.baseModel.currentConfig!.dayOfWeek]! +
                                              " " +
                                              widget.heater.baseModel.currentConfig!.timeOfDay.format(context) +
                                              ")",
                                          style: TextStyle(fontSize: 24),
                                        ),
                                      ],
                                    ),
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
