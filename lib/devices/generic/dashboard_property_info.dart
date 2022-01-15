import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/devices/generic/layout_base_property_info.dart';

part 'dashboard_property_info.g.dart';

@JsonSerializable()
class DashboardPropertyInfo extends LayoutBasePropertyInfo {
  String? format;
  SpecialType specialType = SpecialType.none;

  DashboardPropertyInfo(String name, int order) : super(name, order);

  factory DashboardPropertyInfo.fromJson(Map<String, dynamic> json) {
    return _$DashboardPropertyInfoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DashboardPropertyInfoToJson(this);
}
