import 'dart:math';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/devices/base_model.dart';
import 'package:smarthome/devices/device.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/generic/device_layout_service.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/devices/generic/stores/store_service.dart';
import 'package:smarthome/devices/zigbee/iobroker_history_model.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/helper/settings_manager.dart';
import 'package:smarthome/icons/smarthome_icons.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

import '../helper/theme_manager.dart';

class GenericDevice extends Device<BaseModel> {
  GenericDevice(final int id, final String typeName) : super(id, typeName);

  @override
  DeviceTypes getDeviceType() {
    return DeviceTypes.Generic;
  }

  @override
  void navigateToDevice(final BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (final BuildContext context) => GenericDeviceScreen(this)));
  }

  @override
  Widget dashboardCardBody() {
    return Consumer(
      builder: (final context, final ref, final child) {
        final baseModel = ref.watch(BaseModel.byIdProvider(id));

        if (baseModel == null) return Container();
        final dashboardDeviceLayout =
            ref.watch(dashboardNoSpecialTypeLayoutProvider(Tuple2(id, baseModel.typeNames.first)));
        if (dashboardDeviceLayout?.isEmpty ?? true) return Container();

        return DashboardLayoutWidget(id, dashboardDeviceLayout!);
      },
    );
  }

  @override
  Widget getRightWidgets() {
    return Consumer(
      builder: (final context, final ref, final child) {
        final baseModel = ref.watch(BaseModel.byIdProvider(id));

        if (baseModel == null) return Container();

        final properties = ref.watch(dashboardSpecialTypeLayoutProvider(Tuple2(id, baseModel.typeNames.first)));
        if (properties?.isEmpty ?? true) return Container();

        properties!.sort((final a, final b) => a.order.compareTo(b.order));

        return Column(
          children: properties.map((final e) => DashboardRightValueStoreWidget(e, id)).toList(),
        );
      },
    );
  }
}

class DashboardLayoutWidget extends ConsumerWidget {
  final List<DashboardPropertyInfo> layout;
  final int id;

  const DashboardLayoutWidget(this.id, this.layout, {final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    if (layout.isEmpty) return Container();

    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.spaceEvenly,
          children: layout
              .groupBy((final g) => g.rowNr)
              .map((final row, final elements) {
                return MapEntry(
                  row,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        runAlignment: WrapAlignment.spaceBetween,
                        spacing: 16,
                        children: elements.map((final e) {
                          return DashboardValueStoreWidget(e, id);
                        }).toList(),
                      ),
                    ],
                  ),
                );
              })
              // .select((p0, p1) => Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [p1],
              //     ))
              .values
              .toList(),
        ),
      ],
    );
  }
}

class DashboardValueStoreWidget extends ConsumerWidget {
  final DashboardPropertyInfo e;
  final int deviceId;
  const DashboardValueStoreWidget(this.e, this.deviceId, {final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final valueModel = ref.watch(valueStoreChangedProvider(Tuple2(e.name, deviceId)));
    final showDebugInformation = ref.watch(debugInformationEnabledProvider);

    if (valueModel == null ||
        e.specialType != SpecialType.none ||
        ((e.showOnlyInDeveloperMode ?? false) && !showDebugInformation)) {
      return Container();
    }

    return Text(
      valueModel.getValueAsString(format: e.format) + (e.unitOfMeasurement ?? ""),
      style: e.textStyle?.toTextStyle(),
    );
  }
}

class DashboardRightValueStoreWidget extends ConsumerWidget {
  final DashboardPropertyInfo e;
  final int deviceId;
  const DashboardRightValueStoreWidget(this.e, this.deviceId, {final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final valueModel = ref.watch(valueStoreChangedProvider(Tuple2(e.name, deviceId)));
    if (valueModel == null) return Container();

    final showDebugInformation = ref.watch(debugInformationEnabledProvider);
    if ((e.showOnlyInDeveloperMode ?? false) && !showDebugInformation) return Container();
    if (e.specialType == SpecialType.none) return Container();

    if (e.specialType == SpecialType.battery) {
      if (valueModel.currentValue.runtimeType != (int)) return Container();
      final currentValue = valueModel.currentValue as int;
      return Icon(
        (currentValue > 80
            ? SmarthomeIcons.bat4
            : (currentValue > 60
                ? SmarthomeIcons.bat3
                : (currentValue > 40
                    ? SmarthomeIcons.bat2
                    : (currentValue > 20 ? SmarthomeIcons.bat1 : SmarthomeIcons.bat_charge)))),
        size: 20,
      );
    } else if (e.specialType == SpecialType.disabled) {
      if (valueModel.currentValue.runtimeType != (bool)) return Container();
      final currentValue = valueModel.currentValue as bool;
      return Icon(
        currentValue ? Icons.power_off_outlined : Icons.power_outlined,
        size: 20,
      );
    }
    return Container();
  }
}

class GenericDeviceScreen extends ConsumerStatefulWidget {
  final GenericDevice genericDevice;
  const GenericDeviceScreen(this.genericDevice, {final Key? key}) : super(key: key);

