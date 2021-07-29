import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/devices/heater/temp_scheduling.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'heater_config.dart';

class HeaterTempSettings extends StatefulWidget {
  final List<HeaterConfig> configs;
  final Tuple<TimeOfDay?, double?> timeTemp;
  HeaterTempSettings(this.timeTemp, this.configs);

  @override
  HeaterTempSettingsState createState() => new HeaterTempSettingsState(configs);
}

class HeaterTempSettingsState extends State<HeaterTempSettings> {
  HeaterTempSettingsState(this.heaterConfigs);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  bool _saveNeeded = false;
  List<HeaterConfig> heaterConfigs;
  int selected = 0;
  double _value = 21.0;
  String _annotationValue = '21.0';
  late String initialDate;

  @override
  void initState() {
    super.initState();

    selected = widget.configs.bitOr((x) => DayOfWeekToFlagMap[x.dayOfWeek]!);
    _setPointerValue(widget.timeTemp.item2!);
    initialDate =
        "${widget.timeTemp.item1!.hour.toString().padLeft(2, "0")}:${widget.timeTemp.item1!.minute.toString().padLeft(2, "0")}";
  }

  Future<bool> _onWillPop() async {
    if (!_saveNeeded) return true;

    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle = theme.textTheme.subtitle1!.copyWith(color: theme.textTheme.caption!.color);

    return await (showDialog<bool>(
            context: context,
            builder: (BuildContext context) => new AlertDialog(
                    content: Text("Neue Temperatureinstellung verwerfen?", style: dialogTextStyle),
                    actions: <Widget>[
                      TextButton(
                          child: Text("Nein"),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          }),
                      TextButton(
                          child: Text("Ja"),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          })
                    ]))) ??
        false;
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: new Text(value)));
  }

  Future<bool> _handleSubmitted() async {
    final FormState form = _formKey.currentState!;
    if (!form.validate()) {
      return false;
    } else {
      form.save();
      //double realWeight = recursiveParsing(weight);
      if (_saveNeeded == false) {
        Navigator.of(context).pop(Tuple(false, <HeaterConfig>[]));
        return true;
      }
      var configs = <HeaterConfig>[];
      var time = initialDate.split(":");

      int hour = int.parse(time[0]);
      int minute = int.parse(time[1]);
      var tod = TimeOfDay(hour: hour, minute: minute);
      for (int i = 0; i < 7; i++) {
        var flag = 1 << (i + 1);

        if (selected & flag == 0) continue;
        var dayOfWeek = FlagToDayOfWeekMap[flag]!;

        configs.add(HeaterConfig(dayOfWeek, tod, _value));
      }
      Navigator.of(context).pop(Tuple(true, configs));
    }
    return true;
  }

  void handlePointerValueChanged(double value) {
    _setPointerValue(value);
    _saveNeeded = true;
  }

  void handlePointerValueChangedEnd(double value) {
    handlePointerValueChanged(value);
    _saveNeeded = true;
  }

  void handlePointerValueChanging(ValueChangingArgs args) {
    _value = _value.clamp(5, 35);
    _setPointerValue(_value);
    _saveNeeded = true;
  }

  /// method to set the pointer value
  void _setPointerValue(double value) {
    setState(() {
      _value = (value.clamp(5, 35) * 10).roundToDouble() / 10;
      _annotationValue = '${_value.toStringAsFixed(1)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text("Temperatur Einstellungen"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () => _handleSubmitted(),
      ),
      body: new Form(
        key: _formKey,
        onWillPop: _onWillPop,
        // autovalidate: _autovalidate,
        child: new ListView(
          padding: const EdgeInsets.all(16.0),
          children: //heaterConfigs!.map((x) => heaterConfigToWidget(x)).toList()
              <Widget>[
            Wrap(
              children: weekdayChips(),
            ),
            DateTimePicker(
              initialValue: initialDate,
              type: DateTimePickerType.time,
              textAlign: TextAlign.center,
              onChanged: (val) {
                initialDate = val;
                _saveNeeded = true;
              },
              style: TextStyle(fontSize: 24),
            ),
            Container(
              margin: EdgeInsets.only(top: 16.0),
              child: Stack(
                children: [
                  SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        showFirstLabel: true,
                        startAngle: 150,
                        endAngle: 30,
                        radiusFactor: 0.9,
                        minimum: 5,
                        maximum: 35,
                        interval: 1,
                        canScaleToFit: false,
                        axisLineStyle: const AxisLineStyle(
                            gradient:
                                SweepGradient(colors: [Colors.blue, Colors.amber, Colors.red], stops: [0.3, 0.5, 1]),
                            color: Colors.red,
                            thickness: 0.04,
                            thicknessUnit: GaugeSizeUnit.factor,
                            cornerStyle: CornerStyle.bothFlat),
                        tickOffset: 0.02,
                        showTicks: true,
                        ticksPosition: ElementsPosition.outside,
                        labelOffset: 0.05,
                        offsetUnit: GaugeSizeUnit.factor,
                        showAxisLine: false,
                        showLabels: false,
                        labelsPosition: ElementsPosition.outside,
                        minorTicksPerInterval: 10,
                        minorTickStyle: const MinorTickStyle(length: 0.1, lengthUnit: GaugeSizeUnit.logicalPixel),
                        majorTickStyle: const MajorTickStyle(length: 0.05, lengthUnit: GaugeSizeUnit.factor),
                      ),
                      RadialAxis(
                        showFirstLabel: true,
                        startAngle: 150,
                        endAngle: 30,
                        radiusFactor: 1,
                        minimum: 5,
                        maximum: 35,
                        interval: 5,
                        canScaleToFit: false,
                        axisLineStyle: const AxisLineStyle(
                            gradient:
                                SweepGradient(colors: [Colors.blue, Colors.amber, Colors.red], stops: [0.3, 0.5, 1]),
                            color: Colors.red,
                            thickness: 0.04,
                            thicknessUnit: GaugeSizeUnit.factor,
                            cornerStyle: CornerStyle.bothFlat),
                        tickOffset: 0.02,
                        showTicks: true,
                        ticksPosition: ElementsPosition.outside,
                        labelOffset: 0.05,
                        offsetUnit: GaugeSizeUnit.factor,
                        onAxisTapped: handlePointerValueChangedEnd,
                        showAxisLine: true,
                        labelsPosition: ElementsPosition.outside,
                        minorTicksPerInterval: 0,
                        minorTickStyle: const MinorTickStyle(length: 0.1, lengthUnit: GaugeSizeUnit.logicalPixel),
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
                            markerType: MarkerType.invertedTriangle,
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
                            widget: Container(
                              child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                                Text(
                                  _annotationValue,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 56),
                                ),
                                Text(
                                  ' °C',
                                  style: TextStyle(fontSize: 56),
                                ),
                              ]),
                            ),
                            verticalAlignment: GaugeAlignment.far,
                            horizontalAlignment: GaugeAlignment.center,
                            angle: 90,
                            positionFactor: 0.1,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 200),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        MaterialButton(
                          onPressed: () => handlePointerValueChanged(_value - 0.1),
                          child: Text(
                            "−",
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () => handlePointerValueChanged(_value + 0.1),
                          child: Text(
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
    );
  }

  List<Widget> weekdayChips() {
    return DayOfWeekToStringMap.values
        .map(
          (value) => Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
            child: FilterChip(
              onSelected: (a) {
                if (a)
                  selected |= DayOfWeekStringToFlagMap[value] ?? 0;
                else
                  selected &= ~(DayOfWeekStringToFlagMap[value] ?? 0);
                _saveNeeded = true;
                setState(() {});
              },
              selected: selected & (DayOfWeekStringToFlagMap[value] ?? 0) > 0,
              showCheckmark: false,
              labelStyle: TextStyle(
                color: (selected & (DayOfWeekStringToFlagMap[value] ?? 0) < 1
                    ? Theme.of(context).textTheme.bodyText1!.color
                    : (Theme.of(context).colorScheme.secondary.computeLuminance() > 0.5 ? Colors.black : Colors.white)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
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
    var menuItems = <DropdownMenuItem>[];
    for (double d = 5.0; d <= 35.0; d += 0.1) {
      menuItems.add(DropdownMenuItem(child: Text(d.toStringAsFixed(1)), value: (d * 10).round()));
    }
    return menuItems;
  }
}
