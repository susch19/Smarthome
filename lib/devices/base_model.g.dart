// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseModel _$BaseModelFromJson(Map<String, dynamic> json) => BaseModel(
      json['id'] as int,
      json['friendlyName'] as String,
      json['isConnected'] as bool,
    );

Map<String, dynamic> _$BaseModelToJson(BaseModel instance) => <String, dynamic>{
      'id': instance.id,
      'friendlyName': instance.friendlyName,
      'isConnected': instance.isConnected,
    };
