// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tradfri_motion_sensor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TradfriMotionSensorModel _$TradfriMotionSensorModelFromJson(
        Map<String, dynamic> json) =>
    TradfriMotionSensorModel(
      json['id'] as int,
      json['friendlyName'] as String,
      json['isConnected'] as bool,
    )
      ..available = json['available'] as bool
      ..lastReceived = DateTime.parse(json['lastReceived'] as String)
      ..linkQuality = json['link_Quality'] as int
      ..battery = json['battery'] as int
      ..noMotion = json['no_motion'] as int
      ..occupancy = json['occupancy'] as bool;

Map<String, dynamic> _$TradfriMotionSensorModelToJson(
        TradfriMotionSensorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'friendlyName': instance.friendlyName,
      'available': instance.available,
      'lastReceived': instance.lastReceived.toIso8601String(),
      'link_Quality': instance.linkQuality,
      'battery': instance.battery,
      'no_motion': instance.noMotion,
      'occupancy': instance.occupancy,
      'isConnected': instance.isConnected,
    };
