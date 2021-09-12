import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/device_exporter.dart';

part 'tradfri_motion_sensor_model.g.dart';

@JsonSerializable()
class TradfriMotionSensorModel extends ZigbeeModel {
  late int battery;
  @JsonKey(name: 'no_motion')
  late int noMotion;
  late bool occupancy;

  @override
  bool get isConnected => available;

  TradfriMotionSensorModel(int id, String friendlyName, bool isConnected) : super(id, friendlyName, isConnected);
  factory TradfriMotionSensorModel.fromJson(Map<String, dynamic> json) => _$TradfriMotionSensorModelFromJson(json);

  Map<String, dynamic> toJson() => _$TradfriMotionSensorModelToJson(this);
}
