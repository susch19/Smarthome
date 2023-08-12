import 'package:json_annotation/json_annotation.dart';
import 'package:quiver/core.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/helper/iterable_extensions.dart';

part 'dashboard_device_layout.g.dart';

@JsonSerializable()
class DashboardDeviceLayout {
  List<DashboardPropertyInfo> dashboardProperties;

  @override
  bool operator ==(final Object other) =>
      other is DashboardDeviceLayout && other.dashboardProperties.sequenceEquals(dashboardProperties);

  @override
  int get hashCode => hashObjects(dashboardProperties);

  DashboardDeviceLayout(this.dashboardProperties);

  factory DashboardDeviceLayout.fromJson(final Map<String, dynamic> json) => _$DashboardDeviceLayoutFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardDeviceLayoutToJson(this);
}
