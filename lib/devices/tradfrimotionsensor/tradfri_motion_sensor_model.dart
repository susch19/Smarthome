import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/device_exporter.dart';

part 'tradfri_motion_sensor_model.g.dart';

@JsonSerializable()
class TradfriMotionSensorModel extends ZigbeeModel {
  final int battery;
  final int noMotion;
  final bool occupancy;

  const TradfriMotionSensorModel(final int id, final String friendlyName, final bool isConnected, final bool available,
      final DateTime lastReceived, final int linkQuality, this.battery, this.noMotion, this.occupancy)
      : super(id, friendlyName, isConnected, available, lastReceived, linkQuality);
  factory TradfriMotionSensorModel.fromJson(final Map<String, dynamic> json) =>
      _$TradfriMotionSensorModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TradfriMotionSensorModelToJson(this);

  @override
  bool operator ==(final Object other) =>
      other is TradfriMotionSensorModel &&
      super == other &&
      battery == other.battery &&
      noMotion == other.noMotion &&
      occupancy == other.occupancy;

  @override
  int get hashCode => Object.hash(super.hashCode, battery, noMotion, occupancy);
}
