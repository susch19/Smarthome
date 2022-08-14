import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/base_model.dart';
import 'package:smarthome/devices/connection_base_model.dart';
import 'package:smarthome/devices/heater/heater_config.dart';
import 'package:riverpod/riverpod.dart';

part 'heater_model.g.dart';

@JsonSerializable()
@immutable
class HeaterModel extends ConnectionBaseModel {
  final HeaterConfig? temperature;
  final int? xiaomiTempSensor;
  final HeaterConfig? currentConfig;
  final HeaterConfig? currentCalibration;
  @JsonKey(name: 'version')
  final String? version;
  final bool? disableLed;
  final bool? disableHeating;

  static final temperatureProvider = Provider.family<HeaterConfig?, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    if (baseModel is HeaterModel) return baseModel.temperature;
    return null;
  });
  static final currentConfigProvider = Provider.family<HeaterConfig?, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    if (baseModel is HeaterModel) return baseModel.currentConfig;
    return null;
  });
  static final currentCalibrationProvider = Provider.family<HeaterConfig?, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    if (baseModel is HeaterModel) return baseModel.currentCalibration;
    return null;
  });
  static final disableHeatingProvider = Provider.family<bool, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    if (baseModel is! HeaterModel) return false;
    return baseModel.disableHeating ?? false;
  });
  static final disableLedProvider = Provider.family<bool, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    if (baseModel is! HeaterModel) return false;
    return baseModel.disableHeating ?? false;
  });
  static final versionProvider = Provider.family<String, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    if (baseModel is! HeaterModel) return "";
    return baseModel.version ?? "";
  });
  static final xiaomiProvider = Provider.family<int?, int>((final ref, final id) {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    if (baseModel is! HeaterModel) return null;
    return baseModel.xiaomiTempSensor;
  });

  const HeaterModel(
    final int id,
    final String friendlyName,
    final bool isConnected,
    this.temperature,
    this.xiaomiTempSensor,
    this.currentConfig,
    this.currentCalibration,
    this.version,
    this.disableLed,
    this.disableHeating,
  ) : super(id, friendlyName, isConnected);

  factory HeaterModel.fromJson(final Map<String, dynamic> json) => _$HeaterModelFromJson(json);

  @override
  HeaterModel getModelFromJson(final Map<String, dynamic> json) {
    return HeaterModel.fromJson(json);
  }

  @override
  BaseModel updateFromJson(final Map<String, dynamic> json) {
    final updatedModel = getModelFromJson(json);
    bool updated = false;
    if (updatedModel != this) {
      updated = true;
    }
    return updated ? updatedModel : this;
  }

  @override
  Map<String, dynamic> toJson() => _$HeaterModelToJson(this);

  @override
  bool operator ==(final Object other) =>
      other is HeaterModel &&
      other.id == id &&
      other.friendlyName == friendlyName &&
      other.disableHeating == disableHeating &&
      other.disableLed == disableLed &&
      other.version == version &&
      xiaomiTempSensor == other.xiaomiTempSensor &&
      currentCalibration == other.currentCalibration &&
      currentConfig == other.currentConfig &&
      temperature == other.temperature;

  @override
  int get hashCode => Object.hash(id, friendlyName, disableHeating, disableLed, version, xiaomiTempSensor,
      currentCalibration, currentConfig, temperature);

  HeaterModel copyWith(
      {final int? id,
      final String? friendlyName,
      final bool? isConnected,
      final bool? disableHeating,
      final bool? disableLed,
      final String? version,
      final int? xiaomiTempSensor,
      final HeaterConfig? temperature,
      final HeaterConfig? currentConfig,
      final HeaterConfig? currentCalibration}) {
    return HeaterModel(
      id ?? this.id,
      friendlyName ?? this.friendlyName,
      isConnected ?? this.isConnected,
      temperature ?? this.temperature,
      xiaomiTempSensor ?? this.xiaomiTempSensor,
      currentConfig ?? this.currentConfig,
      currentCalibration ?? this.currentCalibration,
      version ?? this.version,
      disableLed ?? this.disableLed,
      disableHeating ?? this.disableHeating,
    );
  }
}
