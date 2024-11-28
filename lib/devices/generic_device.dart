import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/controls/blurry_card.dart';
import 'package:smarthome/devices/base_model.dart';
import 'package:smarthome/devices/device.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/generic/device_layout_service.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/devices/generic/stores/store_service.dart';
import 'package:smarthome/devices/generic/stores/value_store.dart';
import 'package:smarthome/devices/generic/widgets/edits/basic_edit_types.dart';
import 'package:smarthome/devices/generic/widgets/edits/gauge_edit.dart';
import 'package:smarthome/devices/zigbee/iobroker_history_model.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/helper/settings_manager.dart';
import 'package:smarthome/models/message.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../helper/theme_manager.dart';

class GenericDevice extends Device<BaseModel> {
  GenericDevice(final int id, final String typeName) : super(id, typeName);

  @override
  DeviceTypes getDeviceType() {
    return DeviceTypes.Generic;
  }

  @override
  void navigateToDevice(final BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (final BuildContext context) =>
                GenericDeviceScreen(this)));
  }

  @override
  Widget dashboardCardBody() {
    return Consumer(
      builder: (final context, final ref, final child) {
        final baseModel = ref.watch(BaseModel.byIdProvider(id));
        if (baseModel == null) return const SizedBox();
        final dashboardDeviceLayout = ref.watch(
            dashboardNoSpecialTypeLayoutProvider(
                Tuple2(id, baseModel.typeName)));
        if (dashboardDeviceLayout?.isEmpty ?? true) return const SizedBox();

        return DashboardLayoutWidget(this, dashboardDeviceLayout!);
      },
    );
  }

  @override
  Widget getRightWidgets() {
    return Consumer(
      builder: (final context, final ref, final child) {
        final baseModel = ref.watch(BaseModel.byIdProvider(id));

        if (baseModel == null) return const SizedBox();

        final properties = ref.watch(
            dashboardSpecialTypeLayoutProvider(Tuple2(id, baseModel.typeName)));
        if (properties?.isEmpty ?? true) return const SizedBox();

        properties!.sort((final a, final b) => a.order.compareTo(b.order));

        return Column(
          children: properties
              .map((final e) => DashboardRightValueStoreWidget(e, this))
              .toList(),
        );
      },
    );
  }

  Widget getEditWidget(
          final BuildContext context,
          final LayoutBasePropertyInfo e,
          final ValueStore? valueModel,
          final WidgetRef ref) =>
      GenericDevice.getEditWidgetFor(context, id, e, valueModel, ref);

  static Widget getEditWidgetFor(
      final BuildContext context,
      final int id,
      final LayoutBasePropertyInfo e,
      final ValueStore? valueModel,
      final WidgetRef ref) {
    switch (e.editInfo?.editType) {
      case EditType.button:
      case EditType.raisedbutton:
        return BasicEditTypes.buildButton(id, context, valueModel, e, ref,
            e.editInfo!.editType == EditType.raisedbutton);
      case EditType.toggle:
        return BasicEditTypes.buildToggle(id, valueModel, e, ref);
      case EditType.dropdown:
        return BasicEditTypes.buildDropdown(id, valueModel, e, ref);
      case EditType.slider:
        return BasicEditTypes.buildSlider(context, id, valueModel, e, ref);
      case EditType.iconbutton:
        return BasicEditTypes.iconButton(id, valueModel, e, ref);
      case EditType.icon:
        return BasicEditTypes.icon(valueModel, e, ref);
      case EditType.radial:
        return GaugeEdit.getTempGauge(id, context, valueModel, e, ref);
      // case EditType.input:
      //   return _buildInput(valueModel, e, ref);
      //https://github.com/mchome/flutter_colorpicker
      //FAB
      case EditType.floatingactionbutton:
        return const SizedBox();
      default:
        return Text(
          (valueModel?.getValueAsString(
                      format: e.format, precision: e.precision ?? 1) ??
                  "") +
              (e.unitOfMeasurement),
          style: toTextStyle(e.textStyle),
        );
    }
  }

  static TextStyle toTextStyle(TextSettings? setting) {
    var ts = const TextStyle();
    if (setting == null) return ts;
    if (setting.fontSize != null) ts = ts.copyWith(fontSize: setting.fontSize);
    if (setting.fontFamily != "")
      ts = ts.copyWith(fontFamily: setting.fontFamily);
    ts = ts.copyWith(fontStyle: FontStyle.values[setting.fontStyle.index]);
    ts = ts.copyWith(fontWeight: FontWeight.values[setting.fontWeight.index]);
    return ts;
  }

  static Message getMessage(final PropertyEditInformation info,
      final EditParameter edit, final int id) {
    return Message(edit.id ?? id, edit.messageType ?? info.editCommand,
        edit.command, edit.parameters);
  }

  static EditParameter getEditParameter(final ValueStore<dynamic>? valueModel,
      final PropertyEditInformation info) {
    if (valueModel == null) return info.editParameter.first;
    if (valueModel.currentValue is num) {
      final val = (valueModel.currentValue as num);
      return info.editParameter.firstWhere((final element) {
        final lower = element.extensionData?["Min"] as num?;
        final upper = element.extensionData?["Max"] as num?;
        if (lower != null && upper != null) {
          return val >= lower && val < upper;
        }
        return element.$value == val;
      }, orElse: () => info.editParameter.first);
    } else if (valueModel.currentValue is bool) {
      final val = (valueModel.currentValue as bool);
      return info.editParameter.firstWhere((final element) {
        return element.$value == val;
      }, orElse: () => info.editParameter.first);
    } else if (valueModel.currentValue is String) {
      final val = (valueModel.currentValue as String);
      return info.editParameter.firstWhere((final element) {
        return element.$value == val;
      }, orElse: () => info.editParameter.first);
    } else {
      return info.editParameter.first;
    }
  }
}

