import 'dart:typed_data';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/zigbee/iobroker_history_model.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/models/message.dart' as sm;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smarthome/icons/icons.dart';
import 'package:smarthome/helper/theme_manager.dart';
import '../../helper/datetime_helper.dart';

class XiaomiTempSensor extends Device<TempSensorModel> {
  XiaomiTempSensor(final int id, final String typeName, {final IconData? icon, final Uint8List? iconBytes})
      : super(id, typeName, iconData: icon, iconBytes: iconBytes);

  @override
  void navigateToDevice(final BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (final BuildContext context) => XiaomiTempSensorScreen(this)));
  }

  @override
  Widget getRightWidgets() {
    return Consumer(
      builder: (final context, final ref, final child) {
        final battery = ref.watch(TempSensorModel.batteryProvider(id));
        return Icon(
          (battery > 80
              ? SmarthomeIcons.bat4
              : (battery > 60
                  ? SmarthomeIcons.bat3
                  : (battery > 40
                      ? SmarthomeIcons.bat2
                      : (battery > 20 ? SmarthomeIcons.bat1 : SmarthomeIcons.bat_charge)))),
          size: 20,
        );
      },
    );
  }

  @override
  Widget dashboardCardBody() {
    return Consumer(
      builder: (final context, final ref, final child) {
        return Column(
            children: (<Widget>[
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Consumer(
                      builder: (final context, final ref, final child) {
                        return Text((ref.watch(TempSensorModel.temperatureProvider(id)).toStringAsFixed(1)),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24));
                      },
                    ),
                    const Text(" °C", style: TextStyle(fontSize: 18))
                  ]),
                  Container(
                    height: 2,
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.spaceEvenly,
                    children: [
                      Consumer(
                        builder: (final context, final ref, final child) {
                          return Text(("${ref.watch(TempSensorModel.humidityProvider(id)).toStringAsFixed(0)} %"),
                              style: const TextStyle());
                        },
                      ),
                      Container(
                        width: 8,
                      ),
                      Consumer(
                        builder: (final context, final ref, final child) {
                          return Text(("${ref.watch(TempSensorModel.pressureProvider(id)).toStringAsFixed(0)} hPa"),
                              style: const TextStyle());
                        },
                      ),
                    ],
                  ),
                ] +
                (DeviceManager.showDebugInformation
                    ? <Widget>[
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Consumer(
                            builder: (final context, final ref, final child) {
                              return Text(ref.watch(ZigbeeModel.lastReceivedProvider(id)).toDate());
                            },
                          )
                        ]),
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(id.toRadixString(16))]),
                      ]
                    : <Widget>[])));
      },
    );
  }

  @override
  DeviceTypes getDeviceType() {
    return DeviceTypes.XiaomiTempSensor;
  }
}

class XiaomiTempSensorScreen extends ConsumerStatefulWidget {
  final XiaomiTempSensor device;
  final bool showAppBar;
  const XiaomiTempSensorScreen(this.device, {this.showAppBar = true, final Key? key}) : super(key: key);

  @override
  _XiaomiTempSensorScreenState createState() => _XiaomiTempSensorScreenState();
}

class _XiaomiTempSensorScreenState extends ConsumerState<XiaomiTempSensorScreen> with SingleTickerProviderStateMixin {
  late List<HistoryModel> histories;
  late DateTime currentShownTime;

  @override
  void initState() {
    super.initState();
    currentShownTime = DateTime.now();
    histories = <HistoryModel>[];
    widget.device
        .getFromServer(
            "GetIoBrokerHistories", [widget.device.id, currentShownTime.toString()], ref.read(hubConnectionProvider))
        .then((final x) {
      for (final hist in x) {
        histories.add(HistoryModel.fromJson(hist));
      }
      setState(() {});
    });
  }

  void changeColor() {}

  void changeDelay(final int delay) {
    widget.device
        .sendToServer(sm.MessageType.Options, sm.Command.Delay, ["delay=$delay"], ref.read(hubConnectionProvider));
  }

