import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/devices/generic/stores/store_service.dart';
import 'package:smarthome/helper/settings_manager.dart';

class DashboardRightValueStoreWidget extends HookConsumerWidget {
  final DashboardPropertyInfo info;
  final GenericDevice device;
  const DashboardRightValueStoreWidget(this.info, this.device, {super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final valueModel = ref.watch(
        valueStoreChangedProvider(info.name, info.deviceId ?? device.id));
    if (valueModel == null) return const SizedBox();
    useListenable(valueModel);

    final showDebugInformation = ref.watch(debugInformationEnabledProvider);
    if ((info.showOnlyInDeveloperMode ?? false) && !showDebugInformation) {
      return const SizedBox();
    }
    if (info.specialType == DasboardSpecialType.right) {
      return device.getEditWidget(info, valueModel);
    }

    // else if (e.specialType == SpecialType.disabled) {
    //   if (valueModel.currentValue.runtimeType != (bool)) return const SizedBox();
    //   final currentValue = valueModel.currentValue as bool;
    //   return Icon(
    //     currentValue ? Icons.power_off_outlined : Icons.power_outlined,
    //     size: 20,
    //   );
    // }
    return const SizedBox();
  }

  // StatelessWidget buildBatteryIcon(final ValueStore<dynamic> valueModel) {
  //   if (valueModel.currentValue.runtimeType != (int)) return const SizedBox();
  //   final currentValue = valueModel.currentValue as int;
  //   return Icon(
  //     (currentValue > 80
  //         ? SmarthomeIcons.bat4
  //         : (currentValue > 60
  //             ? SmarthomeIcons.bat3
  //             : (currentValue > 40
  //                 ? SmarthomeIcons.bat2
  //                 : (currentValue > 20 ? SmarthomeIcons.bat1 : SmarthomeIcons.bat_charge)))),
  //     size: 20,
  //   );
  // }
}
