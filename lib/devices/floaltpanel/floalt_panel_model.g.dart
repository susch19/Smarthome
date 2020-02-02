// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'floalt_panel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FloaltPanelModel _$FloaltPanelModelFromJson(Map<String, dynamic> json) {
  return FloaltPanelModel()
    ..id = json['id'] as int
    ..friendlyName = json['friendlyName'] as String
    ..isConnected = json['isConnected'] as bool
    ..available = json['available'] as bool
    ..lastReceived = json['lastReceived'] == null
        ? null
        : DateTime.parse(json['lastReceived'] as String)
    ..linkQuality = json['link_Quality'] as int
    ..brightness = json['brightness'] as int
    ..state = json['state'] as bool
    ..colorTemp = json['colorTemp'] as int
    ..transitionTime = (json['transition_Time'] as num)?.toDouble();
}

Map<String, dynamic> _$FloaltPanelModelToJson(FloaltPanelModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'friendlyName': instance.friendlyName,
      'isConnected': instance.isConnected,
      'available': instance.available,
      'lastReceived': instance.lastReceived?.toIso8601String(),
      'link_Quality': instance.linkQuality,
      'brightness': instance.brightness,
      'state': instance.state,
      'colorTemp': instance.colorTemp,
      'transition_Time': instance.transitionTime
    };
