import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/base_model.dart';
import 'package:smarthome/devices/zigbee/zigbee_model.dart';
import 'package:riverpod/riverpod.dart';

part 'zigbee_switch_model.g.dart';

@JsonSerializable()
@immutable
class ZigbeeSwitchModel extends ZigbeeModel {
  final bool state;

  static final stateProvider =
      Provider.family<bool, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    return (baseModel as ZigbeeSwitchModel).state;
  });

  const ZigbeeSwitchModel(
      super.id,
      super.friendlyName,
      super.typeName,
      super.isConnected,
      super.available,
      super.lastReceived,
      super.linkQuality,
      this.state);

  factory ZigbeeSwitchModel.fromJson(final Map<String, dynamic> json) =>
      _$ZigbeeSwitchModelFromJson(json);

  @override
  BaseModel getModelFromJson(final Map<String, dynamic> json) {
    return ZigbeeSwitchModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$ZigbeeSwitchModelToJson(this);

  @override
  bool operator ==(final Object other) =>
      other is ZigbeeSwitchModel && super == other && state == other.state;

  @override
  int get hashCode => Object.hash(super.hashCode, state);
}
