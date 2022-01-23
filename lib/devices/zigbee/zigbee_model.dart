import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/device_exporter.dart';

part 'zigbee_model.g.dart';

@JsonSerializable()
class ZigbeeModel extends BaseModel {
  final bool available;
  final DateTime lastReceived;
  @JsonKey(name: 'link_Quality')
  final int linkQuality;

  @override
  bool get isConnected => available;

  const ZigbeeModel(final int id, final String friendlyName, final bool isConnected, this.available, this.lastReceived,
      this.linkQuality)
      : super(id, friendlyName, isConnected);
  factory ZigbeeModel.fromJson(final Map<String, dynamic> json) => _$ZigbeeModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ZigbeeModelToJson(this);

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
