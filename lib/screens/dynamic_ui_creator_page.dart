import 'package:flutter/material.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/devices/generic/stores/value_store.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/helper/theme_manager.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final _layoutProvider = FutureProvider<List<DeviceLayout>>((final ref) async {
  final connection = ref.watch(hubConnectionConnectedProvider);
  if (connection == null) return [];
  final layouts = await connection.invoke("GetAllDeviceLayouts");
  if (layouts is! List<dynamic>) return [];
  return layouts.map((final e) => DeviceLayout.fromJson(e)).toList();
});

final _selectedLayoutProvider = StateProvider<DeviceLayout?>((final ref) {
  return null;
});

class DynamicUiCreatorPage extends ConsumerStatefulWidget {
  const DynamicUiCreatorPage({super.key});

  @override
  DynamicUiCreatorPageState createState() => DynamicUiCreatorPageState();
}

class DynamicUiCreatorPageState extends ConsumerState<DynamicUiCreatorPage> {
  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dynamic Ui Konfigurator"),
        leading: BackButton(
          onPressed: () {
            final prov = ref.read(_selectedLayoutProvider.notifier);
            if (prov.state != null) {
              prov.state = null;
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(final BuildContext context) {
    final layouts = ref.watch(_layoutProvider);

    final selected = ref.watch(_selectedLayoutProvider);
    if (selected == null) {
      return Container(
        decoration: ThemeManager.getBackgroundDecoration(context),
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(_layoutProvider);
          },
          child: ListView(
            children: layouts.when(
                data: (final data) {
                  return data
                      .map(
                        (final e) => ListTile(
                          title: Text(e.uniqueName),
                          onTap: (() {
                            ref.read(_selectedLayoutProvider.notifier).state =
                                e;
                          }),
                        ),
                      )
                      .toList(growable: false);
                },
                error: (final error, final stackTrace) {
                  return [Text(error.toString())];
                },
                loading: () => [const Text("loading")]),
          ),
        ),
      );
    }
    return getEditView(context, selected);
  }

  Widget getEditView(final BuildContext context, final DeviceLayout layout) {
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.spaceEvenly,
          children: layout.dashboardDeviceLayout!.dashboardProperties
              .groupBy((final g) => g.rowNr)
              .map((final row, final elements) {
                return MapEntry(
                  row,
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: Center(
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        runAlignment: WrapAlignment.spaceBetween,
                        spacing: 8,
                        children: elements.map((final e) {
                          return GenericDevice.getEditWidgetFor(
                              context,
                              -1,
                              e,
                              ValueStore(-1, 1.0, "", Command2.brightness),
                              ref);
                        }).toList(),
                      ),
                    ),
                  ),
                );
              })
              .values
              .toList(),
        ),
      ],
    );
    // return GenericDevice.getEditWidgetFor(context, -1, layout.dashboardDeviceLayout, null, ref);
  }
}
