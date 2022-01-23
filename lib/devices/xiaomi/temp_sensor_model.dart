import 'package:json_annotation/json_annotation.dart';

import '../device_exporter.dart';

part 'temp_sensor_model.g.dart';

@JsonSerializable()
class TempSensorModel extends ZigbeeModel {
  final double temperature;
  final double humidity;
  final double pressure;
  final int battery;

  const TempSensorModel(final int id, final String friendlyName, final bool isConnected, final bool available,
      final DateTime lastReceived, final int linkQuality, this.temperature, this.humidity, this.pressure, this.battery)
      : super(id, friendlyName, isConnected, available, lastReceived, linkQuality);

  factory TempSensorModel.fromJson(final Map<String, dynamic> json) => _$TempSensorModelFromJson(json);

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
  int get hashCode => Object.hash(
      id, friendlyName, isConnected, available, lastReceived, linkQuality, temperature, humidity, pressure, battery);
}
