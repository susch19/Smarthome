// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLoginResult _$UserLoginResultFromJson(Map<String, dynamic> json) {
  return UserLoginResult()
    ..success = json['success'] as bool
    ..error = json['error'] as String
    ..id = json['id'] as int
    ..username = json['username'] as String
    ..eMail = json['eMail'] as String
    ..token = json['token'] as String;
}

Map<String, dynamic> _$UserLoginResultToJson(UserLoginResult instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'id': instance.id,
      'username': instance.username,
      'eMail': instance.eMail,
      'token': instance.token
    };

BaseResult _$BaseResultFromJson(Map<String, dynamic> json) {
  return BaseResult()
    ..success = json['success'] as bool
    ..error = json['error'] as String;
}

Map<String, dynamic> _$BaseResultToJson(BaseResult instance) =>
    <String, dynamic>{'success': instance.success, 'error': instance.error};
