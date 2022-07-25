import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/device_exporter.dart';

import 'package:riverpod/riverpod.dart';

part 'zigbee_model.g.dart';

@JsonSerializable()
class ZigbeeModel extends BaseModel {
  final bool available;
  final DateTime lastReceived;
  @JsonKey(name: 'link_Quality')
  final int linkQuality;

  static final availableProvider = Provider.family<bool, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    return (baseModel as ZigbeeModel).available;
  });
  static final lastReceivedProvider = Provider.family<DateTime, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    return (baseModel as ZigbeeModel).lastReceived;
  });
  static final linkQualityProvider = Provider.family<int, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    return (baseModel as ZigbeeModel).linkQuality;
  });

  @override
  bool get isConnected => available;

  const ZigbeeModel(final int id, final String friendlyName, final bool isConnected, this.available, this.lastReceived,
      this.linkQuality)
      : super(id, friendlyName, isConnected);
  factory ZigbeeModel.fromJson(final Map<String, dynamic> json) => _$ZigbeeModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ZigbeeModelToJson(this);

  @override
  BaseModel getModelFromJson(final Map<String, dynamic> json) {
    return ZigbeeModel.fromJson(json);
  }

  @override
  bool operator ==(final Object other) =>
      other is ZigbeeModel &&
      super == other &&
      available == other.available &&
      lastReceived == other.lastReceived &&
      linkQuality == other.linkQuality;

  @override
  int get hashCode => Object.hash(super.hashCode, available, lastReceived, linkQuality);
}
