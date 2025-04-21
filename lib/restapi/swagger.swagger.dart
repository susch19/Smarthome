// ignore_for_file: type=lint

import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';
import 'dart:convert';

import '../devices/device_exporter.dart';
import 'package:chopper/chopper.dart';

import 'client_mapping.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show MultipartFile;
import 'package:chopper/chopper.dart' as chopper;
import 'swagger.enums.swagger.dart' as enums;
export 'swagger.enums.swagger.dart';

part 'swagger.swagger.chopper.dart';
part 'swagger.swagger.g.dart';

// **************************************************************************
// SwaggerChopperGenerator
// **************************************************************************

@ChopperApi()
abstract class Swagger extends ChopperService {
  static Swagger create({
    ChopperClient? client,
    http.Client? httpClient,
    Authenticator? authenticator,
    ErrorConverter? errorConverter,
    Converter? converter,
    Uri? baseUrl,
    List<Interceptor>? interceptors,
  }) {
    if (client != null) {
      return _$Swagger(client);
    }

    final newClient = ChopperClient(
        services: [_$Swagger()],
        converter: converter ?? $JsonSerializableConverter(),
        interceptors: interceptors ?? [],
        client: httpClient,
        authenticator: authenticator,
        errorConverter: errorConverter,
        baseUrl: baseUrl ?? Uri.parse('http://localhost:5056'));
    return _$Swagger(newClient);
  }

  ///
  ///@param id
  Future<chopper.Response<List<int>>> deviceRebuildIdPatch({required int? id}) {
    return _deviceRebuildIdPatch(id: id);
  }

  ///
  ///@param id
  @Patch(
    path: '/device/rebuild/{id}',
    optionalBody: true,
  )
  Future<chopper.Response<List<int>>> _deviceRebuildIdPatch(
      {@Path('id') required int? id});

  ///
  ///@param onlyNew
  Future<chopper.Response<List<int>>> devicePatch({bool? onlyNew}) {
    return _devicePatch(onlyNew: onlyNew);
  }

  ///
  ///@param onlyNew
  @Patch(
    path: '/device',
    optionalBody: true,
  )
  Future<chopper.Response<List<int>>> _devicePatch(
      {@Query('onlyNew') bool? onlyNew});

  ///
  ///@param deviceCreate
  Future<chopper.Response<List<int>>> devicePut(
      {required RestCreatedDevice? deviceCreate}) {
    return _devicePut(deviceCreate: deviceCreate);
  }

  ///
  ///@param deviceCreate
  @Put(path: '/device')
  Future<chopper.Response<List<int>>> _devicePut(
      {@Body() required RestCreatedDevice? deviceCreate});

  ///
  ///@param includeState
  Future<chopper.Response<List<int>>> deviceGet({bool? includeState}) {
    return _deviceGet(includeState: includeState);
  }

  ///
  ///@param includeState
  @Get(path: '/device')
  Future<chopper.Response<List<int>>> _deviceGet(
      {@Query('includeState') bool? includeState});

  ///
  ///@param id
  Future<chopper.Response<List<int>>> deviceStatesIdGet({required int? id}) {
    return _deviceStatesIdGet(id: id);
  }

  ///
  ///@param id
  @Get(path: '/device/states/{id}')
  Future<chopper.Response<List<int>>> _deviceStatesIdGet(
      {@Path('id') required int? id});

  ///
  ///@param id
  Future<chopper.Response<List<int>>> deviceStatesIdPost({required int? id}) {
    return _deviceStatesIdPost(id: id);
  }

  ///
  ///@param id
  @Post(
    path: '/device/states/{id}',
    optionalBody: true,
  )
  Future<chopper.Response<List<int>>> _deviceStatesIdPost(
      {@Path('id') required int? id});

  ///
  ///@param id
  ///@param from
  ///@param to
  ///@param propName
  Future<chopper.Response<List<int>>> deviceHistoryIdGet({
    required int? id,
    required DateTime? from,
    required DateTime? to,
    required String? propName,
  }) {
    return _deviceHistoryIdGet(id: id, from: from, to: to, propName: propName);
  }

  ///
  ///@param id
  ///@param from
  ///@param to
  ///@param propName
  @Get(path: '/device/history/{id}')
  Future<chopper.Response<List<int>>> _deviceHistoryIdGet({
    @Path('id') required int? id,
    @Query('from') required DateTime? from,
    @Query('to') required DateTime? to,
    @Query('propName') required String? propName,
  });

  ///
  ///@param id
  ///@param name
  Future<chopper.Response<List<int>>> deviceStateIdNameGet({
    required int? id,
    required String? name,
  }) {
    return _deviceStateIdNameGet(id: id, name: name);
  }

  ///
  ///@param id
  ///@param name
  @Get(path: '/device/state/{id}/{name}')
  Future<chopper.Response<List<int>>> _deviceStateIdNameGet({
    @Path('id') required int? id,
    @Path('name') required String? name,
  });

  ///
  ///@param id
  Future<chopper.Response<List<int>>> deviceStateIdPost({required int? id}) {
    return _deviceStateIdPost(id: id);
  }

  ///
  ///@param id
  @Post(
    path: '/device/state/{id}',
    optionalBody: true,
  )
  Future<chopper.Response<List<int>>> _deviceStateIdPost(
      {@Path('id') required int? id});

  ///
  Future<chopper.Response<AppCloudConfiguration>> securityGet() {
    generatedMapping.putIfAbsent(
        AppCloudConfiguration, () => AppCloudConfiguration.fromJsonFactory);

    return _securityGet();
  }

  ///
  @Get(path: '/security')
  Future<chopper.Response<AppCloudConfiguration>> _securityGet();

  ///
  ///@param name
  Future<chopper.Response<String>> appGet({required String? name}) {
    return _appGet(name: name);
  }

  ///
  ///@param name
  @Get(path: '/app')
  Future<chopper.Response<String>> _appGet(
      {@Query('name') required String? name});

  ///
  ///@param id
  ///@param newName
  Future<chopper.Response> appPatch({
    required String? id,
    required String? newName,
  }) {
    return _appPatch(id: id, newName: newName);
  }

  ///
  ///@param id
  ///@param newName
  @Patch(
    path: '/app',
    optionalBody: true,
  )
  Future<chopper.Response> _appPatch({
    @Query('id') required String? id,
    @Query('newName') required String? newName,
  });

  ///
  ///@param id
  ///@param key
  Future<chopper.Response<String>> appSettingsGet({
    required String? id,
    required String? key,
  }) {
    return _appSettingsGet(id: id, key: key);
  }

  ///
  ///@param id
  ///@param key
  @Get(path: '/app/settings')
  Future<chopper.Response<String>> _appSettingsGet({
    @Query('id') required String? id,
    @Query('key') required String? key,
  });

  ///
  ///@param id
  ///@param key
  ///@param value
  Future<chopper.Response<String>> appSettingsPost({
    required String? id,
    required String? key,
    required String? $value,
  }) {
    return _appSettingsPost(id: id, key: key, $value: $value);
  }

  ///
  ///@param id
  ///@param key
  ///@param value
  @Post(
    path: '/app/settings',
    optionalBody: true,
  )
  Future<chopper.Response<String>> _appSettingsPost({
    @Query('id') required String? id,
    @Query('key') required String? key,
    @Query('value') required String? $value,
  });

  ///
  Future<chopper.Response<List<Device>>> appDeviceGet() {
    generatedMapping.putIfAbsent(Device, () => Device.fromJsonFactory);

    return _appDeviceGet();
  }

  ///
  @Get(path: '/app/device')
  Future<chopper.Response<List<Device>>> _appDeviceGet();

  ///
  ///@param request
  Future<chopper.Response> appDevicePatch(
      {required DeviceRenameRequest? request}) {
    generatedMapping.putIfAbsent(
        DeviceRenameRequest, () => DeviceRenameRequest.fromJsonFactory);

    return _appDevicePatch(request: request);
  }

  ///
  ///@param request
  @Patch(path: '/app/device')
  Future<chopper.Response> _appDevicePatch(
      {@Body() required DeviceRenameRequest? request});

  ///
  ///@param onlyShowInApp
  Future<chopper.Response<List<DeviceOverview>>> appDeviceOverviewGet(
      {bool? onlyShowInApp}) {
    generatedMapping.putIfAbsent(
        DeviceOverview, () => DeviceOverview.fromJsonFactory);

    return _appDeviceOverviewGet(onlyShowInApp: onlyShowInApp);
  }

  ///
  ///@param onlyShowInApp
  @Get(path: '/app/device/overview')
  Future<chopper.Response<List<DeviceOverview>>> _appDeviceOverviewGet(
      {@Query('onlyShowInApp') bool? onlyShowInApp});

  ///
  Future<chopper.Response<List<HistoryPropertyState>>> appHistorySettingsGet() {
    generatedMapping.putIfAbsent(
        HistoryPropertyState, () => HistoryPropertyState.fromJsonFactory);

    return _appHistorySettingsGet();
  }

  ///
  @Get(path: '/app/history/settings')
  Future<chopper.Response<List<HistoryPropertyState>>> _appHistorySettingsGet();

  ///
  ///@param request
  Future<chopper.Response> appHistoryPatch(
      {required SetHistoryRequest? request}) {
    generatedMapping.putIfAbsent(
        SetHistoryRequest, () => SetHistoryRequest.fromJsonFactory);

    return _appHistoryPatch(request: request);
  }

  ///
  ///@param request
  @Patch(path: '/app/history')
  Future<chopper.Response> _appHistoryPatch(
      {@Body() required SetHistoryRequest? request});

  ///
  ///@param id
  ///@param dt
  Future<chopper.Response<List<History>>> appHistoryGet({
    required int? id,
    required DateTime? dt,
  }) {
    generatedMapping.putIfAbsent(History, () => History.fromJsonFactory);

    return _appHistoryGet(id: id, dt: dt);
  }

  ///
  ///@param id
  ///@param dt
  @Get(path: '/app/history')
  Future<chopper.Response<List<History>>> _appHistoryGet({
    @Query('id') required int? id,
    @Query('dt') required DateTime? dt,
  });

  ///
  ///@param id
  ///@param from
  ///@param to
  ///@param propertyName
  Future<chopper.Response<History>> appHistoryRangeGet({
    required int? id,
    required DateTime? from,
    required DateTime? to,
    required String? propertyName,
  }) {
    generatedMapping.putIfAbsent(History, () => History.fromJsonFactory);

    return _appHistoryRangeGet(
        id: id, from: from, to: to, propertyName: propertyName);
  }

  ///
  ///@param id
  ///@param from
  ///@param to
  ///@param propertyName
  @Get(path: '/app/history/range')
  Future<chopper.Response<History>> _appHistoryRangeGet({
    @Query('id') required int? id,
    @Query('from') required DateTime? from,
    @Query('to') required DateTime? to,
    @Query('propertyName') required String? propertyName,
  });

  ///
  ///@param TypeName
  ///@param IconName
  ///@param DeviceId
  Future<chopper.Response<LayoutResponse>> appLayoutSingleGet({
    required String? typeName,
    required String? iconName,
    required int? deviceId,
  }) {
    generatedMapping.putIfAbsent(
        LayoutResponse, () => LayoutResponse.fromJsonFactory);

    return _appLayoutSingleGet(
        typeName: typeName, iconName: iconName, deviceId: deviceId);
  }

  ///
  ///@param TypeName
  ///@param IconName
  ///@param DeviceId
  @Get(path: '/app/layout/single')
  Future<chopper.Response<LayoutResponse>> _appLayoutSingleGet({
    @Query('TypeName') required String? typeName,
    @Query('IconName') required String? iconName,
    @Query('DeviceId') required int? deviceId,
  });

  ///
  ///@param request
  Future<chopper.Response<List<LayoutResponse>>> appLayoutMultiGet(
      {required List<dynamic>? request}) {
    generatedMapping.putIfAbsent(
        LayoutRequest, () => LayoutRequest.fromJsonFactory);
    generatedMapping.putIfAbsent(
        LayoutResponse, () => LayoutResponse.fromJsonFactory);

    return _appLayoutMultiGet(request: request);
  }

  ///
  ///@param request
  @Get(path: '/app/layout/multi')
  Future<chopper.Response<List<LayoutResponse>>> _appLayoutMultiGet(
      {@Query('request') required List<dynamic>? request});

  ///
  Future<chopper.Response<List<LayoutResponse>>> appLayoutAllGet() {
    generatedMapping.putIfAbsent(
        LayoutResponse, () => LayoutResponse.fromJsonFactory);

    return _appLayoutAllGet();
  }

  ///
  @Get(path: '/app/layout/all')
  Future<chopper.Response<List<LayoutResponse>>> _appLayoutAllGet();

  ///
  ///@param name
  Future<chopper.Response<SvgIcon>> appLayoutIconByNameGet(
      {required String? name}) {
    generatedMapping.putIfAbsent(SvgIcon, () => SvgIcon.fromJsonFactory);

    return _appLayoutIconByNameGet(name: name);
  }

