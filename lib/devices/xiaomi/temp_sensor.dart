import 'dart:async';
import 'dart:typed_data';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/devices/device.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/xiaomi/temp_sensor_model.dart';
import 'package:smarthome/devices/zigbee/iobroker_history_model.dart';
import 'package:smarthome/models/message.dart' as sm;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'dart:math';

// import 'package:charts_flutter/flutter.dart' as charts;

import 'package:smarthome/icons/icons.dart';
import 'package:smarthome/helper/theme_manager.dart';
import '../device_manager.dart';
import '../../helper/datetime_helper.dart';

class XiaomiTempSensor extends Device<TempSensorModel> {
  XiaomiTempSensor(
      int? id, String typeName, TempSensorModel model, HubConnection connection,
      {IconData? icon, Uint8List? iconBytes})
      : super(id, typeName, model, connection,
            iconData: icon, iconBytes: iconBytes);

  @override
  void navigateToDevice(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => XiaomiTempSensorScreen(this)));
  }

  @override
  Widget rightWidgets() {
    return Icon(
      (baseModel.battery > 80
          ? SmarthomeIcons.bat4
          : (baseModel.battery > 60
              ? SmarthomeIcons.bat3
              : (baseModel.battery > 40
                  ? SmarthomeIcons.bat2
                  : (baseModel.battery > 20
                      ? SmarthomeIcons.bat1
                      : SmarthomeIcons.bat_charge)))),
      size: 20,
    );
  }

  @override
  Widget dashboardCardBody() {
    return Column(
        children: (<Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text((baseModel.temperature.toStringAsFixed(1)),
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                Text(" °C", style: TextStyle(fontSize: 18))
              ]),
              Container(
                height: 2,
              ),
              Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.spaceEvenly,
                children: [
                  Text((baseModel.humidity.toStringAsFixed(0) + " %"),
                      style: TextStyle()),
                  Container(
                    width: 8,
                  ),
                  Text((baseModel.pressure.toStringAsFixed(0) + " kPA"),
                      style: TextStyle()),
                ],
              ),
            ] +
            (DeviceManager.showDebugInformation
                ? <Widget>[
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(baseModel.lastReceived.toDate()),
                    ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text(baseModel.id.toRadixString(16))]),
                  ]
                : <Widget>[])));
  }

  @override
  DeviceTypes getDeviceType() {
    return DeviceTypes.XiaomiTempSensor;
  }
}

class XiaomiTempSensorScreen extends DeviceScreen {
  final XiaomiTempSensor? tempSensor;
  final bool showAppBar;
  XiaomiTempSensorScreen(this.tempSensor, {this.showAppBar = true});

  @override
  State<StatefulWidget> createState() => _XiaomiTempSensorScreenState();
}

