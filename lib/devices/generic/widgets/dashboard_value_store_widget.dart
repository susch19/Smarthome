import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/devices/generic/stores/store_service.dart';
import 'package:smarthome/helper/settings_manager.dart';

class DashboardValueStoreWidget extends ConsumerWidget {
  final DashboardPropertyInfo e;
  final GenericDevice device;
  const DashboardValueStoreWidget(this.e, this.device, {super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final valueModel =
        ref.watch(valueStoreChangedProvider(e.name, e.deviceId ?? device.id));
    final showDebugInformation = ref.watch(debugInformationEnabledProvider);

    if (valueModel == null ||
        valueModel.currentValue == null ||
        (e.specialType == DasboardSpecialType.right) ||
        ((e.showOnlyInDeveloperMode ?? false) && !showDebugInformation)) {
      return const SizedBox();
    }

    return device.getEditWidget(context, e, valueModel, ref);
  }

  // Widget _buildInput(final ValueStore valueModel, final DashboardPropertyInfo e, final WidgetRef ref) {
  //   final info = e.editInfo!;
  //   final edit = info.editParameter.first;
  //   final tec = TextEditingController();
  //   tec.text = valueModel.getValueAsString();
  //   return TextField(
  //     keyboardType:
  //         TextInputType.values.firstOrNull((final element) => element.toString().contains(info.rest!["KeyboardType"])),
  //     decoration: InputDecoration(
  //       labelText: info.display,
  //       hintText: info.rest!["HintText"],
  //     ),
  //     onChanged: (final value) {
  //       valueModel.currentValue = value;
  //     },
  //     onSubmitted: (final value) async {
  //       final message = Message(
  //           edit.id ?? deviceId, edit.messageType ?? info.editCommand, edit.command, [value, ...?edit.parameters]);
  //       await ref.read(apiProvider).invoke(info.hubMethod ?? "Update", args: <Object>[message.toJson()]);
  //     },
  //     controller: tec,
  //   );
  // }
}
