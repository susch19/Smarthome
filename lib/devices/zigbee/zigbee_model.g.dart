// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zigbee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ZigbeeModel _$ZigbeeModelFromJson(Map<String, dynamic> json) => ZigbeeModel(
      json['id'] as int,
      json['friendlyName'] as String,
      json['isConnected'] as bool,
    )
      ..available = json['available'] as bool
      ..lastReceived = DateTime.parse(json['lastReceived'] as String)
      ..linkQuality = json['link_quality'] as int?;

Map<String, dynamic> _$ZigbeeModelToJson(ZigbeeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'friendlyName': instance.friendlyName,
      'available': instance.available,
      'lastReceived': instance.lastReceived.toIso8601String(),
      'link_quality': instance.linkQuality,
      'isConnected': instance.isConnected,
    };
