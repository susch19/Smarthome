import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/devices/generic/stores/store_service.dart';
import 'package:smarthome/helper/settings_manager.dart';

class DashboardValueStoreWidget extends HookConsumerWidget {
  final DashboardPropertyInfo info;
  final GenericDevice device;
  const DashboardValueStoreWidget(this.info, this.device, {super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final valueModel = ref.watch(
        valueStoreChangedProvider(info.name, info.deviceId ?? device.id));
    if (valueModel == null) return const SizedBox();

    useListenable(valueModel);

    final showDebugInformation = ref.watch(debugInformationEnabledProvider);

    if (valueModel.currentValue == null ||
        (info.specialType == DasboardSpecialType.right) ||
        ((info.showOnlyInDeveloperMode ?? false) && !showDebugInformation)) {
      return const SizedBox();
    }

    return device.getEditWidget(info, valueModel);
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
