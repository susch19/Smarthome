import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:riverpod/riverpod.dart';

part 'tradfri_motion_sensor_model.g.dart';

@JsonSerializable()
class TradfriMotionSensorModel extends ZigbeeModel {
  final int battery;
  final int noMotion;
  final bool occupancy;

  static final batteryProvider = Provider.family<int, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    return (baseModel as TradfriMotionSensorModel).battery;
  });

  static final noMotionProvider = Provider.family<int, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    return (baseModel as TradfriMotionSensorModel).noMotion;
  });

  static final occupancyProvider = Provider.family<bool, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    return (baseModel as TradfriMotionSensorModel).occupancy;
  });

  const TradfriMotionSensorModel(
      super.id,
      super.friendlyName,
      super.typeName,
      super.isConnected,
      super.available,
      super.lastReceived,
      super.linkQuality,
      this.battery,
      this.noMotion,
      this.occupancy);
  factory TradfriMotionSensorModel.fromJson(final Map<String, dynamic> json) =>
      _$TradfriMotionSensorModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TradfriMotionSensorModelToJson(this);

  @override
  BaseModel getModelFromJson(final Map<String, dynamic> json) {
    return TradfriMotionSensorModel.fromJson(json);
  }

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