  ///
  ///@param name
  @Get(path: '/app/layout/iconByName')
  Future<chopper.Response<SvgIcon>> _appLayoutIconByNameGet(
      {@Query('name') required String? name});

  ///
  Future<chopper.Response> appLayoutPatch() {
    return _appLayoutPatch();
  }

  ///
  @Patch(
    path: '/app/layout',
    optionalBody: true,
  )
  Future<chopper.Response> _appLayoutPatch();

  ///
  ///@param message
  Future<chopper.Response> appSmarthomePost(
      {required JsonApiSmarthomeMessage? message}) {
    return _appSmarthomePost(message: message);
  }

  ///
  ///@param message
  @Post(path: '/app/smarthome')
  Future<chopper.Response> _appSmarthomePost(
      {@Body() required JsonApiSmarthomeMessage? message});

  ///
  ///@param deviceId
  Future<chopper.Response<List<int>>> appSmarthomeGet(
      {required int? deviceId}) {
    return _appSmarthomeGet(deviceId: deviceId);
  }

  ///
  ///@param deviceId
  @Get(path: '/app/smarthome')
  Future<chopper.Response<List<int>>> _appSmarthomeGet(
      {@Query('deviceId') required int? deviceId});

  ///
  ///@param logLines
  Future<chopper.Response> appSmarthomeLogPost(
      {required List<AppLog>? logLines}) {
    return _appSmarthomeLogPost(logLines: logLines);
  }

  ///
  ///@param logLines
  @Post(path: '/app/smarthome/log')
  Future<chopper.Response> _appSmarthomeLogPost(
      {@Body() required List<AppLog>? logLines});

  ///
  ///@param notification
  Future<chopper.Response<List<int>>> notificationSendNotificationPost(
      {required AppNotification? notification}) {
    generatedMapping.putIfAbsent(
        AppNotification, () => AppNotification.fromJsonFactory);

    return _notificationSendNotificationPost(notification: notification);
  }

  ///
  ///@param notification
  @Post(path: '/notification/sendNotification')
  Future<chopper.Response<List<int>>> _notificationSendNotificationPost(
      {@Body() required AppNotification? notification});

  ///
  Future<chopper.Response<Object>> notificationFirebaseOptionsGet() {
    return _notificationFirebaseOptionsGet();
  }

  ///
  @Get(path: '/notification/firebaseOptions')
  Future<chopper.Response<Object>> _notificationFirebaseOptionsGet();

  ///
  ///@param uniqueName
  ///@param deviceId
  Future<chopper.Response<String>> notificationNextNotificationIdGet({
    required String? uniqueName,
    required int? deviceId,
  }) {
    return _notificationNextNotificationIdGet(
        uniqueName: uniqueName, deviceId: deviceId);
  }

  ///
  ///@param uniqueName
  ///@param deviceId
  @Get(path: '/notification/nextNotificationId')
  Future<chopper.Response<String>> _notificationNextNotificationIdGet({
    @Query('uniqueName') required String? uniqueName,
    @Query('deviceId') required int? deviceId,
  });

  ///
  Future<chopper.Response<AllOneTimeNotifications>>
      notificationAllOneTimeNotificationsGet() {
    generatedMapping.putIfAbsent(
        AllOneTimeNotifications, () => AllOneTimeNotifications.fromJsonFactory);

    return _notificationAllOneTimeNotificationsGet();
  }

  ///
  @Get(path: '/notification/allOneTimeNotifications')
  Future<chopper.Response<AllOneTimeNotifications>>
      _notificationAllOneTimeNotificationsGet();
}

@JsonSerializable(explicitToJson: true)
class RestCreatedDevice {
  const RestCreatedDevice({
    required this.typeNames,
    required this.id,
    required this.typeName,
    required this.friendlyName,
    required this.startAutomatically,
  });

  factory RestCreatedDevice.fromJson(Map<String, dynamic> json) =>
      _$RestCreatedDeviceFromJson(json);

  static const toJsonFactory = _$RestCreatedDeviceToJson;
  Map<String, dynamic> toJson() => _$RestCreatedDeviceToJson(this);

  @JsonKey(name: 'typeNames', defaultValue: <String>[])
  final List<String> typeNames;
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'typeName')
  final String typeName;
  @JsonKey(name: 'friendlyName')
  final String friendlyName;
  @JsonKey(name: 'startAutomatically')
  final bool startAutomatically;
  static const fromJsonFactory = _$RestCreatedDeviceFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RestCreatedDevice &&
            (identical(other.typeNames, typeNames) ||
                const DeepCollectionEquality()
                    .equals(other.typeNames, typeNames)) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.typeName, typeName) ||
                const DeepCollectionEquality()
                    .equals(other.typeName, typeName)) &&
            (identical(other.friendlyName, friendlyName) ||
                const DeepCollectionEquality()
                    .equals(other.friendlyName, friendlyName)) &&
            (identical(other.startAutomatically, startAutomatically) ||
                const DeepCollectionEquality()
                    .equals(other.startAutomatically, startAutomatically)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(typeNames) ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(typeName) ^
      const DeepCollectionEquality().hash(friendlyName) ^
      const DeepCollectionEquality().hash(startAutomatically) ^
      runtimeType.hashCode;
}

extension $RestCreatedDeviceExtension on RestCreatedDevice {
  RestCreatedDevice copyWith(
      {List<String>? typeNames,
      int? id,
      String? typeName,
      String? friendlyName,
      bool? startAutomatically}) {
    return RestCreatedDevice(
        typeNames: typeNames ?? this.typeNames,
        id: id ?? this.id,
        typeName: typeName ?? this.typeName,
        friendlyName: friendlyName ?? this.friendlyName,
        startAutomatically: startAutomatically ?? this.startAutomatically);
  }

  RestCreatedDevice copyWithWrapped(
      {Wrapped<List<String>>? typeNames,
      Wrapped<int>? id,
      Wrapped<String>? typeName,
      Wrapped<String>? friendlyName,
      Wrapped<bool>? startAutomatically}) {
    return RestCreatedDevice(
        typeNames: (typeNames != null ? typeNames.value : this.typeNames),
        id: (id != null ? id.value : this.id),
        typeName: (typeName != null ? typeName.value : this.typeName),
        friendlyName:
            (friendlyName != null ? friendlyName.value : this.friendlyName),
        startAutomatically: (startAutomatically != null
            ? startAutomatically.value
            : this.startAutomatically));
  }
}

@JsonSerializable(explicitToJson: true)
class JavaScriptDevice {
  const JavaScriptDevice({
    required this.typeNames,
    required this.id,
    required this.typeName,
    required this.friendlyName,
    required this.startAutomatically,
  });

  factory JavaScriptDevice.fromJson(Map<String, dynamic> json) =>
      _$JavaScriptDeviceFromJson(json);

  static const toJsonFactory = _$JavaScriptDeviceToJson;
  Map<String, dynamic> toJson() => _$JavaScriptDeviceToJson(this);

  @JsonKey(name: 'typeNames', defaultValue: <String>[])
  final List<String> typeNames;
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'typeName')
  final String typeName;
  @JsonKey(name: 'friendlyName')
  final String friendlyName;
  @JsonKey(name: 'startAutomatically')
  final bool startAutomatically;
  static const fromJsonFactory = _$JavaScriptDeviceFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is JavaScriptDevice &&
            (identical(other.typeNames, typeNames) ||
                const DeepCollectionEquality()
                    .equals(other.typeNames, typeNames)) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.typeName, typeName) ||
                const DeepCollectionEquality()
                    .equals(other.typeName, typeName)) &&
            (identical(other.friendlyName, friendlyName) ||
                const DeepCollectionEquality()
                    .equals(other.friendlyName, friendlyName)) &&
            (identical(other.startAutomatically, startAutomatically) ||
                const DeepCollectionEquality()
                    .equals(other.startAutomatically, startAutomatically)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(typeNames) ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(typeName) ^
      const DeepCollectionEquality().hash(friendlyName) ^
      const DeepCollectionEquality().hash(startAutomatically) ^
      runtimeType.hashCode;
}

extension $JavaScriptDeviceExtension on JavaScriptDevice {
  JavaScriptDevice copyWith(
      {List<String>? typeNames,
      int? id,
      String? typeName,
      String? friendlyName,
      bool? startAutomatically}) {
    return JavaScriptDevice(
        typeNames: typeNames ?? this.typeNames,
        id: id ?? this.id,
        typeName: typeName ?? this.typeName,
        friendlyName: friendlyName ?? this.friendlyName,
        startAutomatically: startAutomatically ?? this.startAutomatically);
  }

  JavaScriptDevice copyWithWrapped(
      {Wrapped<List<String>>? typeNames,
      Wrapped<int>? id,
      Wrapped<String>? typeName,
      Wrapped<String>? friendlyName,
      Wrapped<bool>? startAutomatically}) {
    return JavaScriptDevice(
        typeNames: (typeNames != null ? typeNames.value : this.typeNames),
        id: (id != null ? id.value : this.id),
        typeName: (typeName != null ? typeName.value : this.typeName),
        friendlyName:
            (friendlyName != null ? friendlyName.value : this.friendlyName),
        startAutomatically: (startAutomatically != null
            ? startAutomatically.value
            : this.startAutomatically));
  }
}

@JsonSerializable(explicitToJson: true)
class AppCloudConfiguration {
  const AppCloudConfiguration({
    required this.host,
    required this.port,
    required this.key,
    required this.id,
  });

  factory AppCloudConfiguration.fromJson(Map<String, dynamic> json) =>
      _$AppCloudConfigurationFromJson(json);

  static const toJsonFactory = _$AppCloudConfigurationToJson;
  Map<String, dynamic> toJson() => _$AppCloudConfigurationToJson(this);

  @JsonKey(name: 'host')
  final String host;
  @JsonKey(name: 'port')
  final int port;
  @JsonKey(name: 'key')
  final String key;
  @JsonKey(name: 'id')
  final String id;
  static const fromJsonFactory = _$AppCloudConfigurationFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AppCloudConfiguration &&
            (identical(other.host, host) ||
                const DeepCollectionEquality().equals(other.host, host)) &&
            (identical(other.port, port) ||
                const DeepCollectionEquality().equals(other.port, port)) &&
            (identical(other.key, key) ||
                const DeepCollectionEquality().equals(other.key, key)) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(host) ^
      const DeepCollectionEquality().hash(port) ^
      const DeepCollectionEquality().hash(key) ^
      const DeepCollectionEquality().hash(id) ^
      runtimeType.hashCode;
}

extension $AppCloudConfigurationExtension on AppCloudConfiguration {
  AppCloudConfiguration copyWith(
      {String? host, int? port, String? key, String? id}) {
    return AppCloudConfiguration(
        host: host ?? this.host,
        port: port ?? this.port,
        key: key ?? this.key,
        id: id ?? this.id);
  }

  AppCloudConfiguration copyWithWrapped(
      {Wrapped<String>? host,
      Wrapped<int>? port,
      Wrapped<String>? key,
      Wrapped<String>? id}) {
    return AppCloudConfiguration(
        host: (host != null ? host.value : this.host),
        port: (port != null ? port.value : this.port),
        key: (key != null ? key.value : this.key),
        id: (id != null ? id.value : this.id));
  }
}

@JsonSerializable(explicitToJson: true)
class DeviceOverview {
  const DeviceOverview({
    required this.id,
    required this.friendlyName,
    required this.typeName,
    required this.typeNames,
  });

  factory DeviceOverview.fromJson(Map<String, dynamic> json) =>
      _$DeviceOverviewFromJson(json);

  static const toJsonFactory = _$DeviceOverviewToJson;
  Map<String, dynamic> toJson() => _$DeviceOverviewToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'friendlyName')
  final String friendlyName;
  @JsonKey(name: 'typeName')
  final String typeName;
  @JsonKey(name: 'typeNames', defaultValue: <String>[])
  final List<String> typeNames;
  static const fromJsonFactory = _$DeviceOverviewFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DeviceOverview &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.friendlyName, friendlyName) ||
                const DeepCollectionEquality()
                    .equals(other.friendlyName, friendlyName)) &&
            (identical(other.typeName, typeName) ||
                const DeepCollectionEquality()
                    .equals(other.typeName, typeName)) &&
            (identical(other.typeNames, typeNames) ||
                const DeepCollectionEquality()
                    .equals(other.typeNames, typeNames)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(friendlyName) ^
      const DeepCollectionEquality().hash(typeName) ^
      const DeepCollectionEquality().hash(typeNames) ^
      runtimeType.hashCode;
}

extension $DeviceOverviewExtension on DeviceOverview {
  DeviceOverview copyWith(
      {int? id,
      String? friendlyName,
      String? typeName,
      List<String>? typeNames}) {
    return DeviceOverview(
        id: id ?? this.id,
        friendlyName: friendlyName ?? this.friendlyName,
        typeName: typeName ?? this.typeName,
        typeNames: typeNames ?? this.typeNames);
  }

