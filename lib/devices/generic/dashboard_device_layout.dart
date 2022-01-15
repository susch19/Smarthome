import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';

part 'dashboard_device_layout.g.dart';

@JsonSerializable()
class DashboardDeviceLayout {
  List<DashboardPropertyInfo> dashboardProperties;

  DashboardDeviceLayout(this.dashboardProperties);

  factory DashboardDeviceLayout.fromJson(Map<String, dynamic> json) => _$DashboardDeviceLayoutFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardDeviceLayoutToJson(this);
}
