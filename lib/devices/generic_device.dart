import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart' as signalR;
import 'package:smarthome/devices/base_model.dart';
import 'package:smarthome/devices/device.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/devices/zigbee/iobroker_history_model.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/icons/smarthome_icons.dart';
import 'package:smarthome/models/message.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

// import 'package:smarthome/helper/iterable_extensions.dart';

import '../helper/theme_manager.dart';

//May Use:
//- PageView
//Should Use
//- FutureBuilder,
//- StreamBuilder instead of SetState?

class GenericDevice extends Device<BaseModel> {
  GenericDevice(int? id, String typeName, BaseModel baseModel, signalR.HubConnection connection)
      : super(id, typeName, baseModel, connection);

  @override
  DeviceTypes getDeviceType() {
    return DeviceTypes.Generic;
  }

  @override
  void navigateToDevice(BuildContext context) {
    var multipleFutures = baseModel.historyProperties?.map((e) => IconManager.getIconByName(e.iconName, connection)) ??
        [Future.delayed(Duration(microseconds: 0))];
    Future.wait(multipleFutures).then((value) =>
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => GenericDeviceScreen(this))));
  }

  @override
  Widget dashboardCardBody() {
    if (baseModel.dashboardProperties == null || baseModel.dashboardProperties?.length == 0) return Container();

    return Wrap(
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.spaceEvenly,
      children: baseModel.dashboardProperties!
          .groupBy((g) => g.rowNr)
          .map((row, elements) {
            return MapEntry(
                row,
                Wrap(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  runAlignment: WrapAlignment.spaceBetween,
                  spacing: 16,
                  children: elements.map((e) {
                    if (e.specialType != SpecialType.none ||
                        !baseModel.stores.containsKey(e.name) ||
                        ((e.showOnlyInDeveloperMode ?? false) && !DeviceManager.showDebugInformation))
                      return Container();
                    var store = baseModel.stores[e.name];

                    return Text(
                      store!.getValueAsString(format: e.format) + (e.unitOfMeasurement ?? ""),
                      style: e.textStyle?.toTextStyle(),
                    );
                  }).toList(),
                ));
          })
          .values
          .toList(),
    );
  }

  @override
  Widget rightWidgets() {
    if (baseModel.dashboardProperties == null || baseModel.dashboardProperties!.isEmpty) return Container();
    var widgets = <Widget>[];
    var properties = baseModel.dashboardProperties;
    properties!.sort((a, b) => a.order.compareTo(b.order));
    for (var item in baseModel.dashboardProperties!) {
      if ((item.showOnlyInDeveloperMode ?? false) && !DeviceManager.showDebugInformation) continue;
      if (item.specialType == SpecialType.none) continue;
      var store = baseModel.stores[item.name];
      if (store == null) continue;
      if (item.specialType == SpecialType.battery) {
        if (store.currentValue.runtimeType != (int)) continue;
        var currentValue = store.currentValue as int;
        widgets.add(Icon(
          (currentValue > 80
              ? SmarthomeIcons.bat4
              : (currentValue > 60
                  ? SmarthomeIcons.bat3
                  : (currentValue > 40
                      ? SmarthomeIcons.bat2
                      : (currentValue > 20 ? SmarthomeIcons.bat1 : SmarthomeIcons.bat_charge)))),
          size: 20,
        ));
      } else if (item.specialType == SpecialType.disabled) {
        if (store.currentValue.runtimeType != (bool)) continue;
        var currentValue = store.currentValue as bool;
        widgets.add(
          Icon(
            currentValue ? Icons.power_off_outlined : Icons.power_outlined,
            size: 20,
          ),
        );
      }
    }
    return Column(
      children: widgets,
    );
  }
}

class GenericDeviceScreen extends DeviceScreen {
  final GenericDevice genericDevice;
  GenericDeviceScreen(this.genericDevice);

  @override
  State<StatefulWidget> createState() => _GenericDeviceScreenState();
}

class _GenericDeviceScreenState extends State<GenericDeviceScreen> {
  DateTime dateTime = DateTime.now();
  late StreamSubscription sub;

  DateTime currentShownTime = DateTime.now();
  late List<IoBrokerHistoryModel> histories = [];

