import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/zigbee/zigbee_lamp_model.dart';

import '../device_exporter.dart';


part 'osram_b40_rw_model.g.dart';


@JsonSerializable()
class OsramB40RWModel extends ZigbeeLampModel {

  OsramB40RWModel() {
  }

  factory OsramB40RWModel.fromJson(Map<String, dynamic> json) => _$OsramB40RWModelFromJson(json);

  Map<String, dynamic> toJson() => _$OsramB40RWModelToJson(this);
}
