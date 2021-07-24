import 'package:json_annotation/json_annotation.dart';
 part 'iobroker_history_model.g.dart';

@JsonSerializable()
class IoBrokerHistoryModel {
  late List<HistoryRecord> historyRecords;
  String? propertyName;

  IoBrokerHistoryModel();
   factory IoBrokerHistoryModel.fromJson(Map<String, dynamic> json) => _$IoBrokerHistoryModelFromJson(json);

   Map<String, dynamic> toJson() => _$IoBrokerHistoryModelToJson(this);
}

@JsonSerializable()
class HistoryRecord {
  @JsonKey(name: 'val')
  double? value;
  @JsonKey(name: 'ts')
  late int timeStamp;
  
  HistoryRecord();
   factory HistoryRecord.fromJson(Map<String, dynamic> json) => _$HistoryRecordFromJson(json);

   Map<String, dynamic> toJson() => _$HistoryRecordToJson(this);
}
