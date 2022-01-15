import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';

part 'layout_base_property_info.g.dart';

@JsonSerializable()
class LayoutBasePropertyInfo {
  String name;
  int order;
  ServerTextStyle? textStyle;
  PropertyEditInformation? editInfo;
  int? rowNr;
  String? unitOfMeasurement;
  String? format;
  bool? showOnlyInDeveloperMode;

  LayoutBasePropertyInfo(this.name, this.order);

  factory LayoutBasePropertyInfo.fromJson(Map<String, dynamic> json) => _$LayoutBasePropertyInfoFromJson(json);

  Map<String, dynamic> toJson() => _$LayoutBasePropertyInfoToJson(this);
}
