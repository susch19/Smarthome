import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../device_exporter.dart';

part 'zigbee_lamp_model.g.dart';

@JsonSerializable()
@immutable
class ZigbeeLampModel extends ZigbeeModel {
  final int brightness;
  final bool state;
  final int colorTemp;
  @JsonKey(name: 'transition_Time')
  final double transitionTime;

  const ZigbeeLampModel(
      final int id,
      final String friendlyName,
      final bool isConnected,
      final bool available,
      final DateTime lastReceived,
      final int linkQuality,
      this.brightness,
      this.state,
      this.colorTemp,
      this.transitionTime)
      : super(id, friendlyName, isConnected, available, lastReceived, linkQuality);

  factory ZigbeeLampModel.fromJson(final Map<String, dynamic> json) => _$ZigbeeLampModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ZigbeeLampModelToJson(this);

  @override
  int get hashCode => Object.hash(
        super.hashCode,
        brightness,
        state,
        colorTemp,
        transitionTime,
      );

  @override
  bool operator ==(final Object other) =>
      other is ZigbeeLampModel &&
      super == other &&
      brightness == other.brightness &&
      state == other.state &&
      colorTemp == other.colorTemp &&
      transitionTime == other.transitionTime;
}
