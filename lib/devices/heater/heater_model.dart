import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/devices/base_model.dart';
import 'package:smarthome/devices/heater/heater_config.dart';

part 'heater_model.g.dart';

@JsonSerializable()
@immutable
class HeaterModel extends BaseModel {
  final HeaterConfig? temperature;
  final int? xiaomiTempSensor;
  final HeaterConfig? currentConfig;
  final HeaterConfig? currentCalibration;
  @JsonKey(name: 'version')
  final String? version;
  final bool? disableLed;
  final bool? disableHeating;

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
  Map<String, dynamic> toJson() => _$HeaterModelToJson(this);

  @override
  bool operator ==(final Object other) =>
      other is HeaterModel &&
      other.id == id &&
      other.friendlyName == friendlyName &&
      other.disableHeating == disableHeating &&
      other.disableLed == disableLed &&
      other.version == version &&
      xiaomiTempSensor == other.xiaomiTempSensor;

  @override
  int get hashCode => Object.hash(id, friendlyName, disableHeating, disableLed, version, xiaomiTempSensor);

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
