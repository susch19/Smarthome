import 'dart:math';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/devices/base_model.dart';
import 'package:smarthome/devices/device.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/generic/device_layout_service.dart';
import 'package:smarthome/devices/generic/edit_parameter.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/devices/generic/layout_base_property_info.dart';
import 'package:smarthome/devices/generic/stores/store_service.dart';
import 'package:smarthome/devices/generic/stores/value_store.dart';
import 'package:smarthome/devices/zigbee/iobroker_history_model.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/helper/settings_manager.dart';
import 'package:smarthome/icons/icons.dart';
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

        return DashboardLayoutWidget(this, dashboardDeviceLayout!);
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
          children: properties.map((final e) => DashboardRightValueStoreWidget(e, this)).toList(),
        );
      },
    );
  }

  Widget getEditWidget(final LayoutBasePropertyInfo e, final ValueStore valueModel, final WidgetRef ref) {
    switch (e.editInfo?.editType) {
      case EditType.button:
      case EditType.raisedButton:
        return _buildButton(valueModel, e, ref, e.editInfo!.editType == EditType.raisedButton);
      case EditType.toggle:
        return _buildToggle(valueModel, e, ref);
      case EditType.dropdown:
        return _buildDropdown(valueModel, e, ref);
      case EditType.slider:
        return _buildSlider(valueModel, e, ref);
      case EditType.iconButton:
        return _iconButton(valueModel, e, ref);
      case EditType.icon:
        return _icon(valueModel, e, ref);
      // case EditType.input:
      //   return _buildInput(valueModel, e, ref);
      //https://github.com/mchome/flutter_colorpicker
      //FAB
      case EditType.floatingActionButton:
        return Container();
      default:
        return Text(
          valueModel.getValueAsString(format: e.format) + (e.unitOfMeasurement ?? ""),
          style: e.textStyle?.toTextStyle(),
        );
    }
  }

  Widget _buildButton(
      final ValueStore valueModel, final LayoutBasePropertyInfo e, final WidgetRef ref, final bool raisedButton) {
    final info = e.editInfo!;
    final edit = info.editParameter.first;
    final message = Message(edit.id ?? id, edit.messageType ?? info.editCommand, edit.command, edit.parameters);
    if (raisedButton) {
      return ElevatedButton(
        onPressed: (() async {
          await ref
              .read(hubConnectionConnectedProvider)
              ?.invoke(info.hubMethod ?? "Update", args: <Object>[message.toJson()]);
        }),
        child: Text(info.display!,
            style: TextStyle(
                fontWeight: valueModel.currentValue == info.activeValue ? FontWeight.bold : FontWeight.normal)),
      );
    }

    return MaterialButton(
      onPressed: (() async {
        await ref
            .read(hubConnectionConnectedProvider)
            ?.invoke(info.hubMethod ?? "Update", args: <Object>[message.toJson()]);
      }),
      child: Text(info.display!,
          style:
              TextStyle(fontWeight: valueModel.currentValue == info.activeValue ? FontWeight.bold : FontWeight.normal)),
    );
  }

  Widget _icon(final ValueStore valueModel, final LayoutBasePropertyInfo e, final WidgetRef ref) {
    final info = e.editInfo!;
    EditParameter edit;
    if (valueModel.currentValue is double) {
      final val = (valueModel.currentValue as double);
      edit = info.editParameter.firstWhere((final element) {
        final lower = element.raw["Min"] as double?;
        final upper = element.raw["Max"] as double?;
        if (lower != null && upper != null) {
          return val >= lower && val < upper;
        }
        return element.value == val;
      }, orElse: () => info.editParameter.first);
    } else if (valueModel.currentValue is int) {
      final val = (valueModel.currentValue as int);
      edit = info.editParameter.firstWhere((final element) {
        final lower = element.raw["Min"] as int?;
        final upper = element.raw["Max"] as int?;
        if (lower != null && upper != null) {
          return val >= lower && val < upper;
        }
        return element.value == val;
      }, orElse: () => info.editParameter.first);
    } else {
      edit = info.editParameter.first;
    }

    return Icon(
      IconData(edit.raw["CodePoint"] as int, fontFamily: edit.raw["FontFamily"] ?? 'MaterialIcons'),
    );
  }

  Widget _iconButton(final ValueStore valueModel, final LayoutBasePropertyInfo e, final WidgetRef ref) {
    final info = e.editInfo!;
    final edit = info.editParameter.firstWhere((final element) => element.value == valueModel.currentValue,
        orElse: () => info.editParameter.first);
    final message = Message(edit.id ?? id, edit.messageType ?? info.editCommand, edit.command, edit.parameters);

    return IconButton(
      onPressed: (() async {
        await ref
            .read(hubConnectionConnectedProvider)
            ?.invoke(info.hubMethod ?? "Update", args: <Object>[message.toJson()]);
      }),
      icon: Icon(IconData(edit.raw["CodePoint"] as int, fontFamily: edit.raw["FontFamily"] ?? 'MaterialIcons')),
    );
  }

  Widget _buildToggle(final ValueStore valueModel, final LayoutBasePropertyInfo e, final WidgetRef ref) {
    final info = e.editInfo!;
    final edit = info.editParameter.firstWhere((final element) => element.value != valueModel.currentValue);
    final message = Message(edit.id ?? id, edit.messageType ?? info.editCommand, edit.command, edit.parameters);
    return Switch(
      onChanged: ((final _) async {
        await ref
            .read(hubConnectionConnectedProvider)
            ?.invoke(info.hubMethod ?? "Update", args: <Object>[message.toJson()]);
      }),
      value: valueModel.currentValue == info.activeValue,
    );
  }

  Widget _buildDropdown(final ValueStore valueModel, final LayoutBasePropertyInfo e, final WidgetRef ref) {
    final info = e.editInfo!;
    return DropdownButton(
      items: info.editParameter
          .map((final e) => DropdownMenuItem(
                value: e.value,
                child: Text(e.displayName ?? e.value.toString()),
              ))
          .toList(),
      onChanged: (final value) async {
        final edit = info.editParameter.firstWhere((final element) => element.value == value);
        final message = Message(edit.id ?? id, edit.messageType ?? info.editCommand, edit.command, edit.parameters);
        await ref
            .read(hubConnectionConnectedProvider)
            ?.invoke(info.hubMethod ?? "Update", args: <Object>[message.toJson()]);
      },
      value: valueModel.currentValue,
    );
  }

  static final _sliderValueProvider = StateProvider.family<double, Tuple2<String, int>>((final _, final __) {
    return 0.0;
  });

  Widget _buildSlider(final ValueStore valueModel, final LayoutBasePropertyInfo e, final WidgetRef ref) {
    final info = e.editInfo!;
    final edit = info.editParameter.first;
    final json = edit.value;
    if (json is! Map<String, dynamic>) return Container();
    if (json.containsKey("Divisions") && json.containsKey("Values")) {
      final customLabels = (json["Values"]);
      final currentValue = ref.watch(_sliderValueProvider(Tuple2(e.name, id)));
      return Slider(
        min: json["Min"] as double,
        max: json["Max"] as double,
        divisions: json["Divisions"],
        onChanged: (final value) {
          ref.read(_sliderValueProvider(Tuple2(e.name, id)).notifier).state = value;
        },
        onChangeEnd: (final value) async {
          final message = Message(edit.id ?? id, edit.messageType ?? info.editCommand, edit.command,
              [customLabels[value.round()].values.first, ...?edit.parameters]);
          await ref
              .read(hubConnectionConnectedProvider)
              ?.invoke(info.hubMethod ?? "Update", args: <Object>[message.toJson()]);
        },
        value: currentValue,
        label: customLabels[currentValue.round()].keys.first,
      );
    }

    return Slider(
      min: json["Min"] as double? ?? 0.0,
      max: json["Max"] as double? ?? 1.0,
      divisions: json["Divisions"] as int?,
      onChanged: (final value) {
        if (valueModel.currentValue is double)
          valueModel.setValue(value);
        else if (valueModel.currentValue is int) valueModel.setValue(value.toInt());
      },
      onChangeEnd: (final value) async {
        final message =
            Message(edit.id ?? id, edit.messageType ?? info.editCommand, edit.command, [value, ...?edit.parameters]);
        await ref
            .read(hubConnectionConnectedProvider)
            ?.invoke(info.hubMethod ?? "Update", args: <Object>[message.toJson()]);
      },
      value: valueModel.currentValue is double ? valueModel.currentValue : valueModel.currentValue.toDouble(),
      label: info.display ?? valueModel.getValueAsString(),
    );
  }
}

