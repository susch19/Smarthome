import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/helper/iterable_extensions.dart';

part 'device_layout.g.dart';

@JsonSerializable()
class DeviceLayout {
  String uniqueName;
  String? typeName;
  List<int>? ids;
  DashboardDeviceLayout? dashboardDeviceLayout;
  DetailDeviceLayout? detailDeviceLayout;

  DeviceLayout(
    this.uniqueName, {
    this.typeName,
    this.ids,
    this.dashboardDeviceLayout,
    this.detailDeviceLayout,
  });

  @override
  bool operator ==(final Object other) =>
      other is DeviceLayout &&
      other.uniqueName == uniqueName &&
      other.typeName == typeName &&
      dashboardDeviceLayout == other.dashboardDeviceLayout &&
      detailDeviceLayout == other.detailDeviceLayout &&
      (other.ids ?? []).sequenceEquals(ids ?? []);

  @override
  int get hashCode => Object.hash(uniqueName, typeName, dashboardDeviceLayout, detailDeviceLayout) ^ hashList(ids);

  factory DeviceLayout.fromJson(final Map<String, dynamic> json) => _$DeviceLayoutFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceLayoutToJson(this);
}
