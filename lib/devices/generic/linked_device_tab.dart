import 'package:json_annotation/json_annotation.dart';

part 'linked_device_tab.g.dart';

@JsonSerializable()
class LinkedDeviceTab {
  String deviceIdPropertyName;
  String deviceType;

  LinkedDeviceTab(this.deviceIdPropertyName, this.deviceType);

  factory LinkedDeviceTab.fromJson(Map<String, dynamic> json) => _$LinkedDeviceTabFromJson(json);

  Map<String, dynamic> toJson() => _$LinkedDeviceTabToJson(this);
}
