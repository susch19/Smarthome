import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';

part 'layout_base_property_info.g.dart';

@JsonSerializable()
class LayoutBasePropertyInfo {
  String name;
  int order;
  ServerTextStyle? textStyle;
  PropertyEditInformation? editInfo;
  int? rowNr;
  String? unitOfMeasurement;
  String? format;
  bool? showOnlyInDeveloperMode;
  int? deviceId;
  bool? expanded;
  int? precision;
  @JsonKey(includeFromJson: false, includeToJson: false)
  late Map<String, dynamic> raw;

  LayoutBasePropertyInfo(this.name, this.order);

  @override
  bool operator ==(final Object other) =>
      other is LayoutBasePropertyInfo &&
      other.name == name &&
      other.order == order &&
      textStyle == other.textStyle &&
      editInfo == other.editInfo &&
      rowNr == other.rowNr &&
      unitOfMeasurement == other.unitOfMeasurement &&
      format == other.format &&
      showOnlyInDeveloperMode == other.showOnlyInDeveloperMode &&
      deviceId == other.deviceId &&
      expanded == other.expanded &&
      precision == other.precision &&
      hashCode == other.hashCode;

  @override
  int get hashCode => Object.hash(name, order, textStyle, editInfo, rowNr, unitOfMeasurement, format,
      showOnlyInDeveloperMode, deviceId, expanded, precision, raw);

  factory LayoutBasePropertyInfo.fromJson(final Map<String, dynamic> json) =>
      _$LayoutBasePropertyInfoFromJson(json)..raw = json;

  Map<String, dynamic> toJson() => _$LayoutBasePropertyInfoToJson(this);
}
