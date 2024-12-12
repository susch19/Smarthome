import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/generic/stores/store_service.dart';
import 'package:smarthome/helper/settings_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailValueStoreWidget extends HookConsumerWidget {
  final DetailPropertyInfo e;
  final GenericDevice device;

  const DetailValueStoreWidget(this.e, this.device, {super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final valueModel =
        ref.watch(valueStoreChangedProvider(e.name, e.deviceId ?? device.id));
    if (valueModel == null) return Text((e.displayName));
    useListenable(valueModel);
    final showDebugInformation = ref.watch(debugInformationEnabledProvider);

    if ((e.showOnlyInDeveloperMode ?? false) && !showDebugInformation) {
      return const SizedBox();
    }

    final text = Text(
      (e.displayName) +
          (valueModel.getValueAsString(
              format: e.format, precision: e.precision ?? 1)) +
          (e.unitOfMeasurement),
      style: GenericDevice.toTextStyle(e.textStyle),
    );

    Widget ret;
    if (e.editInfo != null) {
      ret = Row(
        children: [text, device.getEditWidget(e, valueModel)],
      );
      ret = device.getEditWidget(e, valueModel);
    } else {
      ret = text;
    }

    return ret;
  }
}
