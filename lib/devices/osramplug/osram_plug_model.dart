import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/zigbee/zigbee_model.dart';



 part 'osram_plug_model.g.dart';


@JsonSerializable()
class OsramPlugModel extends ZigbeeModel {
  late bool state;
  OsramPlugModel(int id, String friendlyName, bool isConnected) : super(id, friendlyName, isConnected);


   factory OsramPlugModel.fromJson(Map<String, dynamic> json) => _$OsramPlugModelFromJson(json);

   Map<String, dynamic> toJson() => _$OsramPlugModelToJson(this);
}