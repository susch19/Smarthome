// ignore_for_file: prefer_final_parameters

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/generic/stores/store_service.dart';
import 'package:smarthome/devices/generic/stores/value_store.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/restapi/swagger.swagger.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class _Displays {
  final String label;
  final String value;
  final String unit;

  _Displays({required this.label, required this.value, required this.unit});
}

class GaugeEdit extends HookConsumerWidget {
  final int id;
  final ValueStore? valueModel;
  final LayoutBasePropertyInfo info;

  const GaugeEdit({
    super.key,
    required this.id,
    required this.valueModel,
    required this.info,
  });

  static Future _handlePointerValueChangedEnd(
      final double value,
      final int deviceId,
      final PropertyEditInformation info,
      final WidgetRef ref,
      final ValueStore<dynamic> store) async {
    _handlePointerValueChanged(value, store);
    // final msg =
    //     GenericDevice.getMessage(info, info.editParameter.first, deviceId);
    // msg.parameters = [value, ...msg.parameters ?? []];
    // await ref
    //     .read(hubConnectionConnectedProvider)
    //     ?.invoke(info.hubMethod ?? "Update", args: <Object>[msg.toJson()]);

    Device.postMessage(deviceId, info, ref.read(apiProvider), value);
  }

  static void _handlePointerValueChanged(
      final double value, final ValueStore<dynamic> store) {
    _setPointerValue(value, store);
  }

  static void _handlePointerValueChanging(
      final ValueChangingArgs args, final ValueStore<dynamic> store) {
    _setPointerValue(args.value, store);
  }

  static void _setPointerValue(
      final double value, final ValueStore<dynamic> store) {
    store.value = (value.clamp(5, 35) * 10).roundToDouble() / 10;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editInfo = info.editInfo;
    final valueModel = this.valueModel;
    if (valueModel == null ||
        valueModel.currentValue is! num ||
        editInfo == null) {
      return const SizedBox();
    }
    useListenable(valueModel);
    final raw = editInfo.extensionData ?? {};

    final startAngle = (raw.containsKey("StartAngle")
            ? double.tryParse(raw["StartAngle"].toString())
            : null) ??
        150.0;
    final endAngle = (raw.containsKey("EndAngle")
            ? double.tryParse(raw["EndAngle"].toString())
            : null) ??
        30.0;
    final radiusFactor = (raw.containsKey("RadiusFactor")
            ? double.tryParse(raw["RadiusFactor"].toString())
            : null) ??
        0.9;
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
    final angle = (raw.containsKey("Angle")
            ? double.tryParse(raw["Angle"].toString())
            : null) ??
        180.0;
    final margin = (raw.containsKey("Margin")
            ? double.tryParse(raw["Margin"].toString())
            : null) ??
        0;
    final minorTickInterval = (raw.containsKey("MinorTickInterval")
            ? double.tryParse(raw["MinorTickInterval"].toString())
            : null) ??
        0;
    final tickOffset = (raw.containsKey("TickOffset")
            ? double.tryParse(raw["TickOffset"].toString())
            : null) ??
        0.1;
    final thickness = (raw.containsKey("Thickness")
            ? double.tryParse(raw["Thickness"].toString())
            : null) ??
        0.1;
    final centerX = (raw.containsKey("CenterX")
            ? double.tryParse(raw["CenterX"].toString())
            : null) ??
        0.5;
    final centerY = (raw.containsKey("CenterY")
            ? double.tryParse(raw["CenterY"].toString())
            : null) ??
        0.5;
    final labelOffset = (raw.containsKey("LabelOffset")
            ? double.tryParse(raw["LabelOffset"].toString())
            : null) ??
        0.5;
    final curValueProp = (raw.containsKey("CurrentValueProp")
        ? raw["CurrentValueProp"].toString()
        : null);
    final showValueAbove = (raw.containsKey("ShowValueAbove")
        ? raw["ShowValueAbove"] as bool
        : false);
    final heightFactor = (raw.containsKey("HeightFactor")
            ? double.tryParse(raw["HeightFactor"].toString())
            : null) ??
        1.0;

    final val = useMemoized(() {
      return ref.read(valueStoreChangedProvider(
            curValueProp ?? "",
            id,
          )) ??
          ValueStore(0, 21.0, "", Command2.none);
    }, [curValueProp]);
    useListenable(val);

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

    final List<_Displays> displays = [];
    if (raw.containsKey("Displays")) {
      final displayInfos = raw["Displays"] as List<dynamic>;
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
          displays.add(_Displays(label: label, value: value, unit: unit));
        }
      }
    }

    final value = (valueModel.currentValue as num).toDouble();
    final selectedValue = val.currentValue;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showValueAbove)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                selectedValue.toStringAsFixed(1),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              (info.unitOfMeasurement == ""
                  ? const SizedBox()
                  : Text(
                      info.unitOfMeasurement,
                      style: const TextStyle(fontSize: 24),
                    ))
            ],
          ),
        ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: heightFactor,
            child: SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  startAngle: startAngle,
                  endAngle: endAngle,
                  radiusFactor: radiusFactor,
                  minimum: minimum,
                  maximum: maximum,
                  interval: interval,
                  centerX: centerX,
                  centerY: centerY,
                  axisLineStyle: AxisLineStyle(
                    gradient: SweepGradient(colors: gradients, stops: stops),
                    color: Colors.red,
                    thickness: thickness,
                    thicknessUnit: GaugeSizeUnit.factor,
                  ),
                  tickOffset: tickOffset,
                  ticksPosition: ElementsPosition.outside,
                  labelOffset: labelOffset,
                  labelFormat: '{value}${info.unitOfMeasurement}',
                  offsetUnit: GaugeSizeUnit.factor,
                  onAxisTapped: (final v) =>
                      _handlePointerValueChangedEnd(v, id, editInfo, ref, val),
                  labelsPosition: ElementsPosition.outside,
                  minorTicksPerInterval: minorTickInterval,
                  minorTickStyle: const MinorTickStyle(length: 0.1),
                  majorTickStyle: const MajorTickStyle(length: 6),
                  pointers: <GaugePointer>[
                    MarkerPointer(
                      value: (selectedValue as num).toDouble(),
                      elevation: 1,
                      markerOffset: -20,
                      markerHeight: 25,
                      markerWidth: 20,
                      enableDragging: true,
                      onValueChanged: (final v) =>
                          _handlePointerValueChanged(v, val),
                      onValueChangeEnd: (final v) =>
                          _handlePointerValueChangedEnd(
                              v, id, editInfo, ref, val),
                      onValueChanging: (final v) =>
                          _handlePointerValueChanging(v, val),
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
                  // annotations: <GaugeAnnotation>[
                  //   GaugeAnnotation(
                  //     widget: Container(
                  //       margin: EdgeInsets.only(bottom: margin),
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: displays.map((e) {
                  //           return Text("Test");
                  //           if (e.value == "") return Text(e.label);
                  //           return HookConsumer(
                  //             builder: (context, ref, child) {
                  //               final valStore = ref.watch(
                  //                   valueStoreChangedProvider(e.value, id));
                  //               if (valStore == null) return const SizedBox();
                  //               useListenable(valStore);
                  //               if (e.label == "") {
                  //                 return Text(
                  //                     valStore.getValueAsString() + e.unit);
                  //               }
                  //               return Text(e.label +
                  //                   valStore.getValueAsString() +
                  //                   e.unit);
                  //             },
                  //           );
                  //         }).toList(),
                  //       ),
                  //     ),
                  //     angle: angle,
                  //   ),
                  // ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