class GenericDeviceScreen extends ConsumerStatefulWidget {
  final GenericDevice genericDevice;
  const GenericDeviceScreen(this.genericDevice, {final Key? key})
      : super(key: key);

  @override
  GenericDeviceScreenState createState() => GenericDeviceScreenState();
}

class GenericDeviceScreenState extends ConsumerState<GenericDeviceScreen> {
  final _currentShownTimeProvider =
      StateProvider<DateTime>((final _) => DateTime.now());

  final _currentShownTabProvider =
      StateProvider.family<bool, Tuple2<int, String>>((final ref, final _) {
    return false;
  });
  final _tabKeyProvider = StateProvider.autoDispose
      .family<Key, Tuple2<int, String>>((final ref, final key) {
    return Key(key.toString());
  });
  GenericDeviceScreenState();

  @override
  Widget build(final BuildContext context) {
    final name = ref.watch(BaseModel.typeNameProvider(widget.genericDevice.id));
    final historyProps = ref.watch(
        detailHistoryLayoutProvider(Tuple2(widget.genericDevice.id, name)));
    final tabInfos = ref.watch(
        detailTabInfoLayoutProvider(Tuple2(widget.genericDevice.id, name)));

    if (historyProps?.isEmpty ?? true)
      return buildWithoutHistory(context, tabInfos);
    return buildWithHistory(context, historyProps!, tabInfos);
  }

  Widget buildWithoutHistory(
      final BuildContext context, final List<DetailTabInfo>? tabInfos) {
    final friendlyName =
        ref.watch(BaseModel.friendlyNameProvider(widget.genericDevice.id));
    if (tabInfos == null || tabInfos.isEmpty || tabInfos.length == 1) {
      return Scaffold(
          floatingActionButton: _buildFab(),
          appBar: AppBar(
            title: Text(friendlyName),
          ),
          body: buildBody(tabInfos?.first));
    }
    return DefaultTabController(
        length: tabInfos.length,
        child: Scaffold(
            floatingActionButton: _buildFab(),
            appBar: AppBar(
              title: TabBar(
                tabs: tabInfos.map((final e) {
                  final icon = ref.watch(iconWidgetSingleProvider(e.iconName,
                      widget.genericDevice, AdaptiveTheme.of(context), true));
                  return Tab(icon: icon);
                }).toList(),
              ),
            ),
            body: TabBarView(
                children: tabInfos
                    .map((final e) => buildBody(e))
                    .toList(growable: false))));
  }

