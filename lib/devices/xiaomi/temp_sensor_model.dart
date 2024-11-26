import 'package:json_annotation/json_annotation.dart';

import 'package:riverpod/riverpod.dart';
import '../device_exporter.dart';

part 'temp_sensor_model.g.dart';

@JsonSerializable()
class TempSensorModel extends ZigbeeModel {
  final double temperature;
  final double humidity;
  final double pressure;
  final int battery;

  static final temperatureProvider =
      Provider.family<double, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    return (baseModel as TempSensorModel).temperature;
  });
  static final humidityProvider =
      Provider.family<double, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    return (baseModel as TempSensorModel).humidity;
  });
  static final pressureProvider =
      Provider.family<double, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    return (baseModel as TempSensorModel).pressure;
  });
  static final batteryProvider =
      Provider.family<int, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    return (baseModel as TempSensorModel).battery;
  });

  const TempSensorModel(
      super.id,
      super.friendlyName,
      super.typeName,
      super.isConnected,
      super.available,
      super.lastReceived,
      super.linkQuality,
      this.temperature,
      this.humidity,
      this.pressure,
      this.battery);

  factory TempSensorModel.fromJson(final Map<String, dynamic> json) =>
      _$TempSensorModelFromJson(json);

  @override
  BaseModel getModelFromJson(final Map<String, dynamic> json) {
    return TempSensorModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$TempSensorModelToJson(this);

  @override
  bool operator ==(final Object other) =>
      other is TempSensorModel &&
      super == other &&
      other.temperature == temperature &&
      other.humidity == humidity &&
      other.pressure == pressure &&
      other.battery == battery;

  @override
  int get hashCode => Object.hash(id, friendlyName, isConnected, available,
      lastReceived, linkQuality, temperature, humidity, pressure, battery);
}
