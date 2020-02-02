
import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/device_exporter.dart';

part 'zigbee_model.g.dart';
@JsonSerializable()
class ZigbeeModel extends BaseModel{
      bool available;
      DateTime lastReceived;
  @JsonKey(name: 'link_Quality')
      int linkQuality;

    ZigbeeModel();
    factory ZigbeeModel.fromJson(Map<String, dynamic> json) => _$ZigbeeModelFromJson(json);

    Map<String, dynamic> toJson() => _$ZigbeeModelToJson(this);
}