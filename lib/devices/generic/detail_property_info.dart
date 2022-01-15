import 'package:json_annotation/json_annotation.dart';
// ignore: unnecessary_import
import 'package:smarthome/devices/generic/enums.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/devices/generic/layout_base_property_info.dart';

part 'detail_property_info.g.dart';

@JsonSerializable()
class DetailPropertyInfo extends LayoutBasePropertyInfo {
  String? format;
  String? displayName;
  SpecialDetailType specialType;

  DetailPropertyInfo(String name, int order, this.specialType) : super(name, order);

  factory DetailPropertyInfo.fromJson(Map<String, dynamic> json) => _$DetailPropertyInfoFromJson(json);
  Map<String, dynamic> toJson() => _$DetailPropertyInfoToJson(this);
}
