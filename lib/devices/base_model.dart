import 'dart:async';

import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/generic/device_layout_service.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/devices/generic/stores/store_service.dart';
import 'package:smarthome/devices/generic/stores/value_store.dart';

part 'base_model.g.dart';

@JsonSerializable()
class BaseModel {
  int id;
  String friendlyName;
  bool isConnected;
  @JsonKey(ignore: true)
  bool cacheLoaded = false;

  DeviceLayout? get layout => _loadLayout();
  List<DashboardPropertyInfo>? get dashboardProperties => layout?.dashboardDeviceLayout?.dashboardProperties;
  List<HistoryPropertyInfo>? get historyProperties => layout?.detailDeviceLayout?.historyProperties;
  List<DetailPropertyInfo>? get detailProperties => layout?.detailDeviceLayout?.propertyInfos;

  @JsonKey(ignore: true)
  var uiUpadateChannel = StreamController<void>.broadcast();
  @JsonKey(ignore: true)
  Map<String, ValueStore> stores = Map<String, ValueStore>();

  @JsonKey(ignore: true)
  List<String> typeNames = <String>[];

  void dispose() {
    uiUpadateChannel.close();
  }

  void updateFromJson(Map<String, dynamic> json) {
    stores = StoreService.updateAndGetStores(id, json);

    var updatedModel = _$BaseModelFromJson(json);
    friendlyName = updatedModel.friendlyName;
    isConnected = updatedModel.isConnected;
    id = updatedModel.id;
  }

  BaseModel(this.id, this.friendlyName, this.isConnected);

  factory BaseModel.fromJson(Map<String, dynamic> json, List<String> typeNames) {
    var bm = _$BaseModelFromJson(json);
    bm.typeNames = typeNames;
    bm.stores = StoreService.updateAndGetStores(bm.id, json);
    return bm;
  }

  Map<String, dynamic> toJson() => _$BaseModelToJson(this);

  void updateUi() {
    uiUpadateChannel.add(null);
  }

  DeviceLayout? _loadLayout() {
    if (cacheLoaded) return DeviceLayoutService.getCachedDeviceLayout(id, typeNames);
    cacheLoaded = true;
    DeviceLayoutService.getDeviceLayout(id, typeNames);
    return null;
  }
}
