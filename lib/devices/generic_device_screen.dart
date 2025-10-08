import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smarthome/controls/blurry_card.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/generic/device_layout_service.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/devices/generic/stores/store_service.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/helper/settings_manager.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:visibility_detector/visibility_detector.dart';

class GenericDeviceScreen extends HookConsumerWidget {
  final GenericDevice genericDevice;
  const GenericDeviceScreen(this.genericDevice, {super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final name = ref.watch(BaseModel.typeNameProvider(genericDevice.id));
    final historyProps =
        ref.watch(detailHistoryLayoutProvider(genericDevice.id, name));
    final tabInfos =
        ref.watch(detailTabInfoLayoutProvider(genericDevice.id, name));

    if (historyProps?.isEmpty ?? true) {
      return buildWithoutHistory(context, ref, tabInfos);
    }
    return buildWithHistory(context, ref, historyProps!, tabInfos);
  }

  Widget buildWithoutHistory(final BuildContext context, final WidgetRef ref,
      final List<DetailTabInfo>? tabInfos) {
    final friendlyName =
        ref.watch(BaseModel.friendlyNameProvider(genericDevice.id));
    if (tabInfos == null || tabInfos.isEmpty || tabInfos.length == 1) {
      return Scaffold(
          floatingActionButton: _GenericDeviceFab(genericDevice: genericDevice),
          appBar: AppBar(
            title: Text(friendlyName),
          ),
          body: buildBody(ref, tabInfos?.firstOrNull));
    }
    return DefaultTabController(
        length: tabInfos.length,
        child: Scaffold(
            floatingActionButton:
                _GenericDeviceFab(genericDevice: genericDevice),
            appBar: AppBar(
              title: TabBar(
                tabs: tabInfos.map((final e) {
                  final icon = ref.watch(iconWidgetSingleProvider(e.iconName,
                      genericDevice, AdaptiveTheme.of(context), true));
                  return Tab(icon: icon);
                }).toList(),
              ),
            ),
            body: TabBarView(
                children: tabInfos
                    .map((final e) => buildBody(ref, e))
                    .toList(growable: false))));
  }

  Widget buildWithHistory(
      final BuildContext context,
      final WidgetRef ref,
      final List<HistoryPropertyInfo> histProps,
      final List<DetailTabInfo>? tabInfos) {
    if (tabInfos == null || tabInfos.isEmpty) {
      return DefaultTabController(
        length: histProps.length + 1,
        child: Scaffold(
          floatingActionButton: _GenericDeviceFab(genericDevice: genericDevice),
          appBar: AppBar(
            title: TabBar(
              tabs: histProps
                  .map((final e) {
                    final icon = ref.watch(iconWidgetSingleProvider(e.iconName,
                        genericDevice, AdaptiveTheme.of(context), true));
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
                  .map((final e) => buildGraph(context, ref, e))
                  .injectForIndex(
                      (final index) => index == 0 ? buildBody(ref) : null)
                  .toList(),
            ),
          ),
        ),
      );
    }
    return DefaultTabController(
      length: histProps.length + tabInfos.length,
      child: Scaffold(
        floatingActionButton: _GenericDeviceFab(genericDevice: genericDevice),
        appBar: AppBar(
          title: TabBar(
            tabs: [
              ...tabInfos.map((final e) {
                final icon = ref.watch(iconWidgetSingleProvider(e.iconName,
                    genericDevice, AdaptiveTheme.of(context), true));
                return Tab(icon: icon);
              }),
              ...histProps.map((final e) {
                final icon = ref.watch(iconWidgetSingleProvider(e.iconName,
                    genericDevice, AdaptiveTheme.of(context), true));
                return Tab(icon: icon);
              }),
            ].toList(),
          ),
        ),
        body: Container(
          decoration: ThemeManager.getBackgroundDecoration(context),
          child: TabBarView(
            children: [
              ...tabInfos.map((final e) => buildBody(ref, e)),
              ...histProps.map((final e) => buildGraph(context, ref, e))
            ].toList(),
          ),
        ),
      ),
    );
  }

  final emptyContainer = const SizedBox();
  Widget buildBody(final WidgetRef ref, [final DetailTabInfo? tabInfo]) {
    final name = ref.watch(BaseModel.typeNameProvider(genericDevice.id));
    var detailProperties =
        ref.watch(detailPropertyInfoLayoutProvider(genericDevice.id, name));
    final showDebugInformation = ref.watch(debugInformationEnabledProvider);
    if (detailProperties == null || detailProperties.isEmpty) {
      return const SizedBox();
    }
    detailProperties = detailProperties
        .where((final element) =>
            tabInfo == null || tabInfo.id == element.tabInfoId)
        .toList(growable: false);
    // final widgets = <Widget>[];
    detailProperties.sort(
        (final a, final b) => (a.rowNr ?? 0).compareTo(b.rowNr ?? 0xFFFF));
    // for (final detProp in detailProperties) {
    //   widgets.add(DetailValueStoreWidget(detProp, genericDevice));
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
            e.editInfo!.editType.toLowerCase() != "floatingactionbutton")
        .groupBy((final g) => g.rowNr)
        .map((final row, final elements) {
      final children = elements.map((final e) {
        final exp = e.expanded;
        final widget = DetailValueStoreWidget(e, genericDevice);
        if (exp == null || !exp) {
          return widget;
        }
        return Expanded(child: widget);
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

  Widget buildGraph(final BuildContext context, final WidgetRef ref,
      final HistoryPropertyInfo info) {
    final currentShownTime = useState(DateTime.now());
    final showBody = useState(false);

    final from = DateTime.utc(currentShownTime.value.year,
            currentShownTime.value.month, currentShownTime.value.day)
        .subtract(currentShownTime.value.timeZoneOffset);

    return VisibilityDetector(
        key: Key(genericDevice.id.toString() + info.propertyName),
        child: !showBody.value
            ? const SizedBox()
            : ref
                .watch(historyPropertyNameProvider(genericDevice.id, from,
                    from.add(Duration(days: 1)), info.propertyName))
                .when(
                  data: (final data) {
                    if (data.historyRecords.isNotEmpty) {
                      return buildHistorySeriesAnnotationChart(
                          context,
                          data,
                          info,
                          AdaptiveTheme.of(context).brightness ==
                                  Brightness.light
                              ? Color(info.brightThemeColor)
                              : Color(info.darkThemeColor),
                          currentShownTime);
                    }
                    return buildDataMissing(context, currentShownTime);
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
          if (context.mounted) showBody.value = !i.visibleBounds.isEmpty;
        });
  }

  Widget buildDataMissing(
      final BuildContext context, final ValueNotifier<DateTime> notifier) {
    final currentShownTime = notifier.value;
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
                getNewData(currentShownTime.subtract(const Duration(days: 1)),
                    notifier);
              },
            )),
            Expanded(
              child: MaterialButton(
                  onPressed: () => _openDatePicker(context, notifier),
                  child: const Text('Datum auswählen')),
            ),
            Expanded(
                child: MaterialButton(
              child: const Text("Später"),
              onPressed: () {
                getNewData(
                    currentShownTime.add(const Duration(days: 1)), notifier);
              },
            )),
          ],
        )
      ],
    );
  }

  Widget buildHistorySeriesAnnotationChart(
      final BuildContext context,
      final History h,
      final HistoryPropertyInfo info,
      final Color lineColor,
      final ValueNotifier<DateTime> currentShownTime) {
    final historyRecords = h.historyRecords
        .where((final x) => x.val != null)
        .toList(growable: false);
    final chartType = info.chartType;
    final dynamic seriesList = _getSeriesList(chartType, h, lineColor);
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Expanded(
          child: HistorySeriesAnnotationChartWidget(
            seriesList,
            historyRecords.minBy(10000, (final e) => e.val!).toDouble(),
            historyRecords.maxBy(0, (final e) => e.val!).toDouble(),
            info.unitOfMeasurement,
            info.xAxisName,
            currentShownTime.value,
            loadMoreIndicatorBuilder: (final context, final direction) {
              return Consumer(
                builder: (final context, final ref, final child) {
                  Future<void>.delayed(const Duration(milliseconds: 10), (() {
                    final current = currentShownTime;
                    if (direction == ChartSwipeDirection.end) {
                      if (current.value.day < DateTime.now().day) {
                        current.value =
                            current.value.add(const Duration(days: 1));
                      }
                    } else {
                      current.value =
                          current.value.add(const Duration(days: -1));
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
                getNewData(
                    currentShownTime.value.subtract(const Duration(days: 1)),
                    currentShownTime);
              },
            )),
            Expanded(
              child: MaterialButton(
                  onPressed: () => _openDatePicker(context, currentShownTime),
                  child: const Text('Datum auswählen')),
            ),
            currentShownTime.value
                    .isAfter(DateTime.now().add(const Duration(hours: -23)))
                ? Expanded(
                    child: const SizedBox(),
                  )
                : Expanded(
                    child: MaterialButton(
                    child: const Text("Später"),
                    onPressed: () {
                      getNewData(
                          currentShownTime.value.add(const Duration(days: 1)),
                          currentShownTime);
                    },
                  )),
          ],
        )
      ],
    );
  }

  dynamic _getSeriesList(
      final String charType, final History h, final Color lineColor) {
    switch (charType) {
      case "step":
        return [
          StepLineSeries<GraphTimeSeriesValue, DateTime>(
              animationDuration: 500,
              // markerSettings: MarkerSettings(shape: DataMarkerType.circle, color: Colors.green, width: 5, height: 5, isVisible: true),
              markerSettings: const MarkerSettings(
                isVisible: true,
              ),
              dataSource: h.historyRecords
                  .map((final x) => GraphTimeSeriesValue(
                      DateTime.utc(1).add(Duration(milliseconds: x.ts)),
                      x.val,
                      lineColor))
                  .toList(),
              xValueMapper: (final GraphTimeSeriesValue value, final _) =>
                  value.time,
              yValueMapper: (final GraphTimeSeriesValue value, final _) =>
                  value.value,
              pointColorMapper: (final GraphTimeSeriesValue value, final _) =>
                  value.lineColor)
        ];
      default:
        return [
          LineSeries<GraphTimeSeriesValue, DateTime>(
              animationDuration: 500,
              // markerSettings: MarkerSettings(shape: DataMarkerType.circle, color: Colors.green, width: 5, height: 5, isVisible: true),
              markerSettings: const MarkerSettings(
                isVisible: true,
              ),
              dataSource: h.historyRecords
                  .map((final x) => GraphTimeSeriesValue(
                      DateTime.utc(1).add(Duration(milliseconds: x.ts)),
                      x.val,
                      lineColor))
                  .toList(),
              xValueMapper: (final GraphTimeSeriesValue value, final _) =>
                  value.time,
              yValueMapper: (final GraphTimeSeriesValue value, final _) =>
                  value.value,
              pointColorMapper: (final GraphTimeSeriesValue value, final _) =>
                  value.lineColor)
        ];
    }
  }

  void _openDatePicker(
      final BuildContext context, final ValueNotifier<DateTime> initial) {
    // showDatePicker is a pre-made funtion of Flutter
    showDatePicker(
            context: context,
            initialDate: initial.value,
            firstDate: DateTime(2018),
            lastDate: DateTime.now())
        .then((final pickedDate) {
      // Check if no date is selected
      if (pickedDate == null) {
        return;
      }
      getNewData(pickedDate, initial);
    });
  }

  void getNewData(final DateTime dt, final ValueNotifier<DateTime> state) {
    if (dt.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch) {
      return;
    }
    state.value = dt;
  }
}

class _GenericDeviceFab extends HookConsumerWidget {
  const _GenericDeviceFab({
    required this.genericDevice,
  });

  final GenericDevice genericDevice;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final name = ref.watch(BaseModel.typeNameProvider(genericDevice.id));
    final fabLayout = ref.watch(fabLayoutProvider(genericDevice.id, name));
    if (fabLayout == null) return const SizedBox();

    final valueModel = ref.watch(valueStoreChangedProvider(
      fabLayout.name,
      fabLayout.deviceId ?? genericDevice.id,
    ));
    if (valueModel == null) return const SizedBox();
    useListenable(valueModel);
    // final showDebugInformation = ref.watch(debugInformationEnabledProvider);

    final info = fabLayout.editInfo!;
    final edit = GenericDevice.getEditParameter(valueModel, info, "Fab");
    if (edit == null) return const SizedBox();

    return FloatingActionButton(
      onPressed: (() async {
        await Device.postMessage(
            genericDevice.id, info, ref.read(apiProvider), valueModel.value);
      }),
      child: Icon(
        IconData(edit.extensionData!["CodePoint"] as int,
            fontFamily: edit.extensionData!["FontFamily"] ?? 'MaterialIcons'),
      ),
    );
  }
}
