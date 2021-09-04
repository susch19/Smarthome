// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heater_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HeaterConfig _$HeaterConfigFromJson(Map<String, dynamic> json) => HeaterConfig(
      _$enumDecode(_$DayOfWeekEnumMap, json['dayOfWeek']),
      HeaterConfig.timeOfDayFromJson(json['timeOfDay'] as String),
      (json['temperature'] as num).toDouble(),
    );

Map<String, dynamic> _$HeaterConfigToJson(HeaterConfig instance) =>
    <String, dynamic>{
      'dayOfWeek': _$DayOfWeekEnumMap[instance.dayOfWeek],
      'timeOfDay': HeaterConfig.timeOfDayToJson(instance.timeOfDay),
      'temperature': instance.temperature,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$DayOfWeekEnumMap = {
  DayOfWeek.Mon: 'Mon',
  DayOfWeek.Tue: 'Tue',
  DayOfWeek.Wed: 'Wed',
  DayOfWeek.Thu: 'Thu',
  DayOfWeek.Fri: 'Fri',
  DayOfWeek.Sat: 'Sat',
  DayOfWeek.Sun: 'Sun',
};
