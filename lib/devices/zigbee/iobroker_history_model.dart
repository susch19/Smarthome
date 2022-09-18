import 'package:json_annotation/json_annotation.dart';
part 'iobroker_history_model.g.dart';

@JsonSerializable()
class HistoryModel {
  late List<HistoryRecord> historyRecords;
  String? propertyName;

  HistoryModel();
  factory HistoryModel.fromJson(final Map<String, dynamic> json) => _$HistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryModelToJson(this);
}

@JsonSerializable()
class HistoryRecord {
  @JsonKey(name: 'val')
  num? value;
  @JsonKey(name: 'ts')
  late int timeStamp;

  HistoryRecord();
  factory HistoryRecord.fromJson(final Map<String, dynamic> json) => _$HistoryRecordFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryRecordToJson(this);
}
