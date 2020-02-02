import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';
enum MessageType { Get, Update, Options }

enum Command {
  WhoIAm,
  IP,
  Time,
  Temp,
  Brightness,
  RelativeBrightness,
  Color,
  Mode,
  OnChangedConnections,
  OnNewConnection,
  Mesh,
  Delay,
  Off,
  RGB,
  Strobo,
  RGBCycle,
  LightWander,
  RGBWander,
  Reverse,
  SingleColor,
  DeviceMapping,
  Calibration
}

@JsonSerializable()
class Message {
  int id;
  @JsonKey(name:"m")
  MessageType messageType;
  @JsonKey(name:"c")
  Command command;
  @JsonKey(name:"p")
  List<String> parameters;

  Message(this.id, this.messageType, this.command, [this.parameters]);

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

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