  Widget buildWithHistory(
      final BuildContext context,
      final List<HistoryPropertyInfo> histProps,
      final List<DetailTabInfo>? tabInfos) {
    if (tabInfos == null || tabInfos.isEmpty) {
      return DefaultTabController(
        length: histProps.length + 1,
        child: Scaffold(
          floatingActionButton: _buildFab(),
          appBar: AppBar(
            title: TabBar(
              tabs: histProps
                  .map((final e) {
                    final icon = ref.watch(iconWidgetSingleProvider(e.iconName,
                        widget.genericDevice, AdaptiveTheme.of(context), true));
                    return Tab(icon: icon);
                  })
                  .injectForIndex((final index) =>
                      index == 0 ? const Tab(icon: Icon(Icons.home)) : null)
                  .toList(),
            ),
          ),
          body: Container(
            decoration: ThemeManager.getBackgroundDecoration(context),
            child: TabBarView(
              children: histProps
                  .map((final e) => buildGraph(e))
                  .injectForIndex(
                      (final index) => index == 0 ? buildBody() : null)
                  .toList(),
            ),
          ),
        ),
      );
    }
    return DefaultTabController(
      length: histProps.length + tabInfos.length,
      child: Scaffold(
        floatingActionButton: _buildFab(),
        appBar: AppBar(
          title: TabBar(
            tabs: [
              ...tabInfos.map((final e) {
                final icon = ref.watch(iconWidgetSingleProvider(e.iconName,
                    widget.genericDevice, AdaptiveTheme.of(context), true));
                return Tab(icon: icon);
              }),
              ...histProps.map((final e) {
                final icon = ref.watch(iconWidgetSingleProvider(e.iconName,
                    widget.genericDevice, AdaptiveTheme.of(context), true));
                return Tab(icon: icon);
              }),
            ].toList(),
          ),
        ),
        body: Container(
          decoration: ThemeManager.getBackgroundDecoration(context),
          child: TabBarView(
            children: [
              ...tabInfos.map((final e) => buildBody(e)),
              ...histProps.map((final e) => buildGraph(e))
            ].toList(),
          ),
        ),
      ),
    );
  }

  Widget? _buildFab() {
    final name = ref.watch(BaseModel.typeNameProvider(widget.genericDevice.id));
    final fabLayout =
        ref.watch(fabLayoutProvider(Tuple2(widget.genericDevice.id, name)));
    if (fabLayout == null) return null;

    final valueModel = ref.watch(valueStoreChangedProvider(
        Tuple2(fabLayout.name, fabLayout.deviceId ?? widget.genericDevice.id)));
    if (valueModel == null) return null;
    // final showDebugInformation = ref.watch(debugInformationEnabledProvider);

    final info = fabLayout.editInfo!;
    final EditParameter edit;
    edit = GenericDevice.getEditParameter(valueModel, info);
    final message = Message(edit.id ?? widget.genericDevice.id,
        edit.messageType ?? info.editCommand, edit.command, edit.parameters);

    return FloatingActionButton(
      onPressed: (() async {
        await ref.read(hubConnectionConnectedProvider)?.invoke(
            info.hubMethod ?? "Update",
            args: <Object>[message.toJson()]);
      }),
      child: Icon(
        IconData(edit.extensionData!["CodePoint"] as int,
            fontFamily: edit.extensionData!["FontFamily"] ?? 'MaterialIcons'),
      ),
    );
  }

