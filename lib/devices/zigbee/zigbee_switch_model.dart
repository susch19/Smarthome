import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/zigbee/zigbee_model.dart';

part 'zigbee_switch_model.g.dart';

@JsonSerializable()
class ZigbeeSwitchModel extends ZigbeeModel {
  late bool state;
  ZigbeeSwitchModel(int id, String friendlyName, bool isConnected) : super(id, friendlyName, isConnected);

  factory ZigbeeSwitchModel.fromJson(Map<String, dynamic> json) => _$ZigbeeSwitchModelFromJson(json);

  Map<String, dynamic> toJson() => _$ZigbeeSwitchModelToJson(this);
}
