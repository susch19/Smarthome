import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/generic/stores/value_store.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class AdvancedSlider extends HookConsumerWidget {
  final int id;
  final ValueStore<dynamic> valueModel;
  final LayoutBasePropertyInfo info;

  const AdvancedSlider(this.id, this.valueModel,
      {super.key, required this.info});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final editInfo = info.editInfo;
    final valueModel = this.valueModel;
    if (valueModel.currentValue is! num || editInfo == null) {
      return const SizedBox();
    }
    useListenable(valueModel);
    final raw = editInfo.extensionData ?? {};

    final minimum = (raw.containsKey("Min")
            ? double.tryParse(raw["Min"].toString())
            : null) ??
        5.0;
    final maximum = (raw.containsKey("Max")
            ? double.tryParse(raw["Max"].toString())
            : null) ??
        35.0;
    final interval = (raw.containsKey("Interval")
            ? double.tryParse(raw["Interval"].toString())
            : null) ??
        1.0;
    final minorTickInterval = (raw.containsKey("MinorTickInterval")
            ? int.tryParse(raw["MinorTickInterval"].toString())
            : null) ??
        0;

    List<Color> gradients;
    if (raw.containsKey("GradientColors")) {
      final gradientColor = raw["GradientColors"] as List<dynamic>;
      gradients = [];
      for (final grad in gradientColor) {
        if (grad is int) {
          gradients.add(Color(grad));
        } else if (grad is List<dynamic>) {
          gradients.add(Color.fromARGB(grad[0], grad[1], grad[2], grad[3]));
        }
      }
    } else {
      gradients = [Colors.blue, Colors.amber, Colors.red];
    }

    List<double> stops;
    if (raw.containsKey("Stops")) {
      final stopsInfo = raw["Stops"] as List<dynamic>;
      stops = [];
      for (final grad in stopsInfo) {
        if (grad is double) {
          stops.add(grad);
        }
      }
    } else {
      stops = [0.3, 0.5, 1];
    }

    return SfLinearGauge(
        isMirrored: true,
        minimum: minimum,
        maximum: maximum,
        interval: interval,
        minorTicksPerInterval: minorTickInterval,
        animateAxis: true,
        labelFormatterCallback: (final String value) {
          return value + info.unitOfMeasurement;
        },
        axisTrackStyle: const LinearAxisTrackStyle(thickness: 1),
        barPointers: <LinearBarPointer>[
          LinearBarPointer(
              value: maximum,
              thickness: 4,
              enableAnimation: false,
              position: LinearElementPosition.outside,
              shaderCallback: (final Rect bounds) {
                return LinearGradient(colors: gradients, stops: stops)
                    .createShader(bounds);
              }),
        ],
        markerPointers: <LinearMarkerPointer>[
          LinearWidgetPointer(
              value: (valueModel.value as num).toDouble(),
              enableAnimation: false,
              onChanged: (final value) => valueModel.value = value,
              offset: 7,
              position: LinearElementPosition.outside,
              child: SizedBox(
                  width: 55,
                  height: 45,
                  child: Center(
                      child: Text(
                    valueModel.getValueAsString(
                            precision: info.precision ?? 0) +
                        info.unitOfMeasurement,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      // color: valueModel.currentValue < 20
                      //     ? Colors.green
                      //     : valueModel.currentValue < 60
                      //         ? Colors.orange
                      //         : Colors.red,
                    ),
                  )))),
          LinearShapePointer(
            offset: 4,
            enableAnimation: false,
            onChanged: (final dynamic value) {
              valueModel.value = value as double;
            },
            onChangeEnd: (final value) async {
              Device.postMessage(id, editInfo, ref.read(apiProvider), value);
            },
            value: (valueModel.currentValue as num).toDouble(),
            // color: valueModel.currentValue < 20
            //     ? Colors.green
            //     : valueModel.currentValue < 60
            //         ? Colors.orange
            //         : Colors.red,
          ),
        ]);
  }
}
