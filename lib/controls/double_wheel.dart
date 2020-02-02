library wheel_chooser;

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class WheelChooser extends StatefulWidget {
  final TextStyle selectTextStyle;
  final TextStyle unSelectTextStyle;
  final Function(dynamic) onValueChanged;
  final List<dynamic> datas;
  final int startPosition;
  final double itemSize;
  final double squeeze;
  final double magnification;
  final double perspective;
  final double listHeight;
  final double listWidth;
  final List<Widget> children;
  final bool horizontal;
  final double diameter;
  static const double _defaultItemSize = 48.0;

  WheelChooser({
    @required this.onValueChanged,
    @required this.datas,
    this.selectTextStyle,
    this.unSelectTextStyle,
    this.startPosition = 0,
    this.squeeze = 1.0,
    this.itemSize = _defaultItemSize,
    this.magnification = 1,
    this.perspective = 0.01,
    this.listWidth,
    this.listHeight,
    this.horizontal = false,
    this.diameter = 10000
  })  : assert(perspective <= 0.01),
        children = null;

  WheelChooser.custom({
    @required this.onValueChanged,
    @required this.children,
    this.datas,
    this.startPosition = 0,
    this.squeeze = 1.0,
    this.itemSize = _defaultItemSize,
    this.magnification = 1,
    this.perspective = 0.01,
    this.diameter=10000,
    this.listWidth,
    this.listHeight,
    this.horizontal = false,
  })  : assert(perspective <= 0.01),
        assert(datas == null || datas.length == children.length),
        selectTextStyle = null,
        unSelectTextStyle = null;
    

  WheelChooser.integer({
    @required this.onValueChanged,
    @required int maxValue,
    @required int minValue,
    int initValue,
    int step = 1,
    this.selectTextStyle,
    this.unSelectTextStyle,
    this.squeeze = 1.0,
    this.itemSize = _defaultItemSize,
    this.magnification = 1,
    this.perspective = 0.01,
    this.diameter=10000,
    this.listWidth,
    this.listHeight,
    this.horizontal = false,
    bool reverse = false,
  })  : assert(perspective <= 0.01),
        assert(minValue < maxValue),
        assert(initValue == null || initValue >= minValue),
        assert(initValue == null || maxValue >= initValue),
        assert(step > 0),
        children = null,
        datas = _createIntegerList(minValue, maxValue, step, reverse),
        startPosition = initValue == null ? 0 : reverse ? (maxValue - initValue) ~/ step : (initValue - minValue) ~/ step;

  WheelChooser.double({
    @required this.onValueChanged,
    @required double maxValue,
    @required double minValue,
    double initValue,
    double step = 0.1,
    this.selectTextStyle,
    this.unSelectTextStyle,
    this.squeeze = 1.0,
    this.itemSize = _defaultItemSize,
    this.magnification = 1,
    this.perspective = 0.01,
    this.diameter=10000,
    this.listWidth,
    this.listHeight,
    this.horizontal = false,
    bool reverse = false,
  })  : assert(perspective <= 0.01),
        assert(minValue < maxValue),
        assert(initValue == null || initValue >= minValue),
        assert(initValue == null || maxValue >= initValue),
        assert(step > 0),
        children = null,
        datas = _createDoubleList(minValue, maxValue, step, reverse),
        startPosition = initValue == null ? 0 : reverse ? (maxValue - initValue) ~/ step : (initValue - minValue) ~/ step;

  static List<double> _createDoubleList(double minValue, double maxValue, double step, bool reverse){
    List<double> result = [];
      if (reverse) {
      for (double i = maxValue; i >= minValue; i -= step) {
        result.add( i);
      }
    } else {
      for (double i = minValue; i <= maxValue; i += step) {
        result.add(i);
      }
    }
    return result;
  }

  static List<int> _createIntegerList(int minValue, int maxValue, int step, bool reverse) {
    List<int> result = [];
    if (reverse) {
      for (int i = maxValue; i >= minValue; i -= step) {
        result.add(i);
      }
    } else {
      for (int i = minValue; i <= maxValue; i += step) {
        result.add(i);
      }
    }
    return result;
  }

  @override
  _WheelChooserState createState() {
    return _WheelChooserState();
  }
}

class _WheelChooserState extends State<WheelChooser> {
  FixedExtentScrollController fixedExtentScrollController;
  int currentPosition;
  @override
  void initState() {
    super.initState();
    currentPosition = widget.startPosition;
    fixedExtentScrollController = FixedExtentScrollController(initialItem: currentPosition);
  }

  void _listener(int position) {
    setState(() {
      currentPosition = position;
    });
    if (widget.datas == null) {
      widget.onValueChanged(currentPosition);
    } else {
      widget.onValueChanged(widget.datas[currentPosition]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
        quarterTurns: widget.horizontal ? 3 : 0,
        child: Container(
            height: widget.listHeight ?? double.infinity,
            width: widget.listWidth ?? double.infinity,
            child: ListWheelScrollView(
              onSelectedItemChanged: _listener,
              perspective: widget.perspective,
              squeeze: widget.squeeze,
              diameterRatio: widget.diameter,
              controller: fixedExtentScrollController,
              physics: FixedExtentScrollPhysics(),
              children: _convertListItems() ?? _buildListItems(),
              useMagnifier: true,
              magnification: widget.magnification,
              itemExtent: widget.itemSize,
            )));
  }

  List<Widget> _buildListItems() {
    List<Widget> result = [];
    for (int i = 0; i < widget.datas.length; i++) {
      result.add(
        RotatedBox(
          quarterTurns: widget.horizontal ? 1 : 0,
          child: Text(
            widget.datas[i] is double ? widget.datas[i].toStringAsFixed(1) : widget.datas[i].toString(),
            textAlign: TextAlign.center,
            textScaleFactor: 1.5,
            style: i == currentPosition ? widget.selectTextStyle ?? null : widget.unSelectTextStyle ?? null,
          ),
        ),
      );
    }
    return result;
  }

  List<Widget> _convertListItems() {
    if (widget.children == null) {
      return null;
    }
    if (widget.horizontal) {
      List<Widget> result = [];
      for (int i = 0; i < widget.children.length; i++) {
        result.add(RotatedBox(
          quarterTurns: 1,
          child: widget.children[i],
        ));
      }
      return result;
    } else {
      return widget.children;
    }
  }
}



class ListWheelScrollViewX extends StatelessWidget {
  final Widget Function(BuildContext, int) builder;
  final Axis scrollDirection;
  final FixedExtentScrollController controller;
  final double itemExtent;
  final double diameterRatio;
  final void Function(int) onSelectedItemChanged;
  const ListWheelScrollViewX({
    Key key,
    @required this.builder,
    @required this.itemExtent,
    this.controller,
    this.onSelectedItemChanged,
    this.scrollDirection = Axis.vertical,
    this.diameterRatio = 100000,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: scrollDirection == Axis.horizontal ? 3 : 0,
      child: ListWheelScrollView.useDelegate(
        onSelectedItemChanged: onSelectedItemChanged,
        controller: controller,
        itemExtent: itemExtent,
        diameterRatio: diameterRatio,
        physics: FixedExtentScrollPhysics(),
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            return RotatedBox(
              quarterTurns: scrollDirection == Axis.horizontal ? 1 : 0,
              child: builder(context, index),
            );
          },
        ),
      ),
    );
  }
}