  @override
  GenericDeviceScreenState createState() => GenericDeviceScreenState();
}

class GenericDeviceScreenState extends ConsumerState<GenericDeviceScreen> {
  final currentShownTimeProvider = StateProvider<DateTime>((final _) => DateTime.now());

  GenericDeviceScreenState();

  @override
  Widget build(final BuildContext context) {
    final name = ref.watch(BaseModel.typeNameProvider(widget.genericDevice.id));
    final historyProps = ref.watch(detailHistoryLayoutProvider(Tuple2(widget.genericDevice.id, name)));
    if (historyProps?.isEmpty ?? true) return buildWithoutHistory(context);
    return buildWithHistory(context, historyProps!);
  }

  Widget buildWithoutHistory(final BuildContext context) {
    final friendlyName = ref.watch(BaseModel.friendlyNameProvider(widget.genericDevice.id));
    return Scaffold(
        appBar: AppBar(
          title: Text(friendlyName),
        ),
        body: buildBody());
  }

  Widget buildWithHistory(final BuildContext context, final List<HistoryPropertyInfo> histProps) {
    return DefaultTabController(
      length: histProps.length + 1,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: histProps
                .map((final e) {
                  final icon = ref.watch(
                      iconWidgetSingleProvider(Tuple3(e.iconName, widget.genericDevice, AdaptiveTheme.of(context))));
                  return Tab(icon: icon);
                })
                .injectForIndex((final index) => index == 0 ? const Tab(icon: Icon(Icons.home)) : null)
                .toList(),
          ),
        ),
        body: Container(
          decoration: ThemeManager.getBackgroundDecoration(context),
          child: TabBarView(
            children: histProps
                .map((final e) => buildGraph(e))
                .injectForIndex((final index) => index == 0 ? buildBody() : null)
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    final name = ref.watch(BaseModel.typeNameProvider(widget.genericDevice.id));
    final detailProperties = ref.watch(detailPropertyInfoLayoutProvider(Tuple2(widget.genericDevice.id, name)));
    if (detailProperties == null || detailProperties.isEmpty) return Container();
    final widgets = <Widget>[];
    detailProperties.sort((final a, final b) => a.order.compareTo(b.order));

    for (final detProp in detailProperties) {
      widgets.add(DetailValueStoreWidget(detProp, widget.genericDevice.id));
    }
    return Column(
      children: widgets,
    );
  }

  Widget buildGraph(final HistoryPropertyInfo info) {
    final currentShownTime = ref.watch(currentShownTimeProvider);
    final h = ref.watch(
        historyPropertyNameProvider(Tuple3(widget.genericDevice.id, currentShownTime.toString(), info.propertyName)));

    return h.when(
      data: (final data) {
        if (data != null) {
          return buildHistorySeriesAnnotationChart(
              data,
              info.unitOfMeasurement,
              info.xAxisName,
              AdaptiveTheme.of(context).brightness == Brightness.light
                  ? Color(info.brightThemeColor)
                  : Color(info.darkThemeColor),
              currentShownTime);
        }
        return buildDataMissing(currentShownTime);
      },
      error: (final e, final o) => Text(e.toString()),
      loading: () => Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 50),
            child: Text(
              'Lade weitere History Daten...',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 25),
            child: const CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }

  Widget buildDataMissing(final DateTime currentShownTime) {
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
              child: const Text("Früher"),
              onPressed: () {
                getNewData(currentShownTime.subtract(const Duration(days: 1)));
              },
            )),
            Expanded(
                child: MaterialButton(
              child: const Text("Später"),
              onPressed: () {
                getNewData(currentShownTime.add(const Duration(days: 1)));
              },
            )),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        )
      ],
    );
  }

  Widget buildHistorySeriesAnnotationChart(final IoBrokerHistoryModel h, final String unit, final String valueName,
      final Color lineColor, final DateTime currentShownTime) {
    h.historyRecords = h.historyRecords.where((final x) => x.value != null).toList(growable: false);
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
                      .map((final x) => GraphTimeSeriesValue(
                          DateTime(1970).add(Duration(milliseconds: x.timeStamp)), x.value, lineColor))
                      .toList(),
                  xValueMapper: (final GraphTimeSeriesValue value, final _) => value.time,
                  yValueMapper: (final GraphTimeSeriesValue value, final _) => value.value,
                  pointColorMapper: (final GraphTimeSeriesValue value, final _) => value.lineColor,
                  width: 2)
            ],
            h.historyRecords.where((final x) => x.value != null).map((final x) => x.value!).fold(10000, min),
            h.historyRecords.where((final x) => x.value != null).map((final x) => x.value!).fold(0, max),
            unit,
            valueName,
            currentShownTime,
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
                child: MaterialButton(
              child: const Text("Früher"),
              onPressed: () {
                getNewData(currentShownTime.subtract(const Duration(days: 1)));
              },
            )),
            currentShownTime.isAfter(DateTime.now().add(const Duration(hours: -23)))
                ? Expanded(
                    child: Container(),
                  )
                : Expanded(
                    child: MaterialButton(
                    child: const Text("Später"),
                    onPressed: () {
                      getNewData(currentShownTime.add(const Duration(days: 1)));
                    },
                  )),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        )
      ],
    );
  }

  getNewData(final DateTime dt) {
    if (dt.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch) return;
    ref.read(currentShownTimeProvider.notifier).state = dt;
  }
}

