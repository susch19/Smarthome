// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temp_sensor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TempSensorModel _$TempSensorModelFromJson(Map<String, dynamic> json) {
  return TempSensorModel()
    ..id = json['id'] as int
    ..friendlyName = json['friendlyName'] as String
    ..isConnected = json['isConnected'] as bool
    ..available = json['available'] as bool
    ..lastReceived = json['lastReceived'] == null
        ? null
        : DateTime.parse(json['lastReceived'] as String)
    ..linkQuality = json['link_Quality'] as int
    ..temperature = (json['temperature'] as num)?.toDouble()
    ..humidity = (json['humidity'] as num)?.toDouble()
    ..pressure = (json['pressure'] as num)?.toDouble()
    ..battery = json['battery'] as int;
}

Map<String, dynamic> _$TempSensorModelToJson(TempSensorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'friendlyName': instance.friendlyName,
      'isConnected': instance.isConnected,
      'available': instance.available,
      'lastReceived': instance.lastReceived?.toIso8601String(),
      'link_Quality': instance.linkQuality,
      'temperature': instance.temperature,
      'humidity': instance.humidity,
      'pressure': instance.pressure,
      'battery': instance.battery
    };
