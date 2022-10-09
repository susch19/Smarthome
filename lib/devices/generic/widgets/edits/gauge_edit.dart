// ignore_for_file: prefer_final_parameters

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/generic/layout_base_property_info.dart';
import 'package:smarthome/devices/generic/property_edit_information.dart';
import 'package:smarthome/devices/generic/stores/store_service.dart';
import 'package:smarthome/devices/generic/stores/value_store.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tuple/tuple.dart';

class GaugeEdit {
  static final _newValueProvider = StateProvider.family<double, Tuple2<int, String>>((final ref, final key) {
    return 21.0;
  });

  static Widget getTempGauge(final int id, final BuildContext context, final ValueStore? valueModel,
      final LayoutBasePropertyInfo e, final WidgetRef ref) {
    final info = e.editInfo;
    if (valueModel == null || valueModel.currentValue is! num || info == null) return Container();

    final startAngle =
        (info.raw.containsKey("StartAngle") ? double.tryParse(info.raw["StartAngle"].toString()) : null) ?? 150.0;
    final endAngle =
        (info.raw.containsKey("EndAngle") ? double.tryParse(info.raw["EndAngle"].toString()) : null) ?? 30.0;
    final radiusFactor =
        (info.raw.containsKey("RadiusFactor") ? double.tryParse(info.raw["RadiusFactor"].toString()) : null) ?? 0.9;
    final minimum = (info.raw.containsKey("Min") ? double.tryParse(info.raw["Min"].toString()) : null) ?? 5.0;
    final maximum = (info.raw.containsKey("Max") ? double.tryParse(info.raw["Max"].toString()) : null) ?? 35.0;
    final interval =
        (info.raw.containsKey("Interval") ? double.tryParse(info.raw["Interval"].toString()) : null) ?? 1.0;
    final angle = (info.raw.containsKey("Angle") ? double.tryParse(info.raw["Angle"].toString()) : null) ?? 180.0;
    final margin = (info.raw.containsKey("Margin") ? double.tryParse(info.raw["Margin"].toString()) : null) ?? 0;

    List<Color> gradients;
    if (info.raw.containsKey("GradientColors")) {
      final gradientColor = info.raw["GradientColors"] as List<dynamic>;
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
    if (info.raw.containsKey("Stops")) {
      final stopsInfo = info.raw["Stops"] as List<dynamic>;
      stops = [];
      for (final grad in stopsInfo) {
        if (grad is double) {
          stops.add(grad);
        }
      }
    } else {
      stops = [0.3, 0.5, 1];
    }

    List<Tuple3<String, String, String>> displays = [];
    if (info.raw.containsKey("Displays")) {
      final displayInfos = info.raw["Displays"] as List<dynamic>;
      for (final di in displayInfos) {
        if (di is Map<String, dynamic>) {
          String label = "";
          String value = "";
          String unit = "";
          if (di.containsKey("Prop")) {
            value = di["Prop"].toString();
          }
          if (di.containsKey("Text")) {
            label = di["Text"];
          }
          if (di.containsKey("Unit")) {
            unit = di["Unit"];
          }
          displays.add(Tuple3(label, value, unit));
        }
      }
    }

    final value = valueModel.currentValue as double;
    final selectedValue = ref.watch(_newValueProvider(Tuple2(id, valueModel.key)));

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                selectedValue.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              (e.unitOfMeasurement == null
                  ? Container()
                  : Text(
                      e.unitOfMeasurement!,
                      style: const TextStyle(fontSize: 24),
                    ))
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(),
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                startAngle: startAngle,
                endAngle: endAngle,
                radiusFactor: radiusFactor,
                minimum: minimum,
                maximum: maximum,
                interval: interval,
                axisLineStyle: AxisLineStyle(
                    gradient: SweepGradient(colors: gradients, stops: stops),
                    color: Colors.red,
                    thickness: 0.04,
                    thicknessUnit: GaugeSizeUnit.factor),
                tickOffset: 0.02,
                ticksPosition: ElementsPosition.outside,
                labelOffset: 0.05,
                offsetUnit: GaugeSizeUnit.factor,
                showAxisLine: false,
                showLabels: false,
                labelsPosition: ElementsPosition.outside,
                minorTicksPerInterval: 10,
                minorTickStyle: const MinorTickStyle(length: 0.1),
                majorTickStyle: const MajorTickStyle(length: 0.05, lengthUnit: GaugeSizeUnit.factor),
              ),
              RadialAxis(
                startAngle: startAngle,
                endAngle: endAngle,
                radiusFactor: radiusFactor,
                minimum: minimum,
                maximum: maximum,
                interval: interval,
                axisLineStyle: AxisLineStyle(
                    gradient: SweepGradient(colors: gradients, stops: stops),
                    color: Colors.red,
                    thickness: 0.04,
                    thicknessUnit: GaugeSizeUnit.factor),
                tickOffset: 0.02,
                ticksPosition: ElementsPosition.outside,
                labelOffset: 0.05,
                offsetUnit: GaugeSizeUnit.factor,
                onAxisTapped: (final v) => _handlePointerValueChangedEnd(v, id, valueModel.key, info, ref),
                labelsPosition: ElementsPosition.outside,
                minorTicksPerInterval: 0,
                minorTickStyle: const MinorTickStyle(length: 0.1),
                majorTickStyle: const MajorTickStyle(length: 0.05, lengthUnit: GaugeSizeUnit.factor),
                pointers: <GaugePointer>[
                  MarkerPointer(
                    value: selectedValue,
                    elevation: 1,
                    markerOffset: -20,
                    markerHeight: 25,
                    markerWidth: 20,
                    enableDragging: true,
                    onValueChanged: (final v) => _handlePointerValueChanged(v, id, valueModel.key, ref),
                    onValueChangeEnd: (final v) => _handlePointerValueChangedEnd(v, id, valueModel.key, info, ref),
                    onValueChanging: (final v) => _handlePointerValueChanging(v, id, valueModel.key, ref),
                    borderColor: Colors.black,
                    borderWidth: 1,
                    color: Colors.white,
                  ),
                  MarkerPointer(
                    value: value,
                    elevation: 10,
                    markerOffset: 5,
                    markerType: MarkerType.triangle,
                    markerHeight: 15,
                    markerWidth: 15,
                    color: Colors.red,
                  ),
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                      widget: Container(
                        margin: EdgeInsets.only(bottom: margin),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: displays.map((e) {
                            if (e.item2 == "") return Text(e.item1);
                            return Consumer(
                              builder: (context, ref, child) {
                                final valStore = ref.watch(valueStoreChangedProvider(Tuple2(e.item2, id)));
                                if (valStore == null) return Container();

                                if (e.item1 == "") return Text(valStore.getValueAsString() + e.item3);
                                return Text(e.item1 + valStore.getValueAsString() + e.item3);
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      angle: angle)
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  static void _handlePointerValueChanged(
      final double value, final int deviceId, final String key, final WidgetRef ref) {
    _setPointerValue(value, deviceId, key, ref);
  }

  static Future _handlePointerValueChangedEnd(final double value, final int deviceId, final String key,
      final PropertyEditInformation info, final WidgetRef ref) async {
    _handlePointerValueChanged(value, deviceId, key, ref);

    final msg = GenericDevice.getMessage(info, info.editParameter.first, deviceId);
    msg.parameters = [value, ...msg.parameters ?? []];
    await ref.read(hubConnectionConnectedProvider)?.invoke(info.hubMethod ?? "Update", args: <Object>[msg.toJson()]);
  }

  static void _handlePointerValueChanging(
      final ValueChangingArgs args, final int deviceId, final String key, final WidgetRef ref) {
    _setPointerValue(args.value, deviceId, key, ref);
  }

  static void _setPointerValue(final double value, final int deviceId, final String key, final WidgetRef ref) {
    final curValue = ref.read(_newValueProvider(Tuple2(deviceId, key)).state);
    curValue.state = (value.clamp(5, 35) * 10).roundToDouble() / 10;
  }
}
