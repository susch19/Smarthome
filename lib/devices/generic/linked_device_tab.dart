import 'package:json_annotation/json_annotation.dart';
import 'package:quiver/core.dart';

part 'linked_device_tab.g.dart';

@JsonSerializable()
class LinkedDeviceTab {
  String deviceIdPropertyName;
  String deviceType;

  LinkedDeviceTab(this.deviceIdPropertyName, this.deviceType);

  @override
  bool operator ==(final Object other) =>
      other is LinkedDeviceTab && other.deviceIdPropertyName == deviceIdPropertyName && other.deviceType == deviceType;

  @override
  int get hashCode => hash2(deviceIdPropertyName, deviceType);

  factory LinkedDeviceTab.fromJson(final Map<String, dynamic> json) => _$LinkedDeviceTabFromJson(json);

  Map<String, dynamic> toJson() => _$LinkedDeviceTabToJson(this);
}