class _XiaomiTempSensorScreenState extends State<XiaomiTempSensorScreen>
    with SingleTickerProviderStateMixin {
  late List<IoBrokerHistoryModel> histories;
  late DateTime currentShownTime;
  late StreamSubscription sub;

  @override
  void initState() {
    super.initState();
    currentShownTime = DateTime.now();
    histories = <IoBrokerHistoryModel>[];
    this.widget.tempSensor!.getFromServer("GetIoBrokerHistories",
        [this.widget.tempSensor!.id, currentShownTime.toString()]).then((x) {
      for (var hist in x) {
        histories.add(IoBrokerHistoryModel.fromJson(hist));
      }
      setState(() {});
    });
    sub = this.widget.tempSensor!.listenOnUpdateFromServer((p0) {
      setState(() {});
    });
  }

  @override
  void deactivate() {
    super.deactivate();
    sub.cancel();
  }

  void changeColor() {}

  void changeDelay(int delay) {
    this.widget.tempSensor!.sendToServer(
        sm.MessageType.Options, sm.Command.Delay, ["delay=$delay"]);
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
                icon: Icon(
                  SmarthomeIcons.wi_barometer,
                  size: 38.0,
                ),
              )
            ],
          ),
        ),
        body: Container(
          decoration: ThemeManager.getBackgroundDecoration(context),
          child: TabBarView(
            children: [
              buildListView(this.widget.tempSensor!.baseModel),
              buildGraphViewTemp(),
              buildGraphViewHumidity(),
              buildGraphViewPressure(),
            ],
          ),
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
                  title: Text("Temperature: " +
                      model.temperature.toStringAsFixed(2) +
                      " °C"),
                ),
                ListTile(
                  title: Text("Luftdruck: " +
                      model.pressure.toStringAsFixed(1) +
                      " kPa"),
                ),
                ListTile(
                  title: Text("Luftfeuchtigkeit: " +
                      model.humidity.toStringAsFixed(2) +
                      " %"),
                ),
                ListTile(
                  title: Text(
                      "Battery: " + model.battery.toStringAsFixed(0) + " %"),
                ),
                ListTile(
                  title:
                      Text("Verfügbar: " + (model.available ? "Ja" : "Nein")),
                ),
                ListTile(
                  title:
                      Text("Zuletzt empfangen: " + model.lastReceived.toDate()),
                ),
              ],
        );
      },
    );
  }

  Widget buildGraphViewHumidity() {
    var h = histories.firstWhereOrNull((x) => x.propertyName == "humidity");
    if (h != null)
      return buildTimeSeriesRangeAnnotationChart(
          h,
          " %",
          "rel. Luftfeuchtigkeit",
          AdaptiveTheme.of(context).mode.isLight
              ? Colors.blueAccent.shade700
              : Colors.blueAccent.shade100);
    return buildDataMissing();
  }

  Widget buildGraphViewTemp() {
    var h = histories.firstWhereOrNull((x) => x.propertyName == "temperature");
    if (h != null)
      return buildTimeSeriesRangeAnnotationChart(
          h,
          " °C",
          "Temperatur",
          AdaptiveTheme.of(context).mode.isLight
              ? Colors.redAccent.shade700
              : Colors.redAccent);
    return buildDataMissing();
  }

  Widget buildGraphViewPressure() {
    var h = histories.firstWhereOrNull((x) => x.propertyName == "pressure");
    if (h != null)
      return buildTimeSeriesRangeAnnotationChart(
          h,
          " hPA",
          "Luftdruck",
          AdaptiveTheme.of(context).mode.isLight
              ? Colors.greenAccent.shade700
              : Colors.greenAccent.shade400);
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

  Widget buildTimeSeriesRangeAnnotationChart(
      IoBrokerHistoryModel h, String unit, String valueName, Color lineColor) {
    h.historyRecords =
        h.historyRecords.where((x) => x.value != null).toList(growable: false);
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Expanded(
          child: TimeSeriesRangeAnnotationChart(
            [
              LineSeries<TimeSeriesValue, DateTime>(
                  enableTooltip: true,
                  animationDuration: 500,
                  // markerSettings: MarkerSettings(shape: DataMarkerType.circle, color: Colors.green, width: 5, height: 5, isVisible: true),
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    shape: DataMarkerType.circle,
                  ),
                  dataSource: h.historyRecords
                      .map((x) => TimeSeriesValue(
                          DateTime(1970)
                              .add(Duration(milliseconds: x.timeStamp)),
                          x.value,
                          lineColor))
                      .toList(),
                  xValueMapper: (TimeSeriesValue value, _) => value.time,
                  yValueMapper: (TimeSeriesValue value, _) => value.value,
                  pointColorMapper: (TimeSeriesValue value, _) =>
                      value.lineColor,
                  width: 2)
            ],
            h.historyRecords
                .where((x) => x.value != null)
                .map((x) => x.value!)
                .fold(10000, min),
            h.historyRecords
                .where((x) => x.value != null)
                .map((x) => x.value!)
                .fold(0, max),
            unit,
            valueName,
            currentShownTime,
          ),
        ),
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
    if (dt.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch)
      return;
    this.widget.tempSensor!.getFromServer("GetIoBrokerHistories",
        [this.widget.tempSensor!.id, dt.toString()]).then((x) {
      currentShownTime = dt;
      histories.clear();
      for (var hist in x) {
        var histo = IoBrokerHistoryModel.fromJson(hist);
        histo.historyRecords =
            histo.historyRecords.where((x) => x.value != null).toList();
        histories.add(histo);
      }
      setState(() {});
    });
  }
}

class TimeSeriesRangeAnnotationChart extends StatelessWidget {
  final List<LineSeries> seriesList;
  final double min;
  final double max;
  final String unit;
  final String valueName;
  final DateTime shownDate;

  TimeSeriesRangeAnnotationChart(this.seriesList, this.min, this.max, this.unit,
      this.valueName, this.shownDate);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return SfCartesianChart(
        primaryXAxis: DateTimeAxis(
            interval: orientation == Orientation.landscape ? 2 : 4,
            intervalType: DateTimeIntervalType.hours,
            dateFormat: DateFormat("HH:mm"),
            majorGridLines: MajorGridLines(width: 0),
            title: AxisTitle(text: DateFormat("dd.MM.yyyy").format(shownDate))),
        primaryYAxis: NumericAxis(
            minimum: (min - (((max - min) < 10 ? 10 : (max - min)) / 10))
                .roundToDouble(),
            maximum: (max + (((max - min) < 10 ? 10 : (max - min)) / 10))
                .roundToDouble(),
            interval:
                (((max - min) < 10 ? 10 : (max - min)) / 10).roundToDouble(),
            axisLine: AxisLine(width: 0),
            labelFormat: '{value}' + unit,
            majorTickLines: MajorTickLines(size: 0),
            title: AxisTitle(text: valueName)),
        series: seriesList,
        trackballBehavior: TrackballBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
            lineType: TrackballLineType.vertical,
            tooltipSettings:
                InteractiveTooltip(format: '{point.x} : {point.y}')),
        enableAxisAnimation: false,
      );
    });
  }
}

/// Sample time series data type.
class TimeSeriesValue {
  final DateTime time;
  final double? value;
  final Color lineColor;

  TimeSeriesValue(this.time, this.value, this.lineColor);
}
