import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_cloud_configuration.g.dart';

@JsonSerializable()
class AppCloudConfiguration {
  String host;
  int port;
  String key;
  String id;

  @JsonKey(ignore: true)
  bool loadedFromPersistentStorage = false;
  @JsonKey(ignore: true)
  late Uint8List keyBytes;

  AppCloudConfiguration(
    this.host,
    this.port,
    this.key,
    this.id,
  );
  factory AppCloudConfiguration.fromJson(final Map<String, dynamic> json) {
    final res = _$AppCloudConfigurationFromJson(json);
    res.keyBytes = base64Decode(res.key);
    return res;
  }

  Map<String, dynamic> toJson() => _$AppCloudConfigurationToJson(this);
}
