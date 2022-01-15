import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';

part 'device_layout.g.dart';

@JsonSerializable()
class DeviceLayout {
  String? typeName;
  List<int>? ids;
  DashboardDeviceLayout? dashboardDeviceLayout;
  DetailDeviceLayout? detailDeviceLayout;

  DeviceLayout({
    this.typeName,
    this.ids,
    this.dashboardDeviceLayout,
    this.detailDeviceLayout,
  });

  factory DeviceLayout.fromJson(Map<String, dynamic> json) => _$DeviceLayoutFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceLayoutToJson(this);
}
