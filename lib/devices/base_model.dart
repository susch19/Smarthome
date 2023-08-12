import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/generic/stores/store_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smarthome/helper/iterable_extensions.dart';

part 'base_model.g.dart';

final baseModelProvider = StateProvider<List<BaseModel>>((final ref) => []);

final baseModelASMapProvider = StateProvider<Map<int, BaseModel>>(
    (final ref) => ref.watch(baseModelProvider).toMap((final bm) => bm.id, (final bm) => bm));

final baseModelFriendlyNamesMapProvider = Provider<Map<int, String>>((final ref) {
  return ref.watch(baseModelProvider).toMap((final bm) => bm.id, (final bm) => bm.friendlyName);
});

const defaultList = <String>[];

@JsonSerializable()
@immutable
class BaseModel {
  static final byIdProvider = Provider.family<BaseModel?, int>((final ref, final id) {
    final baseModels = ref.watch(baseModelProvider);
    return baseModels.firstOrNull((final bm) => bm.id == id);
  });

  static final friendlyNameProvider = Provider.family<String, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    return baseModel?.friendlyName ?? "";
  });

  static final typeNamesProvider = Provider.family<List<String>?, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    return baseModel?.typeNames;
  });

  static final typeNameProvider = Provider.family<String, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.typeNamesProvider(id));
    if (baseModel?.isEmpty ?? true) {
      return "";
    }
    return baseModel!.first;
  });

  final int id;
  final String friendlyName;
  final String typeName;

  // @JsonKey(includeFromJson: false, includeToJson: false)
  final List<String> typeNames;

  @protected
  BaseModel getModelFromJson(final Map<String, dynamic> json) {
    return BaseModel.fromJson(json, defaultList);
  }

  BaseModel updateFromJson(final Map<String, dynamic> json) {
    final updatedModel = getModelFromJson(json);

    bool updated = false;
    if (updatedModel != this) {
      updated = true;
    }

    return updated ? updatedModel : this;
  }

  @protected
  bool updateModelFromJson(final Map<String, dynamic> json) {
    return false;
  }

  const BaseModel(this.id, this.friendlyName, this.typeName, [this.typeNames = defaultList]);

  factory BaseModel.fromJson(final Map<String, dynamic> json, final List<String> typeNames) {
    final bm = BaseModel(json['id'] as int, json['friendlyName'] as String, json['typeName'], typeNames);
    StoreService.updateAndGetStores(bm.id, json);
    return bm;
  }

  Map<String, dynamic> toJson() => _$BaseModelToJson(this);

  @override
  bool operator ==(final Object other) =>
      other is BaseModel && other.id == id && other.friendlyName == friendlyName && other.typeName == typeName;

  @override
  int get hashCode => Object.hash(id, friendlyName);
}
