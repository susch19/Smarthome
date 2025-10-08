import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smarthome/helper/iterable_extensions.dart';

part 'base_model.g.dart';

@Riverpod(keepAlive: true)
class BaseModels extends _$BaseModels {
  @override
  List<BaseModel> build() {
    return [];
  }

  void storeModels(final List<BaseModel> baseModels) {
    final oldState = state.toList();
    for (final element in baseModels) {
      if (oldState.indexWhere((final x) => x.id == element.id)
          case final int index when index > -1) {
        oldState[index] = element;
      } else {
        oldState.add(element);
      }
    }
    state = oldState;
  }
}

final baseModelASMapProvider = Provider<Map<int, BaseModel>>((final ref) =>
    ref.watch(baseModelsProvider).toMap((final bm) => bm.id, (final bm) => bm));

final baseModelFriendlyNamesMapProvider =
    Provider<Map<int, String>>((final ref) {
  return ref
      .watch(baseModelsProvider)
      .toMap((final bm) => bm.id, (final bm) => bm.friendlyName);
});

const defaultList = <String>[];

@JsonSerializable()
@immutable
class BaseModel {
  static final byIdProvider =
      Provider.family<BaseModel?, int>((final ref, final id) {
    final baseModels = ref.watch(baseModelsProvider);
    return baseModels.firstOrDefault((final bm) => bm.id == id);
  });

  static final friendlyNameProvider =
      Provider.family<String, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    return baseModel?.friendlyName ?? "";
  });

  static final typeNamesProvider =
      Provider.family<List<String>?, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    return baseModel?.typeNames;
  });

  static final typeNameProvider =
      Provider.family<String, int>((final ref, final id) {
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
  final Map<String, dynamic>? dynamicStateData;

  @protected
  BaseModel getModelFromJson(final Map<String, dynamic> json) {
    return BaseModel.fromJson(json, defaultList);
  }

  BaseModel mergeWith(final BaseModel updatedModel) {
    bool updated = false;
    if (updatedModel != this) {
      updated = true;
    }

    return updated ? updatedModel : this;
  }

  const BaseModel(this.id, this.friendlyName, this.typeName,
      {this.typeNames = defaultList, this.dynamicStateData = const {}});

  factory BaseModel.fromJson(
      final Map<String, dynamic> json, final List<String> typeNames) {
    final bm = BaseModel(json['id'] as int,
        json['friendlyName'] as String? ?? "", json['typeName'],
        typeNames: typeNames, dynamicStateData: json["dynamicStateData"]);
    return bm;
  }

  Map<String, dynamic> toJson() => _$BaseModelToJson(this);

  @override
  bool operator ==(final Object other) =>
      other is BaseModel &&
      other.id == id &&
      other.friendlyName == friendlyName &&
      other.typeName == typeName;

  @override
  int get hashCode => Object.hash(id, friendlyName);
}