  @override
  Widget build(final BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: widget.showAppBar,

          // flexibleSpace: Text("Xiaomi Sensor " + this.widget.tempSensor.baseModel.friendlyName),
          title: const TabBar(
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
              buildListView(),
              buildGraphViewTemp(),
              buildGraphViewHumidity(),
              buildGraphViewPressure(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListView() {
    final model = ref.watch(widget.device.baseModelTProvider(widget.device.id));
    if (model is! TempSensorModel) {
      return Container();
    }
    return OrientationBuilder(
      builder: (final context, final orientation) {
        return ListView(
          // crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
          shrinkWrap: true,
          children: (DeviceManager.showDebugInformation
                  ? <Widget>[
                      ListTile(
                        title: Text("ID: ${model.id.toRadixString(16)}"),
                      ),
                    ]
                  : <Widget>[]) +
              <Widget>[
                ListTile(
                  title: Text(model.friendlyName),
                ),
                ListTile(
                  title: Text("Temperature: ${model.temperature.toStringAsFixed(2)} °C"),
                ),
                ListTile(
                  title: Text("Luftdruck: ${model.pressure.toStringAsFixed(1)} kPa"),
                ),
                ListTile(
                  title: Text("Luftfeuchtigkeit: ${model.humidity.toStringAsFixed(2)} %"),
                ),
                ListTile(
                  title: Text("Battery: ${model.battery.toStringAsFixed(0)} %"),
                ),
                ListTile(
                  title: Text("Verfügbar: ${model.available ? "Ja" : "Nein"}"),
                ),
                ListTile(
                  title: Text("Zuletzt empfangen: ${model.lastReceived.toDate()}"),
                ),
              ],
        );
      },
    );
  }

  Widget buildGraphViewHumidity() {
    final h = histories.firstWhereOrNull((final x) => x.propertyName == "humidity");
    if (h != null) {
      return buildTimeSeriesRangeAnnotationChart(
          h,
          " %",
          "rel. Luftfeuchtigkeit",
          AdaptiveTheme.of(context).brightness == Brightness.light
              ? Colors.blueAccent.shade700
              : Colors.blueAccent.shade100);
    }
    return buildDataMissing();
  }

  Widget buildGraphViewTemp() {
    final h = histories.firstWhereOrNull((final x) => x.propertyName == "temperature");
    if (h != null) {
      return buildTimeSeriesRangeAnnotationChart(h, " °C", "Temperatur",
          AdaptiveTheme.of(context).brightness == Brightness.light ? Colors.redAccent.shade700 : Colors.redAccent);
    }
    return buildDataMissing();
  }

  Widget buildGraphViewPressure() {
    final h = histories.firstWhereOrNull((final x) => x.propertyName == "pressure");
    if (h != null) {
      return buildTimeSeriesRangeAnnotationChart(
          h,
          " hPA",
          "Luftdruck",
          AdaptiveTheme.of(context).brightness == Brightness.light
              ? Colors.greenAccent.shade700
              : Colors.greenAccent.shade400);
    }
    return buildDataMissing();
  }

  Widget buildDataMissing() {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Expanded(
            child: Text("Daten werden geladen oder sind nicht vorhanden für ${currentShownTime.day}.${currentShownTime.month}.${currentShownTime.year}")),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
                child: MaterialButton(
              child: const Text("Früher"),
              onPressed: () {
                getNewData(currentShownTime.subtract(const Duration(days: 1)));
              },
            )),
            Expanded(
              child: MaterialButton(
                  onPressed: () => _openDatePicker(currentShownTime), child: const Text('Datum auswählen')),
            ),
            Expanded(
                child: MaterialButton(
              child: const Text("Später"),
              onPressed: () {
                getNewData(currentShownTime.add(const Duration(days: 1)));
              },
            )),
          ],
        )
      ],
    );
  }

  Widget buildTimeSeriesRangeAnnotationChart(
      final HistoryModel h, final String unit, final String valueName, final Color lineColor) {
    h.historyRecords = h.historyRecords.where((final x) => x.value != null).toList(growable: false);
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
                      .map((final x) =>
                          TimeSeriesValue(DateTime(1970).add(Duration(milliseconds: x.timeStamp)), x.value, lineColor))
                      .toList(),
                  xValueMapper: (final TimeSeriesValue value, final _) => value.time,
                  yValueMapper: (final TimeSeriesValue value, final _) => value.value,
                  pointColorMapper: (final TimeSeriesValue value, final _) => value.lineColor,
                  width: 2)
            ],
            h.historyRecords
                .where((final x) => x.value != null)
                .map((final x) => x.value!)
                .minBy(10000, (final e) => e)
                .toDouble(),
            h.historyRecords
                .where((final x) => x.value != null)
                .map((final x) => x.value!)
                .maxBy(0, (final e) => e)
                .toDouble(),
            unit,
            valueName,
            currentShownTime,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
                child: MaterialButton(
              child: const Text("Früher"),
              onPressed: () {
                getNewData(currentShownTime.subtract(const Duration(days: 1)));
              },
            )),
            Expanded(
              child: MaterialButton(
                  onPressed: () => _openDatePicker(currentShownTime), child: const Text('Datum auswählen')),
            ),
            Expanded(
                child: MaterialButton(
              child: const Text("Später"),
              onPressed: () {
                getNewData(currentShownTime.add(const Duration(days: 1)));
              },
            )),
          ],
        )
      ],
    );
  }

  void _openDatePicker(final DateTime initial) {
    // showDatePicker is a pre-made funtion of Flutter
    showDatePicker(context: context, initialDate: initial, firstDate: DateTime(2018), lastDate: DateTime.now())
        .then((final pickedDate) {
      // Check if no date is selected
      if (pickedDate == null) {
        return;
      }
      getNewData(pickedDate);
    });
  }

  getNewData(final DateTime dt) {
    if (dt.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch) return;
    widget.device
        .getFromServer("GetIoBrokerHistories", [widget.device.id, dt.toString()], ref.read(hubConnectionProvider))
        .then((final x) {
      currentShownTime = dt;
      histories.clear();
      for (final hist in x) {
        final histo = HistoryModel.fromJson(hist);
        histo.historyRecords = histo.historyRecords.where((final x) => x.value != null).toList();
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

  const TimeSeriesRangeAnnotationChart(this.seriesList, this.min, this.max, this.unit, this.valueName, this.shownDate,
      {final Key? key})
      : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return OrientationBuilder(builder: (final context, final orientation) {
      return SfCartesianChart(
        primaryXAxis: DateTimeAxis(
            interval: orientation == Orientation.landscape ? 2 : 4,
            intervalType: DateTimeIntervalType.hours,
            dateFormat: DateFormat("HH:mm"),
            majorGridLines: const MajorGridLines(width: 0),
            title: AxisTitle(text: DateFormat("dd.MM.yyyy").format(shownDate))),
        primaryYAxis: NumericAxis(
            minimum: (min - (((max - min) < 10 ? 10 : (max - min)) / 10)).roundToDouble(),
            maximum: (max + (((max - min) < 10 ? 10 : (max - min)) / 10)).roundToDouble(),
            interval: (((max - min) < 10 ? 10 : (max - min)) / 10).roundToDouble(),
            axisLine: const AxisLine(width: 0),
            labelFormat: '{value}$unit',
            majorTickLines: const MajorTickLines(size: 0),
            title: AxisTitle(text: valueName)),
        series: seriesList,
        trackballBehavior: TrackballBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
            tooltipSettings: const InteractiveTooltip(format: '{point.x} : {point.y}')),
      );
    });
  }
}

/// Sample time series data type.
class TimeSeriesValue {
  final DateTime time;
  final num? value;
  final Color lineColor;

  TimeSeriesValue(this.time, this.value, this.lineColor);
}
