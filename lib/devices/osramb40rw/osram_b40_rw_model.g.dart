// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'osram_b40_rw_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OsramB40RWModel _$OsramB40RWModelFromJson(Map<String, dynamic> json) =>
    OsramB40RWModel(
      json['id'] as int,
      json['friendlyName'] as String,
      json['isConnected'] as bool,
    )
      ..available = json['available'] as bool
      ..lastReceived = DateTime.parse(json['lastReceived'] as String)
      ..linkQuality = json['link_Quality'] as int
      ..brightness = json['brightness'] as int
      ..state = json['state'] as bool
      ..colorTemp = json['colorTemp'] as int
      ..transitionTime = (json['transition_Time'] as num).toDouble();

Map<String, dynamic> _$OsramB40RWModelToJson(OsramB40RWModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'friendlyName': instance.friendlyName,
      'isConnected': instance.isConnected,
      'available': instance.available,
      'lastReceived': instance.lastReceived.toIso8601String(),
      'link_Quality': instance.linkQuality,
      'brightness': instance.brightness,
      'state': instance.state,
      'colorTemp': instance.colorTemp,
      'transition_Time': instance.transitionTime,
    };
