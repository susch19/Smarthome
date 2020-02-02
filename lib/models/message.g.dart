// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message(
      json['id'] as int,
      _$enumDecodeNullable(_$MessageTypeEnumMap, json['m']),
      _$enumDecodeNullable(_$CommandEnumMap, json['c']),
      (json['p'] as List)?.map((e) => e as String)?.toList());
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'm': _$MessageTypeEnumMap[instance.messageType],
      'c': _$CommandEnumMap[instance.command],
      'p': instance.parameters
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

const _$MessageTypeEnumMap = <MessageType, dynamic>{
  MessageType.Get: 'Get',
  MessageType.Update: 'Update',
  MessageType.Options: 'Options'
};

const _$CommandEnumMap = <Command, dynamic>{
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
  Command.RGB: 'RGB',
  Command.Strobo: 'Strobo',
  Command.RGBCycle: 'RGBCycle',
  Command.LightWander: 'LightWander',
  Command.RGBWander: 'RGBWander',
  Command.Reverse: 'Reverse',
  Command.SingleColor: 'SingleColor',
  Command.DeviceMapping: 'DeviceMapping',
  Command.Calibration: 'Calibration'
};