  final emptyContainer = const SizedBox();
  Widget buildBody([final DetailTabInfo? tabInfo]) {
    final name = ref.watch(BaseModel.typeNameProvider(widget.genericDevice.id));
    var detailProperties = ref.watch(detailPropertyInfoLayoutProvider(
        Tuple2(widget.genericDevice.id, name)));
    final showDebugInformation = ref.watch(debugInformationEnabledProvider);
    if (detailProperties == null || detailProperties.isEmpty)
      return const SizedBox();
    detailProperties = detailProperties
        .where((final element) =>
            tabInfo == null || tabInfo.id == element.tabInfoId)
        .toList(growable: false);
    // final widgets = <Widget>[];
    detailProperties.sort((final a, final b) => a.order.compareTo(b.order));

    // for (final detProp in detailProperties) {
    //   widgets.add(DetailValueStoreWidget(detProp, widget.genericDevice));
    // }
    // return ListView(
    //   children: widgets,
    // );
    final props = detailProperties
        .where((final e) =>
            !(e.showOnlyInDeveloperMode ?? false) ||
            (showDebugInformation && e.showOnlyInDeveloperMode == true))
        .where((final e) =>
            e.editInfo == null ||
            e.editInfo!.editType != EditType.floatingactionbutton)
        .groupBy((final g) => g.rowNr)
        .map((final row, final elements) {
      final children = elements.map((final e) {
        final exp = e.expanded;
        if (exp == null || !exp)
          return DetailValueStoreWidget(e, widget.genericDevice);
        return Expanded(child: DetailValueStoreWidget(e, widget.genericDevice));
      }).toList(growable: false);

      final displayBlurry =
          elements.any(((final element) => element.blurryCard == true));
      return MapEntry(
        row,
        ListTile(
          leading: ref.watch(debugInformationEnabledProvider)
              ? Text("Row: $row")
              : null,
          title: displayBlurry
              ? BlurryCard(
                  // margin: const EdgeInsets.only(left: 8, right: 8),
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 8, right: 8, top: 4, bottom: 4),
                    child: Row(children: children),
                  ),
                )
              : Row(
                  // runAlignment: WrapAlignment.spaceBetween,
                  // spacing: 8,
                  children: children,
                ),
        ),
        // ),
      );
    });

    return ListView(
      children: props.values.toList(),
    );
  }

  Widget buildGraph(final HistoryPropertyInfo info) {
    final currentShownTime = ref.watch(_currentShownTimeProvider);
    final showBody = ref.watch(_currentShownTabProvider(
        Tuple2(widget.genericDevice.id, info.propertyName)));
    final from = DateTime.utc(
            currentShownTime.year, currentShownTime.month, currentShownTime.day)
        .subtract(currentShownTime.timeZoneOffset);
    return VisibilityDetector(
        key: ref.watch(_tabKeyProvider(
            Tuple2(widget.genericDevice.id, info.propertyName))),
        child: !showBody
            ? const SizedBox()
            : ref
                .watch(historyPropertyNameProvider(widget.genericDevice.id,
                    from, from.add(Duration(days: 1)), info.propertyName))
                .when(
                  data: (final data) {
                    if (data.historyRecords.isNotEmpty) {
                      return buildHistorySeriesAnnotationChart(
                          data,
                          info,
                          AdaptiveTheme.of(context).brightness ==
                                  Brightness.light
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
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 25),
                        child: const CircularProgressIndicator(),
                      ),
                    ],
                  ),
                ),
        onVisibilityChanged: (final i) {
          try {
            ref
                .read(_currentShownTabProvider(
                        Tuple2(widget.genericDevice.id, info.propertyName))
                    .notifier)
                .state = !i.visibleBounds.isEmpty;
          } catch (e) {
            //Happends in debug when exiting in the history tab
          }
        });
  }

  Widget buildDataMissing(final DateTime currentShownTime) {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Expanded(
            child: Text(
                "Daten werden geladen oder sind nicht vorhanden für ${currentShownTime.day}.${currentShownTime.month}.${currentShownTime.year}")),
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
                  onPressed: () => _openDatePicker(currentShownTime),
                  child: const Text('Datum auswählen')),
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

  Widget buildHistorySeriesAnnotationChart(
      final HistoryModel h,
      final HistoryPropertyInfo info,
      final Color lineColor,
      final DateTime currentShownTime) {
    h.historyRecords = h.historyRecords
        .where((final x) => x.value != null)
        .toList(growable: false);
    final chartType = info.chartType;
    final dynamic seriesList = _getSeriesList(chartType, h, lineColor);
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Expanded(
          child: HistorySeriesAnnotationChartWidget(
            seriesList,
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
            info.unitOfMeasurement,
            info.xAxisName,
            currentShownTime,
            loadMoreIndicatorBuilder: (final context, final direction) {
              return Consumer(
                builder: (final context, final ref, final child) {
                  Future<void>.delayed(const Duration(milliseconds: 10), (() {
                    final current =
                        ref.read(_currentShownTimeProvider.notifier);
                    if (direction == ChartSwipeDirection.end) {
                      if (current.state.day < DateTime.now().day) {
                        current.state =
                            current.state.add(const Duration(days: 1));
                      }
                    } else {
                      current.state =
                          current.state.add(const Duration(days: -1));
                    }
                  }));
                  return const SizedBox();
                },
              );
            },
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
                  onPressed: () => _openDatePicker(currentShownTime),
                  child: const Text('Datum auswählen')),
            ),
            currentShownTime
                    .isAfter(DateTime.now().add(const Duration(hours: -23)))
                ? Expanded(
                    child: const SizedBox(),
                  )
                : Expanded(
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

  dynamic _getSeriesList(
      final String charType, final HistoryModel h, final Color lineColor) {
    switch (charType) {
      case "step":
        return [
          StepLineSeries<GraphTimeSeriesValue, DateTime>(
              enableTooltip: true,
              animationDuration: 500,
              // markerSettings: MarkerSettings(shape: DataMarkerType.circle, color: Colors.green, width: 5, height: 5, isVisible: true),
              markerSettings: const MarkerSettings(
                isVisible: true,
                shape: DataMarkerType.circle,
              ),
              dataSource: h.historyRecords
                  .map((final x) => GraphTimeSeriesValue(
                      DateTime.utc(1).add(Duration(milliseconds: x.timeStamp)),
                      x.value,
                      lineColor))
                  .toList(),
              xValueMapper: (final GraphTimeSeriesValue value, final _) =>
                  value.time,
              yValueMapper: (final GraphTimeSeriesValue value, final _) =>
                  value.value,
              pointColorMapper: (final GraphTimeSeriesValue value, final _) =>
                  value.lineColor,
              width: 2)
        ];
      default:
        return [
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
                      DateTime.utc(1).add(Duration(milliseconds: x.timeStamp)),
                      x.value,
                      lineColor))
                  .toList(),
              xValueMapper: (final GraphTimeSeriesValue value, final _) =>
                  value.time,
              yValueMapper: (final GraphTimeSeriesValue value, final _) =>
                  value.value,
              pointColorMapper: (final GraphTimeSeriesValue value, final _) =>
                  value.lineColor,
              width: 2)
        ];
    }
  }

  void _openDatePicker(final DateTime initial) {
    // showDatePicker is a pre-made funtion of Flutter
    showDatePicker(
            context: context,
            initialDate: initial,
            firstDate: DateTime(2018),
            lastDate: DateTime.now())
        .then((final pickedDate) {
      // Check if no date is selected
      if (pickedDate == null) {
        return;
      }
      getNewData(pickedDate);
    });
  }

  getNewData(final DateTime dt) {
    if (dt.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch)
      return;
    ref.read(_currentShownTimeProvider.notifier).state = dt;
  }
}
