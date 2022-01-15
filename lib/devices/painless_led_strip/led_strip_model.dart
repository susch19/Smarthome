import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/base_model.dart';

part 'led_strip_model.g.dart';

@JsonSerializable()
class LedStripModel extends BaseModel {
  String colorMode;
  int delay;
  int numberOfLeds;
  int brightness;
  int step;
  bool reverse;
  int colorNumber;
  int version;

  LedStripModel(this.colorMode, this.delay, this.numberOfLeds, this.brightness, this.step, this.reverse,
      this.colorNumber, this.version, int id, String friendlyName, bool isConnected)
      : super(id, friendlyName, isConnected);

  factory LedStripModel.fromJson(Map<String, dynamic> json) => _$LedStripModelFromJson(json);

  Map<String, dynamic> toJson() => _$LedStripModelToJson(this);
}
