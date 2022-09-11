import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../device_exporter.dart';
import 'package:riverpod/riverpod.dart';

part 'zigbee_lamp_model.g.dart';

@JsonSerializable()
@immutable
class ZigbeeLampModel extends ZigbeeModel {
  final int brightness;
  final bool state;
  final int colortemp;
  final double? transitionTime;

  static final transitionTimeProvider = Provider.family<double?, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    return (baseModel as ZigbeeLampModel).transitionTime;
  });
  static final brightnessProvider = Provider.family<int, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    return (baseModel as ZigbeeLampModel).brightness;
  });
  static final colorTempProvider = Provider.family<int, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    return (baseModel as ZigbeeLampModel).colortemp;
  });
  static final stateProvider = Provider.family<bool, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    return (baseModel as ZigbeeLampModel).state;
  });

  const ZigbeeLampModel(
      final int id,
      final String friendlyName,
      final String typeName,
      final bool isConnected,
      final bool available,
      final DateTime lastReceived,
      final int linkQuality,
      this.brightness,
      this.state,
      this.colortemp,
      this.transitionTime)
      : super(id, friendlyName, typeName, isConnected, available, lastReceived, linkQuality);

  factory ZigbeeLampModel.fromJson(final Map<String, dynamic> json) => _$ZigbeeLampModelFromJson(json);

  @override
  BaseModel getModelFromJson(final Map<String, dynamic> json) {
    return ZigbeeLampModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$ZigbeeLampModelToJson(this);

  @override
  int get hashCode => Object.hash(
        super.hashCode,
        brightness,
        state,
        colortemp,
        transitionTime,
      );

  @override
  bool operator ==(final Object other) =>
      other is ZigbeeLampModel &&
      super == other &&
      brightness == other.brightness &&
      state == other.state &&
      colortemp == other.colortemp &&
      transitionTime == other.transitionTime;
}