  DeviceOverview copyWithWrapped(
      {Wrapped<int>? id,
      Wrapped<String>? friendlyName,
      Wrapped<String>? typeName,
      Wrapped<List<String>>? typeNames}) {
    return DeviceOverview(
        id: (id != null ? id.value : this.id),
        friendlyName:
            (friendlyName != null ? friendlyName.value : this.friendlyName),
        typeName: (typeName != null ? typeName.value : this.typeName),
        typeNames: (typeNames != null ? typeNames.value : this.typeNames));
  }
}

@JsonSerializable(explicitToJson: true)
class DeviceRenameRequest {
  const DeviceRenameRequest({
    required this.id,
    required this.newName,
  });

  factory DeviceRenameRequest.fromJson(Map<String, dynamic> json) =>
      _$DeviceRenameRequestFromJson(json);

  static const toJsonFactory = _$DeviceRenameRequestToJson;
  Map<String, dynamic> toJson() => _$DeviceRenameRequestToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'newName')
  final String newName;
  static const fromJsonFactory = _$DeviceRenameRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DeviceRenameRequest &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.newName, newName) ||
                const DeepCollectionEquality().equals(other.newName, newName)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(newName) ^
      runtimeType.hashCode;
}

extension $DeviceRenameRequestExtension on DeviceRenameRequest {
  DeviceRenameRequest copyWith({int? id, String? newName}) {
    return DeviceRenameRequest(
        id: id ?? this.id, newName: newName ?? this.newName);
  }

  DeviceRenameRequest copyWithWrapped(
      {Wrapped<int>? id, Wrapped<String>? newName}) {
    return DeviceRenameRequest(
        id: (id != null ? id.value : this.id),
        newName: (newName != null ? newName.value : this.newName));
  }
}

@JsonSerializable(explicitToJson: true)
class HistoryPropertyState {
  const HistoryPropertyState({
    required this.deviceId,
    required this.propertyName,
    required this.enabled,
  });

  factory HistoryPropertyState.fromJson(Map<String, dynamic> json) =>
      _$HistoryPropertyStateFromJson(json);

  static const toJsonFactory = _$HistoryPropertyStateToJson;
  Map<String, dynamic> toJson() => _$HistoryPropertyStateToJson(this);

  @JsonKey(name: 'deviceId')
  final int deviceId;
  @JsonKey(name: 'propertyName')
  final String propertyName;
  @JsonKey(name: 'enabled')
  final bool enabled;
  static const fromJsonFactory = _$HistoryPropertyStateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is HistoryPropertyState &&
            (identical(other.deviceId, deviceId) ||
                const DeepCollectionEquality()
                    .equals(other.deviceId, deviceId)) &&
            (identical(other.propertyName, propertyName) ||
                const DeepCollectionEquality()
                    .equals(other.propertyName, propertyName)) &&
            (identical(other.enabled, enabled) ||
                const DeepCollectionEquality().equals(other.enabled, enabled)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(deviceId) ^
      const DeepCollectionEquality().hash(propertyName) ^
      const DeepCollectionEquality().hash(enabled) ^
      runtimeType.hashCode;
}

extension $HistoryPropertyStateExtension on HistoryPropertyState {
  HistoryPropertyState copyWith(
      {int? deviceId, String? propertyName, bool? enabled}) {
    return HistoryPropertyState(
        deviceId: deviceId ?? this.deviceId,
        propertyName: propertyName ?? this.propertyName,
        enabled: enabled ?? this.enabled);
  }

  HistoryPropertyState copyWithWrapped(
      {Wrapped<int>? deviceId,
      Wrapped<String>? propertyName,
      Wrapped<bool>? enabled}) {
    return HistoryPropertyState(
        deviceId: (deviceId != null ? deviceId.value : this.deviceId),
        propertyName:
            (propertyName != null ? propertyName.value : this.propertyName),
        enabled: (enabled != null ? enabled.value : this.enabled));
  }
}

@JsonSerializable(explicitToJson: true)
class SetHistoryRequest {
  const SetHistoryRequest({
    required this.enable,
    required this.ids,
    required this.name,
  });

  factory SetHistoryRequest.fromJson(Map<String, dynamic> json) =>
      _$SetHistoryRequestFromJson(json);

  static const toJsonFactory = _$SetHistoryRequestToJson;
  Map<String, dynamic> toJson() => _$SetHistoryRequestToJson(this);

  @JsonKey(name: 'enable')
  final bool enable;
  @JsonKey(name: 'ids', defaultValue: <int>[])
  final List<int> ids;
  @JsonKey(name: 'name')
  final String name;
  static const fromJsonFactory = _$SetHistoryRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SetHistoryRequest &&
            (identical(other.enable, enable) ||
                const DeepCollectionEquality().equals(other.enable, enable)) &&
            (identical(other.ids, ids) ||
                const DeepCollectionEquality().equals(other.ids, ids)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(enable) ^
      const DeepCollectionEquality().hash(ids) ^
      const DeepCollectionEquality().hash(name) ^
      runtimeType.hashCode;
}

extension $SetHistoryRequestExtension on SetHistoryRequest {
  SetHistoryRequest copyWith({bool? enable, List<int>? ids, String? name}) {
    return SetHistoryRequest(
        enable: enable ?? this.enable,
        ids: ids ?? this.ids,
        name: name ?? this.name);
  }

  SetHistoryRequest copyWithWrapped(
      {Wrapped<bool>? enable, Wrapped<List<int>>? ids, Wrapped<String>? name}) {
    return SetHistoryRequest(
        enable: (enable != null ? enable.value : this.enable),
        ids: (ids != null ? ids.value : this.ids),
        name: (name != null ? name.value : this.name));
  }
}

@JsonSerializable(explicitToJson: true)
class History {
  const History({
    required this.historyRecords,
    required this.propertyName,
  });

  factory History.fromJson(Map<String, dynamic> json) =>
      _$HistoryFromJson(json);

  static const toJsonFactory = _$HistoryToJson;
  Map<String, dynamic> toJson() => _$HistoryToJson(this);

  @JsonKey(name: 'historyRecords', defaultValue: <HistoryRecord>[])
  final List<HistoryRecord> historyRecords;
  @JsonKey(name: 'propertyName')
  final String propertyName;
  static const fromJsonFactory = _$HistoryFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is History &&
            (identical(other.historyRecords, historyRecords) ||
                const DeepCollectionEquality()
                    .equals(other.historyRecords, historyRecords)) &&
            (identical(other.propertyName, propertyName) ||
                const DeepCollectionEquality()
                    .equals(other.propertyName, propertyName)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(historyRecords) ^
      const DeepCollectionEquality().hash(propertyName) ^
      runtimeType.hashCode;
}

extension $HistoryExtension on History {
  History copyWith(
      {List<HistoryRecord>? historyRecords, String? propertyName}) {
    return History(
        historyRecords: historyRecords ?? this.historyRecords,
        propertyName: propertyName ?? this.propertyName);
  }

  History copyWithWrapped(
      {Wrapped<List<HistoryRecord>>? historyRecords,
      Wrapped<String>? propertyName}) {
    return History(
        historyRecords: (historyRecords != null
            ? historyRecords.value
            : this.historyRecords),
        propertyName:
            (propertyName != null ? propertyName.value : this.propertyName));
  }
}

@JsonSerializable(explicitToJson: true)
class HistoryRecord {
  const HistoryRecord({
    this.val,
    required this.ts,
  });

  factory HistoryRecord.fromJson(Map<String, dynamic> json) =>
      _$HistoryRecordFromJson(json);

  static const toJsonFactory = _$HistoryRecordToJson;
  Map<String, dynamic> toJson() => _$HistoryRecordToJson(this);

  @JsonKey(name: 'val')
  final double? val;
  @JsonKey(name: 'ts')
  final int ts;
  static const fromJsonFactory = _$HistoryRecordFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is HistoryRecord &&
            (identical(other.val, val) ||
                const DeepCollectionEquality().equals(other.val, val)) &&
            (identical(other.ts, ts) ||
                const DeepCollectionEquality().equals(other.ts, ts)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(val) ^
      const DeepCollectionEquality().hash(ts) ^
      runtimeType.hashCode;
}

extension $HistoryRecordExtension on HistoryRecord {
  HistoryRecord copyWith({double? val, int? ts}) {
    return HistoryRecord(val: val ?? this.val, ts: ts ?? this.ts);
  }

  HistoryRecord copyWithWrapped({Wrapped<double?>? val, Wrapped<int>? ts}) {
    return HistoryRecord(
        val: (val != null ? val.value : this.val),
        ts: (ts != null ? ts.value : this.ts));
  }
}

@JsonSerializable(explicitToJson: true)
class LayoutResponse {
  const LayoutResponse({
    this.layout,
    this.icon,
    required this.additionalIcons,
  });

  factory LayoutResponse.fromJson(Map<String, dynamic> json) =>
      _$LayoutResponseFromJson(json);

  static const toJsonFactory = _$LayoutResponseToJson;
  Map<String, dynamic> toJson() => _$LayoutResponseToJson(this);

  @JsonKey(name: 'layout')
  final DeviceLayout? layout;
  @JsonKey(name: 'icon')
  final IconResponse? icon;
  @JsonKey(name: 'additionalIcons', defaultValue: <IconResponse>[])
  final List<IconResponse> additionalIcons;
  static const fromJsonFactory = _$LayoutResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LayoutResponse &&
            (identical(other.layout, layout) ||
                const DeepCollectionEquality().equals(other.layout, layout)) &&
            (identical(other.icon, icon) ||
                const DeepCollectionEquality().equals(other.icon, icon)) &&
            (identical(other.additionalIcons, additionalIcons) ||
                const DeepCollectionEquality()
                    .equals(other.additionalIcons, additionalIcons)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(layout) ^
      const DeepCollectionEquality().hash(icon) ^
      const DeepCollectionEquality().hash(additionalIcons) ^
      runtimeType.hashCode;
}

extension $LayoutResponseExtension on LayoutResponse {
  LayoutResponse copyWith(
      {DeviceLayout? layout,
      IconResponse? icon,
      List<IconResponse>? additionalIcons}) {
    return LayoutResponse(
        layout: layout ?? this.layout,
        icon: icon ?? this.icon,
        additionalIcons: additionalIcons ?? this.additionalIcons);
  }

  LayoutResponse copyWithWrapped(
      {Wrapped<DeviceLayout?>? layout,
      Wrapped<IconResponse?>? icon,
      Wrapped<List<IconResponse>>? additionalIcons}) {
    return LayoutResponse(
        layout: (layout != null ? layout.value : this.layout),
        icon: (icon != null ? icon.value : this.icon),
        additionalIcons: (additionalIcons != null
            ? additionalIcons.value
            : this.additionalIcons));
  }
}

@JsonSerializable(explicitToJson: true)
class DeviceLayout {
  const DeviceLayout({
    required this.uniqueName,
    required this.iconName,
    this.typeName,
    this.typeNames,
    this.ids,
    this.dashboardDeviceLayout,
    this.detailDeviceLayout,
    this.notificationSetup,
    required this.version,
    required this.showOnlyInDeveloperMode,
    required this.hash,
    required this.additionalData,
  });

  factory DeviceLayout.fromJson(Map<String, dynamic> json) =>
      _$DeviceLayoutFromJson(json);

  static const toJsonFactory = _$DeviceLayoutToJson;
  Map<String, dynamic> toJson() => _$DeviceLayoutToJson(this);

