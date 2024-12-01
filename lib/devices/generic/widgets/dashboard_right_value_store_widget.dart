import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/devices/generic/stores/store_service.dart';
import 'package:smarthome/helper/settings_manager.dart';

class DashboardRightValueStoreWidget extends ConsumerWidget {
  final DashboardPropertyInfo e;
  final GenericDevice device;
  const DashboardRightValueStoreWidget(this.e, this.device, {super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final valueModel =
        ref.watch(valueStoreChangedProvider(e.name, e.deviceId ?? device.id));
    if (valueModel == null) return const SizedBox();

    final showDebugInformation = ref.watch(debugInformationEnabledProvider);
    if ((e.showOnlyInDeveloperMode ?? false) && !showDebugInformation) {
      return const SizedBox();
    }
    if (e.specialType == DasboardSpecialType.right) {
      return device.getEditWidget(context, e, valueModel, ref);
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
