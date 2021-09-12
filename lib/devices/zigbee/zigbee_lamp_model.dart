import 'package:json_annotation/json_annotation.dart';

import '../device_exporter.dart';

part 'zigbee_lamp_model.g.dart';

@JsonSerializable()
class ZigbeeLampModel extends ZigbeeModel {
  late int brightness;
  late bool state;
  late int colorTemp;
  @JsonKey(name: 'transition_time')
  late double transitionTime;

  ZigbeeLampModel(int id, String friendlyName, bool isConnected) : super(id, friendlyName, isConnected);

  factory ZigbeeLampModel.fromJson(Map<String, dynamic> json) => _$ZigbeeLampModelFromJson(json);

  Map<String, dynamic> toJson() => _$ZigbeeLampModelToJson(this);
}
