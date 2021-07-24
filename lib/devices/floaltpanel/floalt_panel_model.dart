import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/zigbee/zigbee_lamp_model.dart';

 part 'floalt_panel_model.g.dart';


@JsonSerializable()
class FloaltPanelModel extends ZigbeeLampModel {

  FloaltPanelModel(int id, String friendlyName, bool isConnected) : super(id, friendlyName, isConnected);

   factory FloaltPanelModel.fromJson(Map<String, dynamic> json) => _$FloaltPanelModelFromJson(json);

   Map<String, dynamic> toJson() => _$FloaltPanelModelToJson(this);
}
