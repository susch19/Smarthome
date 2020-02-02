// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heater_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HeaterConfig _$HeaterConfigFromJson(Map<String, dynamic> json) {
  return HeaterConfig()
    ..dayOfWeek = _$enumDecodeNullable(_$DayOfWeekEnumMap, json['dayOfWeek'])
    ..timeOfDay = json['timeOfDay'] == null
        ? null
        : HeaterConfig.timeOfDayFromJson(json['timeOfDay'] as String)
    ..temperature = (json['temperature'] as num)?.toDouble();
}

Map<String, dynamic> _$HeaterConfigToJson(HeaterConfig instance) =>
    <String, dynamic>{
      'dayOfWeek': _$DayOfWeekEnumMap[instance.dayOfWeek],
      'timeOfDay': instance.timeOfDay == null
          ? null
          : HeaterConfig.timeOfDayToJson(instance.timeOfDay),
      'temperature': instance.temperature
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$DayOfWeekEnumMap = <DayOfWeek, dynamic>{
  DayOfWeek.Mon: 'Mon',
  DayOfWeek.Tue: 'Tue',
  DayOfWeek.Wed: 'Wed',
  DayOfWeek.Thu: 'Thu',
  DayOfWeek.Fri: 'Fri',
  DayOfWeek.Sat: 'Sat',
  DayOfWeek.Sun: 'Sun'
};
