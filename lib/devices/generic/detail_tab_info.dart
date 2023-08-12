import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/generic/linked_device_tab.dart';

part 'detail_tab_info.g.dart';

@JsonSerializable()
class DetailTabInfo {
  int id;
  String iconName;
  int order;
  LinkedDeviceTab? linkedDevice;
  bool showOnlyInDeveloperMode;

  @override
  bool operator ==(final Object other) =>
      other is DetailTabInfo &&
      other.id == id &&
      other.showOnlyInDeveloperMode == other.showOnlyInDeveloperMode &&
      other.iconName == iconName &&
      other.order == order &&
      other.linkedDevice == linkedDevice;

  @override
  int get hashCode => Object.hash(id, iconName, order, linkedDevice, showOnlyInDeveloperMode);

  DetailTabInfo(this.id, this.iconName, this.order, this.linkedDevice, [this.showOnlyInDeveloperMode = false]);

  factory DetailTabInfo.fromJson(final Map<String, dynamic> json) => _$DetailTabInfoFromJson(json);

  Map<String, dynamic> toJson() => _$DetailTabInfoToJson(this);
}
