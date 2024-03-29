import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/generic/detail_property_info.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/devices/generic/stores/store_service.dart';
import 'package:smarthome/helper/settings_manager.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailValueStoreWidget extends ConsumerWidget {
  final DetailPropertyInfo e;
  final GenericDevice device;

  const DetailValueStoreWidget(this.e, this.device, {final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final valueModel = ref.watch(valueStoreChangedProvider(Tuple2(e.name, e.deviceId ?? device.id)));
    final showDebugInformation = ref.watch(debugInformationEnabledProvider);

    if ((e.showOnlyInDeveloperMode ?? false) && !showDebugInformation) {
      return Container();
    }

    final text = Text(
      (e.displayName ?? "") +
          (valueModel?.getValueAsString(format: e.format, precision: e.precision ?? 1) ?? "") +
          (e.unitOfMeasurement ?? ""),
      style: e.textStyle?.toTextStyle(),
    );

    Widget ret;
    if (e.editInfo != null) {
      ret = Row(
        children: [text, device.getEditWidget(context, e, valueModel, ref)],
      );
      ret = device.getEditWidget(context, e, valueModel, ref);
    } else {
      ret = text;
    }

    return ret;
  }
}