class GenericDeviceScreen extends ConsumerStatefulWidget {
  final GenericDevice genericDevice;
  const GenericDeviceScreen(this.genericDevice, {final Key? key}) : super(key: key);

  @override
  GenericDeviceScreenState createState() => GenericDeviceScreenState();
}

class GenericDeviceScreenState extends ConsumerState<GenericDeviceScreen> {
  final _currentShownTimeProvider = StateProvider<DateTime>((final _) => DateTime.now());

  final _currentShownTabProvider = StateProvider.family<bool, Tuple2<int, String>>((final ref, final _) {
    return false;
  });
  final _tabKeyProvider = StateProvider.autoDispose.family<Key, Tuple2<int, String>>((final ref, final key) {
    return Key(key.toString());
  });
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
        floatingActionButton: _buildFab(),
        appBar: AppBar(
          title: Text(friendlyName),
        ),
        body: buildBody());
  }

  Widget buildWithHistory(final BuildContext context, final List<HistoryPropertyInfo> histProps) {
    return DefaultTabController(
      length: histProps.length + 1,
      child: Scaffold(
        floatingActionButton: _buildFab(),
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

  Widget? _buildFab() {
    final name = ref.watch(BaseModel.typeNameProvider(widget.genericDevice.id));
    final fabLayout = ref.watch(fabLayoutProvider(Tuple2(widget.genericDevice.id, name)));
    if (fabLayout == null) return null;

    final valueModel =
        ref.watch(valueStoreChangedProvider(Tuple2(fabLayout.name, fabLayout.deviceId ?? widget.genericDevice.id)));
    if (valueModel == null) return null;
    // final showDebugInformation = ref.watch(debugInformationEnabledProvider);

    final info = fabLayout.editInfo!;
    final EditParameter edit;
    if (valueModel.currentValue is double) {
      final val = (valueModel.currentValue as double);
      edit = info.editParameter.firstWhere((final element) {
        final lower = element.raw["Min"] as double?;
        final upper = element.raw["Max"] as double?;
        if (lower != null && upper != null) {
          return val >= lower && val < upper;
        }
        return element.value == val;
      }, orElse: () => info.editParameter.first);
    } else if (valueModel.currentValue is int) {
      final val = (valueModel.currentValue as int);
      edit = info.editParameter.firstWhere((final element) {
        final lower = element.raw["Min"] as int?;
        final upper = element.raw["Max"] as int?;
        if (lower != null && upper != null) {
          return val >= lower && val < upper;
        }
        return element.value == val;
      }, orElse: () => info.editParameter.first);
    } else {
      edit = info.editParameter.first;
    }
    final message = Message(
        edit.id ?? widget.genericDevice.id, edit.messageType ?? info.editCommand, edit.command, edit.parameters);

    return FloatingActionButton(
      onPressed: (() async {
        await ref
            .read(hubConnectionConnectedProvider)
            ?.invoke(info.hubMethod ?? "Update", args: <Object>[message.toJson()]);
      }),
      child: Icon(
        IconData(edit.raw["CodePoint"] as int, fontFamily: edit.raw["FontFamily"] ?? 'MaterialIcons'),
      ),
    );
  }

  Widget buildBody() {
    final name = ref.watch(BaseModel.typeNameProvider(widget.genericDevice.id));
    final detailProperties = ref.watch(detailPropertyInfoLayoutProvider(Tuple2(widget.genericDevice.id, name)));
    if (detailProperties == null || detailProperties.isEmpty) return Container();
    // final widgets = <Widget>[];
    detailProperties.sort((final a, final b) => a.order.compareTo(b.order));

    // for (final detProp in detailProperties) {
    //   widgets.add(DetailValueStoreWidget(detProp, widget.genericDevice));
    // }
    // return ListView(
    //   children: widgets,
    // );
    final props = detailProperties.groupBy((final g) => g.rowNr).map((final row, final elements) {
      return MapEntry(
        row,
        ListTile(
          leading: ref.watch(debugInformationEnabledProvider) ? Text("Row: $row") : null,
          title: Row(
            // runAlignment: WrapAlignment.spaceBetween,
            // spacing: 8,
            children: elements.map((final e) {
              final exp = e.expanded;
              if (exp == null || !exp) return DetailValueStoreWidget(e, widget.genericDevice);
              return Expanded(child: DetailValueStoreWidget(e, widget.genericDevice));
            }).toList(),
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
    final showBody = ref.watch(_currentShownTabProvider(Tuple2(widget.genericDevice.id, info.propertyName)));
    return VisibilityDetector(
        key: ref.watch(_tabKeyProvider(Tuple2(widget.genericDevice.id, info.propertyName))),
        child: !showBody
            ? Container()
            : ref
                .watch(historyPropertyNameProvider(
                    Tuple3(widget.genericDevice.id, currentShownTime.toString(), info.propertyName)))
                .when(
                  data: (final data) {
                    if (data != null && data.historyRecords.isNotEmpty) {
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
                ),
        onVisibilityChanged: (final i) {
          try {
            ref.read(_currentShownTabProvider(Tuple2(widget.genericDevice.id, info.propertyName)).notifier).state =
                !i.visibleBounds.isEmpty;
          } catch (e) {
            //Happends in debug when exiting in the history tab
          }
        });

    // final h = ;

    // return h.when(
    //   data: (final data) {
    //     if (data != null && data.historyRecords.isNotEmpty) {
    //       return buildHistorySeriesAnnotationChart(
    //           data,
    //           info.unitOfMeasurement,
    //           info.xAxisName,
    //           AdaptiveTheme.of(context).brightness == Brightness.light
    //               ? Color(info.brightThemeColor)
    //               : Color(info.darkThemeColor),
    //           currentShownTime);
    //     }
    //     return buildDataMissing(currentShownTime);
    //   },
    //   error: (final e, final o) => Text(e.toString()),
    //   loading: () => Column(
    //     children: <Widget>[
    //       Container(
    //         margin: const EdgeInsets.only(top: 50),
    //         child: Text(
    //           'Lade weitere History Daten...',
    //           style: Theme.of(context).textTheme.headline6,
    //         ),
    //       ),
    //       Container(
    //         margin: const EdgeInsets.only(top: 25),
    //         child: const CircularProgressIndicator(),
    //       ),
    //     ],
    //   ),
    // );
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

  Widget buildHistorySeriesAnnotationChart(final IoBrokerHistoryModel h, final String unit, final String valueName,
      final Color lineColor, final DateTime currentShownTime) {
    h.historyRecords = h.historyRecords.where((final x) => x.value != null).toList(growable: false);
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Expanded(
          child: HistorySeriesAnnotationChartWidget(
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
        )
      ],
    );
  }

  getNewData(final DateTime dt) {
    if (dt.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch) return;
    ref.read(_currentShownTimeProvider.notifier).state = dt;
  }
}
