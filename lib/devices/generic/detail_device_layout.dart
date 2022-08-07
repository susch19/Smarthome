import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:quiver/core.dart';
import 'package:smarthome/devices/generic/detail_property_info.dart';
import 'package:smarthome/devices/generic/detail_tab_info.dart';
import 'package:smarthome/devices/generic/history_property_info.dart';
import 'package:smarthome/helper/iterable_extensions.dart';

part 'detail_device_layout.g.dart';

@JsonSerializable()
class DetailDeviceLayout {
  List<DetailPropertyInfo> propertyInfos;
  List<DetailTabInfo> tabInfos;
  List<HistoryPropertyInfo> historyProperties;

  @override
  bool operator ==(final Object other) =>
      other is DetailDeviceLayout &&
      other.propertyInfos.sequenceEquals(propertyInfos) &&
      other.tabInfos.sequenceEquals(tabInfos) &&
      other.historyProperties.sequenceEquals(historyProperties);

  @override
  int get hashCode => hashObjects(propertyInfos) ^ hashObjects(tabInfos) ^ hashObjects(historyProperties);

  DetailDeviceLayout(this.propertyInfos, this.tabInfos, this.historyProperties);

  factory DetailDeviceLayout.fromJson(final Map<String, dynamic> json) => _$DetailDeviceLayoutFromJson(json);

  Map<String, dynamic> toJson() => _$DetailDeviceLayoutToJson(this);
}
