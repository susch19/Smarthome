import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/generic/stores/store_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smarthome/helper/iterable_extensions.dart';

part 'base_model.g.dart';

final baseModelProvider = StateProvider<List<BaseModel>>((final ref) => []);

final baseModelByIdProvider = Provider.family<BaseModel?, int>((final ref, final id) {
  final baseModels = ref.watch(baseModelProvider);
  return baseModels.firstOrNull((final bm) => bm.id == id);
});

// final baseModelChangedProvider = ChangeNotifierProvider.family<BaseModel?, int>((final ref, final id) {
//   return ref.watch(idBaseModelProvider(id));
// });

final baseModelFriendlyNameProvider = Provider.family<String?, int>((final ref, final id) {
  final baseModel = ref.watch(baseModelByIdProvider(id));
  return baseModel?.friendlyName;
});

final baseModelIsConnectedProvider = Provider.family<bool?, int>((final ref, final id) {
  final baseModel = ref.watch(baseModelByIdProvider(id));
  return baseModel?.isConnected;
});

final baseModelTypeNamesProvider = Provider.family<List<String>?, int>((final ref, final id) {
  final baseModel = ref.watch(baseModelByIdProvider(id));
  return baseModel?.typeNames;
});

final baseModelTypeNameProvider = Provider.family<String, int>((final ref, final id) {
  final baseModel = ref.watch(baseModelTypeNamesProvider(id));
  if (baseModel?.isEmpty ?? true) {
    return "";
  }
  return baseModel!.first;
});

const defaultList = <String>[];

@JsonSerializable()
@immutable
class BaseModel {
  final int id;
  final String friendlyName;
  final bool isConnected;

  // @JsonKey(ignore: true)
  final List<String> typeNames;

  @protected
  BaseModel getModelFromJson(final Map<String, dynamic> json) {
    return BaseModel.fromJson(json, defaultList);
  }

  BaseModel updateFromJson(final Map<String, dynamic> json) {
    final updatedModel = getModelFromJson(json);

    bool updated = StoreService.updateAndGetStores(id, json);
    if (updatedModel != this) {
      updated = true;
    }

    return updated ? updatedModel : this;
  }

  @protected
  bool updateModelFromJson(final Map<String, dynamic> json) {
    return false;
  }

  const BaseModel(this.id, this.friendlyName, this.isConnected, [this.typeNames = defaultList]);

  factory BaseModel.fromJson(final Map<String, dynamic> json, final List<String> typeNames) {
    final bm = BaseModel(json['id'] as int, json['friendlyName'] as String, json['isConnected'] as bool, typeNames);
    StoreService.updateAndGetStores(bm.id, json);
    return bm;
  }

  Map<String, dynamic> toJson() => _$BaseModelToJson(this);

  @override
  bool operator ==(final Object other) => other is BaseModel && other.id == id && other.friendlyName == friendlyName;

  @override
  int get hashCode => Object.hash(id, friendlyName);
}
