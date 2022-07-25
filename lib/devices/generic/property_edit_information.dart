import 'package:json_annotation/json_annotation.dart';
import 'package:quiver/core.dart';
import 'package:smarthome/models/message.dart';

part 'property_edit_information.g.dart';

@JsonSerializable()
class PropertyEditInformation {
  MessageType editType;
  Command editCommand;

  PropertyEditInformation(this.editType, this.editCommand);

  @override
  bool operator ==(final Object other) =>
      other is PropertyEditInformation && other.editType == editType && other.editCommand == editCommand;

  @override
  int get hashCode => hash2(editType, editCommand);

  factory PropertyEditInformation.fromJson(final Map<String, dynamic> json) => _$PropertyEditInformationFromJson(json);
  Map<String, dynamic> toJson() => _$PropertyEditInformationToJson(this);
}
