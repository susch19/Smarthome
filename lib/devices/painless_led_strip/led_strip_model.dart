import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/base_model.dart';

part 'led_strip_model.g.dart';

@JsonSerializable()
@immutable
class LedStripModel extends BaseModel {
  final String colorMode;
  final int delay;
  final int numberOfLeds;
  final int brightness;
  final int step;
  final bool reverse;
  final int colorNumber;

  @JsonKey(name: "version")
  final int version;

  const LedStripModel(this.colorMode, this.delay, this.numberOfLeds, this.brightness, this.step, this.reverse,
      this.colorNumber, this.version, final int id, final String friendlyName, final bool isConnected)
      : super(id, friendlyName, isConnected);

  factory LedStripModel.fromJson(final Map<String, dynamic> json) => _$LedStripModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LedStripModelToJson(this);

  @override
  LedStripModel getModelFromJson(final Map<String, dynamic> json) {
    return LedStripModel.fromJson(json);
  }

  @override
  int get hashCode =>
      Object.hash(super.hashCode, colorMode, delay, numberOfLeds, brightness, step, reverse, colorNumber, version);

  @override
  bool operator ==(final Object other) =>
      other is LedStripModel &&
      super == other &&
      colorMode == other.colorMode &&
      delay == other.delay &&
      numberOfLeds == other.numberOfLeds &&
      brightness == other.brightness &&
      step == other.step &&
      reverse == other.reverse &&
      colorNumber == other.colorNumber &&
      version == other.version;

  @override
  String toString() {
    return 'LedStripModel{colorMode: $colorMode, delay: $delay, numberOfLeds: $numberOfLeds, brightness: $brightness, step: $step, reverse: $reverse, colorNumber: $colorNumber, version: $version}';
  }
}