  @JsonKey(name: 'uniqueName')
  final String uniqueName;
  @JsonKey(name: 'iconName')
  final String iconName;
  @JsonKey(name: 'typeName')
  final String? typeName;
  @JsonKey(name: 'typeNames', defaultValue: <String>[])
  final List<String>? typeNames;
  @JsonKey(name: 'ids', defaultValue: <int>[])
  final List<int>? ids;
  @JsonKey(name: 'dashboardDeviceLayout')
  final DashboardDeviceLayout? dashboardDeviceLayout;
  @JsonKey(name: 'detailDeviceLayout')
  final DetailDeviceLayout? detailDeviceLayout;
  @JsonKey(name: 'notificationSetup', defaultValue: <NotificationSetup>[])
  final List<NotificationSetup>? notificationSetup;
  @JsonKey(name: 'version')
  final int version;
  @JsonKey(name: 'showOnlyInDeveloperMode')
  final bool showOnlyInDeveloperMode;
  @JsonKey(name: 'hash')
  final String hash;
  @JsonKey(name: 'additionalData')
  final Map<String, dynamic> additionalData;
  static const fromJsonFactory = _$DeviceLayoutFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DeviceLayout &&
            (identical(other.uniqueName, uniqueName) ||
                const DeepCollectionEquality()
                    .equals(other.uniqueName, uniqueName)) &&
            (identical(other.iconName, iconName) ||
                const DeepCollectionEquality()
                    .equals(other.iconName, iconName)) &&
            (identical(other.typeName, typeName) ||
                const DeepCollectionEquality()
                    .equals(other.typeName, typeName)) &&
            (identical(other.typeNames, typeNames) ||
                const DeepCollectionEquality()
                    .equals(other.typeNames, typeNames)) &&
            (identical(other.ids, ids) ||
                const DeepCollectionEquality().equals(other.ids, ids)) &&
            (identical(other.dashboardDeviceLayout, dashboardDeviceLayout) ||
                const DeepCollectionEquality().equals(
                    other.dashboardDeviceLayout, dashboardDeviceLayout)) &&
            (identical(other.detailDeviceLayout, detailDeviceLayout) ||
                const DeepCollectionEquality()
                    .equals(other.detailDeviceLayout, detailDeviceLayout)) &&
            (identical(other.notificationSetup, notificationSetup) ||
                const DeepCollectionEquality()
                    .equals(other.notificationSetup, notificationSetup)) &&
            (identical(other.version, version) ||
                const DeepCollectionEquality()
                    .equals(other.version, version)) &&
            (identical(
                    other.showOnlyInDeveloperMode, showOnlyInDeveloperMode) ||
                const DeepCollectionEquality().equals(
                    other.showOnlyInDeveloperMode, showOnlyInDeveloperMode)) &&
            (identical(other.hash, hash) ||
                const DeepCollectionEquality().equals(other.hash, hash)) &&
            (identical(other.additionalData, additionalData) ||
                const DeepCollectionEquality()
                    .equals(other.additionalData, additionalData)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(uniqueName) ^
      const DeepCollectionEquality().hash(iconName) ^
      const DeepCollectionEquality().hash(typeName) ^
      const DeepCollectionEquality().hash(typeNames) ^
      const DeepCollectionEquality().hash(ids) ^
      const DeepCollectionEquality().hash(dashboardDeviceLayout) ^
      const DeepCollectionEquality().hash(detailDeviceLayout) ^
      const DeepCollectionEquality().hash(notificationSetup) ^
      const DeepCollectionEquality().hash(version) ^
      const DeepCollectionEquality().hash(showOnlyInDeveloperMode) ^
      const DeepCollectionEquality().hash(hash) ^
      const DeepCollectionEquality().hash(additionalData) ^
      runtimeType.hashCode;
}

extension $DeviceLayoutExtension on DeviceLayout {
  DeviceLayout copyWith(
      {String? uniqueName,
      String? iconName,
      String? typeName,
      List<String>? typeNames,
      List<int>? ids,
      DashboardDeviceLayout? dashboardDeviceLayout,
      DetailDeviceLayout? detailDeviceLayout,
      List<NotificationSetup>? notificationSetup,
      int? version,
      bool? showOnlyInDeveloperMode,
      String? hash,
      Map<String, dynamic>? additionalData}) {
    return DeviceLayout(
        uniqueName: uniqueName ?? this.uniqueName,
        iconName: iconName ?? this.iconName,
        typeName: typeName ?? this.typeName,
        typeNames: typeNames ?? this.typeNames,
        ids: ids ?? this.ids,
        dashboardDeviceLayout:
            dashboardDeviceLayout ?? this.dashboardDeviceLayout,
        detailDeviceLayout: detailDeviceLayout ?? this.detailDeviceLayout,
        notificationSetup: notificationSetup ?? this.notificationSetup,
        version: version ?? this.version,
        showOnlyInDeveloperMode:
            showOnlyInDeveloperMode ?? this.showOnlyInDeveloperMode,
        hash: hash ?? this.hash,
        additionalData: additionalData ?? this.additionalData);
  }

  DeviceLayout copyWithWrapped(
      {Wrapped<String>? uniqueName,
      Wrapped<String>? iconName,
      Wrapped<String?>? typeName,
      Wrapped<List<String>?>? typeNames,
      Wrapped<List<int>?>? ids,
      Wrapped<DashboardDeviceLayout?>? dashboardDeviceLayout,
      Wrapped<DetailDeviceLayout?>? detailDeviceLayout,
      Wrapped<List<NotificationSetup>?>? notificationSetup,
      Wrapped<int>? version,
      Wrapped<bool>? showOnlyInDeveloperMode,
      Wrapped<String>? hash,
      Wrapped<Map<String, dynamic>>? additionalData}) {
    return DeviceLayout(
        uniqueName: (uniqueName != null ? uniqueName.value : this.uniqueName),
        iconName: (iconName != null ? iconName.value : this.iconName),
        typeName: (typeName != null ? typeName.value : this.typeName),
        typeNames: (typeNames != null ? typeNames.value : this.typeNames),
        ids: (ids != null ? ids.value : this.ids),
        dashboardDeviceLayout: (dashboardDeviceLayout != null
            ? dashboardDeviceLayout.value
            : this.dashboardDeviceLayout),
        detailDeviceLayout: (detailDeviceLayout != null
            ? detailDeviceLayout.value
            : this.detailDeviceLayout),
        notificationSetup: (notificationSetup != null
            ? notificationSetup.value
            : this.notificationSetup),
        version: (version != null ? version.value : this.version),
        showOnlyInDeveloperMode: (showOnlyInDeveloperMode != null
            ? showOnlyInDeveloperMode.value
            : this.showOnlyInDeveloperMode),
        hash: (hash != null ? hash.value : this.hash),
        additionalData: (additionalData != null
            ? additionalData.value
            : this.additionalData));
  }
}

@JsonSerializable(explicitToJson: true)
class DashboardDeviceLayout {
  const DashboardDeviceLayout({
    required this.dashboardProperties,
  });

  factory DashboardDeviceLayout.fromJson(Map<String, dynamic> json) =>
      _$DashboardDeviceLayoutFromJson(json);

  static const toJsonFactory = _$DashboardDeviceLayoutToJson;
  Map<String, dynamic> toJson() => _$DashboardDeviceLayoutToJson(this);

  @JsonKey(name: 'dashboardProperties', defaultValue: <DashboardPropertyInfo>[])
  final List<DashboardPropertyInfo> dashboardProperties;
  static const fromJsonFactory = _$DashboardDeviceLayoutFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DashboardDeviceLayout &&
            (identical(other.dashboardProperties, dashboardProperties) ||
                const DeepCollectionEquality()
                    .equals(other.dashboardProperties, dashboardProperties)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(dashboardProperties) ^
      runtimeType.hashCode;
}

extension $DashboardDeviceLayoutExtension on DashboardDeviceLayout {
  DashboardDeviceLayout copyWith(
      {List<DashboardPropertyInfo>? dashboardProperties}) {
    return DashboardDeviceLayout(
        dashboardProperties: dashboardProperties ?? this.dashboardProperties);
  }

  DashboardDeviceLayout copyWithWrapped(
      {Wrapped<List<DashboardPropertyInfo>>? dashboardProperties}) {
    return DashboardDeviceLayout(
        dashboardProperties: (dashboardProperties != null
            ? dashboardProperties.value
            : this.dashboardProperties));
  }
}

@JsonSerializable(explicitToJson: true)
class TextSettings {
  const TextSettings({
    this.fontSize,
    this.fontFamily,
    required this.fontWeight,
    required this.fontStyle,
  });

  factory TextSettings.fromJson(Map<String, dynamic> json) =>
      _$TextSettingsFromJson(json);

  static const toJsonFactory = _$TextSettingsToJson;
  Map<String, dynamic> toJson() => _$TextSettingsToJson(this);

  @JsonKey(name: 'fontSize')
  final double? fontSize;
  @JsonKey(name: 'fontFamily')
  final String? fontFamily;
  @JsonKey(
    name: 'fontWeight',
    toJson: fontWeightSettingToJson,
    fromJson: fontWeightSettingFromJson,
  )
  final enums.FontWeightSetting fontWeight;
  @JsonKey(
    name: 'fontStyle',
    toJson: fontStyleSettingToJson,
    fromJson: fontStyleSettingFromJson,
  )
  final enums.FontStyleSetting fontStyle;
  static const fromJsonFactory = _$TextSettingsFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TextSettings &&
            (identical(other.fontSize, fontSize) ||
                const DeepCollectionEquality()
                    .equals(other.fontSize, fontSize)) &&
            (identical(other.fontFamily, fontFamily) ||
                const DeepCollectionEquality()
                    .equals(other.fontFamily, fontFamily)) &&
            (identical(other.fontWeight, fontWeight) ||
                const DeepCollectionEquality()
                    .equals(other.fontWeight, fontWeight)) &&
            (identical(other.fontStyle, fontStyle) ||
                const DeepCollectionEquality()
                    .equals(other.fontStyle, fontStyle)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(fontSize) ^
      const DeepCollectionEquality().hash(fontFamily) ^
      const DeepCollectionEquality().hash(fontWeight) ^
      const DeepCollectionEquality().hash(fontStyle) ^
      runtimeType.hashCode;
}

extension $TextSettingsExtension on TextSettings {
  TextSettings copyWith(
      {double? fontSize,
      String? fontFamily,
      enums.FontWeightSetting? fontWeight,
      enums.FontStyleSetting? fontStyle}) {
    return TextSettings(
        fontSize: fontSize ?? this.fontSize,
        fontFamily: fontFamily ?? this.fontFamily,
        fontWeight: fontWeight ?? this.fontWeight,
        fontStyle: fontStyle ?? this.fontStyle);
  }

  TextSettings copyWithWrapped(
      {Wrapped<double?>? fontSize,
      Wrapped<String?>? fontFamily,
      Wrapped<enums.FontWeightSetting>? fontWeight,
      Wrapped<enums.FontStyleSetting>? fontStyle}) {
    return TextSettings(
        fontSize: (fontSize != null ? fontSize.value : this.fontSize),
        fontFamily: (fontFamily != null ? fontFamily.value : this.fontFamily),
        fontWeight: (fontWeight != null ? fontWeight.value : this.fontWeight),
        fontStyle: (fontStyle != null ? fontStyle.value : this.fontStyle));
  }
}

@JsonSerializable(explicitToJson: true)
class PropertyEditInformation {
  const PropertyEditInformation({
    required this.messageType,
    required this.editParameter,
    required this.editType,
    this.display,
    this.hubMethod,
    this.valueName,
    this.activeValue,
    this.dialog,
    this.extensionData,
  });

  factory PropertyEditInformation.fromJson(Map<String, dynamic> json) =>
      _$PropertyEditInformationFromJson(json);

  static const toJsonFactory = _$PropertyEditInformationToJson;
  Map<String, dynamic> toJson() => _$PropertyEditInformationToJson(this);

  @JsonKey(
    name: 'messageType',
    toJson: messageTypeToJson,
    fromJson: messageTypeFromJson,
  )
  final enums.MessageType messageType;
  @JsonKey(name: 'editParameter', defaultValue: <EditParameter>[])
  final List<EditParameter> editParameter;
  @JsonKey(name: 'editType')
  final String editType;
  @JsonKey(name: 'display')
  final String? display;
  @JsonKey(name: 'hubMethod')
  final String? hubMethod;
  @JsonKey(name: 'valueName')
  final String? valueName;
  @JsonKey(name: 'activeValue')
  final dynamic activeValue;
  @JsonKey(name: 'dialog')
  final String? dialog;
  @JsonKey(name: 'extensionData')
  final Map<String, dynamic>? extensionData;
  static const fromJsonFactory = _$PropertyEditInformationFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PropertyEditInformation &&
            (identical(other.messageType, messageType) ||
                const DeepCollectionEquality()
                    .equals(other.messageType, messageType)) &&
            (identical(other.editParameter, editParameter) ||
                const DeepCollectionEquality()
                    .equals(other.editParameter, editParameter)) &&
            (identical(other.editType, editType) ||
                const DeepCollectionEquality()
                    .equals(other.editType, editType)) &&
            (identical(other.display, display) ||
                const DeepCollectionEquality()
                    .equals(other.display, display)) &&
            (identical(other.hubMethod, hubMethod) ||
                const DeepCollectionEquality()
                    .equals(other.hubMethod, hubMethod)) &&
            (identical(other.valueName, valueName) ||
                const DeepCollectionEquality()
                    .equals(other.valueName, valueName)) &&
            (identical(other.activeValue, activeValue) ||
                const DeepCollectionEquality()
                    .equals(other.activeValue, activeValue)) &&
            (identical(other.dialog, dialog) ||
                const DeepCollectionEquality().equals(other.dialog, dialog)) &&
            (identical(other.extensionData, extensionData) ||
                const DeepCollectionEquality()
                    .equals(other.extensionData, extensionData)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(messageType) ^
      const DeepCollectionEquality().hash(editParameter) ^
      const DeepCollectionEquality().hash(editType) ^
      const DeepCollectionEquality().hash(display) ^
      const DeepCollectionEquality().hash(hubMethod) ^
      const DeepCollectionEquality().hash(valueName) ^
      const DeepCollectionEquality().hash(activeValue) ^
      const DeepCollectionEquality().hash(dialog) ^
      const DeepCollectionEquality().hash(extensionData) ^
      runtimeType.hashCode;
}

extension $PropertyEditInformationExtension on PropertyEditInformation {
  PropertyEditInformation copyWith(
      {enums.MessageType? messageType,
      List<EditParameter>? editParameter,
      String? editType,
      String? display,
      String? hubMethod,
      String? valueName,
      dynamic activeValue,
      String? dialog,
      Map<String, dynamic>? extensionData}) {
    return PropertyEditInformation(
        messageType: messageType ?? this.messageType,
        editParameter: editParameter ?? this.editParameter,
        editType: editType ?? this.editType,
        display: display ?? this.display,
        hubMethod: hubMethod ?? this.hubMethod,
        valueName: valueName ?? this.valueName,
        activeValue: activeValue ?? this.activeValue,
        dialog: dialog ?? this.dialog,
        extensionData: extensionData ?? this.extensionData);
  }

