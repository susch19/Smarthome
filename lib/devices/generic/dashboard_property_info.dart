import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/devices/generic/layout_base_property_info.dart';

part 'dashboard_property_info.g.dart';

@JsonSerializable()
class DashboardPropertyInfo extends LayoutBasePropertyInfo {
  SpecialType specialType = SpecialType.none;

  DashboardPropertyInfo(final String name, final int order) : super(name, order);

  factory DashboardPropertyInfo.fromJson(final Map<String, dynamic> json) {
    return _$DashboardPropertyInfoFromJson(json);
  }

  @override
  bool operator ==(final Object other) =>
      other is DashboardPropertyInfo &&
      other.name == name &&
      other.order == order &&
      textStyle == other.textStyle &&
      editInfo == other.editInfo &&
      rowNr == other.rowNr &&
      unitOfMeasurement == other.unitOfMeasurement &&
      format == other.format &&
      showOnlyInDeveloperMode == other.showOnlyInDeveloperMode &&
      specialType == other.specialType;

  @override
  int get hashCode => Object.hash(
      name, order, textStyle, editInfo, rowNr, unitOfMeasurement, format, showOnlyInDeveloperMode, specialType);

  @override
  Map<String, dynamic> toJson() => _$DashboardPropertyInfoToJson(this);
}
