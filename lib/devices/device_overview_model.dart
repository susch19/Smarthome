import 'package:json_annotation/json_annotation.dart';

part 'device_overview_model.g.dart';

@JsonSerializable()
class DeviceOverviewModel {
  int id;
  List<String> typeNames;
  String typeName;
  String? friendlyName;

  DeviceOverviewModel(
    this.id,
    this.typeNames,
    this.typeName,
    this.friendlyName,
  );

  factory DeviceOverviewModel.fromJson(final Map<String, dynamic> json) =>
      _$DeviceOverviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceOverviewModelToJson(this);
}
