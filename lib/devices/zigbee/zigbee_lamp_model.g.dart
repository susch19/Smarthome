// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zigbee_lamp_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ZigbeeLampModel _$ZigbeeLampModelFromJson(Map<String, dynamic> json) =>
    ZigbeeLampModel(
      json['id'] as int,
      json['friendlyName'] as String,
      json['isConnected'] as bool,
    )
      ..available = json['available'] as bool
      ..lastReceived = DateTime.parse(json['lastReceived'] as String)
      ..linkQuality = json['link_quality'] as int?
      ..brightness = json['brightness'] as int
      ..state = json['state'] as bool
      ..colorTemp = json['colorTemp'] as int
      ..transitionTime = (json['transition_time'] as num).toDouble();

Map<String, dynamic> _$ZigbeeLampModelToJson(ZigbeeLampModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'friendlyName': instance.friendlyName,
      'available': instance.available,
      'lastReceived': instance.lastReceived.toIso8601String(),
      'link_quality': instance.linkQuality,
      'isConnected': instance.isConnected,
      'brightness': instance.brightness,
      'state': instance.state,
      'colorTemp': instance.colorTemp,
      'transition_time': instance.transitionTime,
    };
