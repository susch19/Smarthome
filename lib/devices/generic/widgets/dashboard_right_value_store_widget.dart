import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/devices/generic/stores/store_service.dart';
import 'package:smarthome/devices/generic/stores/value_store.dart';
import 'package:smarthome/devices/generic_device.dart';
import 'package:smarthome/helper/settings_manager.dart';
import 'package:smarthome/icons/icons.dart';
import 'package:tuple/tuple.dart';

class DashboardRightValueStoreWidget extends ConsumerWidget {
  final DashboardPropertyInfo e;
  final GenericDevice device;
  const DashboardRightValueStoreWidget(this.e, this.device, {final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final valueModel = ref.watch(valueStoreChangedProvider(Tuple2(e.name, e.deviceId ?? device.id)));
    if (valueModel == null) return Container();

    final showDebugInformation = ref.watch(debugInformationEnabledProvider);
    if ((e.showOnlyInDeveloperMode ?? false) && !showDebugInformation) return Container();
    if (e.specialType == SpecialType.right) {
      return device.getEditWidget(e, valueModel, ref);
    }

    // else if (e.specialType == SpecialType.disabled) {
    //   if (valueModel.currentValue.runtimeType != (bool)) return Container();
    //   final currentValue = valueModel.currentValue as bool;
    //   return Icon(
    //     currentValue ? Icons.power_off_outlined : Icons.power_outlined,
    //     size: 20,
    //   );
    // }
    return Container();
  }

  // StatelessWidget buildBatteryIcon(final ValueStore<dynamic> valueModel) {
  //   if (valueModel.currentValue.runtimeType != (int)) return Container();
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
