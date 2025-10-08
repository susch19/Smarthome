library;

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class WheelChooser extends StatefulWidget {
  final TextStyle? selectTextStyle;
  final TextStyle? unSelectTextStyle;
  final Function(dynamic) onValueChanged;
  final List<dynamic>? datas;
  final int startPosition;
  final double itemSize;
  final double squeeze;
  final double magnification;
  final double perspective;
  final double? listHeight;
  final double? listWidth;
  final List<Widget>? children;
  final bool horizontal;
  final double diameter;
  static const double _defaultItemSize = 48.0;

  const WheelChooser(
      {required this.onValueChanged,
      required this.datas,
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
      this.diameter = 10000,
      super.key})
      : assert(perspective <= 0.01),
        children = null;

  WheelChooser.custom(
      {required this.onValueChanged,
      required this.children,
      this.datas,
      this.startPosition = 0,
      this.squeeze = 1.0,
      this.itemSize = _defaultItemSize,
      this.magnification = 1,
      this.perspective = 0.01,
      this.diameter = 10000,
      this.listWidth,
      this.listHeight,
      this.horizontal = false,
      super.key})
      : assert(perspective <= 0.01),
        assert(datas == null || datas.length == children!.length),
        selectTextStyle = null,
        unSelectTextStyle = null;

  WheelChooser.integer(
      {required this.onValueChanged,
      required final int maxValue,
      required final int minValue,
      final int? initValue,
      final int step = 1,
      this.selectTextStyle,
      this.unSelectTextStyle,
      this.squeeze = 1.0,
      this.itemSize = _defaultItemSize,
      this.magnification = 1,
      this.perspective = 0.01,
      this.diameter = 10000,
      this.listWidth,
      this.listHeight,
      this.horizontal = false,
      final bool reverse = false,
      super.key})
      : assert(perspective <= 0.01),
        assert(minValue < maxValue),
        assert(initValue == null || initValue >= minValue),
        assert(initValue == null || maxValue >= initValue),
        assert(step > 0),
        children = null,
        datas = _createIntegerList(minValue, maxValue, step, reverse),
        startPosition = initValue == null
            ? 0
            : reverse
                ? (maxValue - initValue) ~/ step
                : (initValue - minValue) ~/ step;

  WheelChooser.double(
      {required this.onValueChanged,
      required final double maxValue,
      required final double minValue,
      final double? initValue,
      final double step = 0.1,
      this.selectTextStyle,
      this.unSelectTextStyle,
      this.squeeze = 1.0,
      this.itemSize = _defaultItemSize,
      this.magnification = 1,
      this.perspective = 0.01,
      this.diameter = 10000,
      this.listWidth,
      this.listHeight,
      this.horizontal = false,
      final bool reverse = false,
      super.key})
      : assert(perspective <= 0.01),
        assert(minValue < maxValue),
        assert(initValue == null || initValue >= minValue),
        assert(initValue == null || maxValue >= initValue),
        assert(step > 0),
        children = null,
        datas = _createDoubleList(minValue, maxValue, step, reverse),
        startPosition = initValue == null
            ? 0
            : reverse
                ? (maxValue - initValue) ~/ step
                : (initValue - minValue) ~/ step;

  static List<double> _createDoubleList(
    final double minValue,
    final double maxValue,
    final double step,
    final bool reverse,
  ) {
    final List<double> result = [];
    if (reverse) {
      for (double i = maxValue; i >= minValue; i -= step) {
        result.add(i);
      }
    } else {
      for (double i = minValue; i <= maxValue; i += step) {
        result.add(i);
      }
    }
    return result;
  }

  static List<int> _createIntegerList(
    final int minValue,
    final int maxValue,
    final int step,
    final bool reverse,
  ) {
    final List<int> result = [];
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
  WheelChooserState createState() {
    return WheelChooserState();
  }
}

class WheelChooserState extends State<WheelChooser> {
  FixedExtentScrollController? fixedExtentScrollController;
  int? currentPosition;
  @override
  void initState() {
    super.initState();
    currentPosition = widget.startPosition;
    fixedExtentScrollController =
        FixedExtentScrollController(initialItem: currentPosition!);
  }

  void _listener(final int position) {
    setState(() {
      currentPosition = position;
    });
    if (widget.datas == null) {
      widget.onValueChanged(currentPosition);
    } else {
      widget.onValueChanged(widget.datas![currentPosition!]);
    }
  }

  @override
  Widget build(final BuildContext context) {
    return RotatedBox(
        quarterTurns: widget.horizontal ? 3 : 0,
        child: SizedBox(
            height: widget.listHeight ?? double.infinity,
            width: widget.listWidth ?? double.infinity,
            child: ListWheelScrollView(
              onSelectedItemChanged: _listener,
              perspective: widget.perspective,
              squeeze: widget.squeeze,
              diameterRatio: widget.diameter,
              controller: fixedExtentScrollController,
              physics: const FixedExtentScrollPhysics(),
              useMagnifier: true,
              magnification: widget.magnification,
              itemExtent: widget.itemSize,
              children: _convertListItems() ?? _buildListItems(),
            )));
  }

  List<Widget> _buildListItems() {
    final List<Widget> result = [];
    for (int i = 0; i < widget.datas!.length; i++) {
      result.add(
        RotatedBox(
          quarterTurns: widget.horizontal ? 1 : 0,
          child: Text(
            widget.datas![i] is double
                ? widget.datas![i].toStringAsFixed(1)
                : widget.datas![i].toString(),
            textAlign: TextAlign.center,
            textScaler: const TextScaler.linear(1.5),
            style: i == currentPosition
                ? widget.selectTextStyle
                : widget.unSelectTextStyle,
          ),
        ),
      );
    }
    return result;
  }

  List<Widget>? _convertListItems() {
    if (widget.children == null) {
      return null;
    }
    if (widget.horizontal) {
      final List<Widget> result = [];
      for (int i = 0; i < widget.children!.length; i++) {
        result.add(RotatedBox(
          quarterTurns: 1,
          child: widget.children![i],
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
  final FixedExtentScrollController? controller;
  final double itemExtent;
  final double diameterRatio;
  final void Function(int)? onSelectedItemChanged;
  const ListWheelScrollViewX({
    super.key,
    required this.builder,
    required this.itemExtent,
    this.controller,
    this.onSelectedItemChanged,
    this.scrollDirection = Axis.vertical,
    this.diameterRatio = 100000,
  });

  @override
  Widget build(final BuildContext context) {
    return RotatedBox(
      quarterTurns: scrollDirection == Axis.horizontal ? 0 : 0,
      child: ListWheelScrollView.useDelegate(
        onSelectedItemChanged: onSelectedItemChanged,
        controller: controller,
        itemExtent: itemExtent,
        diameterRatio: diameterRatio,
        physics: const FixedExtentScrollPhysics(),
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (final context, final index) {
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
