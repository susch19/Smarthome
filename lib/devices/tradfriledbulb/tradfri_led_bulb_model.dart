import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/device_exporter.dart';

part 'tradfri_led_bulb_model.g.dart';

@JsonSerializable()
@immutable
class TradfriLedBulbModel extends ZigbeeModel {
  final int brightness;
  final String color;
  final bool state;

  @override
  bool get isConnected => available;

  const TradfriLedBulbModel(final int id, final String friendlyName, final bool isConnected, final bool available,
      final DateTime lastReceived, final int linkQuality, this.brightness, this.color, this.state)
      : super(id, friendlyName, isConnected, available, lastReceived, linkQuality);
  factory TradfriLedBulbModel.fromJson(final Map<String, dynamic> json) => _$TradfriLedBulbModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TradfriLedBulbModelToJson(this);

  @override
  bool operator ==(final Object other) =>
      other is TradfriLedBulbModel &&
      super == other &&
      brightness == other.brightness &&
      color == other.color &&
      state == other.state;

  @override
  int get hashCode => Object.hash(super.hashCode, brightness, color, state);
}
