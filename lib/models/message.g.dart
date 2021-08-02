// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      json['id'] as int?,
      _$enumDecode(_$MessageTypeEnumMap, json['m']),
      _$enumDecode(_$CommandEnumMap, json['c']),
      (json['p'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'm': _$MessageTypeEnumMap[instance.messageType],
      'c': _$CommandEnumMap[instance.command],
      'p': instance.parameters,
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

const _$MessageTypeEnumMap = {
  MessageType.Get: 'Get',
  MessageType.Update: 'Update',
  MessageType.Options: 'Options',
};

const _$CommandEnumMap = {
  Command.WhoIAm: 'WhoIAm',
  Command.IP: 'IP',
  Command.Time: 'Time',
  Command.Temp: 'Temp',
  Command.Brightness: 'Brightness',
  Command.RelativeBrightness: 'RelativeBrightness',
  Command.Color: 'Color',
  Command.Mode: 'Mode',
  Command.OnChangedConnections: 'OnChangedConnections',
  Command.OnNewConnection: 'OnNewConnection',
  Command.Mesh: 'Mesh',
  Command.Delay: 'Delay',
  Command.Off: 'Off',
  Command.On: 'On',
  Command.RGB: 'RGB',
  Command.Strobo: 'Strobo',
  Command.RGBCycle: 'RGBCycle',
  Command.LightWander: 'LightWander',
  Command.RGBWander: 'RGBWander',
  Command.Reverse: 'Reverse',
  Command.SingleColor: 'SingleColor',
  Command.DeviceMapping: 'DeviceMapping',
  Command.Calibration: 'Calibration',
};
