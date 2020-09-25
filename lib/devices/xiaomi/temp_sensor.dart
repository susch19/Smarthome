import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/devices/device.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/xiaomi/temp_sensor_model.dart';
import 'package:smarthome/devices/zigbee/iobroker_history_model.dart';
import 'package:smarthome/models/message.dart' as sm;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'dart:math';

// import 'package:charts_flutter/flutter.dart' as charts;

import 'package:smarthome/icons/icons.dart';
import '../device_manager.dart';

class XiaomiTempSensor extends Device<TempSensorModel> {
  XiaomiTempSensor(int id, TempSensorModel model, HubConnection connection, Icon icon, SharedPreferences prefs)
      : super(id, model, connection, icon, prefs);

  Function func;

  @override
  State<StatefulWidget> createState() => _XiaomiTempSensorState();

  @override
  Future sendToServer(sm.MessageType messageType, sm.Command command, [List<String> parameters]) async {
    await super.sendToServer(messageType, command, parameters);
    var message = new sm.Message(id, messageType, command, parameters);
    var s = message.toJson();
    await connection.invoke("Update", args: <Object>[message.toJson()]);
  }

  @override
  void updateFromServer(Map<String, dynamic> message) {
    baseModel = TempSensorModel.fromJson(message);
    if (func != null) func(() {});
  }

