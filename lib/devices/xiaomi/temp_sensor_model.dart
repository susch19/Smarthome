import 'package:json_annotation/json_annotation.dart';

import '../device_exporter.dart';

part 'temp_sensor_model.g.dart';


@JsonSerializable()
class TempSensorModel extends ZigbeeModel {
      double temperature;
      double humidity;
      double pressure;
      int battery;

  TempSensorModel() {
  }

  factory TempSensorModel.fromJson(Map<String, dynamic> json) => _$TempSensorModelFromJson(json);

  Map<String, dynamic> toJson() => _$TempSensorModelToJson(this);
}
