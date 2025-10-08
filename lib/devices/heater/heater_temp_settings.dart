import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'heater_config.dart';

class HeaterTempSettings extends HookWidget {
  final List<HeaterConfig> configs;
  final (TimeOfDay?, double?) timeTemp;
  HeaterTempSettings(this.timeTemp, this.configs, {super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // bool _saveNeeded = false;
  // late List<HeaterConfig> heaterConfigs;
  // int selected = 0;
  // double _value = 21.0;
  // String _annotationValue = '21.0';
  // late TimeOfDay selectedDate;

  Future<bool> _onWillPop(
    final BuildContext context,
    final ValueNotifier<bool> saveNeeded,
  ) async {
    if (!saveNeeded.value) return true;

    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle = theme.textTheme.titleMedium!.copyWith(
      color: theme.textTheme.bodySmall!.color,
    );

    return await (showDialog<bool>(
          context: context,
          builder: (final BuildContext context) => AlertDialog(
            content: Text(
              "Neue Temperatureinstellung verwerfen?",
              style: dialogTextStyle,
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Abbrechen"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: const Text("Verwerfen"),
                onPressed: () {
                  saveNeeded.value = false;
                  WidgetsBinding.instance.addPostFrameCallback((final _) {
                    Navigator.of(context).pop(true);
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          ),
        )) ??
        false;
  }

  void showInSnackBar(final BuildContext context, final String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  Future<bool> _handleSubmitted(
    final BuildContext context,
    final bool saveNeeded,
    final TimeOfDay selectedDate,
    final int selected,
    final double value,
  ) async {
    final FormState form = _formKey.currentState!;
    if (!form.validate()) {
      return false;
    } else {
      form.save();
      //double realWeight = recursiveParsing(weight);
      if (saveNeeded == false) {
        Navigator.of(context).pop(const (false, <HeaterConfig>[]));
        return true;
      }
      final configs = <HeaterConfig>[];
      final tod = selectedDate;
      for (int i = 0; i < 7; i++) {
        final flag = 1 << (i + 1);

        if (selected & flag == 0) continue;
        final dayOfWeek = flagToDayOfWeekMap[flag]!;

        configs.add(HeaterConfig(dayOfWeek, tod, value));
      }
      Navigator.of(context).pop((true, configs));
    }
    return true;
  }

  void handlePointerValueChangedEnd(
    final double value,
    final ValueNotifier<double> valueNot,
    final ValueNotifier<String> annotationValue,
    final ValueNotifier<bool> saveNeeded,
  ) {
    _setPointerValue(value, valueNot, annotationValue);
    saveNeeded.value = true;
  }

  void handlePointerValueChanging(
    final ValueChangingArgs args,
    final ValueNotifier<double> value,
    final ValueNotifier<String> annotationValue,
    final ValueNotifier<bool> saveNeeded,
  ) {
    value.value = value.value.clamp(5, 35);
    _setPointerValue(value.value, value, annotationValue);
    saveNeeded.value = true;
  }

  /// method to set the pointer value
  void _setPointerValue(
    final double value,
    final ValueNotifier<double> valueNot,
    final ValueNotifier<String> annotationValue,
  ) {
    valueNot.value = (value.clamp(5, 35) * 10).roundToDouble() / 10;
    annotationValue.value = valueNot.value.toStringAsFixed(1);
  }

  Future displayTimePicker(
    final BuildContext context,
    final TimeOfDay initalTime,
    final Function(TimeOfDay time) selectedValue,
  ) async {
    final time = await showTimePicker(
      context: context,
      initialTime: initalTime,
    );

    if (time != null) {
      selectedValue(time);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final selected = useState(
      configs.bitOr((final x) => dayOfWeekToFlagMap[x.dayOfWeek]!),
    );
    final saveNeeded = useState(false);
    final value = useState(0.0);
    final annotationValue = useState("");
    final selectedDate = useState(timeTemp.$1!);
    useEffect(() {
      _setPointerValue(timeTemp.$2!, value, annotationValue);
      return null;
    }, [timeTemp.$2]);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: const Text("Temperatur Einstellungen")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () => _handleSubmitted(
          context,
          saveNeeded.value,
          selectedDate.value,
          selected.value,
          value.value,
        ),
      ),
      body: Container(
        decoration: ThemeManager.getBackgroundDecoration(context),
        child: Form(
          key: _formKey,
          canPop: !saveNeeded.value,
          onPopInvokedWithResult: (final didPop, final result) async {
            if (!didPop) await _onWillPop(context, saveNeeded);
          },
          // autovalidate: _autovalidate,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: //heaterConfigs!.map((x) => heaterConfigToWidget(x)).toList()
            <Widget>[
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      selected.value = selected.value == 0x7F ? 0 : 0x7F;
                      saveNeeded.value = true;
                    },
                    child: Text("Alle Tage"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      selected.value = (selected.value & 0x1f) == 0x1F
                          ? selected.value & 0x60
                          : selected.value | 0x1F;
                      saveNeeded.value = true;
                    },
                    child: Text("Wochentage"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      selected.value = (selected.value & 0x60) == 0x60
                          ? selected.value & 0x1F
                          : selected.value | 0x60;
                      saveNeeded.value = true;
                    },
                    child: Text("Wochenende"),
                  ),
                ],
              ),
              Wrap(children: weekdayChips(context, selected, saveNeeded)),
              Container(
                margin: const EdgeInsets.only(top: 32.0),
                child: ElevatedButton(
                  onPressed: () => displayTimePicker(
                    context,
                    selectedDate.value,
                    ((final time) {
                      selectedDate.value = time;
                      saveNeeded.value = true;
                    }),
                  ),
                  child: Text(
                    "Uhrzeit einstellen: ${selectedDate.value.format(context)}",
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 16.0),
                child: Stack(
                  children: [
                    SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          startAngle: 150,
                          endAngle: 30,
                          radiusFactor: 1,
                          minimum: 5,
                          maximum: 35,
                          interval: 5,
                          axisLineStyle: const AxisLineStyle(
                            gradient: SweepGradient(
                              colors: [Colors.blue, Colors.amber, Colors.red],
                              stops: [0.3, 0.5, 1],
                            ),
                            color: Colors.red,
                            thickness: 0.04,
                            thicknessUnit: GaugeSizeUnit.factor,
                          ),
                          tickOffset: 0.02,
                          ticksPosition: ElementsPosition.outside,
                          labelOffset: 0.05,
                          offsetUnit: GaugeSizeUnit.factor,
                          onAxisTapped: (final v) =>
                              handlePointerValueChangedEnd(
                                v,
                                value,
                                annotationValue,
                                saveNeeded,
                              ),
                          labelsPosition: ElementsPosition.outside,
                          minorTicksPerInterval: 5,
                          minorTickStyle: const MinorTickStyle(length: 1),
                          majorTickStyle: const MajorTickStyle(length: 5),
                          pointers: <GaugePointer>[
                            // RangePointer(
                            //     color: Colors.transparent,
                            //     value: _markerValue,
                            //     gradient: SweepGradient(
                            //       colors: [Colors.blue.shade700, Colors.blue.shade100],
                            //       stops: <double>[0.5, 1],
                            //     ),
                            //     cornerStyle: CornerStyle.endCurve,
                            //     width: 0.055,
                            //     sizeUnit: GaugeSizeUnit.factor),

                            // MarkerPointer(
                            //   value: _value,
                            //   overlayColor:
                            //       const Color.fromRGBO(202, 94, 230, 0.125),
                            //   onValueChanged: handlePointerValueChanged,
                            //   onValueChangeEnd: handlePointerValueChanged,
                            //   onValueChanging: handlePointerValueChanging,
                            //   enableDragging: true,
                            //   elevation: 5,
                            //   color: Colors.white,
                            //   borderWidth: 3,
                            //   borderColor: Colors.black,
                            //   markerHeight: 25,
                            //   markerWidth: 25,
                            //   markerType: MarkerType.circle,
                            // ),
                            MarkerPointer(
                              value: value.value,
                              elevation: 1,
                              markerOffset: -20,
                              markerHeight: 25,
                              markerWidth: 20,
                              enableDragging: true,
                              onValueChanged: (final v) =>
                                  handlePointerValueChangedEnd(
                                    v,
                                    value,
                                    annotationValue,
                                    saveNeeded,
                                  ),
                              onValueChangeEnd: (final v) =>
                                  handlePointerValueChangedEnd(
                                    v,
                                    value,
                                    annotationValue,
                                    saveNeeded,
                                  ),
                              onValueChanging: (final v) =>
                                  handlePointerValueChanging(
                                    v,
                                    value,
                                    annotationValue,
                                    saveNeeded,
                                  ),
                              borderColor: Colors.black,
                              borderWidth: 1,
                              color: Colors.white,
                            ),
                          ],
                          annotations: [
                            GaugeAnnotation(
                              widget: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    annotationValue.value,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 56,
                                    ),
                                  ),
                                  const Text(
                                    ' °C',
                                    style: TextStyle(fontSize: 56),
                                  ),
                                ],
                              ),
                              verticalAlignment: GaugeAlignment.far,
                              angle: 90,
                              positionFactor: 0.1,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 200),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          MaterialButton(
                            onPressed: () => handlePointerValueChangedEnd(
                              value.value - 0.1,
                              value,
                              annotationValue,
                              saveNeeded,
                            ),
                            child: const Text(
                              "−",
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () => handlePointerValueChangedEnd(
                              value.value + 0.1,
                              value,
                              annotationValue,
                              saveNeeded,
                            ),
                            child: const Text(
                              "+",
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> weekdayChips(
    final BuildContext context,
    final ValueNotifier<int> selected,
    final ValueNotifier<bool> saveNeeded,
  ) {
    return dayOfWeekToStringMap.values
        .map(
          (final value) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
            child: FilterChip(
              onSelected: (final a) {
                if (a) {
                  selected.value |= dayOfWeekStringToFlagMap[value] ?? 0;
                } else {
                  selected.value &= ~(dayOfWeekStringToFlagMap[value] ?? 0);
                }
                saveNeeded.value = true;
              },
              selected:
                  selected.value & (dayOfWeekStringToFlagMap[value] ?? 0) > 0,
              showCheckmark: true,
              labelStyle: TextStyle(
                color:
                    (selected.value & (dayOfWeekStringToFlagMap[value] ?? 0) < 1
                    ? Theme.of(context).textTheme.bodyLarge!.color
                    : (Theme.of(
                                context,
                              ).colorScheme.secondary.computeLuminance() >
                              0.5
                          ? Colors.black
                          : Colors.white)),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 4.0,
              ),
              selectedColor: Theme.of(context).colorScheme.secondary,
              label: Text(value),
            ),
          ),
        )
        .cast<Widget>()
        .toList(growable: false);
  }

  final List<String> weekdayListText = [
    "Mo",
    "Di",
    "Mi",
    "Do",
    "Fr",
    "Sa",
    "So",
  ];
  final List<DropdownMenuItem> itemsForDropdown = buildItems();

  static List<DropdownMenuItem> buildItems() {
    final menuItems = <DropdownMenuItem>[];
    for (double d = 5.0; d <= 35.0; d += 0.1) {
      menuItems.add(
        DropdownMenuItem(
          value: (d * 10).round(),
          child: Text(d.toStringAsFixed(1)),
        ),
      );
    }
    return menuItems;
  }
}
