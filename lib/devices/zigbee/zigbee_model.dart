import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/device_exporter.dart';

part 'zigbee_model.g.dart';

@JsonSerializable()
class ZigbeeModel extends BaseModel {
  late bool available;
  late DateTime lastReceived;
  @JsonKey(name: 'link_quality')
  late int linkQuality;

  @override
  bool get isConnected => available;

  ZigbeeModel(int id, String friendlyName, bool isConnected) : super(id, friendlyName, isConnected);
  factory ZigbeeModel.fromJson(Map<String, dynamic> json) => _$ZigbeeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ZigbeeModelToJson(this);
}
