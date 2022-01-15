import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/generic/detail_property_info.dart';
import 'package:smarthome/devices/generic/detail_tab_info.dart';
import 'package:smarthome/devices/generic/history_property_info.dart';

part 'detail_device_layout.g.dart';

@JsonSerializable()
class DetailDeviceLayout {
  List<DetailPropertyInfo> propertyInfos;
  List<DetailTabInfo> tabInfos;
  List<HistoryPropertyInfo> historyProperties;

  DetailDeviceLayout(this.propertyInfos, this.tabInfos, this.historyProperties);

  factory DetailDeviceLayout.fromJson(Map<String, dynamic> json) => _$DetailDeviceLayoutFromJson(json);

  Map<String, dynamic> toJson() => _$DetailDeviceLayoutToJson(this);
}
