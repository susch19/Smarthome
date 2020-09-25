// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heater_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HeaterModel _$HeaterModelFromJson(Map<String, dynamic> json) {
  return HeaterModel()
    ..id = json['id'] as int
    ..friendlyName = json['friendlyName'] as String
    ..isConnected = json['isConnected'] as bool
    ..temperature = json['temperature'] == null
        ? null
        : HeaterConfig.fromJson(json['temperature'] as Map<String, dynamic>)
    ..xiaomiTempSensor = json['xiaomiTempSensor'] as int
    ..currentConfig = json['currentConfig'] == null
        ? null
        : HeaterConfig.fromJson(json['currentConfig'] as Map<String, dynamic>)
    ..currentCalibration = json['currentCalibration'] == null
        ? null
        : HeaterConfig.fromJson(
            json['currentCalibration'] as Map<String, dynamic>)
    ..firmwareVersion = json['firmwareVersion'] as String;
}

Map<String, dynamic> _$HeaterModelToJson(HeaterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'friendlyName': instance.friendlyName,
      'isConnected': instance.isConnected,
      'temperature': instance.temperature,
      'xiaomiTempSensor': instance.xiaomiTempSensor,
      'currentConfig': instance.currentConfig,
      'currentCalibration': instance.currentCalibration,
      'firmwareVersion': instance.firmwareVersion
    };
