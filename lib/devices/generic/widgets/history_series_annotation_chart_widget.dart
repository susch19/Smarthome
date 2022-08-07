import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class HistorySeriesAnnotationChartWidget extends StatelessWidget {
  final List<LineSeries> seriesList;
  final double min;
  final double max;
  final String unit;
  final String valueName;
  final DateTime shownDate;

  const HistorySeriesAnnotationChartWidget(
      this.seriesList, this.min, this.max, this.unit, this.valueName, this.shownDate,
      {final Key? key})
      : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return OrientationBuilder(builder: (final context, final orientation) {
      return SfCartesianChart(
        primaryXAxis: DateTimeAxis(
            interval: orientation == Orientation.landscape ? 2 : 4,
            intervalType: DateTimeIntervalType.hours,
            dateFormat: DateFormat("HH:mm"),
            majorGridLines: const MajorGridLines(width: 0),
            title: AxisTitle(text: DateFormat("dd.MM.yyyy").format(shownDate))),
        primaryYAxis: NumericAxis(
            minimum: (min - (((max - min) < 10 ? 10 : (max - min)) / 10)).roundToDouble(),
            maximum: (max + (((max - min) < 10 ? 10 : (max - min)) / 10)).roundToDouble(),
            interval: (((max - min) < 10 ? 10 : (max - min)) / 10).roundToDouble(),
            axisLine: const AxisLine(width: 0),
            labelFormat: '{value}$unit',
            majorTickLines: const MajorTickLines(size: 0),
            title: AxisTitle(text: valueName)),
        series: seriesList,
        trackballBehavior: TrackballBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
            tooltipSettings: const InteractiveTooltip(format: '{point.x} : {point.y}')),
      );
    });
  }
}

/// Sample time series data type.
class GraphTimeSeriesValue {
  final DateTime time;
  final double? value;
  final Color lineColor;

  GraphTimeSeriesValue(this.time, this.value, this.lineColor);
}