import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/models/message.dart';

part 'property_edit_information.g.dart';

@JsonSerializable()
class PropertyEditInformation {
  MessageType editType;
  Command editCommand;

  PropertyEditInformation(this.editType, this.editCommand);

  factory PropertyEditInformation.fromJson(Map<String, dynamic> json) => _$PropertyEditInformationFromJson(json);
  Map<String, dynamic> toJson() => _$PropertyEditInformationToJson(this);
}
