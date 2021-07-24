// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLoginArgs _$UserLoginArgsFromJson(Map<String, dynamic> json) =>
    UserLoginArgs(
      json['username'] as String,
      json['email'] as String,
      json['password'] as String,
    );

Map<String, dynamic> _$UserLoginArgsToJson(UserLoginArgs instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
    };
