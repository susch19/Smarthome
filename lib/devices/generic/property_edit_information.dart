import 'package:flutter/rendering.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:quiver/core.dart';
import 'package:smarthome/devices/generic/edit_parameter.dart';
import 'package:smarthome/devices/generic/enums.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
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
  String? dialog;
  @JsonKey(ignore: true)
  late Map<String, dynamic> raw;

  PropertyEditInformation(
      this.editCommand, this.editParameter, this.display, this.hubMethod, this.activeValue, this.editType, this.dialog);

  @override
  bool operator ==(final Object other) =>
      other is PropertyEditInformation &&
      other.editType == editType &&
      other.editCommand == editCommand &&
      other.display == display &&
      other.hubMethod == hubMethod &&
      other.activeValue == activeValue &&
      other.dialog == dialog &&
      editParameter.sequenceEquals(other.editParameter);

  @override
  int get hashCode => Object.hash(editType, editCommand, display, activeValue, dialog) ^ hashObjects(editParameter);

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