class DetailValueStoreWidget extends ConsumerWidget {
  final DetailPropertyInfo e;
  final int deviceId;
  const DetailValueStoreWidget(this.e, this.deviceId, {final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final valueModel = ref.watch(valueStoreChangedProvider(Tuple2(e.name, deviceId)));
    final showDebugInformation = ref.watch(debugInformationEnabledProvider);

    if (valueModel == null ||
        e.specialType != SpecialDetailType.none ||
        ((e.showOnlyInDeveloperMode ?? false) && !showDebugInformation)) {
      return Container();
    }

    return ListTile(
      title: Text(
        (e.displayName ?? "") + valueModel.getValueAsString(format: e.format) + (e.unitOfMeasurement ?? ""),
        style: e.textStyle?.toTextStyle(),
      ),
    );
  }
}

class HistorySeriesAnnotationChart extends StatelessWidget {
  final List<LineSeries> seriesList;
  final double min;
  final double max;
  final String unit;
  final String valueName;
  final DateTime shownDate;

  const HistorySeriesAnnotationChart(this.seriesList, this.min, this.max, this.unit, this.valueName, this.shownDate,
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
            labelFormat: '{value}' + unit,
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
class GraphTimeSeriesValue {
  final DateTime time;
  final double? value;
  final Color lineColor;

  GraphTimeSeriesValue(this.time, this.value, this.lineColor);
}