  PropertyEditInformation copyWithWrapped(
      {Wrapped<enums.MessageType>? messageType,
      Wrapped<List<EditParameter>>? editParameter,
      Wrapped<String>? editType,
      Wrapped<String?>? display,
      Wrapped<String?>? hubMethod,
      Wrapped<String?>? valueName,
      Wrapped<dynamic>? activeValue,
      Wrapped<String?>? dialog,
      Wrapped<Map<String, dynamic>?>? extensionData}) {
    return PropertyEditInformation(
        messageType:
            (messageType != null ? messageType.value : this.messageType),
        editParameter:
            (editParameter != null ? editParameter.value : this.editParameter),
        editType: (editType != null ? editType.value : this.editType),
        display: (display != null ? display.value : this.display),
        hubMethod: (hubMethod != null ? hubMethod.value : this.hubMethod),
        valueName: (valueName != null ? valueName.value : this.valueName),
        activeValue:
            (activeValue != null ? activeValue.value : this.activeValue),
        dialog: (dialog != null ? dialog.value : this.dialog),
        extensionData:
            (extensionData != null ? extensionData.value : this.extensionData));
  }
}

@JsonSerializable(explicitToJson: true)
class EditParameter {
  const EditParameter({
    required this.command,
    required this.$value,
    this.id,
    this.messageType,
    this.displayName,
    this.parameters,
    this.extensionData,
  });

  factory EditParameter.fromJson(Map<String, dynamic> json) =>
      _$EditParameterFromJson(json);

  static const toJsonFactory = _$EditParameterToJson;
  Map<String, dynamic> toJson() => _$EditParameterToJson(this);

  @JsonKey(
    name: 'command',
    toJson: commandToJson,
    fromJson: commandFromJson,
  )
  final enums.Command command;
  @JsonKey(name: 'value')
  final dynamic $value;
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(
    name: 'messageType',
    toJson: messageTypeNullableToJson,
    fromJson: messageTypeNullableFromJson,
  )
  final enums.MessageType? messageType;
  @JsonKey(name: 'displayName')
  final String? displayName;
  @JsonKey(name: 'parameters', defaultValue: <Object>[])
  final List<Object>? parameters;
  @JsonKey(name: 'extensionData')
  final Map<String, dynamic>? extensionData;
  static const fromJsonFactory = _$EditParameterFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is EditParameter &&
            (identical(other.command, command) ||
                const DeepCollectionEquality()
                    .equals(other.command, command)) &&
            (identical(other.$value, $value) ||
                const DeepCollectionEquality().equals(other.$value, $value)) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.messageType, messageType) ||
                const DeepCollectionEquality()
                    .equals(other.messageType, messageType)) &&
            (identical(other.displayName, displayName) ||
                const DeepCollectionEquality()
                    .equals(other.displayName, displayName)) &&
            (identical(other.parameters, parameters) ||
                const DeepCollectionEquality()
                    .equals(other.parameters, parameters)) &&
            (identical(other.extensionData, extensionData) ||
                const DeepCollectionEquality()
                    .equals(other.extensionData, extensionData)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(command) ^
      const DeepCollectionEquality().hash($value) ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(messageType) ^
      const DeepCollectionEquality().hash(displayName) ^
      const DeepCollectionEquality().hash(parameters) ^
      const DeepCollectionEquality().hash(extensionData) ^
      runtimeType.hashCode;
}

extension $EditParameterExtension on EditParameter {
  EditParameter copyWith(
      {enums.Command? command,
      dynamic $value,
      int? id,
      enums.MessageType? messageType,
      String? displayName,
      List<Object>? parameters,
      Map<String, dynamic>? extensionData}) {
    return EditParameter(
        command: command ?? this.command,
        $value: $value ?? this.$value,
        id: id ?? this.id,
        messageType: messageType ?? this.messageType,
        displayName: displayName ?? this.displayName,
        parameters: parameters ?? this.parameters,
        extensionData: extensionData ?? this.extensionData);
  }

  EditParameter copyWithWrapped(
      {Wrapped<enums.Command>? command,
      Wrapped<dynamic>? $value,
      Wrapped<int?>? id,
      Wrapped<enums.MessageType?>? messageType,
      Wrapped<String?>? displayName,
      Wrapped<List<Object>?>? parameters,
      Wrapped<Map<String, dynamic>?>? extensionData}) {
    return EditParameter(
        command: (command != null ? command.value : this.command),
        $value: ($value != null ? $value.value : this.$value),
        id: (id != null ? id.value : this.id),
        messageType:
            (messageType != null ? messageType.value : this.messageType),
        displayName:
            (displayName != null ? displayName.value : this.displayName),
        parameters: (parameters != null ? parameters.value : this.parameters),
        extensionData:
            (extensionData != null ? extensionData.value : this.extensionData));
  }
}

@JsonSerializable(explicitToJson: true)
class DetailDeviceLayout {
  const DetailDeviceLayout({
    required this.propertyInfos,
    required this.tabInfos,
    required this.historyProperties,
  });

  factory DetailDeviceLayout.fromJson(Map<String, dynamic> json) =>
      _$DetailDeviceLayoutFromJson(json);

  static const toJsonFactory = _$DetailDeviceLayoutToJson;
  Map<String, dynamic> toJson() => _$DetailDeviceLayoutToJson(this);

  @JsonKey(name: 'propertyInfos', defaultValue: <DetailPropertyInfo>[])
  final List<DetailPropertyInfo> propertyInfos;
  @JsonKey(name: 'tabInfos', defaultValue: <DetailTabInfo>[])
  final List<DetailTabInfo> tabInfos;
  @JsonKey(name: 'historyProperties', defaultValue: <HistoryPropertyInfo>[])
  final List<HistoryPropertyInfo> historyProperties;
  static const fromJsonFactory = _$DetailDeviceLayoutFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DetailDeviceLayout &&
            (identical(other.propertyInfos, propertyInfos) ||
                const DeepCollectionEquality()
                    .equals(other.propertyInfos, propertyInfos)) &&
            (identical(other.tabInfos, tabInfos) ||
                const DeepCollectionEquality()
                    .equals(other.tabInfos, tabInfos)) &&
            (identical(other.historyProperties, historyProperties) ||
                const DeepCollectionEquality()
                    .equals(other.historyProperties, historyProperties)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(propertyInfos) ^
      const DeepCollectionEquality().hash(tabInfos) ^
      const DeepCollectionEquality().hash(historyProperties) ^
      runtimeType.hashCode;
}

extension $DetailDeviceLayoutExtension on DetailDeviceLayout {
  DetailDeviceLayout copyWith(
      {List<DetailPropertyInfo>? propertyInfos,
      List<DetailTabInfo>? tabInfos,
      List<HistoryPropertyInfo>? historyProperties}) {
    return DetailDeviceLayout(
        propertyInfos: propertyInfos ?? this.propertyInfos,
        tabInfos: tabInfos ?? this.tabInfos,
        historyProperties: historyProperties ?? this.historyProperties);
  }

  DetailDeviceLayout copyWithWrapped(
      {Wrapped<List<DetailPropertyInfo>>? propertyInfos,
      Wrapped<List<DetailTabInfo>>? tabInfos,
      Wrapped<List<HistoryPropertyInfo>>? historyProperties}) {
    return DetailDeviceLayout(
        propertyInfos:
            (propertyInfos != null ? propertyInfos.value : this.propertyInfos),
        tabInfos: (tabInfos != null ? tabInfos.value : this.tabInfos),
        historyProperties: (historyProperties != null
            ? historyProperties.value
            : this.historyProperties));
  }
}

@JsonSerializable(explicitToJson: true)
class DetailTabInfo {
  const DetailTabInfo({
    required this.id,
    required this.iconName,
    required this.order,
    this.linkedDevice,
    required this.showOnlyInDeveloperMode,
  });

  factory DetailTabInfo.fromJson(Map<String, dynamic> json) =>
      _$DetailTabInfoFromJson(json);

  static const toJsonFactory = _$DetailTabInfoToJson;
  Map<String, dynamic> toJson() => _$DetailTabInfoToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'iconName')
  final String iconName;
  @JsonKey(name: 'order')
  final int order;
  @JsonKey(name: 'linkedDevice')
  final LinkedDeviceTab? linkedDevice;
  @JsonKey(name: 'showOnlyInDeveloperMode')
  final bool showOnlyInDeveloperMode;
  static const fromJsonFactory = _$DetailTabInfoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DetailTabInfo &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.iconName, iconName) ||
                const DeepCollectionEquality()
                    .equals(other.iconName, iconName)) &&
            (identical(other.order, order) ||
                const DeepCollectionEquality().equals(other.order, order)) &&
            (identical(other.linkedDevice, linkedDevice) ||
                const DeepCollectionEquality()
                    .equals(other.linkedDevice, linkedDevice)) &&
            (identical(
                    other.showOnlyInDeveloperMode, showOnlyInDeveloperMode) ||
                const DeepCollectionEquality().equals(
                    other.showOnlyInDeveloperMode, showOnlyInDeveloperMode)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(iconName) ^
      const DeepCollectionEquality().hash(order) ^
      const DeepCollectionEquality().hash(linkedDevice) ^
      const DeepCollectionEquality().hash(showOnlyInDeveloperMode) ^
      runtimeType.hashCode;
}

extension $DetailTabInfoExtension on DetailTabInfo {
  DetailTabInfo copyWith(
      {int? id,
      String? iconName,
      int? order,
      LinkedDeviceTab? linkedDevice,
      bool? showOnlyInDeveloperMode}) {
    return DetailTabInfo(
        id: id ?? this.id,
        iconName: iconName ?? this.iconName,
        order: order ?? this.order,
        linkedDevice: linkedDevice ?? this.linkedDevice,
        showOnlyInDeveloperMode:
            showOnlyInDeveloperMode ?? this.showOnlyInDeveloperMode);
  }

  DetailTabInfo copyWithWrapped(
      {Wrapped<int>? id,
      Wrapped<String>? iconName,
      Wrapped<int>? order,
      Wrapped<LinkedDeviceTab?>? linkedDevice,
      Wrapped<bool>? showOnlyInDeveloperMode}) {
    return DetailTabInfo(
        id: (id != null ? id.value : this.id),
        iconName: (iconName != null ? iconName.value : this.iconName),
        order: (order != null ? order.value : this.order),
        linkedDevice:
            (linkedDevice != null ? linkedDevice.value : this.linkedDevice),
        showOnlyInDeveloperMode: (showOnlyInDeveloperMode != null
            ? showOnlyInDeveloperMode.value
            : this.showOnlyInDeveloperMode));
  }
}

@JsonSerializable(explicitToJson: true)
class LinkedDeviceTab {
  const LinkedDeviceTab({
    required this.deviceIdPropertyName,
    required this.deviceType,
  });

  factory LinkedDeviceTab.fromJson(Map<String, dynamic> json) =>
      _$LinkedDeviceTabFromJson(json);

  static const toJsonFactory = _$LinkedDeviceTabToJson;
  Map<String, dynamic> toJson() => _$LinkedDeviceTabToJson(this);

  @JsonKey(name: 'deviceIdPropertyName')
  final String deviceIdPropertyName;
  @JsonKey(name: 'deviceType')
  final String deviceType;
  static const fromJsonFactory = _$LinkedDeviceTabFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LinkedDeviceTab &&
            (identical(other.deviceIdPropertyName, deviceIdPropertyName) ||
                const DeepCollectionEquality().equals(
                    other.deviceIdPropertyName, deviceIdPropertyName)) &&
            (identical(other.deviceType, deviceType) ||
                const DeepCollectionEquality()
                    .equals(other.deviceType, deviceType)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(deviceIdPropertyName) ^
      const DeepCollectionEquality().hash(deviceType) ^
      runtimeType.hashCode;
}

extension $LinkedDeviceTabExtension on LinkedDeviceTab {
  LinkedDeviceTab copyWith({String? deviceIdPropertyName, String? deviceType}) {
    return LinkedDeviceTab(
        deviceIdPropertyName: deviceIdPropertyName ?? this.deviceIdPropertyName,
        deviceType: deviceType ?? this.deviceType);
  }

