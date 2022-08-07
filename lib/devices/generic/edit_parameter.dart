import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/models/message.dart';

part 'edit_parameter.g.dart';

@JsonSerializable()
class EditParameter {
  Command command;
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

  factory EditParameter.fromJson(final Map<String, dynamic> json) => _$EditParameterFromJson(json)..raw = json;

  Map<String, dynamic> toJson() => _$EditParameterToJson(this);
}
