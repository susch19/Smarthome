import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/zigbee/zigbee_switch_model.dart';
part 'tradfri_control_outlet_model.g.dart';

@JsonSerializable()
class TradfriControlOutletModel extends ZigbeeSwitchModel {
  TradfriControlOutletModel(int id, String friendlyName, bool isConnected) : super(id, friendlyName, isConnected);

  factory TradfriControlOutletModel.fromJson(Map<String, dynamic> json) => _$TradfriControlOutletModelFromJson(json);

  Map<String, dynamic> toJson() => _$TradfriControlOutletModelToJson(this);
}
