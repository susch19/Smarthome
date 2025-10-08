// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/restapi/swagger.enums.swagger.dart';

part 'message.g.dart';

// enum MessageType { Get, Update, Options }



@JsonSerializable()
class Message {
  int? id;
  @JsonKey(name: "m")
  MessageType messageType;
  @JsonKey(name: "c")
  int command;
  @JsonKey(name: "p")
  List<Object?>? parameters;

  Message(this.id, this.messageType, this.command, [this.parameters]);

  factory Message.fromJson(final Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  // Map<String, dynamic> toJson() {
  //   var va = {"id": id, "m": messageType, "c": command, "p": parameters};
  //   var vat = va.toString();

  //   return va;
  // }

  // Message.fromJson(Map data) {
  //   id = data["id"];
  //   messageType = MessageType.values.firstWhere((e) => e.toString() == data["m"]);
  //   command = Command.values.firstWhere((e) => e.toString() == data["c"]);
  //   parameters = data["p"];
  // }
}
