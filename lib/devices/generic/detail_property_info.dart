import 'package:json_annotation/json_annotation.dart';
// ignore: unnecessary_import
import 'package:smarthome/devices/generic/enums.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/devices/generic/layout_base_property_info.dart';

part 'detail_property_info.g.dart';

@JsonSerializable()
class DetailPropertyInfo extends LayoutBasePropertyInfo {
  String? displayName;
  SpecialDetailType specialType;

  DetailPropertyInfo(final String name, final int order, this.specialType) : super(name, order);

  @override
  bool operator ==(final Object other) =>
      other is DetailPropertyInfo &&
      other.name == name &&
      other.order == order &&
      textStyle == other.textStyle &&
      editInfo == other.editInfo &&
      rowNr == other.rowNr &&
      unitOfMeasurement == other.unitOfMeasurement &&
      format == other.format &&
      showOnlyInDeveloperMode == other.showOnlyInDeveloperMode &&
      specialType == other.specialType &&
      displayName == other.displayName;

  @override
  int get hashCode => Object.hash(name, order, textStyle, editInfo, rowNr, unitOfMeasurement, format,
      showOnlyInDeveloperMode, specialType, displayName);

  factory DetailPropertyInfo.fromJson(final Map<String, dynamic> json) => _$DetailPropertyInfoFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$DetailPropertyInfoToJson(this);
}
