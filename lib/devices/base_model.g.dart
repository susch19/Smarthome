// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseModel _$BaseModelFromJson(Map<String, dynamic> json) {
  return BaseModel()
    ..id = json['id'] as int
    ..friendlyName = json['friendlyName'] as String
    ..isConnected = json['isConnected'] as bool;
}

Map<String, dynamic> _$BaseModelToJson(BaseModel instance) => <String, dynamic>{
      'id': instance.id,
      'friendlyName': instance.friendlyName,
      'isConnected': instance.isConnected
    };
