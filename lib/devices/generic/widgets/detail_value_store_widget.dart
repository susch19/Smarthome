import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/generic/stores/store_service.dart';
import 'package:smarthome/helper/settings_manager.dart';

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

    if (e.editInfo != null) {
      // ret = Row(
      //   children: [text, device.getEditWidget(e, valueModel)],
      // );
      return device.getEditWidget(e, valueModel);
    }
    final jsonVal = valueModel.getFromJson(e)?.toString() ?? "";
    final text = Text(
      (e.displayName) + (jsonVal) + (e.unitOfMeasurement),
      style: GenericDevice.toTextStyle(e.textStyle),
    );
    return text;
  }
}
