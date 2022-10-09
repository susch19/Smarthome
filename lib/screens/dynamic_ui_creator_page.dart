import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/generic/device_layout_service.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/devices/generic/stores/value_store.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/helper/theme_manager.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smarthome/models/message.dart';

final _layoutProvider = FutureProvider<List<DeviceLayout>>((ref) async {
  var connection = ref.watch(hubConnectionConnectedProvider);
  if (connection == null) return [];
  var layouts = await connection.invoke("GetAllDeviceLayouts");
  if (layouts is! List<dynamic>) return [];
  return layouts.map((e) => DeviceLayout.fromJson(e)).toList();
});

final _selectedLayoutProvider = StateProvider<DeviceLayout?>((ref) {
  return null;
});

class DynamicUiCreatorPage extends ConsumerStatefulWidget {
  const DynamicUiCreatorPage({final Key? key}) : super(key: key);

  @override
  DynamicUiCreatorPageState createState() => DynamicUiCreatorPageState();
}

class DynamicUiCreatorPageState extends ConsumerState<DynamicUiCreatorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dynamic Ui Konfigurator"),
        leading: BackButton(
          onPressed: () {
            var prov = ref.read(_selectedLayoutProvider.notifier);
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

  Widget buildBody(BuildContext context) {
    final iconColor = AdaptiveTheme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;
    var layouts = ref.watch(_layoutProvider);

    var selected = ref.watch(_selectedLayoutProvider);
    if (selected == null) {
      return Container(
        decoration: ThemeManager.getBackgroundDecoration(context),
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(_layoutProvider.future);
          },
          child: ListView(
            children: layouts.when(
                data: (data) {
                  return data
                      .map(
                        (e) => ListTile(
                          title: Text(e.uniqueName),
                          onTap: (() {
                            ref.read(_selectedLayoutProvider.notifier).state = e;
                          }),
                        ),
                      )
                      .toList(growable: false);
                },
                error: (error, stackTrace) {
                  return [Text(error.toString())];
                },
                loading: () => [Text("loading")]),
          ),
        ),
      );
    }
    return getEditView(context, selected);
  }

  Widget getEditView(BuildContext context, DeviceLayout layout) {
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
                              context, -1, e, ValueStore(-1, 1.0, "", Command.Brightness), ref);
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
