import 'package:flutter/rendering.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/generic/edit_parameter.dart';
import 'package:smarthome/devices/generic/enums.dart';
import 'package:smarthome/models/message.dart';

part 'property_edit_information.g.dart';

@JsonSerializable()
class PropertyEditInformation {
  MessageType editCommand;
  List<EditParameter> editParameter;
  String? display;
  EditType editType;
  String? hubMethod;
  Object? activeValue;
  @JsonKey(ignore: true)
  Map<String, dynamic>? raw;

  PropertyEditInformation(
      this.editCommand, this.editParameter, this.display, this.hubMethod, this.activeValue, this.editType);

  @override
  bool operator ==(final Object other) =>
      other is PropertyEditInformation &&
      other.editType == editType &&
      other.editCommand == editCommand &&
      other.display == display &&
      other.activeValue == activeValue;

  @override
  int get hashCode => Object.hash(editType, editCommand, display, activeValue);

  List<EditParameter> getEditParametersFor(final int id) {
    final ret = editParameter.map((final e) => e.clone()).toList();
    for (final element in ret) {
      if (element.id == 0) {
        element.id = id;
      }
    }
    return ret;
  }

  factory PropertyEditInformation.fromJson(final Map<String, dynamic> json) =>
      _$PropertyEditInformationFromJson(json)..raw = json;
  Map<String, dynamic> toJson() => _$PropertyEditInformationToJson(this);
}
