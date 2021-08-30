// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tradfri_led_bulb_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TradfriLedBulbModel _$TradfriLedBulbModelFromJson(Map<String, dynamic> json) =>
    TradfriLedBulbModel(
      json['id'] as int,
      json['friendlyName'] as String,
      json['isConnected'] as bool,
    )
      ..available = json['available'] as bool
      ..lastReceived = DateTime.parse(json['lastReceived'] as String)
      ..linkQuality = json['link_Quality'] as int
      ..brightness = json['brightness'] as int
      ..color = json['color'] as String?
      ..state = json['state'] as bool;

Map<String, dynamic> _$TradfriLedBulbModelToJson(
        TradfriLedBulbModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'friendlyName': instance.friendlyName,
      'available': instance.available,
      'lastReceived': instance.lastReceived.toIso8601String(),
      'link_Quality': instance.linkQuality,
      'brightness': instance.brightness,
      'color': instance.color,
      'state': instance.state,
      'isConnected': instance.isConnected,
    };
