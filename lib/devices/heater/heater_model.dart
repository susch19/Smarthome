import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/connection_base_model.dart';
import 'package:smarthome/devices/generic/stores/store_service.dart';
import 'package:smarthome/devices/heater/heater_config.dart';
import 'package:riverpod/riverpod.dart';

part 'heater_model.g.dart';

// These baseModel Providers should be moved to store architecture
//

@JsonSerializable()
@immutable
class HeaterModel extends ConnectionBaseModel {
  // final HeaterConfig? temperature;
  // final int? xiaomiTempSensor;
  // final HeaterConfig? currentConfig;
  // final HeaterConfig? currentCalibration;
  // @JsonKey(name: 'version')
  // final String? version;
  // final bool? disableLed;
  // final bool? disableHeating;
  // final String? logs;

  static final temperatureProvider = Provider.family<HeaterConfig?, int>((
    final ref,
    final id,
  ) {
    final temp = ref.watch(valueStoreChangedProvider("temperature", id))?.value;
    if (temp is Map<String, dynamic>) return HeaterConfig.fromJson(temp);
    return null;
  });
  static final currentConfigProvider = Provider.family<HeaterConfig?, int>((
    final ref,
    final id,
  ) {
    final temp = ref
        .watch(valueStoreChangedProvider("currentConfig", id))
        ?.value;
    if (temp is Map<String, dynamic>) return HeaterConfig.fromJson(temp);
    return null;
  });
  static final currentCalibrationProvider = Provider.family<HeaterConfig?, int>(
    (final ref, final id) {
      final temp = ref
          .watch(valueStoreChangedProvider("currentCalibration", id))
          ?.value;
      if (temp is Map<String, dynamic>) return HeaterConfig.fromJson(temp);
      return null;
    },
  );
  static final disableHeatingProvider = Provider.family<bool, int>((
    final ref,
    final id,
  ) {
    return ref.watch(valueStoreChangedProvider("disableHeating", id))?.value
            as bool? ??
        false;
  });
  static final disableLedProvider = Provider.family<bool, int>((
    final ref,
    final id,
  ) {
    return ref.watch(valueStoreChangedProvider("disableLed", id))?.value
            as bool? ??
        false;
  });
  static final versionProvider = Provider.family<String, int>((
    final ref,
    final id,
  ) {
    return ref.watch(valueStoreChangedProvider("version", id))?.value
            as String? ??
        "";
  });
  static final xiaomiProvider = Provider.family<int?, int>((
    final ref,
    final id,
  ) {
    return ref.watch(valueStoreChangedProvider("xiaomiTempSensor", id))?.value
        as int?;
  });
  static final logsProvider = Provider.family<String, int>((
    final ref,
    final id,
  ) {
    return ref.watch(valueStoreChangedProvider("logs", id))?.value as String? ??
        "";
  });

  const HeaterModel(
    super.id,
    super.friendlyName,
    super.typeName,
    super.isConnected,
    // this.temperature,
    // this.xiaomiTempSensor,
    // this.currentConfig,
    // this.currentCalibration,
    // this.version,
    // this.disableLed,
    // this.disableHeating,
    // this.logs,
  );

  factory HeaterModel.fromJson(final Map<String, dynamic> json) =>
      _$HeaterModelFromJson(json);

  @override
  HeaterModel getModelFromJson(final Map<String, dynamic> json) {
    return HeaterModel.fromJson(json);
  }

  // @override
  // bool updateModelFromJson(final Map<String, dynamic> json) {
  //   final updatedModel = getModelFromJson(json);
  //   bool updated = false;
  //   if (updatedModel != this) {
  //     updated = true;
  //   }

  //   return updated ? updatedModel : this;
  // }

  @override
  Map<String, dynamic> toJson() => _$HeaterModelToJson(this);

  @override
  bool operator ==(final Object other) =>
      other is HeaterModel &&
      other.id == id &&
      other.friendlyName ==
          friendlyName //&&
  // other.disableHeating == disableHeating &&
  // other.disableLed == disableLed &&
  // other.version == version &&
  // xiaomiTempSensor == other.xiaomiTempSensor &&
  // currentCalibration == other.currentCalibration &&
  // currentConfig == other.currentConfig &&
  // temperature == other.temperature &&
  // logs == other.logs
  ;

  @override
  int get hashCode => Object.hash(
    id,
    friendlyName,
    // disableHeating,
    // disableLed,
    // version,
    // xiaomiTempSensor,
    // currentCalibration,
    // currentConfig,
    // temperature,
    // logs,
  );

  HeaterModel copyWith({
    final int? id,
    final String? friendlyName,
    final String? typeName,
    final bool? isConnected,
    // final bool? disableHeating,
    // final bool? disableLed,
    // final String? version,
    // final int? xiaomiTempSensor,
    // final HeaterConfig? temperature,
    // final HeaterConfig? currentConfig,
    // final HeaterConfig? currentCalibration,
    // final String? logs,
  }) {
    return HeaterModel(
      id ?? this.id,
      friendlyName ?? this.friendlyName,
      typeName ?? this.typeName,
      isConnected ?? this.isConnected,
      // temperature ?? this.temperature,
      // xiaomiTempSensor ?? this.xiaomiTempSensor,
      // currentConfig ?? this.currentConfig,
      // currentCalibration ?? this.currentCalibration,
      // version ?? this.version,
      // disableLed ?? this.disableLed,
      // disableHeating ?? this.disableHeating,
      // logs ?? this.logs,
    );
  }
}
