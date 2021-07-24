import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/zigbee/zigbee_lamp_model.dart';



 part 'osram_b40_rw_model.g.dart';


@JsonSerializable()
class OsramB40RWModel extends ZigbeeLampModel {

  OsramB40RWModel(int id, String friendlyName, bool isConnected) : super(id, friendlyName, isConnected);


   factory OsramB40RWModel.fromJson(Map<String, dynamic> json) => _$OsramB40RWModelFromJson(json);

   Map<String, dynamic> toJson() => _$OsramB40RWModelToJson(this);
}