  LinkedDeviceTab copyWithWrapped(
      {Wrapped<String>? deviceIdPropertyName, Wrapped<String>? deviceType}) {
    return LinkedDeviceTab(
        deviceIdPropertyName: (deviceIdPropertyName != null
            ? deviceIdPropertyName.value
            : this.deviceIdPropertyName),
        deviceType: (deviceType != null ? deviceType.value : this.deviceType));
  }
}

@JsonSerializable(explicitToJson: true)
class HistoryPropertyInfo {
  const HistoryPropertyInfo({
    required this.propertyName,
    required this.xAxisName,
    required this.unitOfMeasurement,
    required this.iconName,
    required this.brightThemeColor,
    required this.darkThemeColor,
    required this.chartType,
  });

  factory HistoryPropertyInfo.fromJson(Map<String, dynamic> json) =>
      _$HistoryPropertyInfoFromJson(json);

  static const toJsonFactory = _$HistoryPropertyInfoToJson;
  Map<String, dynamic> toJson() => _$HistoryPropertyInfoToJson(this);

  @JsonKey(name: 'propertyName')
  final String propertyName;
  @JsonKey(name: 'xAxisName')
  final String xAxisName;
  @JsonKey(name: 'unitOfMeasurement')
  final String unitOfMeasurement;
  @JsonKey(name: 'iconName')
  final String iconName;
  @JsonKey(name: 'brightThemeColor')
  final int brightThemeColor;
  @JsonKey(name: 'darkThemeColor')
  final int darkThemeColor;
  @JsonKey(name: 'chartType')
  final String chartType;
  static const fromJsonFactory = _$HistoryPropertyInfoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is HistoryPropertyInfo &&
            (identical(other.propertyName, propertyName) ||
                const DeepCollectionEquality()
                    .equals(other.propertyName, propertyName)) &&
            (identical(other.xAxisName, xAxisName) ||
                const DeepCollectionEquality()
                    .equals(other.xAxisName, xAxisName)) &&
            (identical(other.unitOfMeasurement, unitOfMeasurement) ||
                const DeepCollectionEquality()
                    .equals(other.unitOfMeasurement, unitOfMeasurement)) &&
            (identical(other.iconName, iconName) ||
                const DeepCollectionEquality()
                    .equals(other.iconName, iconName)) &&
            (identical(other.brightThemeColor, brightThemeColor) ||
                const DeepCollectionEquality()
                    .equals(other.brightThemeColor, brightThemeColor)) &&
            (identical(other.darkThemeColor, darkThemeColor) ||
                const DeepCollectionEquality()
                    .equals(other.darkThemeColor, darkThemeColor)) &&
            (identical(other.chartType, chartType) ||
                const DeepCollectionEquality()
                    .equals(other.chartType, chartType)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(propertyName) ^
      const DeepCollectionEquality().hash(xAxisName) ^
      const DeepCollectionEquality().hash(unitOfMeasurement) ^
      const DeepCollectionEquality().hash(iconName) ^
      const DeepCollectionEquality().hash(brightThemeColor) ^
      const DeepCollectionEquality().hash(darkThemeColor) ^
      const DeepCollectionEquality().hash(chartType) ^
      runtimeType.hashCode;
}

extension $HistoryPropertyInfoExtension on HistoryPropertyInfo {
  HistoryPropertyInfo copyWith(
      {String? propertyName,
      String? xAxisName,
      String? unitOfMeasurement,
      String? iconName,
      int? brightThemeColor,
      int? darkThemeColor,
      String? chartType}) {
    return HistoryPropertyInfo(
        propertyName: propertyName ?? this.propertyName,
        xAxisName: xAxisName ?? this.xAxisName,
        unitOfMeasurement: unitOfMeasurement ?? this.unitOfMeasurement,
        iconName: iconName ?? this.iconName,
        brightThemeColor: brightThemeColor ?? this.brightThemeColor,
        darkThemeColor: darkThemeColor ?? this.darkThemeColor,
        chartType: chartType ?? this.chartType);
  }

  HistoryPropertyInfo copyWithWrapped(
      {Wrapped<String>? propertyName,
      Wrapped<String>? xAxisName,
      Wrapped<String>? unitOfMeasurement,
      Wrapped<String>? iconName,
      Wrapped<int>? brightThemeColor,
      Wrapped<int>? darkThemeColor,
      Wrapped<String>? chartType}) {
    return HistoryPropertyInfo(
        propertyName:
            (propertyName != null ? propertyName.value : this.propertyName),
        xAxisName: (xAxisName != null ? xAxisName.value : this.xAxisName),
        unitOfMeasurement: (unitOfMeasurement != null
            ? unitOfMeasurement.value
            : this.unitOfMeasurement),
        iconName: (iconName != null ? iconName.value : this.iconName),
        brightThemeColor: (brightThemeColor != null
            ? brightThemeColor.value
            : this.brightThemeColor),
        darkThemeColor: (darkThemeColor != null
            ? darkThemeColor.value
            : this.darkThemeColor),
        chartType: (chartType != null ? chartType.value : this.chartType));
  }
}

@JsonSerializable(explicitToJson: true)
class NotificationSetup {
  const NotificationSetup({
    required this.uniqueName,
    required this.translatableName,
    required this.times,
    this.deviceIds,
    required this.global,
  });

  factory NotificationSetup.fromJson(Map<String, dynamic> json) =>
      _$NotificationSetupFromJson(json);

  static const toJsonFactory = _$NotificationSetupToJson;
  Map<String, dynamic> toJson() => _$NotificationSetupToJson(this);

  @JsonKey(name: 'uniqueName')
  final String uniqueName;
  @JsonKey(name: 'translatableName')
  final String translatableName;
  @JsonKey(name: 'times')
  final int times;
  @JsonKey(name: 'deviceIds', defaultValue: <int>[])
  final List<int>? deviceIds;
  @JsonKey(name: 'global')
  final bool global;
  static const fromJsonFactory = _$NotificationSetupFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is NotificationSetup &&
            (identical(other.uniqueName, uniqueName) ||
                const DeepCollectionEquality()
                    .equals(other.uniqueName, uniqueName)) &&
            (identical(other.translatableName, translatableName) ||
                const DeepCollectionEquality()
                    .equals(other.translatableName, translatableName)) &&
            (identical(other.times, times) ||
                const DeepCollectionEquality().equals(other.times, times)) &&
            (identical(other.deviceIds, deviceIds) ||
                const DeepCollectionEquality()
                    .equals(other.deviceIds, deviceIds)) &&
            (identical(other.global, global) ||
                const DeepCollectionEquality().equals(other.global, global)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(uniqueName) ^
      const DeepCollectionEquality().hash(translatableName) ^
      const DeepCollectionEquality().hash(times) ^
      const DeepCollectionEquality().hash(deviceIds) ^
      const DeepCollectionEquality().hash(global) ^
      runtimeType.hashCode;
}

extension $NotificationSetupExtension on NotificationSetup {
  NotificationSetup copyWith(
      {String? uniqueName,
      String? translatableName,
      int? times,
      List<int>? deviceIds,
      bool? global}) {
    return NotificationSetup(
        uniqueName: uniqueName ?? this.uniqueName,
        translatableName: translatableName ?? this.translatableName,
        times: times ?? this.times,
        deviceIds: deviceIds ?? this.deviceIds,
        global: global ?? this.global);
  }

  NotificationSetup copyWithWrapped(
      {Wrapped<String>? uniqueName,
      Wrapped<String>? translatableName,
      Wrapped<int>? times,
      Wrapped<List<int>?>? deviceIds,
      Wrapped<bool>? global}) {
    return NotificationSetup(
        uniqueName: (uniqueName != null ? uniqueName.value : this.uniqueName),
        translatableName: (translatableName != null
            ? translatableName.value
            : this.translatableName),
        times: (times != null ? times.value : this.times),
        deviceIds: (deviceIds != null ? deviceIds.value : this.deviceIds),
        global: (global != null ? global.value : this.global));
  }
}

@JsonSerializable(explicitToJson: true)
class IconResponse {
  const IconResponse({
    required this.icon,
    required this.name,
  });

  factory IconResponse.fromJson(Map<String, dynamic> json) =>
      _$IconResponseFromJson(json);

  static const toJsonFactory = _$IconResponseToJson;
  Map<String, dynamic> toJson() => _$IconResponseToJson(this);

  @JsonKey(name: 'icon')
  final SvgIcon icon;
  @JsonKey(name: 'name')
  final String name;
  static const fromJsonFactory = _$IconResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is IconResponse &&
            (identical(other.icon, icon) ||
                const DeepCollectionEquality().equals(other.icon, icon)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(icon) ^
      const DeepCollectionEquality().hash(name) ^
      runtimeType.hashCode;
}

extension $IconResponseExtension on IconResponse {
  IconResponse copyWith({SvgIcon? icon, String? name}) {
    return IconResponse(icon: icon ?? this.icon, name: name ?? this.name);
  }

  IconResponse copyWithWrapped(
      {Wrapped<SvgIcon>? icon, Wrapped<String>? name}) {
    return IconResponse(
        icon: (icon != null ? icon.value : this.icon),
        name: (name != null ? name.value : this.name));
  }
}

@JsonSerializable(explicitToJson: true)
class LayoutRequest {
  const LayoutRequest({
    required this.typeName,
    required this.iconName,
    required this.deviceId,
  });

  factory LayoutRequest.fromJson(Map<String, dynamic> json) =>
      _$LayoutRequestFromJson(json);

  static const toJsonFactory = _$LayoutRequestToJson;
  Map<String, dynamic> toJson() => _$LayoutRequestToJson(this);

  @JsonKey(name: 'typeName')
  final String typeName;
  @JsonKey(name: 'iconName')
  final String iconName;
  @JsonKey(name: 'deviceId')
  final int deviceId;
  static const fromJsonFactory = _$LayoutRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LayoutRequest &&
            (identical(other.typeName, typeName) ||
                const DeepCollectionEquality()
                    .equals(other.typeName, typeName)) &&
            (identical(other.iconName, iconName) ||
                const DeepCollectionEquality()
                    .equals(other.iconName, iconName)) &&
            (identical(other.deviceId, deviceId) ||
                const DeepCollectionEquality()
                    .equals(other.deviceId, deviceId)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(typeName) ^
      const DeepCollectionEquality().hash(iconName) ^
      const DeepCollectionEquality().hash(deviceId) ^
      runtimeType.hashCode;
}

extension $LayoutRequestExtension on LayoutRequest {
  LayoutRequest copyWith({String? typeName, String? iconName, int? deviceId}) {
    return LayoutRequest(
        typeName: typeName ?? this.typeName,
        iconName: iconName ?? this.iconName,
        deviceId: deviceId ?? this.deviceId);
  }

  LayoutRequest copyWithWrapped(
      {Wrapped<String>? typeName,
      Wrapped<String>? iconName,
      Wrapped<int>? deviceId}) {
    return LayoutRequest(
        typeName: (typeName != null ? typeName.value : this.typeName),
        iconName: (iconName != null ? iconName.value : this.iconName),
        deviceId: (deviceId != null ? deviceId.value : this.deviceId));
  }
}

@JsonSerializable(explicitToJson: true)
class JsonApiSmarthomeMessage {
  const JsonApiSmarthomeMessage({
    required this.parameters,
    required this.id,
    required this.messageType,
    required this.command,
  });

  factory JsonApiSmarthomeMessage.fromJson(Map<String, dynamic> json) =>
      _$JsonApiSmarthomeMessageFromJson(json);

  static const toJsonFactory = _$JsonApiSmarthomeMessageToJson;
  Map<String, dynamic> toJson() => _$JsonApiSmarthomeMessageToJson(this);

  @JsonKey(name: 'parameters', defaultValue: <Object>[])
  final List<Object> parameters;
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(
    name: 'messageType',
    toJson: messageTypeToJson,
    fromJson: messageTypeFromJson,
  )
  final enums.MessageType messageType;
  @JsonKey(
    name: 'command',
    toJson: command2ToJson,
    fromJson: command2FromJson,
  )
  final enums.Command2 command;
  static const fromJsonFactory = _$JsonApiSmarthomeMessageFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is JsonApiSmarthomeMessage &&
            (identical(other.parameters, parameters) ||
                const DeepCollectionEquality()
                    .equals(other.parameters, parameters)) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.messageType, messageType) ||
                const DeepCollectionEquality()
                    .equals(other.messageType, messageType)) &&
            (identical(other.command, command) ||
                const DeepCollectionEquality().equals(other.command, command)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(parameters) ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(messageType) ^
      const DeepCollectionEquality().hash(command) ^
      runtimeType.hashCode;
}

extension $JsonApiSmarthomeMessageExtension on JsonApiSmarthomeMessage {
  JsonApiSmarthomeMessage copyWith(
      {List<Object>? parameters,
      int? id,
      enums.MessageType? messageType,
      enums.Command2? command}) {
    return JsonApiSmarthomeMessage(
        parameters: parameters ?? this.parameters,
        id: id ?? this.id,
        messageType: messageType ?? this.messageType,
        command: command ?? this.command);
  }

