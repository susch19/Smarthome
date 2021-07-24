// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iobroker_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IoBrokerHistoryModel _$IoBrokerHistoryModelFromJson(
        Map<String, dynamic> json) =>
    IoBrokerHistoryModel()
      ..historyRecords = (json['historyRecords'] as List<dynamic>)
          .map((e) => HistoryRecord.fromJson(e as Map<String, dynamic>))
          .toList()
      ..propertyName = json['propertyName'] as String?;

Map<String, dynamic> _$IoBrokerHistoryModelToJson(
        IoBrokerHistoryModel instance) =>
    <String, dynamic>{
      'historyRecords': instance.historyRecords,
      'propertyName': instance.propertyName,
    };

HistoryRecord _$HistoryRecordFromJson(Map<String, dynamic> json) =>
    HistoryRecord()
      ..value = (json['val'] as num?)?.toDouble()
      ..timeStamp = json['ts'] as int;

Map<String, dynamic> _$HistoryRecordToJson(HistoryRecord instance) =>
    <String, dynamic>{
      'val': instance.value,
      'ts': instance.timeStamp,
    };