  @override
  void navigateToDevice(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => XiaomiTempSensorScreen(this)));
  }

  @override
  Widget dashboardView() {
    return Column(
        children: (<Widget>[
      Row(
        children: [
          icon,
          Icon((baseModel.battery > 80
              ? SmarthomeIcons.bat4
              : (baseModel.battery > 60
                  ? SmarthomeIcons.bat3
                  : (baseModel.battery > 40
                      ? SmarthomeIcons.bat2
                      : (baseModel.battery > 20 ? SmarthomeIcons.bat1 : SmarthomeIcons.bat_charge))))),
          Icon((baseModel.isConnected ? Icons.check : Icons.close))
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      Text(baseModel?.friendlyName ?? baseModel?.id.toString() ?? ""),
      Text((baseModel?.temperature?.toStringAsFixed(2) ?? "") + " °C"),
      Text((baseModel?.humidity?.toStringAsFixed(2) ?? "") + " %"),
      Text((baseModel?.pressure?.toStringAsFixed(1) ?? "") + " kPA"),
      
    ]+(DeviceManager.showDebugInformation ? <Widget>[
      Text(baseModel.lastReceived.add(Duration(hours: 1))?.toString()),
      Text(baseModel.id.toRadixString(16))
      ] : <Widget>[])));
  }

  @override
  DeviceTypes getDeviceType() {
    return DeviceTypes.XiaomiTempSensor;
  }
}

class _XiaomiTempSensorState extends State<XiaomiTempSensor> {
  @override
  Widget build(BuildContext context) => XiaomiTempSensorScreen(this.widget);
}

class XiaomiTempSensorScreen extends DeviceScreen {
  final XiaomiTempSensor tempSensor;
  final bool showAppBar;
  XiaomiTempSensorScreen(this.tempSensor, {this.showAppBar = true});

  @override
  State<StatefulWidget> createState() => _XiaomiTempSensorScreenState();
}

class _XiaomiTempSensorScreenState extends State<XiaomiTempSensorScreen> with SingleTickerProviderStateMixin {
  List<IoBrokerHistoryModel> histories;
  DateTime currentShownTime;

  @override
  void initState() {
    super.initState();
    this.widget.tempSensor.func = setState;
    histories = new List<IoBrokerHistoryModel>();
    currentShownTime = DateTime.now();
    this
        .widget
        .tempSensor
        .getFromServer("GetIoBrokerHistories", [this.widget.tempSensor.id, currentShownTime.toString()]).then((x) {
      for (var hist in x) {
        histories.add(IoBrokerHistoryModel.fromJson(hist));
      }
      setState(() {});
    });
  }

  @override
  void deactivate() {
    super.deactivate();
    this.widget.tempSensor.func = null;
  }

  void changeColor() {}

  void changeDelay(int delay) {
    this.widget.tempSensor.sendToServer(sm.MessageType.Options, sm.Command.Delay, ["delay=$delay"]);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: this.widget.showAppBar,

          // flexibleSpace: Text("Xiaomi Sensor " + this.widget.tempSensor.baseModel.friendlyName),
          title: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(SmarthomeIcons.temperature)),
              Tab(icon: Icon(Icons.cloud)),
              Tab(
                icon: Icon(SmarthomeIcons.wi_barometer, size: 38.0,),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildListView(this.widget.tempSensor.baseModel),
            buildGraphViewTemp(),
            buildGraphViewHumidity(),
            buildGraphViewPressure(),
          ],
        ),
      ),
    );
  }

  Widget buildListView(TempSensorModel model) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return ListView(
          // crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
          shrinkWrap: true,
          children: (DeviceManager.showDebugInformation
                  ? <Widget>[
                      ListTile(
                        title: Text("ID: " + model.id.toRadixString(16)),
                      ),
                    ]
                  : <Widget>[]) +
              <Widget>[
                ListTile(
                  title: Text(model.friendlyName),
                ),
                ListTile(
                  title: Text("Temperature: " + model.temperature.toStringAsFixed(2) + " °C"),
                ),
                ListTile(
                  title: Text("Luftdruck: " + model.pressure.toStringAsFixed(1) + " kPa"),
                ),
                ListTile(
                  title: Text("Luftfeuchtigkeit: " + model.humidity.toStringAsFixed(2) + " %"),
                ),
                ListTile(
                  title: Text("Battery: " + model.battery.toStringAsFixed(0) + " %"),
                ),
                ListTile(
                  title: Text("Verfügbar: " + (model.available ? "Ja" : "Nein")),
                ),
                ListTile(
                  title: Text("Zuletzt empfangen: " + (model.lastReceived.add(Duration(hours: 1))?.toString())),
                ),
              ],
        );
      },
    );
  }

  // Widget buildGraphViewTempAndHumidity() {
  //   return TimeSeriesRangeAnnotationChart(
  //       histories
  //           .where((x) => x.historyRecords.first.value < 800)
  //           .map((h) => charts.LineSeries<TimeSeriesValue, DateTime>(
  //                 id: h.propertyName,
  //                 domainFn: (TimeSeriesValue value, _) => value.time,
  //                 measureFn: (TimeSeriesValue value, _) => value.value,
  //                 data: h.historyRecords
  //                     .map((x) => TimeSeriesValue(DateTime(1970).add(Duration(milliseconds: x.timeStamp)), x.value))
  //                     .toList(),
  //               ))
  //           .toList(),
  //       animate: true);
  // }

  Widget buildGraphViewHumidity() {
    var h = histories.firstWhere((x) => x.propertyName == "humidity", orElse: () => null);
    if (h != null) return buildTimeSeriesRangeAnnotationChart(h, " %", "rel. Luftfeuchtigkeit", Colors.blueAccent);
    return buildDataMissing();
  }

  Widget buildGraphViewTemp() {
    var h = histories.firstWhere((x) => x.propertyName == "temperature", orElse: () => null);
    if (h != null) return buildTimeSeriesRangeAnnotationChart(h, " °C", "Temperatur", Colors.redAccent);
    return buildDataMissing();
  }

  Widget buildGraphViewPressure() {
    var h = histories.firstWhere((x) => x.propertyName == "pressure", orElse: () => null);
    if (h != null) return buildTimeSeriesRangeAnnotationChart(h, " hPA", "Luftdruck", Colors.greenAccent);
    return buildDataMissing();
  }

  Widget buildDataMissing() {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Expanded(
            child: Text("Daten werden geladen oder sind nicht vorhanden für " +
                currentShownTime.day.toString() +
                "." +
                currentShownTime.month.toString() +
                "." +
                currentShownTime.year.toString())),
        Row(
          children: <Widget>[
            Expanded(
                child: MaterialButton(
              child: Text("Früher"),
              onPressed: () {
                getNewData(currentShownTime.subtract(Duration(days: 1)));
              },
            )),
            Expanded(
                child: MaterialButton(
              child: Text("Später"),
              onPressed: () {
                getNewData(currentShownTime.add(Duration(days: 1)));
              },
            )),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        )
      ],
    );
  }

  Widget buildTimeSeriesRangeAnnotationChart(IoBrokerHistoryModel h, String unit, String valueName, Color lineColor) {
    h.historyRecords = h.historyRecords.where((x) => x.value != null).toList(growable: false);
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Expanded(
            child: TimeSeriesRangeAnnotationChart([
          LineSeries<TimeSeriesValue, DateTime>(
              enableTooltip: true,
              animationDuration: 2500,
              dataSource: h.historyRecords
                  .map((x) =>
                      TimeSeriesValue(DateTime(1970).add(Duration(milliseconds: x.timeStamp)), x.value, lineColor))
                  .toList(),
              xValueMapper: (TimeSeriesValue value, _) => value.time,
              yValueMapper: (TimeSeriesValue value, _) => value.value,
              pointColorMapper: (TimeSeriesValue value, _) => value.lineColor,
              width: 2)
        ], h.historyRecords.map((x) => x.value).fold(10000, min), h.historyRecords.map((x) => x.value).fold(0, max),
                unit, valueName)),
        Row(
          children: <Widget>[
            Expanded(
                child: MaterialButton(
              child: Text("Früher"),
              onPressed: () {
                getNewData(currentShownTime.subtract(Duration(days: 1)));
              },
            )),
            Expanded(
                child: MaterialButton(
              child: Text("Später"),
              onPressed: () {
                getNewData(currentShownTime.add(Duration(days: 1)));
              },
            )),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        )
      ],
    );
  }

  getNewData(DateTime dt) {
    if (dt.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch) return;
    this.widget.tempSensor.getFromServer("GetIoBrokerHistories", [this.widget.tempSensor.id, dt.toString()]).then((x) {
      currentShownTime = dt;
      histories.clear();
      for (var hist in x) {
        var histo = IoBrokerHistoryModel.fromJson(hist);
        histo.historyRecords = histo.historyRecords.where((x) => x.value != null).toList();
        histories.add(histo);
      }
      setState(() {});
    });
  }

  // Widget buildGraphViewPressure() {
  //   return TimeSeriesRangeAnnotationChart(histories
  //       .where((x) => x.historyRecords.first.value > 800)
  //       .map((h) => charts.Series<TimeSeriesValue, DateTime>(
  //             id: h.propertyName,
  //             domainFn: (TimeSeriesValue value, _) => value.time,
  //             measureFn: (TimeSeriesValue value, _) => value.value,
  //             data: h.historyRecords
  //                 .map((x) => TimeSeriesValue(DateTime(1970).add(Duration(milliseconds: x.timeStamp)), x.value))
  //                 .toList(),
  //           ))
  //       .toList());
  // }
}

