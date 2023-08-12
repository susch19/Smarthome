import 'package:json_annotation/json_annotation.dart';
import 'package:quiver/core.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/helper/iterable_extensions.dart';

part 'device_layout.g.dart';

@JsonSerializable()
class DeviceLayout {
  String uniqueName;
  String? typeName;
  List<String>? typeNames;
  List<int>? ids;
  DashboardDeviceLayout? dashboardDeviceLayout;
  DetailDeviceLayout? detailDeviceLayout;
  int version;
  bool showOnlyInDeveloperMode;

  DeviceLayout(this.uniqueName,
      {this.typeName,
      this.typeNames,
      this.ids,
      this.dashboardDeviceLayout,
      this.detailDeviceLayout,
      this.version = 1,
      this.showOnlyInDeveloperMode = false});

  @override
  bool operator ==(final Object other) =>
      other is DeviceLayout &&
      other.uniqueName == uniqueName &&
      other.version == version &&
      other.showOnlyInDeveloperMode == showOnlyInDeveloperMode &&
      other.typeName == typeName &&
      dashboardDeviceLayout == other.dashboardDeviceLayout &&
      detailDeviceLayout == other.detailDeviceLayout &&
      (other.ids ?? []).sequenceEquals(ids ?? []) &&
      (other.typeNames ?? []).sequenceEquals(typeNames ?? []);

  @override
  int get hashCode =>
      Object.hash(uniqueName, typeName, version, dashboardDeviceLayout, detailDeviceLayout, showOnlyInDeveloperMode) ^
      hashObjects(ids ?? []) ^
      hashObjects(typeNames ?? []);

  factory DeviceLayout.fromJson(final Map<String, dynamic> json) => _$DeviceLayoutFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceLayoutToJson(this);
}