  JsonApiSmarthomeMessage copyWithWrapped(
      {Wrapped<List<Object>>? parameters,
      Wrapped<int>? id,
      Wrapped<enums.MessageType>? messageType,
      Wrapped<enums.Command2>? command}) {
    return JsonApiSmarthomeMessage(
        parameters: (parameters != null ? parameters.value : this.parameters),
        id: (id != null ? id.value : this.id),
        messageType:
            (messageType != null ? messageType.value : this.messageType),
        command: (command != null ? command.value : this.command));
  }
}

@JsonSerializable(explicitToJson: true)
class BaseSmarthomeMessage {
  const BaseSmarthomeMessage({
    required this.id,
    required this.messageType,
    required this.command,
  });

  factory BaseSmarthomeMessage.fromJson(Map<String, dynamic> json) =>
      _$BaseSmarthomeMessageFromJson(json);

  static const toJsonFactory = _$BaseSmarthomeMessageToJson;
  Map<String, dynamic> toJson() => _$BaseSmarthomeMessageToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(
    name: 'messageType',
    toJson: messageTypeToJson,
    fromJson: messageTypeFromJson,
  )
  final enums.MessageType messageType;
  @JsonKey(
    name: 'command',
    toJson: command2ToJson,
    fromJson: command2FromJson,
  )
  final enums.Command2 command;
  static const fromJsonFactory = _$BaseSmarthomeMessageFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is BaseSmarthomeMessage &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.messageType, messageType) ||
                const DeepCollectionEquality()
                    .equals(other.messageType, messageType)) &&
            (identical(other.command, command) ||
                const DeepCollectionEquality().equals(other.command, command)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(messageType) ^
      const DeepCollectionEquality().hash(command) ^
      runtimeType.hashCode;
}

extension $BaseSmarthomeMessageExtension on BaseSmarthomeMessage {
  BaseSmarthomeMessage copyWith(
      {int? id, enums.MessageType? messageType, enums.Command2? command}) {
    return BaseSmarthomeMessage(
        id: id ?? this.id,
        messageType: messageType ?? this.messageType,
        command: command ?? this.command);
  }

  BaseSmarthomeMessage copyWithWrapped(
      {Wrapped<int>? id,
      Wrapped<enums.MessageType>? messageType,
      Wrapped<enums.Command2>? command}) {
    return BaseSmarthomeMessage(
        id: (id != null ? id.value : this.id),
        messageType:
            (messageType != null ? messageType.value : this.messageType),
        command: (command != null ? command.value : this.command));
  }
}

@JsonSerializable(explicitToJson: true)
class AppLog {
  const AppLog({
    required this.logLevel,
    required this.timeStamp,
    required this.message,
    this.loggerName,
  });

  factory AppLog.fromJson(Map<String, dynamic> json) => _$AppLogFromJson(json);

  static const toJsonFactory = _$AppLogToJson;
  Map<String, dynamic> toJson() => _$AppLogToJson(this);

  @JsonKey(
    name: 'logLevel',
    toJson: appLogLevelToJson,
    fromJson: appLogLevelFromJson,
  )
  final enums.AppLogLevel logLevel;
  @JsonKey(name: 'timeStamp')
  final DateTime timeStamp;
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'loggerName')
  final String? loggerName;
  static const fromJsonFactory = _$AppLogFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AppLog &&
            (identical(other.logLevel, logLevel) ||
                const DeepCollectionEquality()
                    .equals(other.logLevel, logLevel)) &&
            (identical(other.timeStamp, timeStamp) ||
                const DeepCollectionEquality()
                    .equals(other.timeStamp, timeStamp)) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality()
                    .equals(other.message, message)) &&
            (identical(other.loggerName, loggerName) ||
                const DeepCollectionEquality()
                    .equals(other.loggerName, loggerName)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(logLevel) ^
      const DeepCollectionEquality().hash(timeStamp) ^
      const DeepCollectionEquality().hash(message) ^
      const DeepCollectionEquality().hash(loggerName) ^
      runtimeType.hashCode;
}

extension $AppLogExtension on AppLog {
  AppLog copyWith(
      {enums.AppLogLevel? logLevel,
      DateTime? timeStamp,
      String? message,
      String? loggerName}) {
    return AppLog(
        logLevel: logLevel ?? this.logLevel,
        timeStamp: timeStamp ?? this.timeStamp,
        message: message ?? this.message,
        loggerName: loggerName ?? this.loggerName);
  }

  AppLog copyWithWrapped(
      {Wrapped<enums.AppLogLevel>? logLevel,
      Wrapped<DateTime>? timeStamp,
      Wrapped<String>? message,
      Wrapped<String?>? loggerName}) {
    return AppLog(
        logLevel: (logLevel != null ? logLevel.value : this.logLevel),
        timeStamp: (timeStamp != null ? timeStamp.value : this.timeStamp),
        message: (message != null ? message.value : this.message),
        loggerName: (loggerName != null ? loggerName.value : this.loggerName));
  }
}

@JsonSerializable(explicitToJson: true)
class FirebaseOptions {
  const FirebaseOptions({
    required this.apiKey,
    required this.appId,
    required this.messagingSenderId,
    required this.projectId,
    required this.storageBucket,
    this.iosBundleId,
    this.authDomain,
  });

  factory FirebaseOptions.fromJson(Map<String, dynamic> json) =>
      _$FirebaseOptionsFromJson(json);

  static const toJsonFactory = _$FirebaseOptionsToJson;
  Map<String, dynamic> toJson() => _$FirebaseOptionsToJson(this);

  @JsonKey(name: 'apiKey')
  final String apiKey;
  @JsonKey(name: 'appId')
  final String appId;
  @JsonKey(name: 'messagingSenderId')
  final String messagingSenderId;
  @JsonKey(name: 'projectId')
  final String projectId;
  @JsonKey(name: 'storageBucket')
  final String storageBucket;
  @JsonKey(name: 'iosBundleId')
  final String? iosBundleId;
  @JsonKey(name: 'authDomain')
  final String? authDomain;
  static const fromJsonFactory = _$FirebaseOptionsFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is FirebaseOptions &&
            (identical(other.apiKey, apiKey) ||
                const DeepCollectionEquality().equals(other.apiKey, apiKey)) &&
            (identical(other.appId, appId) ||
                const DeepCollectionEquality().equals(other.appId, appId)) &&
            (identical(other.messagingSenderId, messagingSenderId) ||
                const DeepCollectionEquality()
                    .equals(other.messagingSenderId, messagingSenderId)) &&
            (identical(other.projectId, projectId) ||
                const DeepCollectionEquality()
                    .equals(other.projectId, projectId)) &&
            (identical(other.storageBucket, storageBucket) ||
                const DeepCollectionEquality()
                    .equals(other.storageBucket, storageBucket)) &&
            (identical(other.iosBundleId, iosBundleId) ||
                const DeepCollectionEquality()
                    .equals(other.iosBundleId, iosBundleId)) &&
            (identical(other.authDomain, authDomain) ||
                const DeepCollectionEquality()
                    .equals(other.authDomain, authDomain)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(apiKey) ^
      const DeepCollectionEquality().hash(appId) ^
      const DeepCollectionEquality().hash(messagingSenderId) ^
      const DeepCollectionEquality().hash(projectId) ^
      const DeepCollectionEquality().hash(storageBucket) ^
      const DeepCollectionEquality().hash(iosBundleId) ^
      const DeepCollectionEquality().hash(authDomain) ^
      runtimeType.hashCode;
}

extension $FirebaseOptionsExtension on FirebaseOptions {
  FirebaseOptions copyWith(
      {String? apiKey,
      String? appId,
      String? messagingSenderId,
      String? projectId,
      String? storageBucket,
      String? iosBundleId,
      String? authDomain}) {
    return FirebaseOptions(
        apiKey: apiKey ?? this.apiKey,
        appId: appId ?? this.appId,
        messagingSenderId: messagingSenderId ?? this.messagingSenderId,
        projectId: projectId ?? this.projectId,
        storageBucket: storageBucket ?? this.storageBucket,
        iosBundleId: iosBundleId ?? this.iosBundleId,
        authDomain: authDomain ?? this.authDomain);
  }

  FirebaseOptions copyWithWrapped(
      {Wrapped<String>? apiKey,
      Wrapped<String>? appId,
      Wrapped<String>? messagingSenderId,
      Wrapped<String>? projectId,
      Wrapped<String>? storageBucket,
      Wrapped<String?>? iosBundleId,
      Wrapped<String?>? authDomain}) {
    return FirebaseOptions(
        apiKey: (apiKey != null ? apiKey.value : this.apiKey),
        appId: (appId != null ? appId.value : this.appId),
        messagingSenderId: (messagingSenderId != null
            ? messagingSenderId.value
            : this.messagingSenderId),
        projectId: (projectId != null ? projectId.value : this.projectId),
        storageBucket:
            (storageBucket != null ? storageBucket.value : this.storageBucket),
        iosBundleId:
            (iosBundleId != null ? iosBundleId.value : this.iosBundleId),
        authDomain: (authDomain != null ? authDomain.value : this.authDomain));
  }
}

@JsonSerializable(explicitToJson: true)
class AllOneTimeNotifications {
  const AllOneTimeNotifications({
    required this.topics,
  });

  factory AllOneTimeNotifications.fromJson(Map<String, dynamic> json) =>
      _$AllOneTimeNotificationsFromJson(json);

  static const toJsonFactory = _$AllOneTimeNotificationsToJson;
  Map<String, dynamic> toJson() => _$AllOneTimeNotificationsToJson(this);

  @JsonKey(name: 'topics', defaultValue: <String>[])
  final List<String> topics;
  static const fromJsonFactory = _$AllOneTimeNotificationsFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AllOneTimeNotifications &&
            (identical(other.topics, topics) ||
                const DeepCollectionEquality().equals(other.topics, topics)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(topics) ^ runtimeType.hashCode;
}

extension $AllOneTimeNotificationsExtension on AllOneTimeNotifications {
  AllOneTimeNotifications copyWith({List<String>? topics}) {
    return AllOneTimeNotifications(topics: topics ?? this.topics);
  }

