import 'package:json_annotation/json_annotation.dart';

import '../device_exporter.dart';

part 'temp_sensor_model.g.dart';

@JsonSerializable()
class TempSensorModel extends ZigbeeModel {
  late double temperature;
  late double humidity;
  late double pressure;
  late int battery;

  TempSensorModel(int id, String friendlyName, bool isConnected) : super(id, friendlyName, isConnected);

  factory TempSensorModel.fromJson(Map<String, dynamic> json) => _$TempSensorModelFromJson(json);

  Map<String, dynamic> toJson() => _$TempSensorModelToJson(this);
}
