import 'package:json_annotation/json_annotation.dart';
// ignore: unnecessary_import
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/devices/generic/layout_base_property_info.dart';

part 'detail_property_info.g.dart';

@JsonSerializable()
class DetailPropertyInfo extends LayoutBasePropertyInfo {
  String? displayName;
  bool? blurryCard;
  int? tabInfoId;

  DetailPropertyInfo(final String name, final int order) : super(name, order);

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
      displayName == other.displayName &&
      blurryCard == other.blurryCard &&
      tabInfoId == tabInfoId;

  @override
  int get hashCode => Object.hash(name, order, textStyle, editInfo, rowNr, unitOfMeasurement, format,
      showOnlyInDeveloperMode, displayName, blurryCard, tabInfoId);

  factory DetailPropertyInfo.fromJson(final Map<String, dynamic> json) => _$DetailPropertyInfoFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$DetailPropertyInfoToJson(this);
}