  AllOneTimeNotifications copyWithWrapped({Wrapped<List<String>>? topics}) {
    return AllOneTimeNotifications(
        topics: (topics != null ? topics.value : this.topics));
  }
}

String? dasboardSpecialTypeNullableToJson(
    enums.DasboardSpecialType? dasboardSpecialType) {
  return dasboardSpecialType?.value;
}

String? dasboardSpecialTypeToJson(
    enums.DasboardSpecialType dasboardSpecialType) {
  return dasboardSpecialType.value;
}

enums.DasboardSpecialType dasboardSpecialTypeFromJson(
  Object? dasboardSpecialType, [
  enums.DasboardSpecialType? defaultValue,
]) {
  return enums.DasboardSpecialType.values
          .firstWhereOrNull((e) => e.value == dasboardSpecialType) ??
      defaultValue ??
      enums.DasboardSpecialType.swaggerGeneratedUnknown;
}

enums.DasboardSpecialType? dasboardSpecialTypeNullableFromJson(
  Object? dasboardSpecialType, [
  enums.DasboardSpecialType? defaultValue,
]) {
  if (dasboardSpecialType == null) {
    return null;
  }
  return enums.DasboardSpecialType.values
          .firstWhereOrNull((e) => e.value == dasboardSpecialType) ??
      defaultValue;
}

String dasboardSpecialTypeExplodedListToJson(
    List<enums.DasboardSpecialType>? dasboardSpecialType) {
  return dasboardSpecialType?.map((e) => e.value!).join(',') ?? '';
}

List<String>? dasboardSpecialTypeListToJson(
    List<enums.DasboardSpecialType>? dasboardSpecialType) {
  if (dasboardSpecialType == null) {
    return null;
  }

  return dasboardSpecialType.map((e) => e.value!).toList();
}

List<enums.DasboardSpecialType> dasboardSpecialTypeListFromJson(
  List? dasboardSpecialType, [
  List<enums.DasboardSpecialType>? defaultValue,
]) {
  if (dasboardSpecialType == null) {
    return defaultValue ?? [];
  }

  return dasboardSpecialType
      .map((e) => dasboardSpecialTypeFromJson(e.toString()))
      .toList();
}

List<enums.DasboardSpecialType>? dasboardSpecialTypeNullableListFromJson(
  List? dasboardSpecialType, [
  List<enums.DasboardSpecialType>? defaultValue,
]) {
  if (dasboardSpecialType == null) {
    return defaultValue;
  }

  return dasboardSpecialType
      .map((e) => dasboardSpecialTypeFromJson(e.toString()))
      .toList();
}

String? fontWeightSettingNullableToJson(
    enums.FontWeightSetting? fontWeightSetting) {
  return fontWeightSetting?.value;
}

String? fontWeightSettingToJson(enums.FontWeightSetting fontWeightSetting) {
  return fontWeightSetting.value;
}

enums.FontWeightSetting fontWeightSettingFromJson(
  Object? fontWeightSetting, [
  enums.FontWeightSetting? defaultValue,
]) {
  return enums.FontWeightSetting.values
          .firstWhereOrNull((e) => e.value == fontWeightSetting) ??
      defaultValue ??
      enums.FontWeightSetting.swaggerGeneratedUnknown;
}

enums.FontWeightSetting? fontWeightSettingNullableFromJson(
  Object? fontWeightSetting, [
  enums.FontWeightSetting? defaultValue,
]) {
  if (fontWeightSetting == null) {
    return null;
  }
  return enums.FontWeightSetting.values
          .firstWhereOrNull((e) => e.value == fontWeightSetting) ??
      defaultValue;
}

String fontWeightSettingExplodedListToJson(
    List<enums.FontWeightSetting>? fontWeightSetting) {
  return fontWeightSetting?.map((e) => e.value!).join(',') ?? '';
}

List<String>? fontWeightSettingListToJson(
    List<enums.FontWeightSetting>? fontWeightSetting) {
  if (fontWeightSetting == null) {
    return null;
  }

  return fontWeightSetting.map((e) => e.value!).toList();
}

List<enums.FontWeightSetting> fontWeightSettingListFromJson(
  List? fontWeightSetting, [
  List<enums.FontWeightSetting>? defaultValue,
]) {
  if (fontWeightSetting == null) {
    return defaultValue ?? [];
  }

  return fontWeightSetting
      .map((e) => fontWeightSettingFromJson(e.toString()))
      .toList();
}

List<enums.FontWeightSetting>? fontWeightSettingNullableListFromJson(
  List? fontWeightSetting, [
  List<enums.FontWeightSetting>? defaultValue,
]) {
  if (fontWeightSetting == null) {
    return defaultValue;
  }

  return fontWeightSetting
      .map((e) => fontWeightSettingFromJson(e.toString()))
      .toList();
}

String? fontStyleSettingNullableToJson(
    enums.FontStyleSetting? fontStyleSetting) {
  return fontStyleSetting?.value;
}

String? fontStyleSettingToJson(enums.FontStyleSetting fontStyleSetting) {
  return fontStyleSetting.value;
}

enums.FontStyleSetting fontStyleSettingFromJson(
  Object? fontStyleSetting, [
  enums.FontStyleSetting? defaultValue,
]) {
  return enums.FontStyleSetting.values
          .firstWhereOrNull((e) => e.value == fontStyleSetting) ??
      defaultValue ??
      enums.FontStyleSetting.swaggerGeneratedUnknown;
}

enums.FontStyleSetting? fontStyleSettingNullableFromJson(
  Object? fontStyleSetting, [
  enums.FontStyleSetting? defaultValue,
]) {
  if (fontStyleSetting == null) {
    return null;
  }
  return enums.FontStyleSetting.values
          .firstWhereOrNull((e) => e.value == fontStyleSetting) ??
      defaultValue;
}

String fontStyleSettingExplodedListToJson(
    List<enums.FontStyleSetting>? fontStyleSetting) {
  return fontStyleSetting?.map((e) => e.value!).join(',') ?? '';
}

List<String>? fontStyleSettingListToJson(
    List<enums.FontStyleSetting>? fontStyleSetting) {
  if (fontStyleSetting == null) {
    return null;
  }

  return fontStyleSetting.map((e) => e.value!).toList();
}

List<enums.FontStyleSetting> fontStyleSettingListFromJson(
  List? fontStyleSetting, [
  List<enums.FontStyleSetting>? defaultValue,
]) {
  if (fontStyleSetting == null) {
    return defaultValue ?? [];
  }

  return fontStyleSetting
      .map((e) => fontStyleSettingFromJson(e.toString()))
      .toList();
}

List<enums.FontStyleSetting>? fontStyleSettingNullableListFromJson(
  List? fontStyleSetting, [
  List<enums.FontStyleSetting>? defaultValue,
]) {
  if (fontStyleSetting == null) {
    return defaultValue;
  }

  return fontStyleSetting
      .map((e) => fontStyleSettingFromJson(e.toString()))
      .toList();
}

String? messageTypeNullableToJson(enums.MessageType? messageType) {
  return messageType?.value;
}

String? messageTypeToJson(enums.MessageType messageType) {
  return messageType.value;
}

enums.MessageType messageTypeFromJson(
  Object? messageType, [
  enums.MessageType? defaultValue,
]) {
  return enums.MessageType.values
          .firstWhereOrNull((e) => e.value == messageType) ??
      defaultValue ??
      enums.MessageType.swaggerGeneratedUnknown;
}

enums.MessageType? messageTypeNullableFromJson(
  Object? messageType, [
  enums.MessageType? defaultValue,
]) {
  if (messageType == null) {
    return null;
  }
  return enums.MessageType.values
          .firstWhereOrNull((e) => e.value == messageType) ??
      defaultValue;
}

String messageTypeExplodedListToJson(List<enums.MessageType>? messageType) {
  return messageType?.map((e) => e.value!).join(',') ?? '';
}

List<String>? messageTypeListToJson(List<enums.MessageType>? messageType) {
  if (messageType == null) {
    return null;
  }

  return messageType.map((e) => e.value!).toList();
}

List<enums.MessageType> messageTypeListFromJson(
  List? messageType, [
  List<enums.MessageType>? defaultValue,
]) {
  if (messageType == null) {
    return defaultValue ?? [];
  }

  return messageType.map((e) => messageTypeFromJson(e.toString())).toList();
}

List<enums.MessageType>? messageTypeNullableListFromJson(
  List? messageType, [
  List<enums.MessageType>? defaultValue,
]) {
  if (messageType == null) {
    return defaultValue;
  }

  return messageType.map((e) => messageTypeFromJson(e.toString())).toList();
}

int? commandNullableToJson(enums.Command? command) {
  return command?.value;
}

int? commandToJson(enums.Command command) {
  return command.value;
}

enums.Command commandFromJson(
  Object? command, [
  enums.Command? defaultValue,
]) {
  return enums.Command.values.firstWhereOrNull((e) => e.value == command) ??
      defaultValue ??
      enums.Command.swaggerGeneratedUnknown;
}

enums.Command? commandNullableFromJson(
  Object? command, [
  enums.Command? defaultValue,
]) {
  if (command == null) {
    return null;
  }
  return enums.Command.values.firstWhereOrNull((e) => e.value == command) ??
      defaultValue;
}

String commandExplodedListToJson(List<enums.Command>? command) {
  return command?.map((e) => e.value!).join(',') ?? '';
}

List<int>? commandListToJson(List<enums.Command>? command) {
  if (command == null) {
    return null;
  }

  return command.map((e) => e.value!).toList();
}

List<enums.Command> commandListFromJson(
  List? command, [
  List<enums.Command>? defaultValue,
]) {
  if (command == null) {
    return defaultValue ?? [];
  }

  return command.map((e) => commandFromJson(e.toString())).toList();
}

List<enums.Command>? commandNullableListFromJson(
  List? command, [
  List<enums.Command>? defaultValue,
]) {
  if (command == null) {
    return defaultValue;
  }

  return command.map((e) => commandFromJson(e.toString())).toList();
}

String? command2NullableToJson(enums.Command2? command2) {
  return command2?.value;
}

String? command2ToJson(enums.Command2 command2) {
  return command2.value;
}

enums.Command2 command2FromJson(
  Object? command2, [
  enums.Command2? defaultValue,
]) {
  return enums.Command2.values.firstWhereOrNull((e) => e.value == command2) ??
      defaultValue ??
      enums.Command2.swaggerGeneratedUnknown;
}

enums.Command2? command2NullableFromJson(
  Object? command2, [
  enums.Command2? defaultValue,
]) {
  if (command2 == null) {
    return null;
  }
  return enums.Command2.values.firstWhereOrNull((e) => e.value == command2) ??
      defaultValue;
}

String command2ExplodedListToJson(List<enums.Command2>? command2) {
  return command2?.map((e) => e.value!).join(',') ?? '';
}

List<String>? command2ListToJson(List<enums.Command2>? command2) {
  if (command2 == null) {
    return null;
  }

  return command2.map((e) => e.value!).toList();
}

List<enums.Command2> command2ListFromJson(
  List? command2, [
  List<enums.Command2>? defaultValue,
]) {
  if (command2 == null) {
    return defaultValue ?? [];
  }

  return command2.map((e) => command2FromJson(e.toString())).toList();
}

List<enums.Command2>? command2NullableListFromJson(
  List? command2, [
  List<enums.Command2>? defaultValue,
]) {
  if (command2 == null) {
    return defaultValue;
  }

  return command2.map((e) => command2FromJson(e.toString())).toList();
}

int? appLogLevelNullableToJson(enums.AppLogLevel? appLogLevel) {
  return appLogLevel?.value;
}

int? appLogLevelToJson(enums.AppLogLevel appLogLevel) {
  return appLogLevel.value;
}

enums.AppLogLevel appLogLevelFromJson(
  Object? appLogLevel, [
  enums.AppLogLevel? defaultValue,
]) {
  return enums.AppLogLevel.values
          .firstWhereOrNull((e) => e.value == appLogLevel) ??
      defaultValue ??
      enums.AppLogLevel.swaggerGeneratedUnknown;
}

enums.AppLogLevel? appLogLevelNullableFromJson(
  Object? appLogLevel, [
  enums.AppLogLevel? defaultValue,
]) {
  if (appLogLevel == null) {
    return null;
  }
  return enums.AppLogLevel.values
          .firstWhereOrNull((e) => e.value == appLogLevel) ??
      defaultValue;
}

String appLogLevelExplodedListToJson(List<enums.AppLogLevel>? appLogLevel) {
  return appLogLevel?.map((e) => e.value!).join(',') ?? '';
}

List<int>? appLogLevelListToJson(List<enums.AppLogLevel>? appLogLevel) {
  if (appLogLevel == null) {
    return null;
  }

  return appLogLevel.map((e) => e.value!).toList();
}

List<enums.AppLogLevel> appLogLevelListFromJson(
  List? appLogLevel, [
  List<enums.AppLogLevel>? defaultValue,
]) {
  if (appLogLevel == null) {
    return defaultValue ?? [];
  }

  return appLogLevel.map((e) => appLogLevelFromJson(e.toString())).toList();
}

List<enums.AppLogLevel>? appLogLevelNullableListFromJson(
  List? appLogLevel, [
  List<enums.AppLogLevel>? defaultValue,
]) {
  if (appLogLevel == null) {
    return defaultValue;
  }

  return appLogLevel.map((e) => appLogLevelFromJson(e.toString())).toList();
}

typedef $JsonFactory<T> = T Function(Map<String, dynamic> json);

class $CustomJsonDecoder {
  $CustomJsonDecoder(this.factories);

  final Map<Type, $JsonFactory> factories;

  dynamic decode<T>(dynamic entity) {
    if (entity is Iterable) {
      return _decodeList<T>(entity);
    }

    if (entity is T) {
      return entity;
    }

    if (isTypeOf<T, Map>()) {
      return entity;
    }

    if (isTypeOf<T, Iterable>()) {
      return entity;
    }

    if (entity is Map<String, dynamic>) {
      return _decodeMap<T>(entity);
    }

    return entity;
  }

  T _decodeMap<T>(Map<String, dynamic> values) {
    final jsonFactory = factories[T];
    if (jsonFactory == null || jsonFactory is! $JsonFactory<T>) {
      return throw "Could not find factory for type $T. Is '$T: $T.fromJsonFactory' included in the CustomJsonDecoder instance creation in bootstrapper.dart?";
    }

    return jsonFactory(values);
  }

  List<T> _decodeList<T>(Iterable values) =>
      values.where((v) => v != null).map<T>((v) => decode<T>(v) as T).toList();
}

class $JsonSerializableConverter extends chopper.JsonConverter {
  @override
  FutureOr<chopper.Response<ResultType>> convertResponse<ResultType, Item>(
      chopper.Response response) async {
    if (response.bodyString.isEmpty) {
      // In rare cases, when let's say 204 (no content) is returned -
      // we cannot decode the missing json with the result type specified
      return chopper.Response(response.base, null, error: response.error);
    }

    if (ResultType == String) {
      return response.copyWith();
    }

    if (ResultType == DateTime) {
      return response.copyWith(
          body: DateTime.parse((response.body as String).replaceAll('"', ''))
              as ResultType);
    }

    final jsonRes = await super.convertResponse(response);
    return jsonRes.copyWith<ResultType>(
        body: $jsonDecoder.decode<Item>(jsonRes.body) as ResultType);
  }
}

final $jsonDecoder = $CustomJsonDecoder(generatedMapping);

// ignore: unused_element
String? _dateToJson(DateTime? date) {
  if (date == null) {
    return null;
  }

  final year = date.year.toString();
  final month = date.month < 10 ? '0${date.month}' : date.month.toString();
  final day = date.day < 10 ? '0${date.day}' : date.day.toString();

  return '$year-$month-$day';
}

class Wrapped<T> {
  final T value;
  const Wrapped.value(this.value);
}
