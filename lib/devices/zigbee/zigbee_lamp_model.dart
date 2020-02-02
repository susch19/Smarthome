import 'package:json_annotation/json_annotation.dart';

import '../device_exporter.dart';


part 'zigbee_lamp_model.g.dart';


@JsonSerializable()
class ZigbeeLampModel extends ZigbeeModel {
     int brightness;
     bool state;
     int colorTemp;
  @JsonKey(name: 'transition_Time')
     double transitionTime;

  ZigbeeLampModel() {
  }

  factory ZigbeeLampModel.fromJson(Map<String, dynamic> json) => _$ZigbeeLampModelFromJson(json);

  Map<String, dynamic> toJson() => _$ZigbeeLampModelToJson(this);
}
