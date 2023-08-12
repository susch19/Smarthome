import 'package:flutter/material.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tuple/tuple.dart';

import 'heater_config.dart';

class HeaterTempSettings extends StatefulWidget {
  final List<HeaterConfig> configs;
  final Tuple2<TimeOfDay?, double?> timeTemp;
  const HeaterTempSettings(this.timeTemp, this.configs, {final Key? key}) : super(key: key);

  @override
  HeaterTempSettingsState createState() => HeaterTempSettingsState();
}

class HeaterTempSettingsState extends State<HeaterTempSettings> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _saveNeeded = false;
  late List<HeaterConfig> heaterConfigs;
  int selected = 0;
  double _value = 21.0;
  String _annotationValue = '21.0';
  late TimeOfDay initialDate;

  @override
  void initState() {
    super.initState();
    heaterConfigs = widget.configs;
    selected = widget.configs.bitOr((final x) => dayOfWeekToFlagMap[x.dayOfWeek]!);
    _setPointerValue(widget.timeTemp.item2!);
    initialDate = widget.timeTemp.item1!;
    //"${widget.timeTemp.item1!.hour.toString().padLeft(2, "0")}:${widget.timeTemp.item1!.minute.toString().padLeft(2, "0")}";
  }

  Future<bool> _onWillPop() async {
    if (!_saveNeeded) return true;

    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle = theme.textTheme.titleMedium!.copyWith(color: theme.textTheme.bodySmall!.color);

    return await (showDialog<bool>(
            context: context,
            builder: (final BuildContext context) => AlertDialog(
                    content: Text("Neue Temperatureinstellung verwerfen?", style: dialogTextStyle),
                    actions: <Widget>[
                      TextButton(
                          child: const Text("Abbrechen"),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          }),
                      TextButton(
                          child: const Text("Verwerfen"),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          })
                    ]))) ??
        false;
  }

  void showInSnackBar(final String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  Future<bool> _handleSubmitted() async {
    final FormState form = _formKey.currentState!;
    if (!form.validate()) {
      return false;
    } else {
      form.save();
      //double realWeight = recursiveParsing(weight);
      if (_saveNeeded == false) {
        Navigator.of(context).pop(const Tuple2(false, <HeaterConfig>[]));
        return true;
      }
      final configs = <HeaterConfig>[];
      final tod = initialDate;
      for (int i = 0; i < 7; i++) {
        final flag = 1 << (i + 1);

        if (selected & flag == 0) continue;
        final dayOfWeek = flagToDayOfWeekMap[flag]!;

        configs.add(HeaterConfig(dayOfWeek, tod, _value));
      }
      Navigator.of(context).pop(Tuple2(true, configs));
    }
    return true;
  }

  void handlePointerValueChanged(final double value) {
    _setPointerValue(value);
    _saveNeeded = true;
  }

  void handlePointerValueChangedEnd(final double value) {
    handlePointerValueChanged(value);
    _saveNeeded = true;
  }

  void handlePointerValueChanging(final ValueChangingArgs args) {
    _value = _value.clamp(5, 35);
    _setPointerValue(_value);
    _saveNeeded = true;
  }

  /// method to set the pointer value
  void _setPointerValue(final double value) {
    setState(() {
      _value = (value.clamp(5, 35) * 10).roundToDouble() / 10;
      _annotationValue = _value.toStringAsFixed(1);
    });
  }

  Future displayTimePicker(
      final BuildContext context, final TimeOfDay initalTime, final Function(TimeOfDay time) selectedValue) async {
    final time = await showTimePicker(context: context, initialTime: initalTime);

    if (time != null) {
      selectedValue(time);
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Temperatur Einstellungen"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () => _handleSubmitted(),
      ),
      body: Container(
        decoration: ThemeManager.getBackgroundDecoration(context),
        child: Form(
          key: _formKey,
          onWillPop: _onWillPop,
          // autovalidate: _autovalidate,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: //heaterConfigs!.map((x) => heaterConfigToWidget(x)).toList()
                <Widget>[
              Wrap(
                children: weekdayChips(),
              ),
              Container(
                margin: const EdgeInsets.only(top: 32.0),
                child: ElevatedButton(
                    onPressed: () => displayTimePicker(context, initialDate, ((final time) => initialDate = time)),
                    child: Text("$initialDate")),
              ),
              // DateTimePicker(
              //   initialValue: initialDate,
              //   type: DateTimePickerType.time,
              //   textAlign: TextAlign.center,
              //   onChanged: (final val) {
              //     initialDate = val;
              //     _saveNeeded = true;
              //   },
              //   style: const TextStyle(fontSize: 24),
              // ),
              Container(
                margin: const EdgeInsets.only(top: 16.0),
                child: Stack(
                  children: [
                    SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          startAngle: 150,
                          endAngle: 30,
                          radiusFactor: 0.9,
                          minimum: 5,
                          maximum: 35,
                          interval: 1,
                          axisLineStyle: const AxisLineStyle(
                              gradient:
                                  SweepGradient(colors: [Colors.blue, Colors.amber, Colors.red], stops: [0.3, 0.5, 1]),
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
                          startAngle: 150,
                          endAngle: 30,
                          radiusFactor: 1,
                          minimum: 5,
                          maximum: 35,
                          interval: 5,
                          axisLineStyle: const AxisLineStyle(
                              gradient:
                                  SweepGradient(colors: [Colors.blue, Colors.amber, Colors.red], stops: [0.3, 0.5, 1]),
                              color: Colors.red,
                              thickness: 0.04,
                              thicknessUnit: GaugeSizeUnit.factor),
                          tickOffset: 0.02,
                          ticksPosition: ElementsPosition.outside,
                          labelOffset: 0.05,
                          offsetUnit: GaugeSizeUnit.factor,
                          onAxisTapped: handlePointerValueChangedEnd,
                          labelsPosition: ElementsPosition.outside,
                          minorTicksPerInterval: 0,
                          minorTickStyle: const MinorTickStyle(length: 0.1),
                          majorTickStyle: const MajorTickStyle(length: 0.05, lengthUnit: GaugeSizeUnit.factor),
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
                            MarkerPointer(
                              value: _value,
                              elevation: 1,
                              markerOffset: -20,
                              markerHeight: 25,
                              markerWidth: 20,
                              enableDragging: true,
                              onValueChanged: handlePointerValueChanged,
                              onValueChangeEnd: handlePointerValueChangedEnd,
                              onValueChanging: handlePointerValueChanging,
                              borderColor: Colors.black,
                              borderWidth: 1,
                              color: Colors.white,
                            )
                          ],
                          annotations: [
                            GaugeAnnotation(
                              widget: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                                Text(
                                  _annotationValue,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 56),
                                ),
                                const Text(
                                  ' °C',
                                  style: TextStyle(fontSize: 56),
                                ),
                              ]),
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
                            onPressed: () => handlePointerValueChanged(_value - 0.1),
                            child: const Text(
                              "−",
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () => handlePointerValueChanged(_value + 0.1),
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

  List<Widget> weekdayChips() {
    return dayOfWeekToStringMap.values
        .map(
          (final value) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
            child: FilterChip(
              onSelected: (final a) {
                if (a) {
                  selected |= dayOfWeekStringToFlagMap[value] ?? 0;
                } else {
                  selected &= ~(dayOfWeekStringToFlagMap[value] ?? 0);
                }
                _saveNeeded = true;
                setState(() {});
              },
              selected: selected & (dayOfWeekStringToFlagMap[value] ?? 0) > 0,
              showCheckmark: false,
              labelStyle: TextStyle(
                color: (selected & (dayOfWeekStringToFlagMap[value] ?? 0) < 1
                    ? Theme.of(context).textTheme.bodyLarge!.color
                    : (Theme.of(context).colorScheme.secondary.computeLuminance() > 0.5 ? Colors.black : Colors.white)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
              selectedColor: Theme.of(context).colorScheme.secondary,
              label: Text(value),
            ),
          ),
        )
        .cast<Widget>()
        .toList(growable: false);
  }

  final List<String> weekdayListText = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"];
  final List<DropdownMenuItem> itemsForDropdown = buildItems();

  static List<DropdownMenuItem> buildItems() {
    final menuItems = <DropdownMenuItem>[];
    for (double d = 5.0; d <= 35.0; d += 0.1) {
      menuItems.add(DropdownMenuItem(value: (d * 10).round(), child: Text(d.toStringAsFixed(1))));
    }
    return menuItems;
  }
}
