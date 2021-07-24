// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'led_strip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LedStripModel _$LedStripModelFromJson(Map<String, dynamic> json) =>
    LedStripModel(
      json['colorMode'] as String,
      json['delay'] as int,
      json['numberOfLeds'] as int,
      json['brightness'] as int,
      json['step'] as int,
      json['reverse'] as bool,
      json['colorNumber'] as int,
      json['version'] as int,
      json['id'] as int,
      json['friendlyName'] as String,
      json['isConnected'] as bool,
    );

Map<String, dynamic> _$LedStripModelToJson(LedStripModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'friendlyName': instance.friendlyName,
      'isConnected': instance.isConnected,
      'colorMode': instance.colorMode,
      'delay': instance.delay,
      'numberOfLeds': instance.numberOfLeds,
      'brightness': instance.brightness,
      'step': instance.step,
      'reverse': instance.reverse,
      'colorNumber': instance.colorNumber,
      'version': instance.version,
    };
