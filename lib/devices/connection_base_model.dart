import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/base_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'connection_base_model.g.dart';

@JsonSerializable()
@immutable
class ConnectionBaseModel extends BaseModel {
  final bool isConnected;
  static final isConnectedProvider =
      Provider.family<bool?, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    if (baseModel is ConnectionBaseModel) return baseModel.isConnected;
    return null;
  });

  const ConnectionBaseModel(
      super.id, super.friendlyName, super.typeName, this.isConnected);

  factory ConnectionBaseModel.fromJson(final Map<String, dynamic> json) =>
      _$ConnectionBaseModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ConnectionBaseModelToJson(this);
}