  @override
  void initState() {
    super.initState();
    sub = this.widget.genericDevice.listenOnUpdateFromServer((p0) {
      setState(() {});
    });
    this.widget.genericDevice.baseModel.uiUpadateChannel.stream.listen((ev) => setState(() {}));
    this.widget.genericDevice.baseModel.stores.values.forEach((element) {
      element.valueChanged.stream.listen((event) {
        setState(() {});
        if (event.sendToSever) {
          this.widget.genericDevice.sendToServer(MessageType.Update, element.command, [element.getValueAsString()]);
        }
      });
    });
    if ((this.widget.genericDevice.baseModel.historyProperties?.length ?? 0) > 0) {
      this
          .widget
          .genericDevice
          .getFromServer("GetIoBrokerHistories", [this.widget.genericDevice.id, currentShownTime.toString()]).then((x) {
        for (var hist in x) {
          histories.add(IoBrokerHistoryModel.fromJson(hist));
        }
        setState(() {});
      });
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (this.widget.genericDevice.baseModel.historyProperties?.isEmpty ?? true) return buildWithoutHistory(context);
    return buildWithHistory(context);
  }

  Widget buildWithoutHistory(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: new Text(this.widget.genericDevice.baseModel.friendlyName),
        ),
        body: buildBody(this.widget.genericDevice.baseModel));
  }

  Widget buildWithHistory(BuildContext context) {
    var histProps = this.widget.genericDevice.baseModel.historyProperties!;
    return DefaultTabController(
      length: histProps.length + 1,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: TabBar(
            tabs: histProps
                .map((e) =>
                    Tab(icon: this.widget.genericDevice.createIconFromSvgByteList(IconManager.cache[e.iconName]!)))
                .injectForIndex((index) => index == 0 ? Tab(icon: Icon(Icons.home)) : null)
                .toList(),
          ),
        ),
        body: Container(
          decoration: ThemeManager.getBackgroundDecoration(context),
          child: TabBarView(
            children: histProps
                .map((e) => buildGraph(e))
                .injectForIndex((index) => index == 0 ? buildBody(this.widget.genericDevice.baseModel) : null)
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget buildBody(BaseModel model) {
    var detailProperties = this.widget.genericDevice.baseModel.detailProperties;
    if (detailProperties == null || detailProperties.isEmpty) return Container();
    var widgets = <Widget>[];
    detailProperties.sort((a, b) => a.order.compareTo(b.order));

    for (var detProp in detailProperties) {
      if ((detProp.showOnlyInDeveloperMode ?? false) && !DeviceManager.showDebugInformation) continue;
      if (detProp.specialType != SpecialDetailType.none) continue;
      var store = this.widget.genericDevice.baseModel.stores[detProp.name];
      if (store == null) continue;
      var widget = ListTile(
        title: Text(
          (detProp.displayName ?? "") +
              store.getValueAsString(format: detProp.format) +
              (detProp.unitOfMeasurement ?? ""),
          style: detProp.textStyle?.toTextStyle(),
        ),
      );

      widgets.add(widget);
    }
    return Column(
      children: widgets,
      // decoration: ThemeManager.getBackgroundDecoration(context),
      // child: ListView(
      //   children: model.stores.values.map((e) {
      //     if (StoreUIService.getWidgetFor.containsKey(e.runtimeType))
      //       return StoreUIService.getWidgetFor[e.runtimeType]!(e);
      //     return Container();
      //   }).toList(),
    ); //);
  }

  Widget buildGraph(HistoryPropertyInfo info) {
    var h = histories.firstWhereOrNull((x) => x.propertyName == info.propertyName);
    if (h != null)
      return buildHistorySeriesAnnotationChart(h, info.unitOfMeasurement, info.xAxisName,
          ThemeManager.isLightTheme ? Color(info.brightThemeColor) : Color(info.darkThemeColor));
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

  Widget buildHistorySeriesAnnotationChart(IoBrokerHistoryModel h, String unit, String valueName, Color lineColor) {
    h.historyRecords = h.historyRecords.where((x) => x.value != null).toList(growable: false);
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Expanded(
          child: HistorySeriesAnnotationChart(
            [
              LineSeries<GraphTimeSeriesValue, DateTime>(
                  enableTooltip: true,
                  animationDuration: 500,
                  // markerSettings: MarkerSettings(shape: DataMarkerType.circle, color: Colors.green, width: 5, height: 5, isVisible: true),
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    shape: DataMarkerType.circle,
                  ),
                  dataSource: h.historyRecords
                      .map((x) => GraphTimeSeriesValue(
                          DateTime(1970).add(Duration(milliseconds: x.timeStamp)), x.value, lineColor))
                      .toList(),
                  xValueMapper: (GraphTimeSeriesValue value, _) => value.time,
                  yValueMapper: (GraphTimeSeriesValue value, _) => value.value,
                  pointColorMapper: (GraphTimeSeriesValue value, _) => value.lineColor,
                  width: 2)
            ],
            h.historyRecords.where((x) => x.value != null).map((x) => x.value!).fold(10000, min),
            h.historyRecords.where((x) => x.value != null).map((x) => x.value!).fold(0, max),
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
    if (dt.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch) return;
    this
        .widget
        .genericDevice
        .getFromServer("GetIoBrokerHistories", [this.widget.genericDevice.id, dt.toString()]).then((x) {
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
}

class HistorySeriesAnnotationChart extends StatelessWidget {
  final List<LineSeries> seriesList;
  final double min;
  final double max;
  final String unit;
  final String valueName;
  final DateTime shownDate;

  HistorySeriesAnnotationChart(this.seriesList, this.min, this.max, this.unit, this.valueName, this.shownDate);

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
        enableAxisAnimation: false,
      );
    });
  }
}

/// Sample time series data type.
class GraphTimeSeriesValue {
  final DateTime time;
  final double? value;
  final Color lineColor;

  GraphTimeSeriesValue(this.time, this.value, this.lineColor);
}
