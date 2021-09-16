// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tradfri_control_outlet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TradfriControlOutletModel _$TradfriControlOutletModelFromJson(
        Map<String, dynamic> json) =>
    TradfriControlOutletModel(
      json['id'] as int,
      json['friendlyName'] as String,
      json['isConnected'] as bool,
    )
      ..available = json['available'] as bool
      ..lastReceived = DateTime.parse(json['lastReceived'] as String)
      ..linkQuality = json['link_Quality'] as int
      ..state = json['state'] as bool;

Map<String, dynamic> _$TradfriControlOutletModelToJson(
        TradfriControlOutletModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'friendlyName': instance.friendlyName,
      'available': instance.available,
      'lastReceived': instance.lastReceived.toIso8601String(),
      'link_Quality': instance.linkQuality,
      'isConnected': instance.isConnected,
      'state': instance.state,
    };
