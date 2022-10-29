import 'package:json_annotation/json_annotation.dart';

part 'history_property_info.g.dart';

@JsonSerializable()
class HistoryPropertyInfo {
  String propertyName;
  String xAxisName;
  String iconName;
  String unitOfMeasurement;
  int brightThemeColor;
  int darkThemeColor;
  String chartType = "line";

  HistoryPropertyInfo(this.propertyName, this.xAxisName, this.unitOfMeasurement, this.iconName, this.brightThemeColor,
      this.darkThemeColor,
      {this.chartType = "line"});

  @override
  bool operator ==(final Object other) =>
      other is HistoryPropertyInfo &&
      propertyName == other.propertyName &&
      xAxisName == other.xAxisName &&
      unitOfMeasurement == other.unitOfMeasurement &&
      iconName == other.iconName &&
      brightThemeColor == other.brightThemeColor &&
      darkThemeColor == other.darkThemeColor &&
      chartType == other.chartType;

  @override
  int get hashCode =>
      Object.hash(propertyName, xAxisName, unitOfMeasurement, iconName, brightThemeColor, darkThemeColor, chartType);

  factory HistoryPropertyInfo.fromJson(final Map<String, dynamic> json) => _$HistoryPropertyInfoFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryPropertyInfoToJson(this);
}
