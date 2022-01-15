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

  HistoryPropertyInfo(this.propertyName, this.xAxisName, this.unitOfMeasurement,
      this.iconName, this.brightThemeColor, this.darkThemeColor);

  factory HistoryPropertyInfo.fromJson(Map<String, dynamic> json) =>
      _$HistoryPropertyInfoFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryPropertyInfoToJson(this);
}
