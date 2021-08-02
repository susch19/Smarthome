// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heater_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HeaterModel _$HeaterModelFromJson(Map<String, dynamic> json) => HeaterModel(
      json['id'] as int,
      json['friendlyName'] as String,
      json['isConnected'] as bool,
    )
      ..temperature = json['temperature'] == null
          ? null
          : HeaterConfig.fromJson(json['temperature'] as Map<String, dynamic>)
      ..xiaomiTempSensor = json['xiaomiTempSensor'] as int?
      ..currentConfig = json['currentConfig'] == null
          ? null
          : HeaterConfig.fromJson(json['currentConfig'] as Map<String, dynamic>)
      ..currentCalibration = json['currentCalibration'] == null
          ? null
          : HeaterConfig.fromJson(
              json['currentCalibration'] as Map<String, dynamic>)
      ..firmwareVersion = json['firmwareVersion'] as String?
      ..disableLed = json['disableLed'] as bool?
      ..disableHeating = json['disableHeating'] as bool?;

Map<String, dynamic> _$HeaterModelToJson(HeaterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'friendlyName': instance.friendlyName,
      'isConnected': instance.isConnected,
      'temperature': instance.temperature,
      'xiaomiTempSensor': instance.xiaomiTempSensor,
      'currentConfig': instance.currentConfig,
      'currentCalibration': instance.currentCalibration,
      'firmwareVersion': instance.firmwareVersion,
      'disableLed': instance.disableLed,
      'disableHeating': instance.disableHeating,
    };
