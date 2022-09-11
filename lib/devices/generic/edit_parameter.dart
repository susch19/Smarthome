import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/models/message.dart';
import 'package:smarthome/helper/iterable_extensions.dart';

part 'edit_parameter.g.dart';

@JsonSerializable()
class EditParameter {
  int command;
  Object value;
  String? displayName;
  List<Object?>? parameters;
  int? id;
  MessageType? messageType;
  @JsonKey(ignore: true)
  late Map<String, dynamic> raw;

  EditParameter(this.command, this.value, this.displayName, this.parameters, this.id, this.messageType);

  EditParameter clone() {
    return EditParameter(command, value, displayName, parameters, id, messageType);
  }

  @override
  bool operator ==(final Object other) =>
      other is EditParameter &&
      other.command == command &&
      other.value == value &&
      other.displayName == displayName &&
      (other.parameters ?? []).sequenceEquals(parameters ?? []) &&
      other.id == id &&
      other.messageType == messageType;

  @override
  int get hashCode => Object.hash(command, value, displayName, parameters, id, messageType, raw);

  factory EditParameter.fromJson(final Map<String, dynamic> json) => _$EditParameterFromJson(json)..raw = json;

  Map<String, dynamic> toJson() => _$EditParameterToJson(this);
}
