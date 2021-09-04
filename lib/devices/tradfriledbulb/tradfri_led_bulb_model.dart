import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/device_exporter.dart';

part 'tradfri_led_bulb_model.g.dart';

@JsonSerializable()
class TradfriLedBulbModel extends ZigbeeModel {
  late int brightness;
  late String? color;
  late bool state;

  @override
  bool get isConnected => available;

  TradfriLedBulbModel(int id, String friendlyName, bool isConnected) : super(id, friendlyName, isConnected);
  factory TradfriLedBulbModel.fromJson(Map<String, dynamic> json) => _$TradfriLedBulbModelFromJson(json);

  Map<String, dynamic> toJson() => _$TradfriLedBulbModelToJson(this);
}
