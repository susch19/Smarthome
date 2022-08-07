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

    if (valueModel == null ||
        e.specialType != SpecialDetailType.none ||
        ((e.showOnlyInDeveloperMode ?? false) && !showDebugInformation)) {
      return Container();
    }

    if (e.editInfo != null) {
      return device.getEditWidget(e, valueModel, ref);
      // return ListTile(
      //     leading: Text(
      //       (e.displayName ?? ""),
      //       style: e.textStyle?.toTextStyle(),
      //     ),
      //     title: device.getEditWidget(e, valueModel, ref));
    }

    return Text(
      (e.displayName ?? "") + valueModel.getValueAsString(format: e.format) + (e.unitOfMeasurement ?? ""),
      style: e.textStyle?.toTextStyle(),
    );

    // return ListTile(
    //   title: Text(
    //     (e.displayName ?? "") + valueModel.getValueAsString(format: e.format) + (e.unitOfMeasurement ?? ""),
    //     style: e.textStyle?.toTextStyle(),
    //   ),
    // );
  }
}