class TimeSeriesRangeAnnotationChart extends StatelessWidget {
  final List<LineSeries> seriesList;
  final double min;
  final double max;
  final String unit;
  final String valueName;

  TimeSeriesRangeAnnotationChart(this.seriesList, this.min, this.max, this.unit, this.valueName);

  // @override
  // Widget build(BuildContext context) {
  //   return new charts.TimeSeriesChart(
  //     seriesList,
  //     animate: animate,
  //     behaviors: [
  //       new charts.RangeAnnotation([
  //         new charts.RangeAnnotationSegment(
  //             DateTime.now(), DateTime.now().subtract(Duration(days: 0)), charts.RangeAnnotationAxisType.domain),
  //       ]),
  //       charts.SeriesLegend(),
  //     ],
  //     defaultRenderer: charts.LineRendererConfig(includePoints: true, radiusPx: 2.2),
  //     selectionModels: [
  //       charts.SelectionModelConfig(changedListener: _onSelectionChanged, type: charts.SelectionModelType.info)
  //     ],
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return SfCartesianChart(
        primaryXAxis: DateTimeAxis(
            interval: orientation == Orientation.landscape ? 3 : 6,
            intervalType: DateTimeIntervalType.hours,
            dateFormat: DateFormat("d.M HH:MM"),
            majorGridLines: MajorGridLines(width: 0),
            title: AxisTitle(text: 'Zeit')),
        primaryYAxis: NumericAxis(
            minimum: (min - (((max - min) < 10 ? 10 : (max - min)) / 10)).roundToDouble(),
            maximum: (max + (((max - min) < 10 ? 10 : (max - min)) / 10)).roundToDouble(),
            interval: (((max - min) < 10 ? 10 : (max - min)) / 10).roundToDouble(),
            axisLine: AxisLine(width: 0),
            labelFormat: '{value}' + unit,
            majorTickLines: MajorTickLines(size: 0),
            title: AxisTitle(text: valueName)),
        series: seriesList,
        trackballBehavior: TrackballBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
            lineType: TrackballLineType.vertical,
            tooltipSettings: InteractiveTooltip(format: '{point.x} : {point.y}')),
      );
    });
  }
}

/// Sample time series data type.
class TimeSeriesValue {
  final DateTime time;
  final double value;
  final Color lineColor;

  TimeSeriesValue(this.time, this.value, this.lineColor);
}
