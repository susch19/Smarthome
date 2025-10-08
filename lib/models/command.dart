
import 'package:json_annotation/json_annotation.dart';

enum Command {
  @JsonValue(0)
  none(0),
  @JsonValue(1)
  off(1),
  @JsonValue(2)
  on(2),
  @JsonValue(3)
  whoiam(3),
  @JsonValue(4)
  ip(4),
  @JsonValue(5)
  time(5),
  @JsonValue(6)
  temp(6),
  @JsonValue(7)
  brightness(7),
  @JsonValue(8)
  relativebrightness(8),
  @JsonValue(9)
  color(9),
  @JsonValue(10)
  mode(10),
  @JsonValue(11)
  onchangedconnections(11),
  @JsonValue(12)
  onnewconnection(12),
  @JsonValue(13)
  mesh(13),
  @JsonValue(14)
  delay(14),
  @JsonValue(15)
  rgb(15),
  @JsonValue(16)
  strobo(16),
  @JsonValue(17)
  rgbcycle(17),
  @JsonValue(18)
  lightwander(18),
  @JsonValue(19)
  rgbwander(19),
  @JsonValue(20)
  reverse(20),
  @JsonValue(21)
  singlecolor(21),
  @JsonValue(22)
  devicemapping(22),
  @JsonValue(23)
  calibration(23),
  @JsonValue(24)
  ota(24),
  @JsonValue(25)
  otapart(25),
  @JsonValue(26)
  log(26),
  @JsonValue(100)
  zigbee(100);

  final int? value;

  const Command(this.value);
}