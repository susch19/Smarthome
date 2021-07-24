import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/base_model.dart';
import 'package:smarthome/devices/heater/heater_config.dart';

part 'heater_model.g.dart';

@JsonSerializable()
class HeaterModel extends BaseModel {
  HeaterConfig? temperature;
  int? xiaomiTempSensor;
  HeaterConfig? currentConfig;
  HeaterConfig? currentCalibration;
  String? firmwareVersion;


  HeaterModel(int id, String friendlyName, bool isConnected) : super(id, friendlyName, isConnected);

 factory HeaterModel.fromJson(Map<String, dynamic> json) => _$HeaterModelFromJson(json);

  Map<String, dynamic> toJson() => _$HeaterModelToJson(this);
}
