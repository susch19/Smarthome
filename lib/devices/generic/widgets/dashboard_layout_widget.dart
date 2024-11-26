import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/helper/iterable_extensions.dart';

class DashboardLayoutWidget extends ConsumerWidget {
  final List<DashboardPropertyInfo> layout;
  final GenericDevice device;

  const DashboardLayoutWidget(this.device, this.layout, {super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    if (layout.isEmpty) return const SizedBox();

    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.spaceEvenly,
          children: layout
              .groupBy((final g) => g.rowNr)
              .map((final row, final elements) {
                return MapEntry(
                  row,
                  FractionallySizedBox(
                    widthFactor: 1,
                    child:
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        Center(
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        runAlignment: WrapAlignment.spaceBetween,
                        spacing: 8,
                        children: elements.map((final e) {
                          return DashboardValueStoreWidget(e, device);
                        }).toList(),
                      ),
                    ),
                    // ],
                    // )

                    //,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // children: [
                    //   Wrap(
                    //     alignment: WrapAlignment.spaceBetween,
                    //     runAlignment: WrapAlignment.spaceBetween,
                    //     spacing: 8,
                    //     children: elements.map((final e) {
                    //       return DashboardValueStoreWidget(e, id);
                    //     }).toList(),
                    //   ),
                    // ],
                  ),
                );
              })
              // .select((p0, p1) => Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [p1],
              //     ))
              .values
              .toList(),
        ),
      ],
    );
  }
}
