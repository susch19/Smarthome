import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/generic/linked_device_tab.dart';

part 'detail_tab_info.g.dart';

@JsonSerializable()
class DetailTabInfo {
  int id;
  String iconName;
  int order;
  LinkedDeviceTab? linkedDevice;

  DetailTabInfo(this.id, this.iconName, this.order, this.linkedDevice);

  factory DetailTabInfo.fromJson(Map<String, dynamic> json) => _$DetailTabInfoFromJson(json);

  Map<String, dynamic> toJson() => _$DetailTabInfoToJson(this);
}
