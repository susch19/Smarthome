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
  Future<chopper.Response<List<DeviceOverview>>> appDeviceOverviewGet() {
    generatedMapping.putIfAbsent(
        DeviceOverview, () => DeviceOverview.fromJsonFactory);

    return _appDeviceOverviewGet();
  }

  ///
  @Get(path: '/app/device/overview')
  Future<chopper.Response<List<DeviceOverview>>> _appDeviceOverviewGet();

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
      {required JsonSmarthomeMessage? message}) {
    return _appSmarthomePost(message: message);
  }

  ///
  ///@param message
  @Post(path: '/app/smarthome')
  Future<chopper.Response> _appSmarthomePost(
      {@Body() required JsonSmarthomeMessage? message});

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
  Future<chopper.Response<List<int>>> notificationSendNotificationGet() {
    return _notificationSendNotificationGet();
  }

  ///
  @Get(path: '/notification/sendNotification')
  Future<chopper.Response<List<int>>> _notificationSendNotificationGet();

  ///
  Future<chopper.Response<Object>> notificationFirebaseOptionsGet() {
    return _notificationFirebaseOptionsGet();
  }

  ///
  @Get(path: '/notification/firebaseOptions')
  Future<chopper.Response<Object>> _notificationFirebaseOptionsGet();
}

@JsonSerializable(explicitToJson: true)
class RestCreatedDevice {
  const RestCreatedDevice({
    required this.idStr,
    required this.fileBased,
    required this.typeNames,
    required this.subscribers,
    required this.id,
    required this.typeName,
    required this.showInApp,
    required this.friendlyName,
    required this.initialized,
    required this.logger,
    required this.startAutomatically,
    this.dynamicStateData,
  });

  factory RestCreatedDevice.fromJson(Map<String, dynamic> json) =>
      _$RestCreatedDeviceFromJson(json);

  static const toJsonFactory = _$RestCreatedDeviceToJson;
  Map<String, dynamic> toJson() => _$RestCreatedDeviceToJson(this);

  @JsonKey(name: 'idStr')
  final String idStr;
  @JsonKey(name: 'fileBased')
  final bool fileBased;
  @JsonKey(name: 'typeNames', defaultValue: <String>[])
  final List<String> typeNames;
  @JsonKey(name: 'subscribers', defaultValue: <Subscriber>[])
  final List<Subscriber> subscribers;
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'typeName')
  final String typeName;
  @JsonKey(name: 'showInApp')
  final bool showInApp;
  @JsonKey(name: 'friendlyName')
  final String friendlyName;
  @JsonKey(name: 'initialized')
  final bool initialized;
  @JsonKey(name: 'logger')
  final Logger logger;
  @JsonKey(name: 'startAutomatically')
  final bool startAutomatically;
  @JsonKey(name: 'dynamicStateData')
  final Map<String, dynamic>? dynamicStateData;
  static const fromJsonFactory = _$RestCreatedDeviceFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RestCreatedDevice &&
            (identical(other.idStr, idStr) ||
                const DeepCollectionEquality().equals(other.idStr, idStr)) &&
            (identical(other.fileBased, fileBased) ||
                const DeepCollectionEquality()
                    .equals(other.fileBased, fileBased)) &&
            (identical(other.typeNames, typeNames) ||
                const DeepCollectionEquality()
                    .equals(other.typeNames, typeNames)) &&
            (identical(other.subscribers, subscribers) ||
                const DeepCollectionEquality()
                    .equals(other.subscribers, subscribers)) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.typeName, typeName) ||
                const DeepCollectionEquality()
                    .equals(other.typeName, typeName)) &&
            (identical(other.showInApp, showInApp) ||
                const DeepCollectionEquality()
                    .equals(other.showInApp, showInApp)) &&
            (identical(other.friendlyName, friendlyName) ||
                const DeepCollectionEquality()
                    .equals(other.friendlyName, friendlyName)) &&
            (identical(other.initialized, initialized) ||
                const DeepCollectionEquality()
                    .equals(other.initialized, initialized)) &&
            (identical(other.logger, logger) ||
                const DeepCollectionEquality().equals(other.logger, logger)) &&
            (identical(other.startAutomatically, startAutomatically) ||
                const DeepCollectionEquality()
                    .equals(other.startAutomatically, startAutomatically)) &&
            (identical(other.dynamicStateData, dynamicStateData) ||
                const DeepCollectionEquality()
                    .equals(other.dynamicStateData, dynamicStateData)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(idStr) ^
      const DeepCollectionEquality().hash(fileBased) ^
      const DeepCollectionEquality().hash(typeNames) ^
      const DeepCollectionEquality().hash(subscribers) ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(typeName) ^
      const DeepCollectionEquality().hash(showInApp) ^
      const DeepCollectionEquality().hash(friendlyName) ^
      const DeepCollectionEquality().hash(initialized) ^
      const DeepCollectionEquality().hash(logger) ^
      const DeepCollectionEquality().hash(startAutomatically) ^
      const DeepCollectionEquality().hash(dynamicStateData) ^
      runtimeType.hashCode;
}

extension $RestCreatedDeviceExtension on RestCreatedDevice {
  RestCreatedDevice copyWith(
      {String? idStr,
      bool? fileBased,
      List<String>? typeNames,
      List<Subscriber>? subscribers,
      int? id,
      String? typeName,
      bool? showInApp,
      String? friendlyName,
      bool? initialized,
      Logger? logger,
      bool? startAutomatically,
      Map<String, dynamic>? dynamicStateData}) {
    return RestCreatedDevice(
        idStr: idStr ?? this.idStr,
        fileBased: fileBased ?? this.fileBased,
        typeNames: typeNames ?? this.typeNames,
        subscribers: subscribers ?? this.subscribers,
        id: id ?? this.id,
        typeName: typeName ?? this.typeName,
        showInApp: showInApp ?? this.showInApp,
        friendlyName: friendlyName ?? this.friendlyName,
        initialized: initialized ?? this.initialized,
        logger: logger ?? this.logger,
        startAutomatically: startAutomatically ?? this.startAutomatically,
        dynamicStateData: dynamicStateData ?? this.dynamicStateData);
  }

  RestCreatedDevice copyWithWrapped(
      {Wrapped<String>? idStr,
      Wrapped<bool>? fileBased,
      Wrapped<List<String>>? typeNames,
      Wrapped<List<Subscriber>>? subscribers,
      Wrapped<int>? id,
      Wrapped<String>? typeName,
      Wrapped<bool>? showInApp,
      Wrapped<String>? friendlyName,
      Wrapped<bool>? initialized,
      Wrapped<Logger>? logger,
      Wrapped<bool>? startAutomatically,
      Wrapped<Map<String, dynamic>?>? dynamicStateData}) {
    return RestCreatedDevice(
        idStr: (idStr != null ? idStr.value : this.idStr),
        fileBased: (fileBased != null ? fileBased.value : this.fileBased),
        typeNames: (typeNames != null ? typeNames.value : this.typeNames),
        subscribers:
            (subscribers != null ? subscribers.value : this.subscribers),
        id: (id != null ? id.value : this.id),
        typeName: (typeName != null ? typeName.value : this.typeName),
        showInApp: (showInApp != null ? showInApp.value : this.showInApp),
        friendlyName:
            (friendlyName != null ? friendlyName.value : this.friendlyName),
        initialized:
            (initialized != null ? initialized.value : this.initialized),
        logger: (logger != null ? logger.value : this.logger),
        startAutomatically: (startAutomatically != null
            ? startAutomatically.value
            : this.startAutomatically),
        dynamicStateData: (dynamicStateData != null
            ? dynamicStateData.value
            : this.dynamicStateData));
  }
}

@JsonSerializable(explicitToJson: true)
class JavaScriptDevice {
  const JavaScriptDevice({
    required this.idStr,
    required this.fileBased,
    required this.typeNames,
    required this.subscribers,
    required this.id,
    required this.typeName,
    required this.showInApp,
    required this.friendlyName,
    required this.initialized,
    required this.logger,
    required this.startAutomatically,
    this.dynamicStateData,
  });

  factory JavaScriptDevice.fromJson(Map<String, dynamic> json) =>
      _$JavaScriptDeviceFromJson(json);

  static const toJsonFactory = _$JavaScriptDeviceToJson;
  Map<String, dynamic> toJson() => _$JavaScriptDeviceToJson(this);

  @JsonKey(name: 'idStr')
  final String idStr;
  @JsonKey(name: 'fileBased')
  final bool fileBased;
  @JsonKey(name: 'typeNames', defaultValue: <String>[])
  final List<String> typeNames;
  @JsonKey(name: 'subscribers', defaultValue: <Subscriber>[])
  final List<Subscriber> subscribers;
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'typeName')
  final String typeName;
  @JsonKey(name: 'showInApp')
  final bool showInApp;
  @JsonKey(name: 'friendlyName')
  final String friendlyName;
  @JsonKey(name: 'initialized')
  final bool initialized;
  @JsonKey(name: 'logger')
  final Logger logger;
  @JsonKey(name: 'startAutomatically')
  final bool startAutomatically;
  @JsonKey(name: 'dynamicStateData')
  final Map<String, dynamic>? dynamicStateData;
  static const fromJsonFactory = _$JavaScriptDeviceFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is JavaScriptDevice &&
            (identical(other.idStr, idStr) ||
                const DeepCollectionEquality().equals(other.idStr, idStr)) &&
            (identical(other.fileBased, fileBased) ||
                const DeepCollectionEquality()
                    .equals(other.fileBased, fileBased)) &&
            (identical(other.typeNames, typeNames) ||
                const DeepCollectionEquality()
                    .equals(other.typeNames, typeNames)) &&
            (identical(other.subscribers, subscribers) ||
                const DeepCollectionEquality()
                    .equals(other.subscribers, subscribers)) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.typeName, typeName) ||
                const DeepCollectionEquality()
                    .equals(other.typeName, typeName)) &&
            (identical(other.showInApp, showInApp) ||
                const DeepCollectionEquality()
                    .equals(other.showInApp, showInApp)) &&
            (identical(other.friendlyName, friendlyName) ||
                const DeepCollectionEquality()
                    .equals(other.friendlyName, friendlyName)) &&
            (identical(other.initialized, initialized) ||
                const DeepCollectionEquality()
                    .equals(other.initialized, initialized)) &&
            (identical(other.logger, logger) ||
                const DeepCollectionEquality().equals(other.logger, logger)) &&
            (identical(other.startAutomatically, startAutomatically) ||
                const DeepCollectionEquality()
                    .equals(other.startAutomatically, startAutomatically)) &&
            (identical(other.dynamicStateData, dynamicStateData) ||
                const DeepCollectionEquality()
                    .equals(other.dynamicStateData, dynamicStateData)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(idStr) ^
      const DeepCollectionEquality().hash(fileBased) ^
      const DeepCollectionEquality().hash(typeNames) ^
      const DeepCollectionEquality().hash(subscribers) ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(typeName) ^
      const DeepCollectionEquality().hash(showInApp) ^
      const DeepCollectionEquality().hash(friendlyName) ^
      const DeepCollectionEquality().hash(initialized) ^
      const DeepCollectionEquality().hash(logger) ^
      const DeepCollectionEquality().hash(startAutomatically) ^
      const DeepCollectionEquality().hash(dynamicStateData) ^
      runtimeType.hashCode;
}

extension $JavaScriptDeviceExtension on JavaScriptDevice {
  JavaScriptDevice copyWith(
      {String? idStr,
      bool? fileBased,
      List<String>? typeNames,
      List<Subscriber>? subscribers,
      int? id,
      String? typeName,
      bool? showInApp,
      String? friendlyName,
      bool? initialized,
      Logger? logger,
      bool? startAutomatically,
      Map<String, dynamic>? dynamicStateData}) {
    return JavaScriptDevice(
        idStr: idStr ?? this.idStr,
        fileBased: fileBased ?? this.fileBased,
        typeNames: typeNames ?? this.typeNames,
        subscribers: subscribers ?? this.subscribers,
        id: id ?? this.id,
        typeName: typeName ?? this.typeName,
        showInApp: showInApp ?? this.showInApp,
        friendlyName: friendlyName ?? this.friendlyName,
        initialized: initialized ?? this.initialized,
        logger: logger ?? this.logger,
        startAutomatically: startAutomatically ?? this.startAutomatically,
        dynamicStateData: dynamicStateData ?? this.dynamicStateData);
  }

  JavaScriptDevice copyWithWrapped(
      {Wrapped<String>? idStr,
      Wrapped<bool>? fileBased,
      Wrapped<List<String>>? typeNames,
      Wrapped<List<Subscriber>>? subscribers,
      Wrapped<int>? id,
      Wrapped<String>? typeName,
      Wrapped<bool>? showInApp,
      Wrapped<String>? friendlyName,
      Wrapped<bool>? initialized,
      Wrapped<Logger>? logger,
      Wrapped<bool>? startAutomatically,
      Wrapped<Map<String, dynamic>?>? dynamicStateData}) {
    return JavaScriptDevice(
        idStr: (idStr != null ? idStr.value : this.idStr),
        fileBased: (fileBased != null ? fileBased.value : this.fileBased),
        typeNames: (typeNames != null ? typeNames.value : this.typeNames),
        subscribers:
            (subscribers != null ? subscribers.value : this.subscribers),
        id: (id != null ? id.value : this.id),
        typeName: (typeName != null ? typeName.value : this.typeName),
        showInApp: (showInApp != null ? showInApp.value : this.showInApp),
        friendlyName:
            (friendlyName != null ? friendlyName.value : this.friendlyName),
        initialized:
            (initialized != null ? initialized.value : this.initialized),
        logger: (logger != null ? logger.value : this.logger),
        startAutomatically: (startAutomatically != null
            ? startAutomatically.value
            : this.startAutomatically),
        dynamicStateData: (dynamicStateData != null
            ? dynamicStateData.value
            : this.dynamicStateData));
  }
}

@JsonSerializable(explicitToJson: true)
class Subscriber {
  const Subscriber({
    required this.connectionId,
    required this.smarthomeClient,
  });

  factory Subscriber.fromJson(Map<String, dynamic> json) =>
      _$SubscriberFromJson(json);

  static const toJsonFactory = _$SubscriberToJson;
  Map<String, dynamic> toJson() => _$SubscriberToJson(this);

  @JsonKey(name: 'connectionId')
  final String connectionId;
  @JsonKey(name: 'smarthomeClient')
  final dynamic smarthomeClient;
  static const fromJsonFactory = _$SubscriberFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Subscriber &&
            (identical(other.connectionId, connectionId) ||
                const DeepCollectionEquality()
                    .equals(other.connectionId, connectionId)) &&
            (identical(other.smarthomeClient, smarthomeClient) ||
                const DeepCollectionEquality()
                    .equals(other.smarthomeClient, smarthomeClient)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(connectionId) ^
      const DeepCollectionEquality().hash(smarthomeClient) ^
      runtimeType.hashCode;
}

extension $SubscriberExtension on Subscriber {
  Subscriber copyWith({String? connectionId, dynamic smarthomeClient}) {
    return Subscriber(
        connectionId: connectionId ?? this.connectionId,
        smarthomeClient: smarthomeClient ?? this.smarthomeClient);
  }

  Subscriber copyWithWrapped(
      {Wrapped<String>? connectionId, Wrapped<dynamic>? smarthomeClient}) {
    return Subscriber(
        connectionId:
            (connectionId != null ? connectionId.value : this.connectionId),
        smarthomeClient: (smarthomeClient != null
            ? smarthomeClient.value
            : this.smarthomeClient));
  }
}

@JsonSerializable(explicitToJson: true)
class Logger {
  const Logger({
    required this.isTraceEnabled,
    required this.isDebugEnabled,
    required this.isInfoEnabled,
    required this.isWarnEnabled,
    required this.isErrorEnabled,
    required this.isFatalEnabled,
    this.name,
    this.$factory,
    this.properties,
  });

  factory Logger.fromJson(Map<String, dynamic> json) => _$LoggerFromJson(json);

  static const toJsonFactory = _$LoggerToJson;
  Map<String, dynamic> toJson() => _$LoggerToJson(this);

  @JsonKey(name: 'isTraceEnabled')
  final bool isTraceEnabled;
  @JsonKey(name: 'isDebugEnabled')
  final bool isDebugEnabled;
  @JsonKey(name: 'isInfoEnabled')
  final bool isInfoEnabled;
  @JsonKey(name: 'isWarnEnabled')
  final bool isWarnEnabled;
  @JsonKey(name: 'isErrorEnabled')
  final bool isErrorEnabled;
  @JsonKey(name: 'isFatalEnabled')
  final bool isFatalEnabled;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'factory')
  final LogFactory? $factory;
  @JsonKey(name: 'properties')
  final Map<String, dynamic>? properties;
  static const fromJsonFactory = _$LoggerFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Logger &&
            (identical(other.isTraceEnabled, isTraceEnabled) ||
                const DeepCollectionEquality()
                    .equals(other.isTraceEnabled, isTraceEnabled)) &&
            (identical(other.isDebugEnabled, isDebugEnabled) ||
                const DeepCollectionEquality()
                    .equals(other.isDebugEnabled, isDebugEnabled)) &&
            (identical(other.isInfoEnabled, isInfoEnabled) ||
                const DeepCollectionEquality()
                    .equals(other.isInfoEnabled, isInfoEnabled)) &&
            (identical(other.isWarnEnabled, isWarnEnabled) ||
                const DeepCollectionEquality()
                    .equals(other.isWarnEnabled, isWarnEnabled)) &&
            (identical(other.isErrorEnabled, isErrorEnabled) ||
                const DeepCollectionEquality()
                    .equals(other.isErrorEnabled, isErrorEnabled)) &&
            (identical(other.isFatalEnabled, isFatalEnabled) ||
                const DeepCollectionEquality()
                    .equals(other.isFatalEnabled, isFatalEnabled)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.$factory, $factory) ||
                const DeepCollectionEquality()
                    .equals(other.$factory, $factory)) &&
            (identical(other.properties, properties) ||
                const DeepCollectionEquality()
                    .equals(other.properties, properties)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(isTraceEnabled) ^
      const DeepCollectionEquality().hash(isDebugEnabled) ^
      const DeepCollectionEquality().hash(isInfoEnabled) ^
      const DeepCollectionEquality().hash(isWarnEnabled) ^
      const DeepCollectionEquality().hash(isErrorEnabled) ^
      const DeepCollectionEquality().hash(isFatalEnabled) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash($factory) ^
      const DeepCollectionEquality().hash(properties) ^
      runtimeType.hashCode;
}

extension $LoggerExtension on Logger {
  Logger copyWith(
      {bool? isTraceEnabled,
      bool? isDebugEnabled,
      bool? isInfoEnabled,
      bool? isWarnEnabled,
      bool? isErrorEnabled,
      bool? isFatalEnabled,
      String? name,
      LogFactory? $factory,
      Map<String, dynamic>? properties}) {
    return Logger(
        isTraceEnabled: isTraceEnabled ?? this.isTraceEnabled,
        isDebugEnabled: isDebugEnabled ?? this.isDebugEnabled,
        isInfoEnabled: isInfoEnabled ?? this.isInfoEnabled,
        isWarnEnabled: isWarnEnabled ?? this.isWarnEnabled,
        isErrorEnabled: isErrorEnabled ?? this.isErrorEnabled,
        isFatalEnabled: isFatalEnabled ?? this.isFatalEnabled,
        name: name ?? this.name,
        $factory: $factory ?? this.$factory,
        properties: properties ?? this.properties);
  }

  Logger copyWithWrapped(
      {Wrapped<bool>? isTraceEnabled,
      Wrapped<bool>? isDebugEnabled,
      Wrapped<bool>? isInfoEnabled,
      Wrapped<bool>? isWarnEnabled,
      Wrapped<bool>? isErrorEnabled,
      Wrapped<bool>? isFatalEnabled,
      Wrapped<String?>? name,
      Wrapped<LogFactory?>? $factory,
      Wrapped<Map<String, dynamic>?>? properties}) {
    return Logger(
        isTraceEnabled: (isTraceEnabled != null
            ? isTraceEnabled.value
            : this.isTraceEnabled),
        isDebugEnabled: (isDebugEnabled != null
            ? isDebugEnabled.value
            : this.isDebugEnabled),
        isInfoEnabled:
            (isInfoEnabled != null ? isInfoEnabled.value : this.isInfoEnabled),
        isWarnEnabled:
            (isWarnEnabled != null ? isWarnEnabled.value : this.isWarnEnabled),
        isErrorEnabled: (isErrorEnabled != null
            ? isErrorEnabled.value
            : this.isErrorEnabled),
        isFatalEnabled: (isFatalEnabled != null
            ? isFatalEnabled.value
            : this.isFatalEnabled),
        name: (name != null ? name.value : this.name),
        $factory: ($factory != null ? $factory.value : this.$factory),
        properties: (properties != null ? properties.value : this.properties));
  }
}

@JsonSerializable(explicitToJson: true)
class LogFactory {
  const LogFactory({
    this.currentAppEnvironment,
    required this.throwExceptions,
    this.throwConfigExceptions,
    required this.keepVariablesOnReload,
    required this.autoShutdown,
    this.configuration,
    required this.serviceRepository,
    this.globalThreshold,
    this.defaultCultureInfo,
  });

  factory LogFactory.fromJson(Map<String, dynamic> json) =>
      _$LogFactoryFromJson(json);

  static const toJsonFactory = _$LogFactoryToJson;
  Map<String, dynamic> toJson() => _$LogFactoryToJson(this);

  @JsonKey(name: 'currentAppEnvironment')
  final IAppEnvironment? currentAppEnvironment;
  @JsonKey(name: 'throwExceptions')
  final bool throwExceptions;
  @JsonKey(name: 'throwConfigExceptions')
  final bool? throwConfigExceptions;
  @JsonKey(name: 'keepVariablesOnReload')
  final bool keepVariablesOnReload;
  @JsonKey(name: 'autoShutdown')
  final bool autoShutdown;
  @JsonKey(name: 'configuration')
  final LoggingConfiguration? configuration;
  @JsonKey(name: 'serviceRepository')
  final ServiceRepository serviceRepository;
  @JsonKey(name: 'globalThreshold')
  final LogLevel? globalThreshold;
  @JsonKey(name: 'defaultCultureInfo')
  final CultureInfo? defaultCultureInfo;
  static const fromJsonFactory = _$LogFactoryFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LogFactory &&
            (identical(other.currentAppEnvironment, currentAppEnvironment) ||
                const DeepCollectionEquality().equals(
                    other.currentAppEnvironment, currentAppEnvironment)) &&
            (identical(other.throwExceptions, throwExceptions) ||
                const DeepCollectionEquality()
                    .equals(other.throwExceptions, throwExceptions)) &&
            (identical(other.throwConfigExceptions, throwConfigExceptions) ||
                const DeepCollectionEquality().equals(
                    other.throwConfigExceptions, throwConfigExceptions)) &&
            (identical(other.keepVariablesOnReload, keepVariablesOnReload) ||
                const DeepCollectionEquality().equals(
                    other.keepVariablesOnReload, keepVariablesOnReload)) &&
            (identical(other.autoShutdown, autoShutdown) ||
                const DeepCollectionEquality()
                    .equals(other.autoShutdown, autoShutdown)) &&
            (identical(other.configuration, configuration) ||
                const DeepCollectionEquality()
                    .equals(other.configuration, configuration)) &&
            (identical(other.serviceRepository, serviceRepository) ||
                const DeepCollectionEquality()
                    .equals(other.serviceRepository, serviceRepository)) &&
            (identical(other.globalThreshold, globalThreshold) ||
                const DeepCollectionEquality()
                    .equals(other.globalThreshold, globalThreshold)) &&
            (identical(other.defaultCultureInfo, defaultCultureInfo) ||
                const DeepCollectionEquality()
                    .equals(other.defaultCultureInfo, defaultCultureInfo)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(currentAppEnvironment) ^
      const DeepCollectionEquality().hash(throwExceptions) ^
      const DeepCollectionEquality().hash(throwConfigExceptions) ^
      const DeepCollectionEquality().hash(keepVariablesOnReload) ^
      const DeepCollectionEquality().hash(autoShutdown) ^
      const DeepCollectionEquality().hash(configuration) ^
      const DeepCollectionEquality().hash(serviceRepository) ^
      const DeepCollectionEquality().hash(globalThreshold) ^
      const DeepCollectionEquality().hash(defaultCultureInfo) ^
      runtimeType.hashCode;
}

extension $LogFactoryExtension on LogFactory {
  LogFactory copyWith(
      {IAppEnvironment? currentAppEnvironment,
      bool? throwExceptions,
      bool? throwConfigExceptions,
      bool? keepVariablesOnReload,
      bool? autoShutdown,
      LoggingConfiguration? configuration,
      ServiceRepository? serviceRepository,
      LogLevel? globalThreshold,
      CultureInfo? defaultCultureInfo}) {
    return LogFactory(
        currentAppEnvironment:
            currentAppEnvironment ?? this.currentAppEnvironment,
        throwExceptions: throwExceptions ?? this.throwExceptions,
        throwConfigExceptions:
            throwConfigExceptions ?? this.throwConfigExceptions,
        keepVariablesOnReload:
            keepVariablesOnReload ?? this.keepVariablesOnReload,
        autoShutdown: autoShutdown ?? this.autoShutdown,
        configuration: configuration ?? this.configuration,
        serviceRepository: serviceRepository ?? this.serviceRepository,
        globalThreshold: globalThreshold ?? this.globalThreshold,
        defaultCultureInfo: defaultCultureInfo ?? this.defaultCultureInfo);
  }

  LogFactory copyWithWrapped(
      {Wrapped<IAppEnvironment?>? currentAppEnvironment,
      Wrapped<bool>? throwExceptions,
      Wrapped<bool?>? throwConfigExceptions,
      Wrapped<bool>? keepVariablesOnReload,
      Wrapped<bool>? autoShutdown,
      Wrapped<LoggingConfiguration?>? configuration,
      Wrapped<ServiceRepository>? serviceRepository,
      Wrapped<LogLevel?>? globalThreshold,
      Wrapped<CultureInfo?>? defaultCultureInfo}) {
    return LogFactory(
        currentAppEnvironment: (currentAppEnvironment != null
            ? currentAppEnvironment.value
            : this.currentAppEnvironment),
        throwExceptions: (throwExceptions != null
            ? throwExceptions.value
            : this.throwExceptions),
        throwConfigExceptions: (throwConfigExceptions != null
            ? throwConfigExceptions.value
            : this.throwConfigExceptions),
        keepVariablesOnReload: (keepVariablesOnReload != null
            ? keepVariablesOnReload.value
            : this.keepVariablesOnReload),
        autoShutdown:
            (autoShutdown != null ? autoShutdown.value : this.autoShutdown),
        configuration:
            (configuration != null ? configuration.value : this.configuration),
        serviceRepository: (serviceRepository != null
            ? serviceRepository.value
            : this.serviceRepository),
        globalThreshold: (globalThreshold != null
            ? globalThreshold.value
            : this.globalThreshold),
        defaultCultureInfo: (defaultCultureInfo != null
            ? defaultCultureInfo.value
            : this.defaultCultureInfo));
  }
}

@JsonSerializable(explicitToJson: true)
class IAppEnvironment {
  const IAppEnvironment({
    this.appDomainBaseDirectory,
    this.appDomainConfigurationFile,
    this.appDomainFriendlyName,
    required this.appDomainId,
    this.appDomainPrivateBinPath,
    this.appDomain,
    this.currentProcessFilePath,
    this.currentProcessBaseName,
    required this.currentProcessId,
    this.entryAssemblyLocation,
    this.entryAssemblyFileName,
    this.userTempFilePath,
  });

  factory IAppEnvironment.fromJson(Map<String, dynamic> json) =>
      _$IAppEnvironmentFromJson(json);

  static const toJsonFactory = _$IAppEnvironmentToJson;
  Map<String, dynamic> toJson() => _$IAppEnvironmentToJson(this);

  @JsonKey(name: 'appDomainBaseDirectory')
  final String? appDomainBaseDirectory;
  @JsonKey(name: 'appDomainConfigurationFile')
  final String? appDomainConfigurationFile;
  @JsonKey(name: 'appDomainFriendlyName')
  final String? appDomainFriendlyName;
  @JsonKey(name: 'appDomainId')
  final int appDomainId;
  @JsonKey(name: 'appDomainPrivateBinPath', defaultValue: <String>[])
  final List<String>? appDomainPrivateBinPath;
  @JsonKey(name: 'appDomain')
  final IAppDomain? appDomain;
  @JsonKey(name: 'currentProcessFilePath')
  final String? currentProcessFilePath;
  @JsonKey(name: 'currentProcessBaseName')
  final String? currentProcessBaseName;
  @JsonKey(name: 'currentProcessId')
  final int currentProcessId;
  @JsonKey(name: 'entryAssemblyLocation')
  final String? entryAssemblyLocation;
  @JsonKey(name: 'entryAssemblyFileName')
  final String? entryAssemblyFileName;
  @JsonKey(name: 'userTempFilePath')
  final String? userTempFilePath;
  static const fromJsonFactory = _$IAppEnvironmentFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is IAppEnvironment &&
            (identical(other.appDomainBaseDirectory, appDomainBaseDirectory) ||
                const DeepCollectionEquality().equals(
                    other.appDomainBaseDirectory, appDomainBaseDirectory)) &&
            (identical(other.appDomainConfigurationFile, appDomainConfigurationFile) ||
                const DeepCollectionEquality().equals(
                    other.appDomainConfigurationFile,
                    appDomainConfigurationFile)) &&
            (identical(other.appDomainFriendlyName, appDomainFriendlyName) ||
                const DeepCollectionEquality().equals(
                    other.appDomainFriendlyName, appDomainFriendlyName)) &&
            (identical(other.appDomainId, appDomainId) ||
                const DeepCollectionEquality()
                    .equals(other.appDomainId, appDomainId)) &&
            (identical(other.appDomainPrivateBinPath, appDomainPrivateBinPath) ||
                const DeepCollectionEquality().equals(
                    other.appDomainPrivateBinPath, appDomainPrivateBinPath)) &&
            (identical(other.appDomain, appDomain) ||
                const DeepCollectionEquality()
                    .equals(other.appDomain, appDomain)) &&
            (identical(other.currentProcessFilePath, currentProcessFilePath) ||
                const DeepCollectionEquality().equals(
                    other.currentProcessFilePath, currentProcessFilePath)) &&
            (identical(other.currentProcessBaseName, currentProcessBaseName) ||
                const DeepCollectionEquality().equals(
                    other.currentProcessBaseName, currentProcessBaseName)) &&
            (identical(other.currentProcessId, currentProcessId) ||
                const DeepCollectionEquality()
                    .equals(other.currentProcessId, currentProcessId)) &&
            (identical(other.entryAssemblyLocation, entryAssemblyLocation) ||
                const DeepCollectionEquality().equals(
                    other.entryAssemblyLocation, entryAssemblyLocation)) &&
            (identical(other.entryAssemblyFileName, entryAssemblyFileName) ||
                const DeepCollectionEquality().equals(
                    other.entryAssemblyFileName, entryAssemblyFileName)) &&
            (identical(other.userTempFilePath, userTempFilePath) ||
                const DeepCollectionEquality()
                    .equals(other.userTempFilePath, userTempFilePath)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(appDomainBaseDirectory) ^
      const DeepCollectionEquality().hash(appDomainConfigurationFile) ^
      const DeepCollectionEquality().hash(appDomainFriendlyName) ^
      const DeepCollectionEquality().hash(appDomainId) ^
      const DeepCollectionEquality().hash(appDomainPrivateBinPath) ^
      const DeepCollectionEquality().hash(appDomain) ^
      const DeepCollectionEquality().hash(currentProcessFilePath) ^
      const DeepCollectionEquality().hash(currentProcessBaseName) ^
      const DeepCollectionEquality().hash(currentProcessId) ^
      const DeepCollectionEquality().hash(entryAssemblyLocation) ^
      const DeepCollectionEquality().hash(entryAssemblyFileName) ^
      const DeepCollectionEquality().hash(userTempFilePath) ^
      runtimeType.hashCode;
}

extension $IAppEnvironmentExtension on IAppEnvironment {
  IAppEnvironment copyWith(
      {String? appDomainBaseDirectory,
      String? appDomainConfigurationFile,
      String? appDomainFriendlyName,
      int? appDomainId,
      List<String>? appDomainPrivateBinPath,
      IAppDomain? appDomain,
      String? currentProcessFilePath,
      String? currentProcessBaseName,
      int? currentProcessId,
      String? entryAssemblyLocation,
      String? entryAssemblyFileName,
      String? userTempFilePath}) {
    return IAppEnvironment(
        appDomainBaseDirectory:
            appDomainBaseDirectory ?? this.appDomainBaseDirectory,
        appDomainConfigurationFile:
            appDomainConfigurationFile ?? this.appDomainConfigurationFile,
        appDomainFriendlyName:
            appDomainFriendlyName ?? this.appDomainFriendlyName,
        appDomainId: appDomainId ?? this.appDomainId,
        appDomainPrivateBinPath:
            appDomainPrivateBinPath ?? this.appDomainPrivateBinPath,
        appDomain: appDomain ?? this.appDomain,
        currentProcessFilePath:
            currentProcessFilePath ?? this.currentProcessFilePath,
        currentProcessBaseName:
            currentProcessBaseName ?? this.currentProcessBaseName,
        currentProcessId: currentProcessId ?? this.currentProcessId,
        entryAssemblyLocation:
            entryAssemblyLocation ?? this.entryAssemblyLocation,
        entryAssemblyFileName:
            entryAssemblyFileName ?? this.entryAssemblyFileName,
        userTempFilePath: userTempFilePath ?? this.userTempFilePath);
  }

  IAppEnvironment copyWithWrapped(
      {Wrapped<String?>? appDomainBaseDirectory,
      Wrapped<String?>? appDomainConfigurationFile,
      Wrapped<String?>? appDomainFriendlyName,
      Wrapped<int>? appDomainId,
      Wrapped<List<String>?>? appDomainPrivateBinPath,
      Wrapped<IAppDomain?>? appDomain,
      Wrapped<String?>? currentProcessFilePath,
      Wrapped<String?>? currentProcessBaseName,
      Wrapped<int>? currentProcessId,
      Wrapped<String?>? entryAssemblyLocation,
      Wrapped<String?>? entryAssemblyFileName,
      Wrapped<String?>? userTempFilePath}) {
    return IAppEnvironment(
        appDomainBaseDirectory: (appDomainBaseDirectory != null
            ? appDomainBaseDirectory.value
            : this.appDomainBaseDirectory),
        appDomainConfigurationFile: (appDomainConfigurationFile != null
            ? appDomainConfigurationFile.value
            : this.appDomainConfigurationFile),
        appDomainFriendlyName: (appDomainFriendlyName != null
            ? appDomainFriendlyName.value
            : this.appDomainFriendlyName),
        appDomainId:
            (appDomainId != null ? appDomainId.value : this.appDomainId),
        appDomainPrivateBinPath: (appDomainPrivateBinPath != null
            ? appDomainPrivateBinPath.value
            : this.appDomainPrivateBinPath),
        appDomain: (appDomain != null ? appDomain.value : this.appDomain),
        currentProcessFilePath: (currentProcessFilePath != null
            ? currentProcessFilePath.value
            : this.currentProcessFilePath),
        currentProcessBaseName: (currentProcessBaseName != null
            ? currentProcessBaseName.value
            : this.currentProcessBaseName),
        currentProcessId: (currentProcessId != null
            ? currentProcessId.value
            : this.currentProcessId),
        entryAssemblyLocation: (entryAssemblyLocation != null
            ? entryAssemblyLocation.value
            : this.entryAssemblyLocation),
        entryAssemblyFileName: (entryAssemblyFileName != null
            ? entryAssemblyFileName.value
            : this.entryAssemblyFileName),
        userTempFilePath: (userTempFilePath != null
            ? userTempFilePath.value
            : this.userTempFilePath));
  }
}

@JsonSerializable(explicitToJson: true)
class IAppDomain {
  const IAppDomain({
    this.baseDirectory,
    this.configurationFile,
    this.privateBinPath,
    this.friendlyName,
    required this.id,
  });

  factory IAppDomain.fromJson(Map<String, dynamic> json) =>
      _$IAppDomainFromJson(json);

  static const toJsonFactory = _$IAppDomainToJson;
  Map<String, dynamic> toJson() => _$IAppDomainToJson(this);

  @JsonKey(name: 'baseDirectory')
  final String? baseDirectory;
  @JsonKey(name: 'configurationFile')
  final String? configurationFile;
  @JsonKey(name: 'privateBinPath', defaultValue: <String>[])
  final List<String>? privateBinPath;
  @JsonKey(name: 'friendlyName')
  final String? friendlyName;
  @JsonKey(name: 'id')
  final int id;
  static const fromJsonFactory = _$IAppDomainFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is IAppDomain &&
            (identical(other.baseDirectory, baseDirectory) ||
                const DeepCollectionEquality()
                    .equals(other.baseDirectory, baseDirectory)) &&
            (identical(other.configurationFile, configurationFile) ||
                const DeepCollectionEquality()
                    .equals(other.configurationFile, configurationFile)) &&
            (identical(other.privateBinPath, privateBinPath) ||
                const DeepCollectionEquality()
                    .equals(other.privateBinPath, privateBinPath)) &&
            (identical(other.friendlyName, friendlyName) ||
                const DeepCollectionEquality()
                    .equals(other.friendlyName, friendlyName)) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(baseDirectory) ^
      const DeepCollectionEquality().hash(configurationFile) ^
      const DeepCollectionEquality().hash(privateBinPath) ^
      const DeepCollectionEquality().hash(friendlyName) ^
      const DeepCollectionEquality().hash(id) ^
      runtimeType.hashCode;
}

extension $IAppDomainExtension on IAppDomain {
  IAppDomain copyWith(
      {String? baseDirectory,
      String? configurationFile,
      List<String>? privateBinPath,
      String? friendlyName,
      int? id}) {
    return IAppDomain(
        baseDirectory: baseDirectory ?? this.baseDirectory,
        configurationFile: configurationFile ?? this.configurationFile,
        privateBinPath: privateBinPath ?? this.privateBinPath,
        friendlyName: friendlyName ?? this.friendlyName,
        id: id ?? this.id);
  }

  IAppDomain copyWithWrapped(
      {Wrapped<String?>? baseDirectory,
      Wrapped<String?>? configurationFile,
      Wrapped<List<String>?>? privateBinPath,
      Wrapped<String?>? friendlyName,
      Wrapped<int>? id}) {
    return IAppDomain(
        baseDirectory:
            (baseDirectory != null ? baseDirectory.value : this.baseDirectory),
        configurationFile: (configurationFile != null
            ? configurationFile.value
            : this.configurationFile),
        privateBinPath: (privateBinPath != null
            ? privateBinPath.value
            : this.privateBinPath),
        friendlyName:
            (friendlyName != null ? friendlyName.value : this.friendlyName),
        id: (id != null ? id.value : this.id));
  }
}

@JsonSerializable(explicitToJson: true)
class LoggingConfiguration {
  const LoggingConfiguration({
    this.logFactory,
    this.variables,
    this.configuredNamedTargets,
    this.fileNamesToWatch,
    this.loggingRules,
    this.defaultCultureInfo,
    this.allTargets,
  });

  factory LoggingConfiguration.fromJson(Map<String, dynamic> json) =>
      _$LoggingConfigurationFromJson(json);

  static const toJsonFactory = _$LoggingConfigurationToJson;
  Map<String, dynamic> toJson() => _$LoggingConfigurationToJson(this);

  @JsonKey(name: 'logFactory')
  final LogFactory? logFactory;
  @JsonKey(name: 'variables')
  final Map<String, dynamic>? variables;
  @JsonKey(name: 'configuredNamedTargets', defaultValue: <Target>[])
  final List<Target>? configuredNamedTargets;
  @JsonKey(name: 'fileNamesToWatch', defaultValue: <String>[])
  final List<String>? fileNamesToWatch;
  @JsonKey(name: 'loggingRules', defaultValue: <LoggingRule>[])
  final List<LoggingRule>? loggingRules;
  @JsonKey(name: 'defaultCultureInfo')
  final CultureInfo? defaultCultureInfo;
  @JsonKey(name: 'allTargets', defaultValue: <Target>[])
  final List<Target>? allTargets;
  static const fromJsonFactory = _$LoggingConfigurationFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LoggingConfiguration &&
            (identical(other.logFactory, logFactory) ||
                const DeepCollectionEquality()
                    .equals(other.logFactory, logFactory)) &&
            (identical(other.variables, variables) ||
                const DeepCollectionEquality()
                    .equals(other.variables, variables)) &&
            (identical(other.configuredNamedTargets, configuredNamedTargets) ||
                const DeepCollectionEquality().equals(
                    other.configuredNamedTargets, configuredNamedTargets)) &&
            (identical(other.fileNamesToWatch, fileNamesToWatch) ||
                const DeepCollectionEquality()
                    .equals(other.fileNamesToWatch, fileNamesToWatch)) &&
            (identical(other.loggingRules, loggingRules) ||
                const DeepCollectionEquality()
                    .equals(other.loggingRules, loggingRules)) &&
            (identical(other.defaultCultureInfo, defaultCultureInfo) ||
                const DeepCollectionEquality()
                    .equals(other.defaultCultureInfo, defaultCultureInfo)) &&
            (identical(other.allTargets, allTargets) ||
                const DeepCollectionEquality()
                    .equals(other.allTargets, allTargets)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(logFactory) ^
      const DeepCollectionEquality().hash(variables) ^
      const DeepCollectionEquality().hash(configuredNamedTargets) ^
      const DeepCollectionEquality().hash(fileNamesToWatch) ^
      const DeepCollectionEquality().hash(loggingRules) ^
      const DeepCollectionEquality().hash(defaultCultureInfo) ^
      const DeepCollectionEquality().hash(allTargets) ^
      runtimeType.hashCode;
}

extension $LoggingConfigurationExtension on LoggingConfiguration {
  LoggingConfiguration copyWith(
      {LogFactory? logFactory,
      Map<String, dynamic>? variables,
      List<Target>? configuredNamedTargets,
      List<String>? fileNamesToWatch,
      List<LoggingRule>? loggingRules,
      CultureInfo? defaultCultureInfo,
      List<Target>? allTargets}) {
    return LoggingConfiguration(
        logFactory: logFactory ?? this.logFactory,
        variables: variables ?? this.variables,
        configuredNamedTargets:
            configuredNamedTargets ?? this.configuredNamedTargets,
        fileNamesToWatch: fileNamesToWatch ?? this.fileNamesToWatch,
        loggingRules: loggingRules ?? this.loggingRules,
        defaultCultureInfo: defaultCultureInfo ?? this.defaultCultureInfo,
        allTargets: allTargets ?? this.allTargets);
  }

  LoggingConfiguration copyWithWrapped(
      {Wrapped<LogFactory?>? logFactory,
      Wrapped<Map<String, dynamic>?>? variables,
      Wrapped<List<Target>?>? configuredNamedTargets,
      Wrapped<List<String>?>? fileNamesToWatch,
      Wrapped<List<LoggingRule>?>? loggingRules,
      Wrapped<CultureInfo?>? defaultCultureInfo,
      Wrapped<List<Target>?>? allTargets}) {
    return LoggingConfiguration(
        logFactory: (logFactory != null ? logFactory.value : this.logFactory),
        variables: (variables != null ? variables.value : this.variables),
        configuredNamedTargets: (configuredNamedTargets != null
            ? configuredNamedTargets.value
            : this.configuredNamedTargets),
        fileNamesToWatch: (fileNamesToWatch != null
            ? fileNamesToWatch.value
            : this.fileNamesToWatch),
        loggingRules:
            (loggingRules != null ? loggingRules.value : this.loggingRules),
        defaultCultureInfo: (defaultCultureInfo != null
            ? defaultCultureInfo.value
            : this.defaultCultureInfo),
        allTargets: (allTargets != null ? allTargets.value : this.allTargets));
  }
}

@JsonSerializable(explicitToJson: true)
class Layout {
  const Layout({
    required this.threadAgnostic,
    required this.threadAgnosticImmutable,
    required this.stackTraceUsage,
    this.loggingConfiguration,
  });

  factory Layout.fromJson(Map<String, dynamic> json) => _$LayoutFromJson(json);

  static const toJsonFactory = _$LayoutToJson;
  Map<String, dynamic> toJson() => _$LayoutToJson(this);

  @JsonKey(name: 'threadAgnostic')
  final bool threadAgnostic;
  @JsonKey(name: 'threadAgnosticImmutable')
  final bool threadAgnosticImmutable;
  @JsonKey(
    name: 'stackTraceUsage',
    toJson: stackTraceUsageToJson,
    fromJson: stackTraceUsageFromJson,
  )
  final enums.StackTraceUsage stackTraceUsage;
  @JsonKey(name: 'loggingConfiguration')
  final LoggingConfiguration? loggingConfiguration;
  static const fromJsonFactory = _$LayoutFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Layout &&
            (identical(other.threadAgnostic, threadAgnostic) ||
                const DeepCollectionEquality()
                    .equals(other.threadAgnostic, threadAgnostic)) &&
            (identical(
                    other.threadAgnosticImmutable, threadAgnosticImmutable) ||
                const DeepCollectionEquality().equals(
                    other.threadAgnosticImmutable, threadAgnosticImmutable)) &&
            (identical(other.stackTraceUsage, stackTraceUsage) ||
                const DeepCollectionEquality()
                    .equals(other.stackTraceUsage, stackTraceUsage)) &&
            (identical(other.loggingConfiguration, loggingConfiguration) ||
                const DeepCollectionEquality()
                    .equals(other.loggingConfiguration, loggingConfiguration)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(threadAgnostic) ^
      const DeepCollectionEquality().hash(threadAgnosticImmutable) ^
      const DeepCollectionEquality().hash(stackTraceUsage) ^
      const DeepCollectionEquality().hash(loggingConfiguration) ^
      runtimeType.hashCode;
}

extension $LayoutExtension on Layout {
  Layout copyWith(
      {bool? threadAgnostic,
      bool? threadAgnosticImmutable,
      enums.StackTraceUsage? stackTraceUsage,
      LoggingConfiguration? loggingConfiguration}) {
    return Layout(
        threadAgnostic: threadAgnostic ?? this.threadAgnostic,
        threadAgnosticImmutable:
            threadAgnosticImmutable ?? this.threadAgnosticImmutable,
        stackTraceUsage: stackTraceUsage ?? this.stackTraceUsage,
        loggingConfiguration:
            loggingConfiguration ?? this.loggingConfiguration);
  }

  Layout copyWithWrapped(
      {Wrapped<bool>? threadAgnostic,
      Wrapped<bool>? threadAgnosticImmutable,
      Wrapped<enums.StackTraceUsage>? stackTraceUsage,
      Wrapped<LoggingConfiguration?>? loggingConfiguration}) {
    return Layout(
        threadAgnostic: (threadAgnostic != null
            ? threadAgnostic.value
            : this.threadAgnostic),
        threadAgnosticImmutable: (threadAgnosticImmutable != null
            ? threadAgnosticImmutable.value
            : this.threadAgnosticImmutable),
        stackTraceUsage: (stackTraceUsage != null
            ? stackTraceUsage.value
            : this.stackTraceUsage),
        loggingConfiguration: (loggingConfiguration != null
            ? loggingConfiguration.value
            : this.loggingConfiguration));
  }
}

@JsonSerializable(explicitToJson: true)
class Target {
  const Target({
    required this.stackTraceUsage,
    this.initializeException,
    this.name,
    required this.optimizeBufferReuse,
    required this.layoutWithLock,
    this.syncRoot,
    this.loggingConfiguration,
    required this.isInitialized,
  });

  factory Target.fromJson(Map<String, dynamic> json) => _$TargetFromJson(json);

  static const toJsonFactory = _$TargetToJson;
  Map<String, dynamic> toJson() => _$TargetToJson(this);

  @JsonKey(
    name: 'stackTraceUsage',
    toJson: stackTraceUsageToJson,
    fromJson: stackTraceUsageFromJson,
  )
  final enums.StackTraceUsage stackTraceUsage;
  @JsonKey(name: 'initializeException')
  final Exception? initializeException;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'optimizeBufferReuse')
  final bool optimizeBufferReuse;
  @JsonKey(name: 'layoutWithLock')
  final bool layoutWithLock;
  @JsonKey(name: 'syncRoot')
  final dynamic syncRoot;
  @JsonKey(name: 'loggingConfiguration')
  final LoggingConfiguration? loggingConfiguration;
  @JsonKey(name: 'isInitialized')
  final bool isInitialized;
  static const fromJsonFactory = _$TargetFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Target &&
            (identical(other.stackTraceUsage, stackTraceUsage) ||
                const DeepCollectionEquality()
                    .equals(other.stackTraceUsage, stackTraceUsage)) &&
            (identical(other.initializeException, initializeException) ||
                const DeepCollectionEquality()
                    .equals(other.initializeException, initializeException)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.optimizeBufferReuse, optimizeBufferReuse) ||
                const DeepCollectionEquality()
                    .equals(other.optimizeBufferReuse, optimizeBufferReuse)) &&
            (identical(other.layoutWithLock, layoutWithLock) ||
                const DeepCollectionEquality()
                    .equals(other.layoutWithLock, layoutWithLock)) &&
            (identical(other.syncRoot, syncRoot) ||
                const DeepCollectionEquality()
                    .equals(other.syncRoot, syncRoot)) &&
            (identical(other.loggingConfiguration, loggingConfiguration) ||
                const DeepCollectionEquality().equals(
                    other.loggingConfiguration, loggingConfiguration)) &&
            (identical(other.isInitialized, isInitialized) ||
                const DeepCollectionEquality()
                    .equals(other.isInitialized, isInitialized)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(stackTraceUsage) ^
      const DeepCollectionEquality().hash(initializeException) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(optimizeBufferReuse) ^
      const DeepCollectionEquality().hash(layoutWithLock) ^
      const DeepCollectionEquality().hash(syncRoot) ^
      const DeepCollectionEquality().hash(loggingConfiguration) ^
      const DeepCollectionEquality().hash(isInitialized) ^
      runtimeType.hashCode;
}

extension $TargetExtension on Target {
  Target copyWith(
      {enums.StackTraceUsage? stackTraceUsage,
      Exception? initializeException,
      String? name,
      bool? optimizeBufferReuse,
      bool? layoutWithLock,
      dynamic syncRoot,
      LoggingConfiguration? loggingConfiguration,
      bool? isInitialized}) {
    return Target(
        stackTraceUsage: stackTraceUsage ?? this.stackTraceUsage,
        initializeException: initializeException ?? this.initializeException,
        name: name ?? this.name,
        optimizeBufferReuse: optimizeBufferReuse ?? this.optimizeBufferReuse,
        layoutWithLock: layoutWithLock ?? this.layoutWithLock,
        syncRoot: syncRoot ?? this.syncRoot,
        loggingConfiguration: loggingConfiguration ?? this.loggingConfiguration,
        isInitialized: isInitialized ?? this.isInitialized);
  }

  Target copyWithWrapped(
      {Wrapped<enums.StackTraceUsage>? stackTraceUsage,
      Wrapped<Exception?>? initializeException,
      Wrapped<String?>? name,
      Wrapped<bool>? optimizeBufferReuse,
      Wrapped<bool>? layoutWithLock,
      Wrapped<dynamic>? syncRoot,
      Wrapped<LoggingConfiguration?>? loggingConfiguration,
      Wrapped<bool>? isInitialized}) {
    return Target(
        stackTraceUsage: (stackTraceUsage != null
            ? stackTraceUsage.value
            : this.stackTraceUsage),
        initializeException: (initializeException != null
            ? initializeException.value
            : this.initializeException),
        name: (name != null ? name.value : this.name),
        optimizeBufferReuse: (optimizeBufferReuse != null
            ? optimizeBufferReuse.value
            : this.optimizeBufferReuse),
        layoutWithLock: (layoutWithLock != null
            ? layoutWithLock.value
            : this.layoutWithLock),
        syncRoot: (syncRoot != null ? syncRoot.value : this.syncRoot),
        loggingConfiguration: (loggingConfiguration != null
            ? loggingConfiguration.value
            : this.loggingConfiguration),
        isInitialized:
            (isInitialized != null ? isInitialized.value : this.isInitialized));
  }
}

@JsonSerializable(explicitToJson: true)
class Exception {
  const Exception({
    this.targetSite,
    required this.message,
    required this.data,
    this.innerException,
    this.helpLink,
    this.source,
    required this.hResult,
    this.stackTrace,
  });

  factory Exception.fromJson(Map<String, dynamic> json) =>
      _$ExceptionFromJson(json);

  static const toJsonFactory = _$ExceptionToJson;
  Map<String, dynamic> toJson() => _$ExceptionToJson(this);

  @JsonKey(name: 'targetSite')
  final MethodBase? targetSite;
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'data', defaultValue: <Object>[])
  final List<Object> data;
  @JsonKey(name: 'innerException')
  final Exception? innerException;
  @JsonKey(name: 'helpLink')
  final String? helpLink;
  @JsonKey(name: 'source')
  final String? source;
  @JsonKey(name: 'hResult')
  final int hResult;
  @JsonKey(name: 'stackTrace')
  final String? stackTrace;
  static const fromJsonFactory = _$ExceptionFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Exception &&
            (identical(other.targetSite, targetSite) ||
                const DeepCollectionEquality()
                    .equals(other.targetSite, targetSite)) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality()
                    .equals(other.message, message)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)) &&
            (identical(other.innerException, innerException) ||
                const DeepCollectionEquality()
                    .equals(other.innerException, innerException)) &&
            (identical(other.helpLink, helpLink) ||
                const DeepCollectionEquality()
                    .equals(other.helpLink, helpLink)) &&
            (identical(other.source, source) ||
                const DeepCollectionEquality().equals(other.source, source)) &&
            (identical(other.hResult, hResult) ||
                const DeepCollectionEquality()
                    .equals(other.hResult, hResult)) &&
            (identical(other.stackTrace, stackTrace) ||
                const DeepCollectionEquality()
                    .equals(other.stackTrace, stackTrace)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(targetSite) ^
      const DeepCollectionEquality().hash(message) ^
      const DeepCollectionEquality().hash(data) ^
      const DeepCollectionEquality().hash(innerException) ^
      const DeepCollectionEquality().hash(helpLink) ^
      const DeepCollectionEquality().hash(source) ^
      const DeepCollectionEquality().hash(hResult) ^
      const DeepCollectionEquality().hash(stackTrace) ^
      runtimeType.hashCode;
}

extension $ExceptionExtension on Exception {
  Exception copyWith(
      {MethodBase? targetSite,
      String? message,
      List<Object>? data,
      Exception? innerException,
      String? helpLink,
      String? source,
      int? hResult,
      String? stackTrace}) {
    return Exception(
        targetSite: targetSite ?? this.targetSite,
        message: message ?? this.message,
        data: data ?? this.data,
        innerException: innerException ?? this.innerException,
        helpLink: helpLink ?? this.helpLink,
        source: source ?? this.source,
        hResult: hResult ?? this.hResult,
        stackTrace: stackTrace ?? this.stackTrace);
  }

  Exception copyWithWrapped(
      {Wrapped<MethodBase?>? targetSite,
      Wrapped<String>? message,
      Wrapped<List<Object>>? data,
      Wrapped<Exception?>? innerException,
      Wrapped<String?>? helpLink,
      Wrapped<String?>? source,
      Wrapped<int>? hResult,
      Wrapped<String?>? stackTrace}) {
    return Exception(
        targetSite: (targetSite != null ? targetSite.value : this.targetSite),
        message: (message != null ? message.value : this.message),
        data: (data != null ? data.value : this.data),
        innerException: (innerException != null
            ? innerException.value
            : this.innerException),
        helpLink: (helpLink != null ? helpLink.value : this.helpLink),
        source: (source != null ? source.value : this.source),
        hResult: (hResult != null ? hResult.value : this.hResult),
        stackTrace: (stackTrace != null ? stackTrace.value : this.stackTrace));
  }
}

@JsonSerializable(explicitToJson: true)
class MethodBase {
  const MethodBase({
    required this.attributes,
    required this.methodImplementationFlags,
    required this.callingConvention,
    required this.isAbstract,
    required this.isConstructor,
    required this.isFinal,
    required this.isHideBySig,
    required this.isSpecialName,
    required this.isStatic,
    required this.isVirtual,
    required this.isAssembly,
    required this.isFamily,
    required this.isFamilyAndAssembly,
    required this.isFamilyOrAssembly,
    required this.isPrivate,
    required this.isPublic,
    required this.isConstructedGenericMethod,
    required this.isGenericMethod,
    required this.isGenericMethodDefinition,
    required this.containsGenericParameters,
    required this.methodHandle,
    required this.isSecurityCritical,
    required this.isSecuritySafeCritical,
    required this.isSecurityTransparent,
    required this.memberType,
    required this.name,
    this.declaringType,
    this.reflectedType,
    required this.module,
    required this.customAttributes,
    required this.isCollectible,
    required this.metadataToken,
  });

  factory MethodBase.fromJson(Map<String, dynamic> json) =>
      _$MethodBaseFromJson(json);

  static const toJsonFactory = _$MethodBaseToJson;
  Map<String, dynamic> toJson() => _$MethodBaseToJson(this);

  @JsonKey(
    name: 'attributes',
    toJson: methodAttributesToJson,
    fromJson: methodAttributesFromJson,
  )
  final enums.MethodAttributes attributes;
  @JsonKey(
    name: 'methodImplementationFlags',
    toJson: methodImplAttributesToJson,
    fromJson: methodImplAttributesFromJson,
  )
  final enums.MethodImplAttributes methodImplementationFlags;
  @JsonKey(
    name: 'callingConvention',
    toJson: callingConventionsToJson,
    fromJson: callingConventionsFromJson,
  )
  final enums.CallingConventions callingConvention;
  @JsonKey(name: 'isAbstract')
  final bool isAbstract;
  @JsonKey(name: 'isConstructor')
  final bool isConstructor;
  @JsonKey(name: 'isFinal')
  final bool isFinal;
  @JsonKey(name: 'isHideBySig')
  final bool isHideBySig;
  @JsonKey(name: 'isSpecialName')
  final bool isSpecialName;
  @JsonKey(name: 'isStatic')
  final bool isStatic;
  @JsonKey(name: 'isVirtual')
  final bool isVirtual;
  @JsonKey(name: 'isAssembly')
  final bool isAssembly;
  @JsonKey(name: 'isFamily')
  final bool isFamily;
  @JsonKey(name: 'isFamilyAndAssembly')
  final bool isFamilyAndAssembly;
  @JsonKey(name: 'isFamilyOrAssembly')
  final bool isFamilyOrAssembly;
  @JsonKey(name: 'isPrivate')
  final bool isPrivate;
  @JsonKey(name: 'isPublic')
  final bool isPublic;
  @JsonKey(name: 'isConstructedGenericMethod')
  final bool isConstructedGenericMethod;
  @JsonKey(name: 'isGenericMethod')
  final bool isGenericMethod;
  @JsonKey(name: 'isGenericMethodDefinition')
  final bool isGenericMethodDefinition;
  @JsonKey(name: 'containsGenericParameters')
  final bool containsGenericParameters;
  @JsonKey(name: 'methodHandle')
  final RuntimeMethodHandle methodHandle;
  @JsonKey(name: 'isSecurityCritical')
  final bool isSecurityCritical;
  @JsonKey(name: 'isSecuritySafeCritical')
  final bool isSecuritySafeCritical;
  @JsonKey(name: 'isSecurityTransparent')
  final bool isSecurityTransparent;
  @JsonKey(
    name: 'memberType',
    toJson: memberTypesToJson,
    fromJson: memberTypesFromJson,
  )
  final enums.MemberTypes memberType;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'declaringType')
  final String? declaringType;
  @JsonKey(name: 'reflectedType')
  final String? reflectedType;
  @JsonKey(name: 'module')
  final Module module;
  @JsonKey(name: 'customAttributes', defaultValue: <CustomAttributeData>[])
  final List<CustomAttributeData> customAttributes;
  @JsonKey(name: 'isCollectible')
  final bool isCollectible;
  @JsonKey(name: 'metadataToken')
  final int metadataToken;
  static const fromJsonFactory = _$MethodBaseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MethodBase &&
            (identical(other.attributes, attributes) ||
                const DeepCollectionEquality()
                    .equals(other.attributes, attributes)) &&
            (identical(other.methodImplementationFlags, methodImplementationFlags) ||
                const DeepCollectionEquality().equals(
                    other.methodImplementationFlags,
                    methodImplementationFlags)) &&
            (identical(other.callingConvention, callingConvention) ||
                const DeepCollectionEquality()
                    .equals(other.callingConvention, callingConvention)) &&
            (identical(other.isAbstract, isAbstract) ||
                const DeepCollectionEquality()
                    .equals(other.isAbstract, isAbstract)) &&
            (identical(other.isConstructor, isConstructor) ||
                const DeepCollectionEquality()
                    .equals(other.isConstructor, isConstructor)) &&
            (identical(other.isFinal, isFinal) ||
                const DeepCollectionEquality()
                    .equals(other.isFinal, isFinal)) &&
            (identical(other.isHideBySig, isHideBySig) ||
                const DeepCollectionEquality()
                    .equals(other.isHideBySig, isHideBySig)) &&
            (identical(other.isSpecialName, isSpecialName) ||
                const DeepCollectionEquality()
                    .equals(other.isSpecialName, isSpecialName)) &&
            (identical(other.isStatic, isStatic) ||
                const DeepCollectionEquality()
                    .equals(other.isStatic, isStatic)) &&
            (identical(other.isVirtual, isVirtual) ||
                const DeepCollectionEquality()
                    .equals(other.isVirtual, isVirtual)) &&
            (identical(other.isAssembly, isAssembly) ||
                const DeepCollectionEquality()
                    .equals(other.isAssembly, isAssembly)) &&
            (identical(other.isFamily, isFamily) ||
                const DeepCollectionEquality()
                    .equals(other.isFamily, isFamily)) &&
            (identical(other.isFamilyAndAssembly, isFamilyAndAssembly) ||
                const DeepCollectionEquality()
                    .equals(other.isFamilyAndAssembly, isFamilyAndAssembly)) &&
            (identical(other.isFamilyOrAssembly, isFamilyOrAssembly) ||
                const DeepCollectionEquality()
                    .equals(other.isFamilyOrAssembly, isFamilyOrAssembly)) &&
            (identical(other.isPrivate, isPrivate) ||
                const DeepCollectionEquality()
                    .equals(other.isPrivate, isPrivate)) &&
            (identical(other.isPublic, isPublic) ||
                const DeepCollectionEquality()
                    .equals(other.isPublic, isPublic)) &&
            (identical(other.isConstructedGenericMethod, isConstructedGenericMethod) ||
                const DeepCollectionEquality().equals(other.isConstructedGenericMethod, isConstructedGenericMethod)) &&
            (identical(other.isGenericMethod, isGenericMethod) || const DeepCollectionEquality().equals(other.isGenericMethod, isGenericMethod)) &&
            (identical(other.isGenericMethodDefinition, isGenericMethodDefinition) || const DeepCollectionEquality().equals(other.isGenericMethodDefinition, isGenericMethodDefinition)) &&
            (identical(other.containsGenericParameters, containsGenericParameters) || const DeepCollectionEquality().equals(other.containsGenericParameters, containsGenericParameters)) &&
            (identical(other.methodHandle, methodHandle) || const DeepCollectionEquality().equals(other.methodHandle, methodHandle)) &&
            (identical(other.isSecurityCritical, isSecurityCritical) || const DeepCollectionEquality().equals(other.isSecurityCritical, isSecurityCritical)) &&
            (identical(other.isSecuritySafeCritical, isSecuritySafeCritical) || const DeepCollectionEquality().equals(other.isSecuritySafeCritical, isSecuritySafeCritical)) &&
            (identical(other.isSecurityTransparent, isSecurityTransparent) || const DeepCollectionEquality().equals(other.isSecurityTransparent, isSecurityTransparent)) &&
            (identical(other.memberType, memberType) || const DeepCollectionEquality().equals(other.memberType, memberType)) &&
            (identical(other.name, name) || const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.declaringType, declaringType) || const DeepCollectionEquality().equals(other.declaringType, declaringType)) &&
            (identical(other.reflectedType, reflectedType) || const DeepCollectionEquality().equals(other.reflectedType, reflectedType)) &&
            (identical(other.module, module) || const DeepCollectionEquality().equals(other.module, module)) &&
            (identical(other.customAttributes, customAttributes) || const DeepCollectionEquality().equals(other.customAttributes, customAttributes)) &&
            (identical(other.isCollectible, isCollectible) || const DeepCollectionEquality().equals(other.isCollectible, isCollectible)) &&
            (identical(other.metadataToken, metadataToken) || const DeepCollectionEquality().equals(other.metadataToken, metadataToken)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(attributes) ^
      const DeepCollectionEquality().hash(methodImplementationFlags) ^
      const DeepCollectionEquality().hash(callingConvention) ^
      const DeepCollectionEquality().hash(isAbstract) ^
      const DeepCollectionEquality().hash(isConstructor) ^
      const DeepCollectionEquality().hash(isFinal) ^
      const DeepCollectionEquality().hash(isHideBySig) ^
      const DeepCollectionEquality().hash(isSpecialName) ^
      const DeepCollectionEquality().hash(isStatic) ^
      const DeepCollectionEquality().hash(isVirtual) ^
      const DeepCollectionEquality().hash(isAssembly) ^
      const DeepCollectionEquality().hash(isFamily) ^
      const DeepCollectionEquality().hash(isFamilyAndAssembly) ^
      const DeepCollectionEquality().hash(isFamilyOrAssembly) ^
      const DeepCollectionEquality().hash(isPrivate) ^
      const DeepCollectionEquality().hash(isPublic) ^
      const DeepCollectionEquality().hash(isConstructedGenericMethod) ^
      const DeepCollectionEquality().hash(isGenericMethod) ^
      const DeepCollectionEquality().hash(isGenericMethodDefinition) ^
      const DeepCollectionEquality().hash(containsGenericParameters) ^
      const DeepCollectionEquality().hash(methodHandle) ^
      const DeepCollectionEquality().hash(isSecurityCritical) ^
      const DeepCollectionEquality().hash(isSecuritySafeCritical) ^
      const DeepCollectionEquality().hash(isSecurityTransparent) ^
      const DeepCollectionEquality().hash(memberType) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(declaringType) ^
      const DeepCollectionEquality().hash(reflectedType) ^
      const DeepCollectionEquality().hash(module) ^
      const DeepCollectionEquality().hash(customAttributes) ^
      const DeepCollectionEquality().hash(isCollectible) ^
      const DeepCollectionEquality().hash(metadataToken) ^
      runtimeType.hashCode;
}

extension $MethodBaseExtension on MethodBase {
  MethodBase copyWith(
      {enums.MethodAttributes? attributes,
      enums.MethodImplAttributes? methodImplementationFlags,
      enums.CallingConventions? callingConvention,
      bool? isAbstract,
      bool? isConstructor,
      bool? isFinal,
      bool? isHideBySig,
      bool? isSpecialName,
      bool? isStatic,
      bool? isVirtual,
      bool? isAssembly,
      bool? isFamily,
      bool? isFamilyAndAssembly,
      bool? isFamilyOrAssembly,
      bool? isPrivate,
      bool? isPublic,
      bool? isConstructedGenericMethod,
      bool? isGenericMethod,
      bool? isGenericMethodDefinition,
      bool? containsGenericParameters,
      RuntimeMethodHandle? methodHandle,
      bool? isSecurityCritical,
      bool? isSecuritySafeCritical,
      bool? isSecurityTransparent,
      enums.MemberTypes? memberType,
      String? name,
      String? declaringType,
      String? reflectedType,
      Module? module,
      List<CustomAttributeData>? customAttributes,
      bool? isCollectible,
      int? metadataToken}) {
    return MethodBase(
        attributes: attributes ?? this.attributes,
        methodImplementationFlags:
            methodImplementationFlags ?? this.methodImplementationFlags,
        callingConvention: callingConvention ?? this.callingConvention,
        isAbstract: isAbstract ?? this.isAbstract,
        isConstructor: isConstructor ?? this.isConstructor,
        isFinal: isFinal ?? this.isFinal,
        isHideBySig: isHideBySig ?? this.isHideBySig,
        isSpecialName: isSpecialName ?? this.isSpecialName,
        isStatic: isStatic ?? this.isStatic,
        isVirtual: isVirtual ?? this.isVirtual,
        isAssembly: isAssembly ?? this.isAssembly,
        isFamily: isFamily ?? this.isFamily,
        isFamilyAndAssembly: isFamilyAndAssembly ?? this.isFamilyAndAssembly,
        isFamilyOrAssembly: isFamilyOrAssembly ?? this.isFamilyOrAssembly,
        isPrivate: isPrivate ?? this.isPrivate,
        isPublic: isPublic ?? this.isPublic,
        isConstructedGenericMethod:
            isConstructedGenericMethod ?? this.isConstructedGenericMethod,
        isGenericMethod: isGenericMethod ?? this.isGenericMethod,
        isGenericMethodDefinition:
            isGenericMethodDefinition ?? this.isGenericMethodDefinition,
        containsGenericParameters:
            containsGenericParameters ?? this.containsGenericParameters,
        methodHandle: methodHandle ?? this.methodHandle,
        isSecurityCritical: isSecurityCritical ?? this.isSecurityCritical,
        isSecuritySafeCritical:
            isSecuritySafeCritical ?? this.isSecuritySafeCritical,
        isSecurityTransparent:
            isSecurityTransparent ?? this.isSecurityTransparent,
        memberType: memberType ?? this.memberType,
        name: name ?? this.name,
        declaringType: declaringType ?? this.declaringType,
        reflectedType: reflectedType ?? this.reflectedType,
        module: module ?? this.module,
        customAttributes: customAttributes ?? this.customAttributes,
        isCollectible: isCollectible ?? this.isCollectible,
        metadataToken: metadataToken ?? this.metadataToken);
  }

  MethodBase copyWithWrapped(
      {Wrapped<enums.MethodAttributes>? attributes,
      Wrapped<enums.MethodImplAttributes>? methodImplementationFlags,
      Wrapped<enums.CallingConventions>? callingConvention,
      Wrapped<bool>? isAbstract,
      Wrapped<bool>? isConstructor,
      Wrapped<bool>? isFinal,
      Wrapped<bool>? isHideBySig,
      Wrapped<bool>? isSpecialName,
      Wrapped<bool>? isStatic,
      Wrapped<bool>? isVirtual,
      Wrapped<bool>? isAssembly,
      Wrapped<bool>? isFamily,
      Wrapped<bool>? isFamilyAndAssembly,
      Wrapped<bool>? isFamilyOrAssembly,
      Wrapped<bool>? isPrivate,
      Wrapped<bool>? isPublic,
      Wrapped<bool>? isConstructedGenericMethod,
      Wrapped<bool>? isGenericMethod,
      Wrapped<bool>? isGenericMethodDefinition,
      Wrapped<bool>? containsGenericParameters,
      Wrapped<RuntimeMethodHandle>? methodHandle,
      Wrapped<bool>? isSecurityCritical,
      Wrapped<bool>? isSecuritySafeCritical,
      Wrapped<bool>? isSecurityTransparent,
      Wrapped<enums.MemberTypes>? memberType,
      Wrapped<String>? name,
      Wrapped<String?>? declaringType,
      Wrapped<String?>? reflectedType,
      Wrapped<Module>? module,
      Wrapped<List<CustomAttributeData>>? customAttributes,
      Wrapped<bool>? isCollectible,
      Wrapped<int>? metadataToken}) {
    return MethodBase(
        attributes: (attributes != null ? attributes.value : this.attributes),
        methodImplementationFlags: (methodImplementationFlags != null
            ? methodImplementationFlags.value
            : this.methodImplementationFlags),
        callingConvention: (callingConvention != null
            ? callingConvention.value
            : this.callingConvention),
        isAbstract: (isAbstract != null ? isAbstract.value : this.isAbstract),
        isConstructor:
            (isConstructor != null ? isConstructor.value : this.isConstructor),
        isFinal: (isFinal != null ? isFinal.value : this.isFinal),
        isHideBySig:
            (isHideBySig != null ? isHideBySig.value : this.isHideBySig),
        isSpecialName:
            (isSpecialName != null ? isSpecialName.value : this.isSpecialName),
        isStatic: (isStatic != null ? isStatic.value : this.isStatic),
        isVirtual: (isVirtual != null ? isVirtual.value : this.isVirtual),
        isAssembly: (isAssembly != null ? isAssembly.value : this.isAssembly),
        isFamily: (isFamily != null ? isFamily.value : this.isFamily),
        isFamilyAndAssembly: (isFamilyAndAssembly != null
            ? isFamilyAndAssembly.value
            : this.isFamilyAndAssembly),
        isFamilyOrAssembly: (isFamilyOrAssembly != null
            ? isFamilyOrAssembly.value
            : this.isFamilyOrAssembly),
        isPrivate: (isPrivate != null ? isPrivate.value : this.isPrivate),
        isPublic: (isPublic != null ? isPublic.value : this.isPublic),
        isConstructedGenericMethod: (isConstructedGenericMethod != null
            ? isConstructedGenericMethod.value
            : this.isConstructedGenericMethod),
        isGenericMethod: (isGenericMethod != null
            ? isGenericMethod.value
            : this.isGenericMethod),
        isGenericMethodDefinition: (isGenericMethodDefinition != null
            ? isGenericMethodDefinition.value
            : this.isGenericMethodDefinition),
        containsGenericParameters: (containsGenericParameters != null
            ? containsGenericParameters.value
            : this.containsGenericParameters),
        methodHandle:
            (methodHandle != null ? methodHandle.value : this.methodHandle),
        isSecurityCritical: (isSecurityCritical != null
            ? isSecurityCritical.value
            : this.isSecurityCritical),
        isSecuritySafeCritical: (isSecuritySafeCritical != null
            ? isSecuritySafeCritical.value
            : this.isSecuritySafeCritical),
        isSecurityTransparent: (isSecurityTransparent != null
            ? isSecurityTransparent.value
            : this.isSecurityTransparent),
        memberType: (memberType != null ? memberType.value : this.memberType),
        name: (name != null ? name.value : this.name),
        declaringType:
            (declaringType != null ? declaringType.value : this.declaringType),
        reflectedType:
            (reflectedType != null ? reflectedType.value : this.reflectedType),
        module: (module != null ? module.value : this.module),
        customAttributes: (customAttributes != null
            ? customAttributes.value
            : this.customAttributes),
        isCollectible:
            (isCollectible != null ? isCollectible.value : this.isCollectible),
        metadataToken:
            (metadataToken != null ? metadataToken.value : this.metadataToken));
  }
}

@JsonSerializable(explicitToJson: true)
class RuntimeMethodHandle {
  const RuntimeMethodHandle({
    required this.$value,
  });

  factory RuntimeMethodHandle.fromJson(Map<String, dynamic> json) =>
      _$RuntimeMethodHandleFromJson(json);

  static const toJsonFactory = _$RuntimeMethodHandleToJson;
  Map<String, dynamic> toJson() => _$RuntimeMethodHandleToJson(this);

  @JsonKey(name: 'value')
  final IntPtr $value;
  static const fromJsonFactory = _$RuntimeMethodHandleFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RuntimeMethodHandle &&
            (identical(other.$value, $value) ||
                const DeepCollectionEquality().equals(other.$value, $value)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash($value) ^ runtimeType.hashCode;
}

extension $RuntimeMethodHandleExtension on RuntimeMethodHandle {
  RuntimeMethodHandle copyWith({IntPtr? $value}) {
    return RuntimeMethodHandle($value: $value ?? this.$value);
  }

  RuntimeMethodHandle copyWithWrapped({Wrapped<IntPtr>? $value}) {
    return RuntimeMethodHandle(
        $value: ($value != null ? $value.value : this.$value));
  }
}

@JsonSerializable(explicitToJson: true)
class IntPtr {
  const IntPtr();

  factory IntPtr.fromJson(Map<String, dynamic> json) => _$IntPtrFromJson(json);

  static const toJsonFactory = _$IntPtrToJson;
  Map<String, dynamic> toJson() => _$IntPtrToJson(this);

  static const fromJsonFactory = _$IntPtrFromJson;

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode => runtimeType.hashCode;
}

@JsonSerializable(explicitToJson: true)
class MemberInfo {
  const MemberInfo({
    required this.memberType,
    required this.name,
    this.declaringType,
    this.reflectedType,
    required this.module,
    required this.customAttributes,
    required this.isCollectible,
    required this.metadataToken,
  });

  factory MemberInfo.fromJson(Map<String, dynamic> json) =>
      _$MemberInfoFromJson(json);

  static const toJsonFactory = _$MemberInfoToJson;
  Map<String, dynamic> toJson() => _$MemberInfoToJson(this);

  @JsonKey(
    name: 'memberType',
    toJson: memberTypesToJson,
    fromJson: memberTypesFromJson,
  )
  final enums.MemberTypes memberType;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'declaringType')
  final String? declaringType;
  @JsonKey(name: 'reflectedType')
  final String? reflectedType;
  @JsonKey(name: 'module')
  final Module module;
  @JsonKey(name: 'customAttributes', defaultValue: <CustomAttributeData>[])
  final List<CustomAttributeData> customAttributes;
  @JsonKey(name: 'isCollectible')
  final bool isCollectible;
  @JsonKey(name: 'metadataToken')
  final int metadataToken;
  static const fromJsonFactory = _$MemberInfoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MemberInfo &&
            (identical(other.memberType, memberType) ||
                const DeepCollectionEquality()
                    .equals(other.memberType, memberType)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.declaringType, declaringType) ||
                const DeepCollectionEquality()
                    .equals(other.declaringType, declaringType)) &&
            (identical(other.reflectedType, reflectedType) ||
                const DeepCollectionEquality()
                    .equals(other.reflectedType, reflectedType)) &&
            (identical(other.module, module) ||
                const DeepCollectionEquality().equals(other.module, module)) &&
            (identical(other.customAttributes, customAttributes) ||
                const DeepCollectionEquality()
                    .equals(other.customAttributes, customAttributes)) &&
            (identical(other.isCollectible, isCollectible) ||
                const DeepCollectionEquality()
                    .equals(other.isCollectible, isCollectible)) &&
            (identical(other.metadataToken, metadataToken) ||
                const DeepCollectionEquality()
                    .equals(other.metadataToken, metadataToken)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(memberType) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(declaringType) ^
      const DeepCollectionEquality().hash(reflectedType) ^
      const DeepCollectionEquality().hash(module) ^
      const DeepCollectionEquality().hash(customAttributes) ^
      const DeepCollectionEquality().hash(isCollectible) ^
      const DeepCollectionEquality().hash(metadataToken) ^
      runtimeType.hashCode;
}

extension $MemberInfoExtension on MemberInfo {
  MemberInfo copyWith(
      {enums.MemberTypes? memberType,
      String? name,
      String? declaringType,
      String? reflectedType,
      Module? module,
      List<CustomAttributeData>? customAttributes,
      bool? isCollectible,
      int? metadataToken}) {
    return MemberInfo(
        memberType: memberType ?? this.memberType,
        name: name ?? this.name,
        declaringType: declaringType ?? this.declaringType,
        reflectedType: reflectedType ?? this.reflectedType,
        module: module ?? this.module,
        customAttributes: customAttributes ?? this.customAttributes,
        isCollectible: isCollectible ?? this.isCollectible,
        metadataToken: metadataToken ?? this.metadataToken);
  }

  MemberInfo copyWithWrapped(
      {Wrapped<enums.MemberTypes>? memberType,
      Wrapped<String>? name,
      Wrapped<String?>? declaringType,
      Wrapped<String?>? reflectedType,
      Wrapped<Module>? module,
      Wrapped<List<CustomAttributeData>>? customAttributes,
      Wrapped<bool>? isCollectible,
      Wrapped<int>? metadataToken}) {
    return MemberInfo(
        memberType: (memberType != null ? memberType.value : this.memberType),
        name: (name != null ? name.value : this.name),
        declaringType:
            (declaringType != null ? declaringType.value : this.declaringType),
        reflectedType:
            (reflectedType != null ? reflectedType.value : this.reflectedType),
        module: (module != null ? module.value : this.module),
        customAttributes: (customAttributes != null
            ? customAttributes.value
            : this.customAttributes),
        isCollectible:
            (isCollectible != null ? isCollectible.value : this.isCollectible),
        metadataToken:
            (metadataToken != null ? metadataToken.value : this.metadataToken));
  }
}

@JsonSerializable(explicitToJson: true)
class Module {
  const Module({
    required this.assembly,
    required this.fullyQualifiedName,
    required this.name,
    required this.mdStreamVersion,
    required this.moduleVersionId,
    required this.scopeName,
    required this.moduleHandle,
    required this.customAttributes,
    required this.metadataToken,
  });

  factory Module.fromJson(Map<String, dynamic> json) => _$ModuleFromJson(json);

  static const toJsonFactory = _$ModuleToJson;
  Map<String, dynamic> toJson() => _$ModuleToJson(this);

  @JsonKey(name: 'assembly')
  final Assembly assembly;
  @JsonKey(name: 'fullyQualifiedName')
  final String fullyQualifiedName;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'mdStreamVersion')
  final int mdStreamVersion;
  @JsonKey(name: 'moduleVersionId')
  final String moduleVersionId;
  @JsonKey(name: 'scopeName')
  final String scopeName;
  @JsonKey(name: 'moduleHandle')
  final ModuleHandle moduleHandle;
  @JsonKey(name: 'customAttributes', defaultValue: <CustomAttributeData>[])
  final List<CustomAttributeData> customAttributes;
  @JsonKey(name: 'metadataToken')
  final int metadataToken;
  static const fromJsonFactory = _$ModuleFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Module &&
            (identical(other.assembly, assembly) ||
                const DeepCollectionEquality()
                    .equals(other.assembly, assembly)) &&
            (identical(other.fullyQualifiedName, fullyQualifiedName) ||
                const DeepCollectionEquality()
                    .equals(other.fullyQualifiedName, fullyQualifiedName)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.mdStreamVersion, mdStreamVersion) ||
                const DeepCollectionEquality()
                    .equals(other.mdStreamVersion, mdStreamVersion)) &&
            (identical(other.moduleVersionId, moduleVersionId) ||
                const DeepCollectionEquality()
                    .equals(other.moduleVersionId, moduleVersionId)) &&
            (identical(other.scopeName, scopeName) ||
                const DeepCollectionEquality()
                    .equals(other.scopeName, scopeName)) &&
            (identical(other.moduleHandle, moduleHandle) ||
                const DeepCollectionEquality()
                    .equals(other.moduleHandle, moduleHandle)) &&
            (identical(other.customAttributes, customAttributes) ||
                const DeepCollectionEquality()
                    .equals(other.customAttributes, customAttributes)) &&
            (identical(other.metadataToken, metadataToken) ||
                const DeepCollectionEquality()
                    .equals(other.metadataToken, metadataToken)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(assembly) ^
      const DeepCollectionEquality().hash(fullyQualifiedName) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(mdStreamVersion) ^
      const DeepCollectionEquality().hash(moduleVersionId) ^
      const DeepCollectionEquality().hash(scopeName) ^
      const DeepCollectionEquality().hash(moduleHandle) ^
      const DeepCollectionEquality().hash(customAttributes) ^
      const DeepCollectionEquality().hash(metadataToken) ^
      runtimeType.hashCode;
}

extension $ModuleExtension on Module {
  Module copyWith(
      {Assembly? assembly,
      String? fullyQualifiedName,
      String? name,
      int? mdStreamVersion,
      String? moduleVersionId,
      String? scopeName,
      ModuleHandle? moduleHandle,
      List<CustomAttributeData>? customAttributes,
      int? metadataToken}) {
    return Module(
        assembly: assembly ?? this.assembly,
        fullyQualifiedName: fullyQualifiedName ?? this.fullyQualifiedName,
        name: name ?? this.name,
        mdStreamVersion: mdStreamVersion ?? this.mdStreamVersion,
        moduleVersionId: moduleVersionId ?? this.moduleVersionId,
        scopeName: scopeName ?? this.scopeName,
        moduleHandle: moduleHandle ?? this.moduleHandle,
        customAttributes: customAttributes ?? this.customAttributes,
        metadataToken: metadataToken ?? this.metadataToken);
  }

  Module copyWithWrapped(
      {Wrapped<Assembly>? assembly,
      Wrapped<String>? fullyQualifiedName,
      Wrapped<String>? name,
      Wrapped<int>? mdStreamVersion,
      Wrapped<String>? moduleVersionId,
      Wrapped<String>? scopeName,
      Wrapped<ModuleHandle>? moduleHandle,
      Wrapped<List<CustomAttributeData>>? customAttributes,
      Wrapped<int>? metadataToken}) {
    return Module(
        assembly: (assembly != null ? assembly.value : this.assembly),
        fullyQualifiedName: (fullyQualifiedName != null
            ? fullyQualifiedName.value
            : this.fullyQualifiedName),
        name: (name != null ? name.value : this.name),
        mdStreamVersion: (mdStreamVersion != null
            ? mdStreamVersion.value
            : this.mdStreamVersion),
        moduleVersionId: (moduleVersionId != null
            ? moduleVersionId.value
            : this.moduleVersionId),
        scopeName: (scopeName != null ? scopeName.value : this.scopeName),
        moduleHandle:
            (moduleHandle != null ? moduleHandle.value : this.moduleHandle),
        customAttributes: (customAttributes != null
            ? customAttributes.value
            : this.customAttributes),
        metadataToken:
            (metadataToken != null ? metadataToken.value : this.metadataToken));
  }
}

@JsonSerializable(explicitToJson: true)
class Assembly {
  const Assembly({
    required this.definedTypes,
    required this.exportedTypes,
    this.codeBase,
    this.entryPoint,
    this.fullName,
    required this.imageRuntimeVersion,
    required this.isDynamic,
    required this.location,
    required this.reflectionOnly,
    required this.isCollectible,
    required this.isFullyTrusted,
    required this.customAttributes,
    required this.escapedCodeBase,
    required this.manifestModule,
    required this.modules,
    required this.globalAssemblyCache,
    required this.hostContext,
    required this.securityRuleSet,
  });

  factory Assembly.fromJson(Map<String, dynamic> json) =>
      _$AssemblyFromJson(json);

  static const toJsonFactory = _$AssemblyToJson;
  Map<String, dynamic> toJson() => _$AssemblyToJson(this);

  @JsonKey(name: 'definedTypes', defaultValue: <TypeInfo>[])
  final List<TypeInfo> definedTypes;
  @JsonKey(name: 'exportedTypes', defaultValue: <String>[])
  final List<String> exportedTypes;
  @JsonKey(name: 'codeBase')
  final String? codeBase;
  @JsonKey(name: 'entryPoint')
  final MethodInfo? entryPoint;
  @JsonKey(name: 'fullName')
  final String? fullName;
  @JsonKey(name: 'imageRuntimeVersion')
  final String imageRuntimeVersion;
  @JsonKey(name: 'isDynamic')
  final bool isDynamic;
  @JsonKey(name: 'location')
  final String location;
  @JsonKey(name: 'reflectionOnly')
  final bool reflectionOnly;
  @JsonKey(name: 'isCollectible')
  final bool isCollectible;
  @JsonKey(name: 'isFullyTrusted')
  final bool isFullyTrusted;
  @JsonKey(name: 'customAttributes', defaultValue: <CustomAttributeData>[])
  final List<CustomAttributeData> customAttributes;
  @JsonKey(name: 'escapedCodeBase')
  final String escapedCodeBase;
  @JsonKey(name: 'manifestModule')
  final Module manifestModule;
  @JsonKey(name: 'modules', defaultValue: <Module>[])
  final List<Module> modules;
  @JsonKey(name: 'globalAssemblyCache')
  final bool globalAssemblyCache;
  @JsonKey(name: 'hostContext')
  final int hostContext;
  @JsonKey(
    name: 'securityRuleSet',
    toJson: securityRuleSetToJson,
    fromJson: securityRuleSetFromJson,
  )
  final enums.SecurityRuleSet securityRuleSet;
  static const fromJsonFactory = _$AssemblyFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Assembly &&
            (identical(other.definedTypes, definedTypes) ||
                const DeepCollectionEquality()
                    .equals(other.definedTypes, definedTypes)) &&
            (identical(other.exportedTypes, exportedTypes) ||
                const DeepCollectionEquality()
                    .equals(other.exportedTypes, exportedTypes)) &&
            (identical(other.codeBase, codeBase) ||
                const DeepCollectionEquality()
                    .equals(other.codeBase, codeBase)) &&
            (identical(other.entryPoint, entryPoint) ||
                const DeepCollectionEquality()
                    .equals(other.entryPoint, entryPoint)) &&
            (identical(other.fullName, fullName) ||
                const DeepCollectionEquality()
                    .equals(other.fullName, fullName)) &&
            (identical(other.imageRuntimeVersion, imageRuntimeVersion) ||
                const DeepCollectionEquality()
                    .equals(other.imageRuntimeVersion, imageRuntimeVersion)) &&
            (identical(other.isDynamic, isDynamic) ||
                const DeepCollectionEquality()
                    .equals(other.isDynamic, isDynamic)) &&
            (identical(other.location, location) ||
                const DeepCollectionEquality()
                    .equals(other.location, location)) &&
            (identical(other.reflectionOnly, reflectionOnly) ||
                const DeepCollectionEquality()
                    .equals(other.reflectionOnly, reflectionOnly)) &&
            (identical(other.isCollectible, isCollectible) ||
                const DeepCollectionEquality()
                    .equals(other.isCollectible, isCollectible)) &&
            (identical(other.isFullyTrusted, isFullyTrusted) ||
                const DeepCollectionEquality()
                    .equals(other.isFullyTrusted, isFullyTrusted)) &&
            (identical(other.customAttributes, customAttributes) ||
                const DeepCollectionEquality()
                    .equals(other.customAttributes, customAttributes)) &&
            (identical(other.escapedCodeBase, escapedCodeBase) ||
                const DeepCollectionEquality()
                    .equals(other.escapedCodeBase, escapedCodeBase)) &&
            (identical(other.manifestModule, manifestModule) ||
                const DeepCollectionEquality()
                    .equals(other.manifestModule, manifestModule)) &&
            (identical(other.modules, modules) ||
                const DeepCollectionEquality()
                    .equals(other.modules, modules)) &&
            (identical(other.globalAssemblyCache, globalAssemblyCache) ||
                const DeepCollectionEquality()
                    .equals(other.globalAssemblyCache, globalAssemblyCache)) &&
            (identical(other.hostContext, hostContext) ||
                const DeepCollectionEquality()
                    .equals(other.hostContext, hostContext)) &&
            (identical(other.securityRuleSet, securityRuleSet) ||
                const DeepCollectionEquality()
                    .equals(other.securityRuleSet, securityRuleSet)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(definedTypes) ^
      const DeepCollectionEquality().hash(exportedTypes) ^
      const DeepCollectionEquality().hash(codeBase) ^
      const DeepCollectionEquality().hash(entryPoint) ^
      const DeepCollectionEquality().hash(fullName) ^
      const DeepCollectionEquality().hash(imageRuntimeVersion) ^
      const DeepCollectionEquality().hash(isDynamic) ^
      const DeepCollectionEquality().hash(location) ^
      const DeepCollectionEquality().hash(reflectionOnly) ^
      const DeepCollectionEquality().hash(isCollectible) ^
      const DeepCollectionEquality().hash(isFullyTrusted) ^
      const DeepCollectionEquality().hash(customAttributes) ^
      const DeepCollectionEquality().hash(escapedCodeBase) ^
      const DeepCollectionEquality().hash(manifestModule) ^
      const DeepCollectionEquality().hash(modules) ^
      const DeepCollectionEquality().hash(globalAssemblyCache) ^
      const DeepCollectionEquality().hash(hostContext) ^
      const DeepCollectionEquality().hash(securityRuleSet) ^
      runtimeType.hashCode;
}

extension $AssemblyExtension on Assembly {
  Assembly copyWith(
      {List<TypeInfo>? definedTypes,
      List<String>? exportedTypes,
      String? codeBase,
      MethodInfo? entryPoint,
      String? fullName,
      String? imageRuntimeVersion,
      bool? isDynamic,
      String? location,
      bool? reflectionOnly,
      bool? isCollectible,
      bool? isFullyTrusted,
      List<CustomAttributeData>? customAttributes,
      String? escapedCodeBase,
      Module? manifestModule,
      List<Module>? modules,
      bool? globalAssemblyCache,
      int? hostContext,
      enums.SecurityRuleSet? securityRuleSet}) {
    return Assembly(
        definedTypes: definedTypes ?? this.definedTypes,
        exportedTypes: exportedTypes ?? this.exportedTypes,
        codeBase: codeBase ?? this.codeBase,
        entryPoint: entryPoint ?? this.entryPoint,
        fullName: fullName ?? this.fullName,
        imageRuntimeVersion: imageRuntimeVersion ?? this.imageRuntimeVersion,
        isDynamic: isDynamic ?? this.isDynamic,
        location: location ?? this.location,
        reflectionOnly: reflectionOnly ?? this.reflectionOnly,
        isCollectible: isCollectible ?? this.isCollectible,
        isFullyTrusted: isFullyTrusted ?? this.isFullyTrusted,
        customAttributes: customAttributes ?? this.customAttributes,
        escapedCodeBase: escapedCodeBase ?? this.escapedCodeBase,
        manifestModule: manifestModule ?? this.manifestModule,
        modules: modules ?? this.modules,
        globalAssemblyCache: globalAssemblyCache ?? this.globalAssemblyCache,
        hostContext: hostContext ?? this.hostContext,
        securityRuleSet: securityRuleSet ?? this.securityRuleSet);
  }

  Assembly copyWithWrapped(
      {Wrapped<List<TypeInfo>>? definedTypes,
      Wrapped<List<String>>? exportedTypes,
      Wrapped<String?>? codeBase,
      Wrapped<MethodInfo?>? entryPoint,
      Wrapped<String?>? fullName,
      Wrapped<String>? imageRuntimeVersion,
      Wrapped<bool>? isDynamic,
      Wrapped<String>? location,
      Wrapped<bool>? reflectionOnly,
      Wrapped<bool>? isCollectible,
      Wrapped<bool>? isFullyTrusted,
      Wrapped<List<CustomAttributeData>>? customAttributes,
      Wrapped<String>? escapedCodeBase,
      Wrapped<Module>? manifestModule,
      Wrapped<List<Module>>? modules,
      Wrapped<bool>? globalAssemblyCache,
      Wrapped<int>? hostContext,
      Wrapped<enums.SecurityRuleSet>? securityRuleSet}) {
    return Assembly(
        definedTypes:
            (definedTypes != null ? definedTypes.value : this.definedTypes),
        exportedTypes:
            (exportedTypes != null ? exportedTypes.value : this.exportedTypes),
        codeBase: (codeBase != null ? codeBase.value : this.codeBase),
        entryPoint: (entryPoint != null ? entryPoint.value : this.entryPoint),
        fullName: (fullName != null ? fullName.value : this.fullName),
        imageRuntimeVersion: (imageRuntimeVersion != null
            ? imageRuntimeVersion.value
            : this.imageRuntimeVersion),
        isDynamic: (isDynamic != null ? isDynamic.value : this.isDynamic),
        location: (location != null ? location.value : this.location),
        reflectionOnly: (reflectionOnly != null
            ? reflectionOnly.value
            : this.reflectionOnly),
        isCollectible:
            (isCollectible != null ? isCollectible.value : this.isCollectible),
        isFullyTrusted: (isFullyTrusted != null
            ? isFullyTrusted.value
            : this.isFullyTrusted),
        customAttributes: (customAttributes != null
            ? customAttributes.value
            : this.customAttributes),
        escapedCodeBase: (escapedCodeBase != null
            ? escapedCodeBase.value
            : this.escapedCodeBase),
        manifestModule: (manifestModule != null
            ? manifestModule.value
            : this.manifestModule),
        modules: (modules != null ? modules.value : this.modules),
        globalAssemblyCache: (globalAssemblyCache != null
            ? globalAssemblyCache.value
            : this.globalAssemblyCache),
        hostContext:
            (hostContext != null ? hostContext.value : this.hostContext),
        securityRuleSet: (securityRuleSet != null
            ? securityRuleSet.value
            : this.securityRuleSet));
  }
}

@JsonSerializable(explicitToJson: true)
class TypeInfo {
  const TypeInfo({
    required this.genericTypeParameters,
    required this.declaredConstructors,
    required this.declaredEvents,
    required this.declaredFields,
    required this.declaredMembers,
    required this.declaredMethods,
    required this.declaredNestedTypes,
    required this.declaredProperties,
    required this.implementedInterfaces,
  });

  factory TypeInfo.fromJson(Map<String, dynamic> json) =>
      _$TypeInfoFromJson(json);

  static const toJsonFactory = _$TypeInfoToJson;
  Map<String, dynamic> toJson() => _$TypeInfoToJson(this);

  @JsonKey(name: 'genericTypeParameters', defaultValue: <String>[])
  final List<String> genericTypeParameters;
  @JsonKey(name: 'declaredConstructors', defaultValue: <ConstructorInfo>[])
  final List<ConstructorInfo> declaredConstructors;
  @JsonKey(name: 'declaredEvents', defaultValue: <EventInfo>[])
  final List<EventInfo> declaredEvents;
  @JsonKey(name: 'declaredFields', defaultValue: <FieldInfo>[])
  final List<FieldInfo> declaredFields;
  @JsonKey(name: 'declaredMembers', defaultValue: <MemberInfo>[])
  final List<MemberInfo> declaredMembers;
  @JsonKey(name: 'declaredMethods', defaultValue: <MethodInfo>[])
  final List<MethodInfo> declaredMethods;
  @JsonKey(name: 'declaredNestedTypes', defaultValue: <TypeInfo>[])
  final List<TypeInfo> declaredNestedTypes;
  @JsonKey(name: 'declaredProperties', defaultValue: <PropertyInfo>[])
  final List<PropertyInfo> declaredProperties;
  @JsonKey(name: 'implementedInterfaces', defaultValue: <String>[])
  final List<String> implementedInterfaces;
  static const fromJsonFactory = _$TypeInfoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TypeInfo &&
            (identical(other.genericTypeParameters, genericTypeParameters) ||
                const DeepCollectionEquality().equals(
                    other.genericTypeParameters, genericTypeParameters)) &&
            (identical(other.declaredConstructors, declaredConstructors) ||
                const DeepCollectionEquality().equals(
                    other.declaredConstructors, declaredConstructors)) &&
            (identical(other.declaredEvents, declaredEvents) ||
                const DeepCollectionEquality()
                    .equals(other.declaredEvents, declaredEvents)) &&
            (identical(other.declaredFields, declaredFields) ||
                const DeepCollectionEquality()
                    .equals(other.declaredFields, declaredFields)) &&
            (identical(other.declaredMembers, declaredMembers) ||
                const DeepCollectionEquality()
                    .equals(other.declaredMembers, declaredMembers)) &&
            (identical(other.declaredMethods, declaredMethods) ||
                const DeepCollectionEquality()
                    .equals(other.declaredMethods, declaredMethods)) &&
            (identical(other.declaredNestedTypes, declaredNestedTypes) ||
                const DeepCollectionEquality()
                    .equals(other.declaredNestedTypes, declaredNestedTypes)) &&
            (identical(other.declaredProperties, declaredProperties) ||
                const DeepCollectionEquality()
                    .equals(other.declaredProperties, declaredProperties)) &&
            (identical(other.implementedInterfaces, implementedInterfaces) ||
                const DeepCollectionEquality().equals(
                    other.implementedInterfaces, implementedInterfaces)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(genericTypeParameters) ^
      const DeepCollectionEquality().hash(declaredConstructors) ^
      const DeepCollectionEquality().hash(declaredEvents) ^
      const DeepCollectionEquality().hash(declaredFields) ^
      const DeepCollectionEquality().hash(declaredMembers) ^
      const DeepCollectionEquality().hash(declaredMethods) ^
      const DeepCollectionEquality().hash(declaredNestedTypes) ^
      const DeepCollectionEquality().hash(declaredProperties) ^
      const DeepCollectionEquality().hash(implementedInterfaces) ^
      runtimeType.hashCode;
}

extension $TypeInfoExtension on TypeInfo {
  TypeInfo copyWith(
      {List<String>? genericTypeParameters,
      List<ConstructorInfo>? declaredConstructors,
      List<EventInfo>? declaredEvents,
      List<FieldInfo>? declaredFields,
      List<MemberInfo>? declaredMembers,
      List<MethodInfo>? declaredMethods,
      List<TypeInfo>? declaredNestedTypes,
      List<PropertyInfo>? declaredProperties,
      List<String>? implementedInterfaces}) {
    return TypeInfo(
        genericTypeParameters:
            genericTypeParameters ?? this.genericTypeParameters,
        declaredConstructors: declaredConstructors ?? this.declaredConstructors,
        declaredEvents: declaredEvents ?? this.declaredEvents,
        declaredFields: declaredFields ?? this.declaredFields,
        declaredMembers: declaredMembers ?? this.declaredMembers,
        declaredMethods: declaredMethods ?? this.declaredMethods,
        declaredNestedTypes: declaredNestedTypes ?? this.declaredNestedTypes,
        declaredProperties: declaredProperties ?? this.declaredProperties,
        implementedInterfaces:
            implementedInterfaces ?? this.implementedInterfaces);
  }

  TypeInfo copyWithWrapped(
      {Wrapped<List<String>>? genericTypeParameters,
      Wrapped<List<ConstructorInfo>>? declaredConstructors,
      Wrapped<List<EventInfo>>? declaredEvents,
      Wrapped<List<FieldInfo>>? declaredFields,
      Wrapped<List<MemberInfo>>? declaredMembers,
      Wrapped<List<MethodInfo>>? declaredMethods,
      Wrapped<List<TypeInfo>>? declaredNestedTypes,
      Wrapped<List<PropertyInfo>>? declaredProperties,
      Wrapped<List<String>>? implementedInterfaces}) {
    return TypeInfo(
        genericTypeParameters: (genericTypeParameters != null
            ? genericTypeParameters.value
            : this.genericTypeParameters),
        declaredConstructors: (declaredConstructors != null
            ? declaredConstructors.value
            : this.declaredConstructors),
        declaredEvents: (declaredEvents != null
            ? declaredEvents.value
            : this.declaredEvents),
        declaredFields: (declaredFields != null
            ? declaredFields.value
            : this.declaredFields),
        declaredMembers: (declaredMembers != null
            ? declaredMembers.value
            : this.declaredMembers),
        declaredMethods: (declaredMethods != null
            ? declaredMethods.value
            : this.declaredMethods),
        declaredNestedTypes: (declaredNestedTypes != null
            ? declaredNestedTypes.value
            : this.declaredNestedTypes),
        declaredProperties: (declaredProperties != null
            ? declaredProperties.value
            : this.declaredProperties),
        implementedInterfaces: (implementedInterfaces != null
            ? implementedInterfaces.value
            : this.implementedInterfaces));
  }
}

@JsonSerializable(explicitToJson: true)
class ConstructorInfo {
  const ConstructorInfo({
    required this.memberType,
    required this.attributes,
    required this.methodImplementationFlags,
    required this.callingConvention,
    required this.isAbstract,
    required this.isConstructor,
    required this.isFinal,
    required this.isHideBySig,
    required this.isSpecialName,
    required this.isStatic,
    required this.isVirtual,
    required this.isAssembly,
    required this.isFamily,
    required this.isFamilyAndAssembly,
    required this.isFamilyOrAssembly,
    required this.isPrivate,
    required this.isPublic,
    required this.isConstructedGenericMethod,
    required this.isGenericMethod,
    required this.isGenericMethodDefinition,
    required this.containsGenericParameters,
    required this.methodHandle,
    required this.isSecurityCritical,
    required this.isSecuritySafeCritical,
    required this.isSecurityTransparent,
    required this.name,
    this.declaringType,
    this.reflectedType,
    required this.module,
    required this.customAttributes,
    required this.isCollectible,
    required this.metadataToken,
  });

  factory ConstructorInfo.fromJson(Map<String, dynamic> json) =>
      _$ConstructorInfoFromJson(json);

  static const toJsonFactory = _$ConstructorInfoToJson;
  Map<String, dynamic> toJson() => _$ConstructorInfoToJson(this);

  @JsonKey(
    name: 'memberType',
    toJson: memberTypesToJson,
    fromJson: memberTypesFromJson,
  )
  final enums.MemberTypes memberType;
  @JsonKey(
    name: 'attributes',
    toJson: methodAttributesToJson,
    fromJson: methodAttributesFromJson,
  )
  final enums.MethodAttributes attributes;
  @JsonKey(
    name: 'methodImplementationFlags',
    toJson: methodImplAttributesToJson,
    fromJson: methodImplAttributesFromJson,
  )
  final enums.MethodImplAttributes methodImplementationFlags;
  @JsonKey(
    name: 'callingConvention',
    toJson: callingConventionsToJson,
    fromJson: callingConventionsFromJson,
  )
  final enums.CallingConventions callingConvention;
  @JsonKey(name: 'isAbstract')
  final bool isAbstract;
  @JsonKey(name: 'isConstructor')
  final bool isConstructor;
  @JsonKey(name: 'isFinal')
  final bool isFinal;
  @JsonKey(name: 'isHideBySig')
  final bool isHideBySig;
  @JsonKey(name: 'isSpecialName')
  final bool isSpecialName;
  @JsonKey(name: 'isStatic')
  final bool isStatic;
  @JsonKey(name: 'isVirtual')
  final bool isVirtual;
  @JsonKey(name: 'isAssembly')
  final bool isAssembly;
  @JsonKey(name: 'isFamily')
  final bool isFamily;
  @JsonKey(name: 'isFamilyAndAssembly')
  final bool isFamilyAndAssembly;
  @JsonKey(name: 'isFamilyOrAssembly')
  final bool isFamilyOrAssembly;
  @JsonKey(name: 'isPrivate')
  final bool isPrivate;
  @JsonKey(name: 'isPublic')
  final bool isPublic;
  @JsonKey(name: 'isConstructedGenericMethod')
  final bool isConstructedGenericMethod;
  @JsonKey(name: 'isGenericMethod')
  final bool isGenericMethod;
  @JsonKey(name: 'isGenericMethodDefinition')
  final bool isGenericMethodDefinition;
  @JsonKey(name: 'containsGenericParameters')
  final bool containsGenericParameters;
  @JsonKey(name: 'methodHandle')
  final RuntimeMethodHandle methodHandle;
  @JsonKey(name: 'isSecurityCritical')
  final bool isSecurityCritical;
  @JsonKey(name: 'isSecuritySafeCritical')
  final bool isSecuritySafeCritical;
  @JsonKey(name: 'isSecurityTransparent')
  final bool isSecurityTransparent;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'declaringType')
  final String? declaringType;
  @JsonKey(name: 'reflectedType')
  final String? reflectedType;
  @JsonKey(name: 'module')
  final Module module;
  @JsonKey(name: 'customAttributes', defaultValue: <CustomAttributeData>[])
  final List<CustomAttributeData> customAttributes;
  @JsonKey(name: 'isCollectible')
  final bool isCollectible;
  @JsonKey(name: 'metadataToken')
  final int metadataToken;
  static const fromJsonFactory = _$ConstructorInfoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ConstructorInfo &&
            (identical(other.memberType, memberType) ||
                const DeepCollectionEquality()
                    .equals(other.memberType, memberType)) &&
            (identical(other.attributes, attributes) ||
                const DeepCollectionEquality()
                    .equals(other.attributes, attributes)) &&
            (identical(other.methodImplementationFlags, methodImplementationFlags) ||
                const DeepCollectionEquality().equals(
                    other.methodImplementationFlags,
                    methodImplementationFlags)) &&
            (identical(other.callingConvention, callingConvention) ||
                const DeepCollectionEquality()
                    .equals(other.callingConvention, callingConvention)) &&
            (identical(other.isAbstract, isAbstract) ||
                const DeepCollectionEquality()
                    .equals(other.isAbstract, isAbstract)) &&
            (identical(other.isConstructor, isConstructor) ||
                const DeepCollectionEquality()
                    .equals(other.isConstructor, isConstructor)) &&
            (identical(other.isFinal, isFinal) ||
                const DeepCollectionEquality()
                    .equals(other.isFinal, isFinal)) &&
            (identical(other.isHideBySig, isHideBySig) ||
                const DeepCollectionEquality()
                    .equals(other.isHideBySig, isHideBySig)) &&
            (identical(other.isSpecialName, isSpecialName) ||
                const DeepCollectionEquality()
                    .equals(other.isSpecialName, isSpecialName)) &&
            (identical(other.isStatic, isStatic) ||
                const DeepCollectionEquality()
                    .equals(other.isStatic, isStatic)) &&
            (identical(other.isVirtual, isVirtual) ||
                const DeepCollectionEquality()
                    .equals(other.isVirtual, isVirtual)) &&
            (identical(other.isAssembly, isAssembly) ||
                const DeepCollectionEquality()
                    .equals(other.isAssembly, isAssembly)) &&
            (identical(other.isFamily, isFamily) ||
                const DeepCollectionEquality()
                    .equals(other.isFamily, isFamily)) &&
            (identical(other.isFamilyAndAssembly, isFamilyAndAssembly) ||
                const DeepCollectionEquality()
                    .equals(other.isFamilyAndAssembly, isFamilyAndAssembly)) &&
            (identical(other.isFamilyOrAssembly, isFamilyOrAssembly) ||
                const DeepCollectionEquality()
                    .equals(other.isFamilyOrAssembly, isFamilyOrAssembly)) &&
            (identical(other.isPrivate, isPrivate) ||
                const DeepCollectionEquality()
                    .equals(other.isPrivate, isPrivate)) &&
            (identical(other.isPublic, isPublic) ||
                const DeepCollectionEquality().equals(other.isPublic, isPublic)) &&
            (identical(other.isConstructedGenericMethod, isConstructedGenericMethod) || const DeepCollectionEquality().equals(other.isConstructedGenericMethod, isConstructedGenericMethod)) &&
            (identical(other.isGenericMethod, isGenericMethod) || const DeepCollectionEquality().equals(other.isGenericMethod, isGenericMethod)) &&
            (identical(other.isGenericMethodDefinition, isGenericMethodDefinition) || const DeepCollectionEquality().equals(other.isGenericMethodDefinition, isGenericMethodDefinition)) &&
            (identical(other.containsGenericParameters, containsGenericParameters) || const DeepCollectionEquality().equals(other.containsGenericParameters, containsGenericParameters)) &&
            (identical(other.methodHandle, methodHandle) || const DeepCollectionEquality().equals(other.methodHandle, methodHandle)) &&
            (identical(other.isSecurityCritical, isSecurityCritical) || const DeepCollectionEquality().equals(other.isSecurityCritical, isSecurityCritical)) &&
            (identical(other.isSecuritySafeCritical, isSecuritySafeCritical) || const DeepCollectionEquality().equals(other.isSecuritySafeCritical, isSecuritySafeCritical)) &&
            (identical(other.isSecurityTransparent, isSecurityTransparent) || const DeepCollectionEquality().equals(other.isSecurityTransparent, isSecurityTransparent)) &&
            (identical(other.name, name) || const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.declaringType, declaringType) || const DeepCollectionEquality().equals(other.declaringType, declaringType)) &&
            (identical(other.reflectedType, reflectedType) || const DeepCollectionEquality().equals(other.reflectedType, reflectedType)) &&
            (identical(other.module, module) || const DeepCollectionEquality().equals(other.module, module)) &&
            (identical(other.customAttributes, customAttributes) || const DeepCollectionEquality().equals(other.customAttributes, customAttributes)) &&
            (identical(other.isCollectible, isCollectible) || const DeepCollectionEquality().equals(other.isCollectible, isCollectible)) &&
            (identical(other.metadataToken, metadataToken) || const DeepCollectionEquality().equals(other.metadataToken, metadataToken)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(memberType) ^
      const DeepCollectionEquality().hash(attributes) ^
      const DeepCollectionEquality().hash(methodImplementationFlags) ^
      const DeepCollectionEquality().hash(callingConvention) ^
      const DeepCollectionEquality().hash(isAbstract) ^
      const DeepCollectionEquality().hash(isConstructor) ^
      const DeepCollectionEquality().hash(isFinal) ^
      const DeepCollectionEquality().hash(isHideBySig) ^
      const DeepCollectionEquality().hash(isSpecialName) ^
      const DeepCollectionEquality().hash(isStatic) ^
      const DeepCollectionEquality().hash(isVirtual) ^
      const DeepCollectionEquality().hash(isAssembly) ^
      const DeepCollectionEquality().hash(isFamily) ^
      const DeepCollectionEquality().hash(isFamilyAndAssembly) ^
      const DeepCollectionEquality().hash(isFamilyOrAssembly) ^
      const DeepCollectionEquality().hash(isPrivate) ^
      const DeepCollectionEquality().hash(isPublic) ^
      const DeepCollectionEquality().hash(isConstructedGenericMethod) ^
      const DeepCollectionEquality().hash(isGenericMethod) ^
      const DeepCollectionEquality().hash(isGenericMethodDefinition) ^
      const DeepCollectionEquality().hash(containsGenericParameters) ^
      const DeepCollectionEquality().hash(methodHandle) ^
      const DeepCollectionEquality().hash(isSecurityCritical) ^
      const DeepCollectionEquality().hash(isSecuritySafeCritical) ^
      const DeepCollectionEquality().hash(isSecurityTransparent) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(declaringType) ^
      const DeepCollectionEquality().hash(reflectedType) ^
      const DeepCollectionEquality().hash(module) ^
      const DeepCollectionEquality().hash(customAttributes) ^
      const DeepCollectionEquality().hash(isCollectible) ^
      const DeepCollectionEquality().hash(metadataToken) ^
      runtimeType.hashCode;
}

extension $ConstructorInfoExtension on ConstructorInfo {
  ConstructorInfo copyWith(
      {enums.MemberTypes? memberType,
      enums.MethodAttributes? attributes,
      enums.MethodImplAttributes? methodImplementationFlags,
      enums.CallingConventions? callingConvention,
      bool? isAbstract,
      bool? isConstructor,
      bool? isFinal,
      bool? isHideBySig,
      bool? isSpecialName,
      bool? isStatic,
      bool? isVirtual,
      bool? isAssembly,
      bool? isFamily,
      bool? isFamilyAndAssembly,
      bool? isFamilyOrAssembly,
      bool? isPrivate,
      bool? isPublic,
      bool? isConstructedGenericMethod,
      bool? isGenericMethod,
      bool? isGenericMethodDefinition,
      bool? containsGenericParameters,
      RuntimeMethodHandle? methodHandle,
      bool? isSecurityCritical,
      bool? isSecuritySafeCritical,
      bool? isSecurityTransparent,
      String? name,
      String? declaringType,
      String? reflectedType,
      Module? module,
      List<CustomAttributeData>? customAttributes,
      bool? isCollectible,
      int? metadataToken}) {
    return ConstructorInfo(
        memberType: memberType ?? this.memberType,
        attributes: attributes ?? this.attributes,
        methodImplementationFlags:
            methodImplementationFlags ?? this.methodImplementationFlags,
        callingConvention: callingConvention ?? this.callingConvention,
        isAbstract: isAbstract ?? this.isAbstract,
        isConstructor: isConstructor ?? this.isConstructor,
        isFinal: isFinal ?? this.isFinal,
        isHideBySig: isHideBySig ?? this.isHideBySig,
        isSpecialName: isSpecialName ?? this.isSpecialName,
        isStatic: isStatic ?? this.isStatic,
        isVirtual: isVirtual ?? this.isVirtual,
        isAssembly: isAssembly ?? this.isAssembly,
        isFamily: isFamily ?? this.isFamily,
        isFamilyAndAssembly: isFamilyAndAssembly ?? this.isFamilyAndAssembly,
        isFamilyOrAssembly: isFamilyOrAssembly ?? this.isFamilyOrAssembly,
        isPrivate: isPrivate ?? this.isPrivate,
        isPublic: isPublic ?? this.isPublic,
        isConstructedGenericMethod:
            isConstructedGenericMethod ?? this.isConstructedGenericMethod,
        isGenericMethod: isGenericMethod ?? this.isGenericMethod,
        isGenericMethodDefinition:
            isGenericMethodDefinition ?? this.isGenericMethodDefinition,
        containsGenericParameters:
            containsGenericParameters ?? this.containsGenericParameters,
        methodHandle: methodHandle ?? this.methodHandle,
        isSecurityCritical: isSecurityCritical ?? this.isSecurityCritical,
        isSecuritySafeCritical:
            isSecuritySafeCritical ?? this.isSecuritySafeCritical,
        isSecurityTransparent:
            isSecurityTransparent ?? this.isSecurityTransparent,
        name: name ?? this.name,
        declaringType: declaringType ?? this.declaringType,
        reflectedType: reflectedType ?? this.reflectedType,
        module: module ?? this.module,
        customAttributes: customAttributes ?? this.customAttributes,
        isCollectible: isCollectible ?? this.isCollectible,
        metadataToken: metadataToken ?? this.metadataToken);
  }

  ConstructorInfo copyWithWrapped(
      {Wrapped<enums.MemberTypes>? memberType,
      Wrapped<enums.MethodAttributes>? attributes,
      Wrapped<enums.MethodImplAttributes>? methodImplementationFlags,
      Wrapped<enums.CallingConventions>? callingConvention,
      Wrapped<bool>? isAbstract,
      Wrapped<bool>? isConstructor,
      Wrapped<bool>? isFinal,
      Wrapped<bool>? isHideBySig,
      Wrapped<bool>? isSpecialName,
      Wrapped<bool>? isStatic,
      Wrapped<bool>? isVirtual,
      Wrapped<bool>? isAssembly,
      Wrapped<bool>? isFamily,
      Wrapped<bool>? isFamilyAndAssembly,
      Wrapped<bool>? isFamilyOrAssembly,
      Wrapped<bool>? isPrivate,
      Wrapped<bool>? isPublic,
      Wrapped<bool>? isConstructedGenericMethod,
      Wrapped<bool>? isGenericMethod,
      Wrapped<bool>? isGenericMethodDefinition,
      Wrapped<bool>? containsGenericParameters,
      Wrapped<RuntimeMethodHandle>? methodHandle,
      Wrapped<bool>? isSecurityCritical,
      Wrapped<bool>? isSecuritySafeCritical,
      Wrapped<bool>? isSecurityTransparent,
      Wrapped<String>? name,
      Wrapped<String?>? declaringType,
      Wrapped<String?>? reflectedType,
      Wrapped<Module>? module,
      Wrapped<List<CustomAttributeData>>? customAttributes,
      Wrapped<bool>? isCollectible,
      Wrapped<int>? metadataToken}) {
    return ConstructorInfo(
        memberType: (memberType != null ? memberType.value : this.memberType),
        attributes: (attributes != null ? attributes.value : this.attributes),
        methodImplementationFlags: (methodImplementationFlags != null
            ? methodImplementationFlags.value
            : this.methodImplementationFlags),
        callingConvention: (callingConvention != null
            ? callingConvention.value
            : this.callingConvention),
        isAbstract: (isAbstract != null ? isAbstract.value : this.isAbstract),
        isConstructor:
            (isConstructor != null ? isConstructor.value : this.isConstructor),
        isFinal: (isFinal != null ? isFinal.value : this.isFinal),
        isHideBySig:
            (isHideBySig != null ? isHideBySig.value : this.isHideBySig),
        isSpecialName:
            (isSpecialName != null ? isSpecialName.value : this.isSpecialName),
        isStatic: (isStatic != null ? isStatic.value : this.isStatic),
        isVirtual: (isVirtual != null ? isVirtual.value : this.isVirtual),
        isAssembly: (isAssembly != null ? isAssembly.value : this.isAssembly),
        isFamily: (isFamily != null ? isFamily.value : this.isFamily),
        isFamilyAndAssembly: (isFamilyAndAssembly != null
            ? isFamilyAndAssembly.value
            : this.isFamilyAndAssembly),
        isFamilyOrAssembly: (isFamilyOrAssembly != null
            ? isFamilyOrAssembly.value
            : this.isFamilyOrAssembly),
        isPrivate: (isPrivate != null ? isPrivate.value : this.isPrivate),
        isPublic: (isPublic != null ? isPublic.value : this.isPublic),
        isConstructedGenericMethod: (isConstructedGenericMethod != null
            ? isConstructedGenericMethod.value
            : this.isConstructedGenericMethod),
        isGenericMethod: (isGenericMethod != null
            ? isGenericMethod.value
            : this.isGenericMethod),
        isGenericMethodDefinition: (isGenericMethodDefinition != null
            ? isGenericMethodDefinition.value
            : this.isGenericMethodDefinition),
        containsGenericParameters: (containsGenericParameters != null
            ? containsGenericParameters.value
            : this.containsGenericParameters),
        methodHandle:
            (methodHandle != null ? methodHandle.value : this.methodHandle),
        isSecurityCritical: (isSecurityCritical != null
            ? isSecurityCritical.value
            : this.isSecurityCritical),
        isSecuritySafeCritical: (isSecuritySafeCritical != null
            ? isSecuritySafeCritical.value
            : this.isSecuritySafeCritical),
        isSecurityTransparent: (isSecurityTransparent != null
            ? isSecurityTransparent.value
            : this.isSecurityTransparent),
        name: (name != null ? name.value : this.name),
        declaringType:
            (declaringType != null ? declaringType.value : this.declaringType),
        reflectedType:
            (reflectedType != null ? reflectedType.value : this.reflectedType),
        module: (module != null ? module.value : this.module),
        customAttributes: (customAttributes != null
            ? customAttributes.value
            : this.customAttributes),
        isCollectible:
            (isCollectible != null ? isCollectible.value : this.isCollectible),
        metadataToken:
            (metadataToken != null ? metadataToken.value : this.metadataToken));
  }
}

@JsonSerializable(explicitToJson: true)
class EventInfo {
  const EventInfo({
    required this.memberType,
    required this.attributes,
    required this.isSpecialName,
    this.addMethod,
    this.removeMethod,
    this.raiseMethod,
    required this.isMulticast,
    this.eventHandlerType,
    required this.name,
    this.declaringType,
    this.reflectedType,
    required this.module,
    required this.customAttributes,
    required this.isCollectible,
    required this.metadataToken,
  });

  factory EventInfo.fromJson(Map<String, dynamic> json) =>
      _$EventInfoFromJson(json);

  static const toJsonFactory = _$EventInfoToJson;
  Map<String, dynamic> toJson() => _$EventInfoToJson(this);

  @JsonKey(
    name: 'memberType',
    toJson: memberTypesToJson,
    fromJson: memberTypesFromJson,
  )
  final enums.MemberTypes memberType;
  @JsonKey(
    name: 'attributes',
    toJson: eventAttributesToJson,
    fromJson: eventAttributesFromJson,
  )
  final enums.EventAttributes attributes;
  @JsonKey(name: 'isSpecialName')
  final bool isSpecialName;
  @JsonKey(name: 'addMethod')
  final MethodInfo? addMethod;
  @JsonKey(name: 'removeMethod')
  final MethodInfo? removeMethod;
  @JsonKey(name: 'raiseMethod')
  final MethodInfo? raiseMethod;
  @JsonKey(name: 'isMulticast')
  final bool isMulticast;
  @JsonKey(name: 'eventHandlerType')
  final String? eventHandlerType;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'declaringType')
  final String? declaringType;
  @JsonKey(name: 'reflectedType')
  final String? reflectedType;
  @JsonKey(name: 'module')
  final Module module;
  @JsonKey(name: 'customAttributes', defaultValue: <CustomAttributeData>[])
  final List<CustomAttributeData> customAttributes;
  @JsonKey(name: 'isCollectible')
  final bool isCollectible;
  @JsonKey(name: 'metadataToken')
  final int metadataToken;
  static const fromJsonFactory = _$EventInfoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is EventInfo &&
            (identical(other.memberType, memberType) ||
                const DeepCollectionEquality()
                    .equals(other.memberType, memberType)) &&
            (identical(other.attributes, attributes) ||
                const DeepCollectionEquality()
                    .equals(other.attributes, attributes)) &&
            (identical(other.isSpecialName, isSpecialName) ||
                const DeepCollectionEquality()
                    .equals(other.isSpecialName, isSpecialName)) &&
            (identical(other.addMethod, addMethod) ||
                const DeepCollectionEquality()
                    .equals(other.addMethod, addMethod)) &&
            (identical(other.removeMethod, removeMethod) ||
                const DeepCollectionEquality()
                    .equals(other.removeMethod, removeMethod)) &&
            (identical(other.raiseMethod, raiseMethod) ||
                const DeepCollectionEquality()
                    .equals(other.raiseMethod, raiseMethod)) &&
            (identical(other.isMulticast, isMulticast) ||
                const DeepCollectionEquality()
                    .equals(other.isMulticast, isMulticast)) &&
            (identical(other.eventHandlerType, eventHandlerType) ||
                const DeepCollectionEquality()
                    .equals(other.eventHandlerType, eventHandlerType)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.declaringType, declaringType) ||
                const DeepCollectionEquality()
                    .equals(other.declaringType, declaringType)) &&
            (identical(other.reflectedType, reflectedType) ||
                const DeepCollectionEquality()
                    .equals(other.reflectedType, reflectedType)) &&
            (identical(other.module, module) ||
                const DeepCollectionEquality().equals(other.module, module)) &&
            (identical(other.customAttributes, customAttributes) ||
                const DeepCollectionEquality()
                    .equals(other.customAttributes, customAttributes)) &&
            (identical(other.isCollectible, isCollectible) ||
                const DeepCollectionEquality()
                    .equals(other.isCollectible, isCollectible)) &&
            (identical(other.metadataToken, metadataToken) ||
                const DeepCollectionEquality()
                    .equals(other.metadataToken, metadataToken)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(memberType) ^
      const DeepCollectionEquality().hash(attributes) ^
      const DeepCollectionEquality().hash(isSpecialName) ^
      const DeepCollectionEquality().hash(addMethod) ^
      const DeepCollectionEquality().hash(removeMethod) ^
      const DeepCollectionEquality().hash(raiseMethod) ^
      const DeepCollectionEquality().hash(isMulticast) ^
      const DeepCollectionEquality().hash(eventHandlerType) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(declaringType) ^
      const DeepCollectionEquality().hash(reflectedType) ^
      const DeepCollectionEquality().hash(module) ^
      const DeepCollectionEquality().hash(customAttributes) ^
      const DeepCollectionEquality().hash(isCollectible) ^
      const DeepCollectionEquality().hash(metadataToken) ^
      runtimeType.hashCode;
}

extension $EventInfoExtension on EventInfo {
  EventInfo copyWith(
      {enums.MemberTypes? memberType,
      enums.EventAttributes? attributes,
      bool? isSpecialName,
      MethodInfo? addMethod,
      MethodInfo? removeMethod,
      MethodInfo? raiseMethod,
      bool? isMulticast,
      String? eventHandlerType,
      String? name,
      String? declaringType,
      String? reflectedType,
      Module? module,
      List<CustomAttributeData>? customAttributes,
      bool? isCollectible,
      int? metadataToken}) {
    return EventInfo(
        memberType: memberType ?? this.memberType,
        attributes: attributes ?? this.attributes,
        isSpecialName: isSpecialName ?? this.isSpecialName,
        addMethod: addMethod ?? this.addMethod,
        removeMethod: removeMethod ?? this.removeMethod,
        raiseMethod: raiseMethod ?? this.raiseMethod,
        isMulticast: isMulticast ?? this.isMulticast,
        eventHandlerType: eventHandlerType ?? this.eventHandlerType,
        name: name ?? this.name,
        declaringType: declaringType ?? this.declaringType,
        reflectedType: reflectedType ?? this.reflectedType,
        module: module ?? this.module,
        customAttributes: customAttributes ?? this.customAttributes,
        isCollectible: isCollectible ?? this.isCollectible,
        metadataToken: metadataToken ?? this.metadataToken);
  }

  EventInfo copyWithWrapped(
      {Wrapped<enums.MemberTypes>? memberType,
      Wrapped<enums.EventAttributes>? attributes,
      Wrapped<bool>? isSpecialName,
      Wrapped<MethodInfo?>? addMethod,
      Wrapped<MethodInfo?>? removeMethod,
      Wrapped<MethodInfo?>? raiseMethod,
      Wrapped<bool>? isMulticast,
      Wrapped<String?>? eventHandlerType,
      Wrapped<String>? name,
      Wrapped<String?>? declaringType,
      Wrapped<String?>? reflectedType,
      Wrapped<Module>? module,
      Wrapped<List<CustomAttributeData>>? customAttributes,
      Wrapped<bool>? isCollectible,
      Wrapped<int>? metadataToken}) {
    return EventInfo(
        memberType: (memberType != null ? memberType.value : this.memberType),
        attributes: (attributes != null ? attributes.value : this.attributes),
        isSpecialName:
            (isSpecialName != null ? isSpecialName.value : this.isSpecialName),
        addMethod: (addMethod != null ? addMethod.value : this.addMethod),
        removeMethod:
            (removeMethod != null ? removeMethod.value : this.removeMethod),
        raiseMethod:
            (raiseMethod != null ? raiseMethod.value : this.raiseMethod),
        isMulticast:
            (isMulticast != null ? isMulticast.value : this.isMulticast),
        eventHandlerType: (eventHandlerType != null
            ? eventHandlerType.value
            : this.eventHandlerType),
        name: (name != null ? name.value : this.name),
        declaringType:
            (declaringType != null ? declaringType.value : this.declaringType),
        reflectedType:
            (reflectedType != null ? reflectedType.value : this.reflectedType),
        module: (module != null ? module.value : this.module),
        customAttributes: (customAttributes != null
            ? customAttributes.value
            : this.customAttributes),
        isCollectible:
            (isCollectible != null ? isCollectible.value : this.isCollectible),
        metadataToken:
            (metadataToken != null ? metadataToken.value : this.metadataToken));
  }
}

@JsonSerializable(explicitToJson: true)
class MethodInfo {
  const MethodInfo({
    required this.memberType,
    required this.returnParameter,
    required this.returnType,
    required this.returnTypeCustomAttributes,
    required this.genericParameterCount,
    required this.attributes,
    required this.methodImplementationFlags,
    required this.callingConvention,
    required this.isAbstract,
    required this.isConstructor,
    required this.isFinal,
    required this.isHideBySig,
    required this.isSpecialName,
    required this.isStatic,
    required this.isVirtual,
    required this.isAssembly,
    required this.isFamily,
    required this.isFamilyAndAssembly,
    required this.isFamilyOrAssembly,
    required this.isPrivate,
    required this.isPublic,
    required this.isConstructedGenericMethod,
    required this.isGenericMethod,
    required this.isGenericMethodDefinition,
    required this.containsGenericParameters,
    required this.methodHandle,
    required this.isSecurityCritical,
    required this.isSecuritySafeCritical,
    required this.isSecurityTransparent,
    required this.name,
    this.declaringType,
    this.reflectedType,
    required this.module,
    required this.customAttributes,
    required this.isCollectible,
    required this.metadataToken,
  });

  factory MethodInfo.fromJson(Map<String, dynamic> json) =>
      _$MethodInfoFromJson(json);

  static const toJsonFactory = _$MethodInfoToJson;
  Map<String, dynamic> toJson() => _$MethodInfoToJson(this);

  @JsonKey(
    name: 'memberType',
    toJson: memberTypesToJson,
    fromJson: memberTypesFromJson,
  )
  final enums.MemberTypes memberType;
  @JsonKey(name: 'returnParameter')
  final ParameterInfo returnParameter;
  @JsonKey(name: 'returnType')
  final String returnType;
  @JsonKey(name: 'returnTypeCustomAttributes')
  final ICustomAttributeProvider returnTypeCustomAttributes;
  @JsonKey(name: 'genericParameterCount')
  final int genericParameterCount;
  @JsonKey(
    name: 'attributes',
    toJson: methodAttributesToJson,
    fromJson: methodAttributesFromJson,
  )
  final enums.MethodAttributes attributes;
  @JsonKey(
    name: 'methodImplementationFlags',
    toJson: methodImplAttributesToJson,
    fromJson: methodImplAttributesFromJson,
  )
  final enums.MethodImplAttributes methodImplementationFlags;
  @JsonKey(
    name: 'callingConvention',
    toJson: callingConventionsToJson,
    fromJson: callingConventionsFromJson,
  )
  final enums.CallingConventions callingConvention;
  @JsonKey(name: 'isAbstract')
  final bool isAbstract;
  @JsonKey(name: 'isConstructor')
  final bool isConstructor;
  @JsonKey(name: 'isFinal')
  final bool isFinal;
  @JsonKey(name: 'isHideBySig')
  final bool isHideBySig;
  @JsonKey(name: 'isSpecialName')
  final bool isSpecialName;
  @JsonKey(name: 'isStatic')
  final bool isStatic;
  @JsonKey(name: 'isVirtual')
  final bool isVirtual;
  @JsonKey(name: 'isAssembly')
  final bool isAssembly;
  @JsonKey(name: 'isFamily')
  final bool isFamily;
  @JsonKey(name: 'isFamilyAndAssembly')
  final bool isFamilyAndAssembly;
  @JsonKey(name: 'isFamilyOrAssembly')
  final bool isFamilyOrAssembly;
  @JsonKey(name: 'isPrivate')
  final bool isPrivate;
  @JsonKey(name: 'isPublic')
  final bool isPublic;
  @JsonKey(name: 'isConstructedGenericMethod')
  final bool isConstructedGenericMethod;
  @JsonKey(name: 'isGenericMethod')
  final bool isGenericMethod;
  @JsonKey(name: 'isGenericMethodDefinition')
  final bool isGenericMethodDefinition;
  @JsonKey(name: 'containsGenericParameters')
  final bool containsGenericParameters;
  @JsonKey(name: 'methodHandle')
  final RuntimeMethodHandle methodHandle;
  @JsonKey(name: 'isSecurityCritical')
  final bool isSecurityCritical;
  @JsonKey(name: 'isSecuritySafeCritical')
  final bool isSecuritySafeCritical;
  @JsonKey(name: 'isSecurityTransparent')
  final bool isSecurityTransparent;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'declaringType')
  final String? declaringType;
  @JsonKey(name: 'reflectedType')
  final String? reflectedType;
  @JsonKey(name: 'module')
  final Module module;
  @JsonKey(name: 'customAttributes', defaultValue: <CustomAttributeData>[])
  final List<CustomAttributeData> customAttributes;
  @JsonKey(name: 'isCollectible')
  final bool isCollectible;
  @JsonKey(name: 'metadataToken')
  final int metadataToken;
  static const fromJsonFactory = _$MethodInfoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MethodInfo &&
            (identical(other.memberType, memberType) ||
                const DeepCollectionEquality()
                    .equals(other.memberType, memberType)) &&
            (identical(other.returnParameter, returnParameter) ||
                const DeepCollectionEquality()
                    .equals(other.returnParameter, returnParameter)) &&
            (identical(other.returnType, returnType) ||
                const DeepCollectionEquality()
                    .equals(other.returnType, returnType)) &&
            (identical(other.returnTypeCustomAttributes, returnTypeCustomAttributes) ||
                const DeepCollectionEquality().equals(
                    other.returnTypeCustomAttributes,
                    returnTypeCustomAttributes)) &&
            (identical(other.genericParameterCount, genericParameterCount) ||
                const DeepCollectionEquality().equals(
                    other.genericParameterCount, genericParameterCount)) &&
            (identical(other.attributes, attributes) ||
                const DeepCollectionEquality()
                    .equals(other.attributes, attributes)) &&
            (identical(other.methodImplementationFlags, methodImplementationFlags) ||
                const DeepCollectionEquality().equals(
                    other.methodImplementationFlags,
                    methodImplementationFlags)) &&
            (identical(other.callingConvention, callingConvention) ||
                const DeepCollectionEquality()
                    .equals(other.callingConvention, callingConvention)) &&
            (identical(other.isAbstract, isAbstract) ||
                const DeepCollectionEquality()
                    .equals(other.isAbstract, isAbstract)) &&
            (identical(other.isConstructor, isConstructor) ||
                const DeepCollectionEquality()
                    .equals(other.isConstructor, isConstructor)) &&
            (identical(other.isFinal, isFinal) ||
                const DeepCollectionEquality()
                    .equals(other.isFinal, isFinal)) &&
            (identical(other.isHideBySig, isHideBySig) ||
                const DeepCollectionEquality()
                    .equals(other.isHideBySig, isHideBySig)) &&
            (identical(other.isSpecialName, isSpecialName) ||
                const DeepCollectionEquality()
                    .equals(other.isSpecialName, isSpecialName)) &&
            (identical(other.isStatic, isStatic) ||
                const DeepCollectionEquality()
                    .equals(other.isStatic, isStatic)) &&
            (identical(other.isVirtual, isVirtual) ||
                const DeepCollectionEquality().equals(other.isVirtual, isVirtual)) &&
            (identical(other.isAssembly, isAssembly) || const DeepCollectionEquality().equals(other.isAssembly, isAssembly)) &&
            (identical(other.isFamily, isFamily) || const DeepCollectionEquality().equals(other.isFamily, isFamily)) &&
            (identical(other.isFamilyAndAssembly, isFamilyAndAssembly) || const DeepCollectionEquality().equals(other.isFamilyAndAssembly, isFamilyAndAssembly)) &&
            (identical(other.isFamilyOrAssembly, isFamilyOrAssembly) || const DeepCollectionEquality().equals(other.isFamilyOrAssembly, isFamilyOrAssembly)) &&
            (identical(other.isPrivate, isPrivate) || const DeepCollectionEquality().equals(other.isPrivate, isPrivate)) &&
            (identical(other.isPublic, isPublic) || const DeepCollectionEquality().equals(other.isPublic, isPublic)) &&
            (identical(other.isConstructedGenericMethod, isConstructedGenericMethod) || const DeepCollectionEquality().equals(other.isConstructedGenericMethod, isConstructedGenericMethod)) &&
            (identical(other.isGenericMethod, isGenericMethod) || const DeepCollectionEquality().equals(other.isGenericMethod, isGenericMethod)) &&
            (identical(other.isGenericMethodDefinition, isGenericMethodDefinition) || const DeepCollectionEquality().equals(other.isGenericMethodDefinition, isGenericMethodDefinition)) &&
            (identical(other.containsGenericParameters, containsGenericParameters) || const DeepCollectionEquality().equals(other.containsGenericParameters, containsGenericParameters)) &&
            (identical(other.methodHandle, methodHandle) || const DeepCollectionEquality().equals(other.methodHandle, methodHandle)) &&
            (identical(other.isSecurityCritical, isSecurityCritical) || const DeepCollectionEquality().equals(other.isSecurityCritical, isSecurityCritical)) &&
            (identical(other.isSecuritySafeCritical, isSecuritySafeCritical) || const DeepCollectionEquality().equals(other.isSecuritySafeCritical, isSecuritySafeCritical)) &&
            (identical(other.isSecurityTransparent, isSecurityTransparent) || const DeepCollectionEquality().equals(other.isSecurityTransparent, isSecurityTransparent)) &&
            (identical(other.name, name) || const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.declaringType, declaringType) || const DeepCollectionEquality().equals(other.declaringType, declaringType)) &&
            (identical(other.reflectedType, reflectedType) || const DeepCollectionEquality().equals(other.reflectedType, reflectedType)) &&
            (identical(other.module, module) || const DeepCollectionEquality().equals(other.module, module)) &&
            (identical(other.customAttributes, customAttributes) || const DeepCollectionEquality().equals(other.customAttributes, customAttributes)) &&
            (identical(other.isCollectible, isCollectible) || const DeepCollectionEquality().equals(other.isCollectible, isCollectible)) &&
            (identical(other.metadataToken, metadataToken) || const DeepCollectionEquality().equals(other.metadataToken, metadataToken)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(memberType) ^
      const DeepCollectionEquality().hash(returnParameter) ^
      const DeepCollectionEquality().hash(returnType) ^
      const DeepCollectionEquality().hash(returnTypeCustomAttributes) ^
      const DeepCollectionEquality().hash(genericParameterCount) ^
      const DeepCollectionEquality().hash(attributes) ^
      const DeepCollectionEquality().hash(methodImplementationFlags) ^
      const DeepCollectionEquality().hash(callingConvention) ^
      const DeepCollectionEquality().hash(isAbstract) ^
      const DeepCollectionEquality().hash(isConstructor) ^
      const DeepCollectionEquality().hash(isFinal) ^
      const DeepCollectionEquality().hash(isHideBySig) ^
      const DeepCollectionEquality().hash(isSpecialName) ^
      const DeepCollectionEquality().hash(isStatic) ^
      const DeepCollectionEquality().hash(isVirtual) ^
      const DeepCollectionEquality().hash(isAssembly) ^
      const DeepCollectionEquality().hash(isFamily) ^
      const DeepCollectionEquality().hash(isFamilyAndAssembly) ^
      const DeepCollectionEquality().hash(isFamilyOrAssembly) ^
      const DeepCollectionEquality().hash(isPrivate) ^
      const DeepCollectionEquality().hash(isPublic) ^
      const DeepCollectionEquality().hash(isConstructedGenericMethod) ^
      const DeepCollectionEquality().hash(isGenericMethod) ^
      const DeepCollectionEquality().hash(isGenericMethodDefinition) ^
      const DeepCollectionEquality().hash(containsGenericParameters) ^
      const DeepCollectionEquality().hash(methodHandle) ^
      const DeepCollectionEquality().hash(isSecurityCritical) ^
      const DeepCollectionEquality().hash(isSecuritySafeCritical) ^
      const DeepCollectionEquality().hash(isSecurityTransparent) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(declaringType) ^
      const DeepCollectionEquality().hash(reflectedType) ^
      const DeepCollectionEquality().hash(module) ^
      const DeepCollectionEquality().hash(customAttributes) ^
      const DeepCollectionEquality().hash(isCollectible) ^
      const DeepCollectionEquality().hash(metadataToken) ^
      runtimeType.hashCode;
}

extension $MethodInfoExtension on MethodInfo {
  MethodInfo copyWith(
      {enums.MemberTypes? memberType,
      ParameterInfo? returnParameter,
      String? returnType,
      ICustomAttributeProvider? returnTypeCustomAttributes,
      int? genericParameterCount,
      enums.MethodAttributes? attributes,
      enums.MethodImplAttributes? methodImplementationFlags,
      enums.CallingConventions? callingConvention,
      bool? isAbstract,
      bool? isConstructor,
      bool? isFinal,
      bool? isHideBySig,
      bool? isSpecialName,
      bool? isStatic,
      bool? isVirtual,
      bool? isAssembly,
      bool? isFamily,
      bool? isFamilyAndAssembly,
      bool? isFamilyOrAssembly,
      bool? isPrivate,
      bool? isPublic,
      bool? isConstructedGenericMethod,
      bool? isGenericMethod,
      bool? isGenericMethodDefinition,
      bool? containsGenericParameters,
      RuntimeMethodHandle? methodHandle,
      bool? isSecurityCritical,
      bool? isSecuritySafeCritical,
      bool? isSecurityTransparent,
      String? name,
      String? declaringType,
      String? reflectedType,
      Module? module,
      List<CustomAttributeData>? customAttributes,
      bool? isCollectible,
      int? metadataToken}) {
    return MethodInfo(
        memberType: memberType ?? this.memberType,
        returnParameter: returnParameter ?? this.returnParameter,
        returnType: returnType ?? this.returnType,
        returnTypeCustomAttributes:
            returnTypeCustomAttributes ?? this.returnTypeCustomAttributes,
        genericParameterCount:
            genericParameterCount ?? this.genericParameterCount,
        attributes: attributes ?? this.attributes,
        methodImplementationFlags:
            methodImplementationFlags ?? this.methodImplementationFlags,
        callingConvention: callingConvention ?? this.callingConvention,
        isAbstract: isAbstract ?? this.isAbstract,
        isConstructor: isConstructor ?? this.isConstructor,
        isFinal: isFinal ?? this.isFinal,
        isHideBySig: isHideBySig ?? this.isHideBySig,
        isSpecialName: isSpecialName ?? this.isSpecialName,
        isStatic: isStatic ?? this.isStatic,
        isVirtual: isVirtual ?? this.isVirtual,
        isAssembly: isAssembly ?? this.isAssembly,
        isFamily: isFamily ?? this.isFamily,
        isFamilyAndAssembly: isFamilyAndAssembly ?? this.isFamilyAndAssembly,
        isFamilyOrAssembly: isFamilyOrAssembly ?? this.isFamilyOrAssembly,
        isPrivate: isPrivate ?? this.isPrivate,
        isPublic: isPublic ?? this.isPublic,
        isConstructedGenericMethod:
            isConstructedGenericMethod ?? this.isConstructedGenericMethod,
        isGenericMethod: isGenericMethod ?? this.isGenericMethod,
        isGenericMethodDefinition:
            isGenericMethodDefinition ?? this.isGenericMethodDefinition,
        containsGenericParameters:
            containsGenericParameters ?? this.containsGenericParameters,
        methodHandle: methodHandle ?? this.methodHandle,
        isSecurityCritical: isSecurityCritical ?? this.isSecurityCritical,
        isSecuritySafeCritical:
            isSecuritySafeCritical ?? this.isSecuritySafeCritical,
        isSecurityTransparent:
            isSecurityTransparent ?? this.isSecurityTransparent,
        name: name ?? this.name,
        declaringType: declaringType ?? this.declaringType,
        reflectedType: reflectedType ?? this.reflectedType,
        module: module ?? this.module,
        customAttributes: customAttributes ?? this.customAttributes,
        isCollectible: isCollectible ?? this.isCollectible,
        metadataToken: metadataToken ?? this.metadataToken);
  }

  MethodInfo copyWithWrapped(
      {Wrapped<enums.MemberTypes>? memberType,
      Wrapped<ParameterInfo>? returnParameter,
      Wrapped<String>? returnType,
      Wrapped<ICustomAttributeProvider>? returnTypeCustomAttributes,
      Wrapped<int>? genericParameterCount,
      Wrapped<enums.MethodAttributes>? attributes,
      Wrapped<enums.MethodImplAttributes>? methodImplementationFlags,
      Wrapped<enums.CallingConventions>? callingConvention,
      Wrapped<bool>? isAbstract,
      Wrapped<bool>? isConstructor,
      Wrapped<bool>? isFinal,
      Wrapped<bool>? isHideBySig,
      Wrapped<bool>? isSpecialName,
      Wrapped<bool>? isStatic,
      Wrapped<bool>? isVirtual,
      Wrapped<bool>? isAssembly,
      Wrapped<bool>? isFamily,
      Wrapped<bool>? isFamilyAndAssembly,
      Wrapped<bool>? isFamilyOrAssembly,
      Wrapped<bool>? isPrivate,
      Wrapped<bool>? isPublic,
      Wrapped<bool>? isConstructedGenericMethod,
      Wrapped<bool>? isGenericMethod,
      Wrapped<bool>? isGenericMethodDefinition,
      Wrapped<bool>? containsGenericParameters,
      Wrapped<RuntimeMethodHandle>? methodHandle,
      Wrapped<bool>? isSecurityCritical,
      Wrapped<bool>? isSecuritySafeCritical,
      Wrapped<bool>? isSecurityTransparent,
      Wrapped<String>? name,
      Wrapped<String?>? declaringType,
      Wrapped<String?>? reflectedType,
      Wrapped<Module>? module,
      Wrapped<List<CustomAttributeData>>? customAttributes,
      Wrapped<bool>? isCollectible,
      Wrapped<int>? metadataToken}) {
    return MethodInfo(
        memberType: (memberType != null ? memberType.value : this.memberType),
        returnParameter: (returnParameter != null
            ? returnParameter.value
            : this.returnParameter),
        returnType: (returnType != null ? returnType.value : this.returnType),
        returnTypeCustomAttributes: (returnTypeCustomAttributes != null
            ? returnTypeCustomAttributes.value
            : this.returnTypeCustomAttributes),
        genericParameterCount: (genericParameterCount != null
            ? genericParameterCount.value
            : this.genericParameterCount),
        attributes: (attributes != null ? attributes.value : this.attributes),
        methodImplementationFlags: (methodImplementationFlags != null
            ? methodImplementationFlags.value
            : this.methodImplementationFlags),
        callingConvention: (callingConvention != null
            ? callingConvention.value
            : this.callingConvention),
        isAbstract: (isAbstract != null ? isAbstract.value : this.isAbstract),
        isConstructor:
            (isConstructor != null ? isConstructor.value : this.isConstructor),
        isFinal: (isFinal != null ? isFinal.value : this.isFinal),
        isHideBySig:
            (isHideBySig != null ? isHideBySig.value : this.isHideBySig),
        isSpecialName:
            (isSpecialName != null ? isSpecialName.value : this.isSpecialName),
        isStatic: (isStatic != null ? isStatic.value : this.isStatic),
        isVirtual: (isVirtual != null ? isVirtual.value : this.isVirtual),
        isAssembly: (isAssembly != null ? isAssembly.value : this.isAssembly),
        isFamily: (isFamily != null ? isFamily.value : this.isFamily),
        isFamilyAndAssembly: (isFamilyAndAssembly != null
            ? isFamilyAndAssembly.value
            : this.isFamilyAndAssembly),
        isFamilyOrAssembly: (isFamilyOrAssembly != null
            ? isFamilyOrAssembly.value
            : this.isFamilyOrAssembly),
        isPrivate: (isPrivate != null ? isPrivate.value : this.isPrivate),
        isPublic: (isPublic != null ? isPublic.value : this.isPublic),
        isConstructedGenericMethod: (isConstructedGenericMethod != null
            ? isConstructedGenericMethod.value
            : this.isConstructedGenericMethod),
        isGenericMethod: (isGenericMethod != null
            ? isGenericMethod.value
            : this.isGenericMethod),
        isGenericMethodDefinition: (isGenericMethodDefinition != null
            ? isGenericMethodDefinition.value
            : this.isGenericMethodDefinition),
        containsGenericParameters: (containsGenericParameters != null
            ? containsGenericParameters.value
            : this.containsGenericParameters),
        methodHandle:
            (methodHandle != null ? methodHandle.value : this.methodHandle),
        isSecurityCritical: (isSecurityCritical != null
            ? isSecurityCritical.value
            : this.isSecurityCritical),
        isSecuritySafeCritical: (isSecuritySafeCritical != null
            ? isSecuritySafeCritical.value
            : this.isSecuritySafeCritical),
        isSecurityTransparent: (isSecurityTransparent != null
            ? isSecurityTransparent.value
            : this.isSecurityTransparent),
        name: (name != null ? name.value : this.name),
        declaringType:
            (declaringType != null ? declaringType.value : this.declaringType),
        reflectedType:
            (reflectedType != null ? reflectedType.value : this.reflectedType),
        module: (module != null ? module.value : this.module),
        customAttributes: (customAttributes != null
            ? customAttributes.value
            : this.customAttributes),
        isCollectible:
            (isCollectible != null ? isCollectible.value : this.isCollectible),
        metadataToken:
            (metadataToken != null ? metadataToken.value : this.metadataToken));
  }
}

@JsonSerializable(explicitToJson: true)
class ParameterInfo {
  const ParameterInfo({
    required this.attributes,
    required this.member,
    this.name,
    required this.parameterType,
    required this.position,
    required this.isIn,
    required this.isLcid,
    required this.isOptional,
    required this.isOut,
    required this.isRetval,
    this.defaultValue,
    this.rawDefaultValue,
    required this.hasDefaultValue,
    required this.customAttributes,
    required this.metadataToken,
  });

  factory ParameterInfo.fromJson(Map<String, dynamic> json) =>
      _$ParameterInfoFromJson(json);

  static const toJsonFactory = _$ParameterInfoToJson;
  Map<String, dynamic> toJson() => _$ParameterInfoToJson(this);

  @JsonKey(
    name: 'attributes',
    toJson: parameterAttributesToJson,
    fromJson: parameterAttributesFromJson,
  )
  final enums.ParameterAttributes attributes;
  @JsonKey(name: 'member')
  final MemberInfo member;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'parameterType')
  final String parameterType;
  @JsonKey(name: 'position')
  final int position;
  @JsonKey(name: 'isIn')
  final bool isIn;
  @JsonKey(name: 'isLcid')
  final bool isLcid;
  @JsonKey(name: 'isOptional')
  final bool isOptional;
  @JsonKey(name: 'isOut')
  final bool isOut;
  @JsonKey(name: 'isRetval')
  final bool isRetval;
  @JsonKey(name: 'defaultValue')
  final dynamic defaultValue;
  @JsonKey(name: 'rawDefaultValue')
  final dynamic rawDefaultValue;
  @JsonKey(name: 'hasDefaultValue')
  final bool hasDefaultValue;
  @JsonKey(name: 'customAttributes', defaultValue: <CustomAttributeData>[])
  final List<CustomAttributeData> customAttributes;
  @JsonKey(name: 'metadataToken')
  final int metadataToken;
  static const fromJsonFactory = _$ParameterInfoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ParameterInfo &&
            (identical(other.attributes, attributes) ||
                const DeepCollectionEquality()
                    .equals(other.attributes, attributes)) &&
            (identical(other.member, member) ||
                const DeepCollectionEquality().equals(other.member, member)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.parameterType, parameterType) ||
                const DeepCollectionEquality()
                    .equals(other.parameterType, parameterType)) &&
            (identical(other.position, position) ||
                const DeepCollectionEquality()
                    .equals(other.position, position)) &&
            (identical(other.isIn, isIn) ||
                const DeepCollectionEquality().equals(other.isIn, isIn)) &&
            (identical(other.isLcid, isLcid) ||
                const DeepCollectionEquality().equals(other.isLcid, isLcid)) &&
            (identical(other.isOptional, isOptional) ||
                const DeepCollectionEquality()
                    .equals(other.isOptional, isOptional)) &&
            (identical(other.isOut, isOut) ||
                const DeepCollectionEquality().equals(other.isOut, isOut)) &&
            (identical(other.isRetval, isRetval) ||
                const DeepCollectionEquality()
                    .equals(other.isRetval, isRetval)) &&
            (identical(other.defaultValue, defaultValue) ||
                const DeepCollectionEquality()
                    .equals(other.defaultValue, defaultValue)) &&
            (identical(other.rawDefaultValue, rawDefaultValue) ||
                const DeepCollectionEquality()
                    .equals(other.rawDefaultValue, rawDefaultValue)) &&
            (identical(other.hasDefaultValue, hasDefaultValue) ||
                const DeepCollectionEquality()
                    .equals(other.hasDefaultValue, hasDefaultValue)) &&
            (identical(other.customAttributes, customAttributes) ||
                const DeepCollectionEquality()
                    .equals(other.customAttributes, customAttributes)) &&
            (identical(other.metadataToken, metadataToken) ||
                const DeepCollectionEquality()
                    .equals(other.metadataToken, metadataToken)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(attributes) ^
      const DeepCollectionEquality().hash(member) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(parameterType) ^
      const DeepCollectionEquality().hash(position) ^
      const DeepCollectionEquality().hash(isIn) ^
      const DeepCollectionEquality().hash(isLcid) ^
      const DeepCollectionEquality().hash(isOptional) ^
      const DeepCollectionEquality().hash(isOut) ^
      const DeepCollectionEquality().hash(isRetval) ^
      const DeepCollectionEquality().hash(defaultValue) ^
      const DeepCollectionEquality().hash(rawDefaultValue) ^
      const DeepCollectionEquality().hash(hasDefaultValue) ^
      const DeepCollectionEquality().hash(customAttributes) ^
      const DeepCollectionEquality().hash(metadataToken) ^
      runtimeType.hashCode;
}

extension $ParameterInfoExtension on ParameterInfo {
  ParameterInfo copyWith(
      {enums.ParameterAttributes? attributes,
      MemberInfo? member,
      String? name,
      String? parameterType,
      int? position,
      bool? isIn,
      bool? isLcid,
      bool? isOptional,
      bool? isOut,
      bool? isRetval,
      dynamic defaultValue,
      dynamic rawDefaultValue,
      bool? hasDefaultValue,
      List<CustomAttributeData>? customAttributes,
      int? metadataToken}) {
    return ParameterInfo(
        attributes: attributes ?? this.attributes,
        member: member ?? this.member,
        name: name ?? this.name,
        parameterType: parameterType ?? this.parameterType,
        position: position ?? this.position,
        isIn: isIn ?? this.isIn,
        isLcid: isLcid ?? this.isLcid,
        isOptional: isOptional ?? this.isOptional,
        isOut: isOut ?? this.isOut,
        isRetval: isRetval ?? this.isRetval,
        defaultValue: defaultValue ?? this.defaultValue,
        rawDefaultValue: rawDefaultValue ?? this.rawDefaultValue,
        hasDefaultValue: hasDefaultValue ?? this.hasDefaultValue,
        customAttributes: customAttributes ?? this.customAttributes,
        metadataToken: metadataToken ?? this.metadataToken);
  }

  ParameterInfo copyWithWrapped(
      {Wrapped<enums.ParameterAttributes>? attributes,
      Wrapped<MemberInfo>? member,
      Wrapped<String?>? name,
      Wrapped<String>? parameterType,
      Wrapped<int>? position,
      Wrapped<bool>? isIn,
      Wrapped<bool>? isLcid,
      Wrapped<bool>? isOptional,
      Wrapped<bool>? isOut,
      Wrapped<bool>? isRetval,
      Wrapped<dynamic>? defaultValue,
      Wrapped<dynamic>? rawDefaultValue,
      Wrapped<bool>? hasDefaultValue,
      Wrapped<List<CustomAttributeData>>? customAttributes,
      Wrapped<int>? metadataToken}) {
    return ParameterInfo(
        attributes: (attributes != null ? attributes.value : this.attributes),
        member: (member != null ? member.value : this.member),
        name: (name != null ? name.value : this.name),
        parameterType:
            (parameterType != null ? parameterType.value : this.parameterType),
        position: (position != null ? position.value : this.position),
        isIn: (isIn != null ? isIn.value : this.isIn),
        isLcid: (isLcid != null ? isLcid.value : this.isLcid),
        isOptional: (isOptional != null ? isOptional.value : this.isOptional),
        isOut: (isOut != null ? isOut.value : this.isOut),
        isRetval: (isRetval != null ? isRetval.value : this.isRetval),
        defaultValue:
            (defaultValue != null ? defaultValue.value : this.defaultValue),
        rawDefaultValue: (rawDefaultValue != null
            ? rawDefaultValue.value
            : this.rawDefaultValue),
        hasDefaultValue: (hasDefaultValue != null
            ? hasDefaultValue.value
            : this.hasDefaultValue),
        customAttributes: (customAttributes != null
            ? customAttributes.value
            : this.customAttributes),
        metadataToken:
            (metadataToken != null ? metadataToken.value : this.metadataToken));
  }
}

@JsonSerializable(explicitToJson: true)
class CustomAttributeData {
  const CustomAttributeData({
    required this.attributeType,
    required this.constructor,
    required this.constructorArguments,
    required this.namedArguments,
  });

  factory CustomAttributeData.fromJson(Map<String, dynamic> json) =>
      _$CustomAttributeDataFromJson(json);

  static const toJsonFactory = _$CustomAttributeDataToJson;
  Map<String, dynamic> toJson() => _$CustomAttributeDataToJson(this);

  @JsonKey(name: 'attributeType')
  final String attributeType;
  @JsonKey(name: 'constructor')
  final ConstructorInfo constructor;
  @JsonKey(
      name: 'constructorArguments',
      defaultValue: <CustomAttributeTypedArgument>[])
  final List<CustomAttributeTypedArgument> constructorArguments;
  @JsonKey(
      name: 'namedArguments', defaultValue: <CustomAttributeNamedArgument>[])
  final List<CustomAttributeNamedArgument> namedArguments;
  static const fromJsonFactory = _$CustomAttributeDataFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CustomAttributeData &&
            (identical(other.attributeType, attributeType) ||
                const DeepCollectionEquality()
                    .equals(other.attributeType, attributeType)) &&
            (identical(other.constructor, constructor) ||
                const DeepCollectionEquality()
                    .equals(other.constructor, constructor)) &&
            (identical(other.constructorArguments, constructorArguments) ||
                const DeepCollectionEquality().equals(
                    other.constructorArguments, constructorArguments)) &&
            (identical(other.namedArguments, namedArguments) ||
                const DeepCollectionEquality()
                    .equals(other.namedArguments, namedArguments)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(attributeType) ^
      const DeepCollectionEquality().hash(constructor) ^
      const DeepCollectionEquality().hash(constructorArguments) ^
      const DeepCollectionEquality().hash(namedArguments) ^
      runtimeType.hashCode;
}

extension $CustomAttributeDataExtension on CustomAttributeData {
  CustomAttributeData copyWith(
      {String? attributeType,
      ConstructorInfo? constructor,
      List<CustomAttributeTypedArgument>? constructorArguments,
      List<CustomAttributeNamedArgument>? namedArguments}) {
    return CustomAttributeData(
        attributeType: attributeType ?? this.attributeType,
        constructor: constructor ?? this.constructor,
        constructorArguments: constructorArguments ?? this.constructorArguments,
        namedArguments: namedArguments ?? this.namedArguments);
  }

  CustomAttributeData copyWithWrapped(
      {Wrapped<String>? attributeType,
      Wrapped<ConstructorInfo>? constructor,
      Wrapped<List<CustomAttributeTypedArgument>>? constructorArguments,
      Wrapped<List<CustomAttributeNamedArgument>>? namedArguments}) {
    return CustomAttributeData(
        attributeType:
            (attributeType != null ? attributeType.value : this.attributeType),
        constructor:
            (constructor != null ? constructor.value : this.constructor),
        constructorArguments: (constructorArguments != null
            ? constructorArguments.value
            : this.constructorArguments),
        namedArguments: (namedArguments != null
            ? namedArguments.value
            : this.namedArguments));
  }
}

@JsonSerializable(explicitToJson: true)
class CustomAttributeTypedArgument {
  const CustomAttributeTypedArgument({
    required this.argumentType,
    this.$value,
  });

  factory CustomAttributeTypedArgument.fromJson(Map<String, dynamic> json) =>
      _$CustomAttributeTypedArgumentFromJson(json);

  static const toJsonFactory = _$CustomAttributeTypedArgumentToJson;
  Map<String, dynamic> toJson() => _$CustomAttributeTypedArgumentToJson(this);

  @JsonKey(name: 'argumentType')
  final String argumentType;
  @JsonKey(name: 'value')
  final dynamic $value;
  static const fromJsonFactory = _$CustomAttributeTypedArgumentFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CustomAttributeTypedArgument &&
            (identical(other.argumentType, argumentType) ||
                const DeepCollectionEquality()
                    .equals(other.argumentType, argumentType)) &&
            (identical(other.$value, $value) ||
                const DeepCollectionEquality().equals(other.$value, $value)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(argumentType) ^
      const DeepCollectionEquality().hash($value) ^
      runtimeType.hashCode;
}

extension $CustomAttributeTypedArgumentExtension
    on CustomAttributeTypedArgument {
  CustomAttributeTypedArgument copyWith(
      {String? argumentType, dynamic $value}) {
    return CustomAttributeTypedArgument(
        argumentType: argumentType ?? this.argumentType,
        $value: $value ?? this.$value);
  }

  CustomAttributeTypedArgument copyWithWrapped(
      {Wrapped<String>? argumentType, Wrapped<dynamic>? $value}) {
    return CustomAttributeTypedArgument(
        argumentType:
            (argumentType != null ? argumentType.value : this.argumentType),
        $value: ($value != null ? $value.value : this.$value));
  }
}

@JsonSerializable(explicitToJson: true)
class CustomAttributeNamedArgument {
  const CustomAttributeNamedArgument({
    required this.argumentType,
    required this.memberInfo,
    required this.typedValue,
    required this.memberName,
    required this.isField,
  });

  factory CustomAttributeNamedArgument.fromJson(Map<String, dynamic> json) =>
      _$CustomAttributeNamedArgumentFromJson(json);

  static const toJsonFactory = _$CustomAttributeNamedArgumentToJson;
  Map<String, dynamic> toJson() => _$CustomAttributeNamedArgumentToJson(this);

  @JsonKey(name: 'argumentType')
  final String argumentType;
  @JsonKey(name: 'memberInfo')
  final MemberInfo memberInfo;
  @JsonKey(name: 'typedValue')
  final CustomAttributeTypedArgument typedValue;
  @JsonKey(name: 'memberName')
  final String memberName;
  @JsonKey(name: 'isField')
  final bool isField;
  static const fromJsonFactory = _$CustomAttributeNamedArgumentFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CustomAttributeNamedArgument &&
            (identical(other.argumentType, argumentType) ||
                const DeepCollectionEquality()
                    .equals(other.argumentType, argumentType)) &&
            (identical(other.memberInfo, memberInfo) ||
                const DeepCollectionEquality()
                    .equals(other.memberInfo, memberInfo)) &&
            (identical(other.typedValue, typedValue) ||
                const DeepCollectionEquality()
                    .equals(other.typedValue, typedValue)) &&
            (identical(other.memberName, memberName) ||
                const DeepCollectionEquality()
                    .equals(other.memberName, memberName)) &&
            (identical(other.isField, isField) ||
                const DeepCollectionEquality().equals(other.isField, isField)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(argumentType) ^
      const DeepCollectionEquality().hash(memberInfo) ^
      const DeepCollectionEquality().hash(typedValue) ^
      const DeepCollectionEquality().hash(memberName) ^
      const DeepCollectionEquality().hash(isField) ^
      runtimeType.hashCode;
}

extension $CustomAttributeNamedArgumentExtension
    on CustomAttributeNamedArgument {
  CustomAttributeNamedArgument copyWith(
      {String? argumentType,
      MemberInfo? memberInfo,
      CustomAttributeTypedArgument? typedValue,
      String? memberName,
      bool? isField}) {
    return CustomAttributeNamedArgument(
        argumentType: argumentType ?? this.argumentType,
        memberInfo: memberInfo ?? this.memberInfo,
        typedValue: typedValue ?? this.typedValue,
        memberName: memberName ?? this.memberName,
        isField: isField ?? this.isField);
  }

  CustomAttributeNamedArgument copyWithWrapped(
      {Wrapped<String>? argumentType,
      Wrapped<MemberInfo>? memberInfo,
      Wrapped<CustomAttributeTypedArgument>? typedValue,
      Wrapped<String>? memberName,
      Wrapped<bool>? isField}) {
    return CustomAttributeNamedArgument(
        argumentType:
            (argumentType != null ? argumentType.value : this.argumentType),
        memberInfo: (memberInfo != null ? memberInfo.value : this.memberInfo),
        typedValue: (typedValue != null ? typedValue.value : this.typedValue),
        memberName: (memberName != null ? memberName.value : this.memberName),
        isField: (isField != null ? isField.value : this.isField));
  }
}

@JsonSerializable(explicitToJson: true)
class ICustomAttributeProvider {
  const ICustomAttributeProvider();

  factory ICustomAttributeProvider.fromJson(Map<String, dynamic> json) =>
      _$ICustomAttributeProviderFromJson(json);

  static const toJsonFactory = _$ICustomAttributeProviderToJson;
  Map<String, dynamic> toJson() => _$ICustomAttributeProviderToJson(this);

  static const fromJsonFactory = _$ICustomAttributeProviderFromJson;

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode => runtimeType.hashCode;
}

@JsonSerializable(explicitToJson: true)
class FieldInfo {
  const FieldInfo({
    required this.memberType,
    required this.attributes,
    required this.fieldType,
    required this.isInitOnly,
    required this.isLiteral,
    required this.isNotSerialized,
    required this.isPinvokeImpl,
    required this.isSpecialName,
    required this.isStatic,
    required this.isAssembly,
    required this.isFamily,
    required this.isFamilyAndAssembly,
    required this.isFamilyOrAssembly,
    required this.isPrivate,
    required this.isPublic,
    required this.isSecurityCritical,
    required this.isSecuritySafeCritical,
    required this.isSecurityTransparent,
    required this.fieldHandle,
    required this.name,
    this.declaringType,
    this.reflectedType,
    required this.module,
    required this.customAttributes,
    required this.isCollectible,
    required this.metadataToken,
  });

  factory FieldInfo.fromJson(Map<String, dynamic> json) =>
      _$FieldInfoFromJson(json);

  static const toJsonFactory = _$FieldInfoToJson;
  Map<String, dynamic> toJson() => _$FieldInfoToJson(this);

  @JsonKey(
    name: 'memberType',
    toJson: memberTypesToJson,
    fromJson: memberTypesFromJson,
  )
  final enums.MemberTypes memberType;
  @JsonKey(
    name: 'attributes',
    toJson: fieldAttributesToJson,
    fromJson: fieldAttributesFromJson,
  )
  final enums.FieldAttributes attributes;
  @JsonKey(name: 'fieldType')
  final String fieldType;
  @JsonKey(name: 'isInitOnly')
  final bool isInitOnly;
  @JsonKey(name: 'isLiteral')
  final bool isLiteral;
  @JsonKey(name: 'isNotSerialized')
  final bool isNotSerialized;
  @JsonKey(name: 'isPinvokeImpl')
  final bool isPinvokeImpl;
  @JsonKey(name: 'isSpecialName')
  final bool isSpecialName;
  @JsonKey(name: 'isStatic')
  final bool isStatic;
  @JsonKey(name: 'isAssembly')
  final bool isAssembly;
  @JsonKey(name: 'isFamily')
  final bool isFamily;
  @JsonKey(name: 'isFamilyAndAssembly')
  final bool isFamilyAndAssembly;
  @JsonKey(name: 'isFamilyOrAssembly')
  final bool isFamilyOrAssembly;
  @JsonKey(name: 'isPrivate')
  final bool isPrivate;
  @JsonKey(name: 'isPublic')
  final bool isPublic;
  @JsonKey(name: 'isSecurityCritical')
  final bool isSecurityCritical;
  @JsonKey(name: 'isSecuritySafeCritical')
  final bool isSecuritySafeCritical;
  @JsonKey(name: 'isSecurityTransparent')
  final bool isSecurityTransparent;
  @JsonKey(name: 'fieldHandle')
  final RuntimeFieldHandle fieldHandle;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'declaringType')
  final String? declaringType;
  @JsonKey(name: 'reflectedType')
  final String? reflectedType;
  @JsonKey(name: 'module')
  final Module module;
  @JsonKey(name: 'customAttributes', defaultValue: <CustomAttributeData>[])
  final List<CustomAttributeData> customAttributes;
  @JsonKey(name: 'isCollectible')
  final bool isCollectible;
  @JsonKey(name: 'metadataToken')
  final int metadataToken;
  static const fromJsonFactory = _$FieldInfoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is FieldInfo &&
            (identical(other.memberType, memberType) ||
                const DeepCollectionEquality()
                    .equals(other.memberType, memberType)) &&
            (identical(other.attributes, attributes) ||
                const DeepCollectionEquality()
                    .equals(other.attributes, attributes)) &&
            (identical(other.fieldType, fieldType) ||
                const DeepCollectionEquality()
                    .equals(other.fieldType, fieldType)) &&
            (identical(other.isInitOnly, isInitOnly) ||
                const DeepCollectionEquality()
                    .equals(other.isInitOnly, isInitOnly)) &&
            (identical(other.isLiteral, isLiteral) ||
                const DeepCollectionEquality()
                    .equals(other.isLiteral, isLiteral)) &&
            (identical(other.isNotSerialized, isNotSerialized) ||
                const DeepCollectionEquality()
                    .equals(other.isNotSerialized, isNotSerialized)) &&
            (identical(other.isPinvokeImpl, isPinvokeImpl) ||
                const DeepCollectionEquality()
                    .equals(other.isPinvokeImpl, isPinvokeImpl)) &&
            (identical(other.isSpecialName, isSpecialName) ||
                const DeepCollectionEquality()
                    .equals(other.isSpecialName, isSpecialName)) &&
            (identical(other.isStatic, isStatic) ||
                const DeepCollectionEquality()
                    .equals(other.isStatic, isStatic)) &&
            (identical(other.isAssembly, isAssembly) ||
                const DeepCollectionEquality()
                    .equals(other.isAssembly, isAssembly)) &&
            (identical(other.isFamily, isFamily) ||
                const DeepCollectionEquality()
                    .equals(other.isFamily, isFamily)) &&
            (identical(other.isFamilyAndAssembly, isFamilyAndAssembly) ||
                const DeepCollectionEquality()
                    .equals(other.isFamilyAndAssembly, isFamilyAndAssembly)) &&
            (identical(other.isFamilyOrAssembly, isFamilyOrAssembly) ||
                const DeepCollectionEquality()
                    .equals(other.isFamilyOrAssembly, isFamilyOrAssembly)) &&
            (identical(other.isPrivate, isPrivate) ||
                const DeepCollectionEquality()
                    .equals(other.isPrivate, isPrivate)) &&
            (identical(other.isPublic, isPublic) ||
                const DeepCollectionEquality()
                    .equals(other.isPublic, isPublic)) &&
            (identical(other.isSecurityCritical, isSecurityCritical) ||
                const DeepCollectionEquality()
                    .equals(other.isSecurityCritical, isSecurityCritical)) &&
            (identical(other.isSecuritySafeCritical, isSecuritySafeCritical) ||
                const DeepCollectionEquality().equals(
                    other.isSecuritySafeCritical, isSecuritySafeCritical)) &&
            (identical(other.isSecurityTransparent, isSecurityTransparent) ||
                const DeepCollectionEquality().equals(
                    other.isSecurityTransparent, isSecurityTransparent)) &&
            (identical(other.fieldHandle, fieldHandle) ||
                const DeepCollectionEquality()
                    .equals(other.fieldHandle, fieldHandle)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.declaringType, declaringType) ||
                const DeepCollectionEquality()
                    .equals(other.declaringType, declaringType)) &&
            (identical(other.reflectedType, reflectedType) ||
                const DeepCollectionEquality().equals(other.reflectedType, reflectedType)) &&
            (identical(other.module, module) || const DeepCollectionEquality().equals(other.module, module)) &&
            (identical(other.customAttributes, customAttributes) || const DeepCollectionEquality().equals(other.customAttributes, customAttributes)) &&
            (identical(other.isCollectible, isCollectible) || const DeepCollectionEquality().equals(other.isCollectible, isCollectible)) &&
            (identical(other.metadataToken, metadataToken) || const DeepCollectionEquality().equals(other.metadataToken, metadataToken)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(memberType) ^
      const DeepCollectionEquality().hash(attributes) ^
      const DeepCollectionEquality().hash(fieldType) ^
      const DeepCollectionEquality().hash(isInitOnly) ^
      const DeepCollectionEquality().hash(isLiteral) ^
      const DeepCollectionEquality().hash(isNotSerialized) ^
      const DeepCollectionEquality().hash(isPinvokeImpl) ^
      const DeepCollectionEquality().hash(isSpecialName) ^
      const DeepCollectionEquality().hash(isStatic) ^
      const DeepCollectionEquality().hash(isAssembly) ^
      const DeepCollectionEquality().hash(isFamily) ^
      const DeepCollectionEquality().hash(isFamilyAndAssembly) ^
      const DeepCollectionEquality().hash(isFamilyOrAssembly) ^
      const DeepCollectionEquality().hash(isPrivate) ^
      const DeepCollectionEquality().hash(isPublic) ^
      const DeepCollectionEquality().hash(isSecurityCritical) ^
      const DeepCollectionEquality().hash(isSecuritySafeCritical) ^
      const DeepCollectionEquality().hash(isSecurityTransparent) ^
      const DeepCollectionEquality().hash(fieldHandle) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(declaringType) ^
      const DeepCollectionEquality().hash(reflectedType) ^
      const DeepCollectionEquality().hash(module) ^
      const DeepCollectionEquality().hash(customAttributes) ^
      const DeepCollectionEquality().hash(isCollectible) ^
      const DeepCollectionEquality().hash(metadataToken) ^
      runtimeType.hashCode;
}

extension $FieldInfoExtension on FieldInfo {
  FieldInfo copyWith(
      {enums.MemberTypes? memberType,
      enums.FieldAttributes? attributes,
      String? fieldType,
      bool? isInitOnly,
      bool? isLiteral,
      bool? isNotSerialized,
      bool? isPinvokeImpl,
      bool? isSpecialName,
      bool? isStatic,
      bool? isAssembly,
      bool? isFamily,
      bool? isFamilyAndAssembly,
      bool? isFamilyOrAssembly,
      bool? isPrivate,
      bool? isPublic,
      bool? isSecurityCritical,
      bool? isSecuritySafeCritical,
      bool? isSecurityTransparent,
      RuntimeFieldHandle? fieldHandle,
      String? name,
      String? declaringType,
      String? reflectedType,
      Module? module,
      List<CustomAttributeData>? customAttributes,
      bool? isCollectible,
      int? metadataToken}) {
    return FieldInfo(
        memberType: memberType ?? this.memberType,
        attributes: attributes ?? this.attributes,
        fieldType: fieldType ?? this.fieldType,
        isInitOnly: isInitOnly ?? this.isInitOnly,
        isLiteral: isLiteral ?? this.isLiteral,
        isNotSerialized: isNotSerialized ?? this.isNotSerialized,
        isPinvokeImpl: isPinvokeImpl ?? this.isPinvokeImpl,
        isSpecialName: isSpecialName ?? this.isSpecialName,
        isStatic: isStatic ?? this.isStatic,
        isAssembly: isAssembly ?? this.isAssembly,
        isFamily: isFamily ?? this.isFamily,
        isFamilyAndAssembly: isFamilyAndAssembly ?? this.isFamilyAndAssembly,
        isFamilyOrAssembly: isFamilyOrAssembly ?? this.isFamilyOrAssembly,
        isPrivate: isPrivate ?? this.isPrivate,
        isPublic: isPublic ?? this.isPublic,
        isSecurityCritical: isSecurityCritical ?? this.isSecurityCritical,
        isSecuritySafeCritical:
            isSecuritySafeCritical ?? this.isSecuritySafeCritical,
        isSecurityTransparent:
            isSecurityTransparent ?? this.isSecurityTransparent,
        fieldHandle: fieldHandle ?? this.fieldHandle,
        name: name ?? this.name,
        declaringType: declaringType ?? this.declaringType,
        reflectedType: reflectedType ?? this.reflectedType,
        module: module ?? this.module,
        customAttributes: customAttributes ?? this.customAttributes,
        isCollectible: isCollectible ?? this.isCollectible,
        metadataToken: metadataToken ?? this.metadataToken);
  }

  FieldInfo copyWithWrapped(
      {Wrapped<enums.MemberTypes>? memberType,
      Wrapped<enums.FieldAttributes>? attributes,
      Wrapped<String>? fieldType,
      Wrapped<bool>? isInitOnly,
      Wrapped<bool>? isLiteral,
      Wrapped<bool>? isNotSerialized,
      Wrapped<bool>? isPinvokeImpl,
      Wrapped<bool>? isSpecialName,
      Wrapped<bool>? isStatic,
      Wrapped<bool>? isAssembly,
      Wrapped<bool>? isFamily,
      Wrapped<bool>? isFamilyAndAssembly,
      Wrapped<bool>? isFamilyOrAssembly,
      Wrapped<bool>? isPrivate,
      Wrapped<bool>? isPublic,
      Wrapped<bool>? isSecurityCritical,
      Wrapped<bool>? isSecuritySafeCritical,
      Wrapped<bool>? isSecurityTransparent,
      Wrapped<RuntimeFieldHandle>? fieldHandle,
      Wrapped<String>? name,
      Wrapped<String?>? declaringType,
      Wrapped<String?>? reflectedType,
      Wrapped<Module>? module,
      Wrapped<List<CustomAttributeData>>? customAttributes,
      Wrapped<bool>? isCollectible,
      Wrapped<int>? metadataToken}) {
    return FieldInfo(
        memberType: (memberType != null ? memberType.value : this.memberType),
        attributes: (attributes != null ? attributes.value : this.attributes),
        fieldType: (fieldType != null ? fieldType.value : this.fieldType),
        isInitOnly: (isInitOnly != null ? isInitOnly.value : this.isInitOnly),
        isLiteral: (isLiteral != null ? isLiteral.value : this.isLiteral),
        isNotSerialized: (isNotSerialized != null
            ? isNotSerialized.value
            : this.isNotSerialized),
        isPinvokeImpl:
            (isPinvokeImpl != null ? isPinvokeImpl.value : this.isPinvokeImpl),
        isSpecialName:
            (isSpecialName != null ? isSpecialName.value : this.isSpecialName),
        isStatic: (isStatic != null ? isStatic.value : this.isStatic),
        isAssembly: (isAssembly != null ? isAssembly.value : this.isAssembly),
        isFamily: (isFamily != null ? isFamily.value : this.isFamily),
        isFamilyAndAssembly: (isFamilyAndAssembly != null
            ? isFamilyAndAssembly.value
            : this.isFamilyAndAssembly),
        isFamilyOrAssembly: (isFamilyOrAssembly != null
            ? isFamilyOrAssembly.value
            : this.isFamilyOrAssembly),
        isPrivate: (isPrivate != null ? isPrivate.value : this.isPrivate),
        isPublic: (isPublic != null ? isPublic.value : this.isPublic),
        isSecurityCritical: (isSecurityCritical != null
            ? isSecurityCritical.value
            : this.isSecurityCritical),
        isSecuritySafeCritical: (isSecuritySafeCritical != null
            ? isSecuritySafeCritical.value
            : this.isSecuritySafeCritical),
        isSecurityTransparent: (isSecurityTransparent != null
            ? isSecurityTransparent.value
            : this.isSecurityTransparent),
        fieldHandle:
            (fieldHandle != null ? fieldHandle.value : this.fieldHandle),
        name: (name != null ? name.value : this.name),
        declaringType:
            (declaringType != null ? declaringType.value : this.declaringType),
        reflectedType:
            (reflectedType != null ? reflectedType.value : this.reflectedType),
        module: (module != null ? module.value : this.module),
        customAttributes: (customAttributes != null
            ? customAttributes.value
            : this.customAttributes),
        isCollectible:
            (isCollectible != null ? isCollectible.value : this.isCollectible),
        metadataToken:
            (metadataToken != null ? metadataToken.value : this.metadataToken));
  }
}

@JsonSerializable(explicitToJson: true)
class RuntimeFieldHandle {
  const RuntimeFieldHandle({
    required this.$value,
  });

  factory RuntimeFieldHandle.fromJson(Map<String, dynamic> json) =>
      _$RuntimeFieldHandleFromJson(json);

  static const toJsonFactory = _$RuntimeFieldHandleToJson;
  Map<String, dynamic> toJson() => _$RuntimeFieldHandleToJson(this);

  @JsonKey(name: 'value')
  final IntPtr $value;
  static const fromJsonFactory = _$RuntimeFieldHandleFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RuntimeFieldHandle &&
            (identical(other.$value, $value) ||
                const DeepCollectionEquality().equals(other.$value, $value)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash($value) ^ runtimeType.hashCode;
}

extension $RuntimeFieldHandleExtension on RuntimeFieldHandle {
  RuntimeFieldHandle copyWith({IntPtr? $value}) {
    return RuntimeFieldHandle($value: $value ?? this.$value);
  }

  RuntimeFieldHandle copyWithWrapped({Wrapped<IntPtr>? $value}) {
    return RuntimeFieldHandle(
        $value: ($value != null ? $value.value : this.$value));
  }
}

@JsonSerializable(explicitToJson: true)
class PropertyInfo {
  const PropertyInfo({
    required this.memberType,
    required this.propertyType,
    required this.attributes,
    required this.isSpecialName,
    required this.canRead,
    required this.canWrite,
    this.getMethod,
    this.setMethod,
    required this.name,
    this.declaringType,
    this.reflectedType,
    required this.module,
    required this.customAttributes,
    required this.isCollectible,
    required this.metadataToken,
  });

  factory PropertyInfo.fromJson(Map<String, dynamic> json) =>
      _$PropertyInfoFromJson(json);

  static const toJsonFactory = _$PropertyInfoToJson;
  Map<String, dynamic> toJson() => _$PropertyInfoToJson(this);

  @JsonKey(
    name: 'memberType',
    toJson: memberTypesToJson,
    fromJson: memberTypesFromJson,
  )
  final enums.MemberTypes memberType;
  @JsonKey(name: 'propertyType')
  final String propertyType;
  @JsonKey(
    name: 'attributes',
    toJson: propertyAttributesToJson,
    fromJson: propertyAttributesFromJson,
  )
  final enums.PropertyAttributes attributes;
  @JsonKey(name: 'isSpecialName')
  final bool isSpecialName;
  @JsonKey(name: 'canRead')
  final bool canRead;
  @JsonKey(name: 'canWrite')
  final bool canWrite;
  @JsonKey(name: 'getMethod')
  final MethodInfo? getMethod;
  @JsonKey(name: 'setMethod')
  final MethodInfo? setMethod;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'declaringType')
  final String? declaringType;
  @JsonKey(name: 'reflectedType')
  final String? reflectedType;
  @JsonKey(name: 'module')
  final Module module;
  @JsonKey(name: 'customAttributes', defaultValue: <CustomAttributeData>[])
  final List<CustomAttributeData> customAttributes;
  @JsonKey(name: 'isCollectible')
  final bool isCollectible;
  @JsonKey(name: 'metadataToken')
  final int metadataToken;
  static const fromJsonFactory = _$PropertyInfoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PropertyInfo &&
            (identical(other.memberType, memberType) ||
                const DeepCollectionEquality()
                    .equals(other.memberType, memberType)) &&
            (identical(other.propertyType, propertyType) ||
                const DeepCollectionEquality()
                    .equals(other.propertyType, propertyType)) &&
            (identical(other.attributes, attributes) ||
                const DeepCollectionEquality()
                    .equals(other.attributes, attributes)) &&
            (identical(other.isSpecialName, isSpecialName) ||
                const DeepCollectionEquality()
                    .equals(other.isSpecialName, isSpecialName)) &&
            (identical(other.canRead, canRead) ||
                const DeepCollectionEquality()
                    .equals(other.canRead, canRead)) &&
            (identical(other.canWrite, canWrite) ||
                const DeepCollectionEquality()
                    .equals(other.canWrite, canWrite)) &&
            (identical(other.getMethod, getMethod) ||
                const DeepCollectionEquality()
                    .equals(other.getMethod, getMethod)) &&
            (identical(other.setMethod, setMethod) ||
                const DeepCollectionEquality()
                    .equals(other.setMethod, setMethod)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.declaringType, declaringType) ||
                const DeepCollectionEquality()
                    .equals(other.declaringType, declaringType)) &&
            (identical(other.reflectedType, reflectedType) ||
                const DeepCollectionEquality()
                    .equals(other.reflectedType, reflectedType)) &&
            (identical(other.module, module) ||
                const DeepCollectionEquality().equals(other.module, module)) &&
            (identical(other.customAttributes, customAttributes) ||
                const DeepCollectionEquality()
                    .equals(other.customAttributes, customAttributes)) &&
            (identical(other.isCollectible, isCollectible) ||
                const DeepCollectionEquality()
                    .equals(other.isCollectible, isCollectible)) &&
            (identical(other.metadataToken, metadataToken) ||
                const DeepCollectionEquality()
                    .equals(other.metadataToken, metadataToken)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(memberType) ^
      const DeepCollectionEquality().hash(propertyType) ^
      const DeepCollectionEquality().hash(attributes) ^
      const DeepCollectionEquality().hash(isSpecialName) ^
      const DeepCollectionEquality().hash(canRead) ^
      const DeepCollectionEquality().hash(canWrite) ^
      const DeepCollectionEquality().hash(getMethod) ^
      const DeepCollectionEquality().hash(setMethod) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(declaringType) ^
      const DeepCollectionEquality().hash(reflectedType) ^
      const DeepCollectionEquality().hash(module) ^
      const DeepCollectionEquality().hash(customAttributes) ^
      const DeepCollectionEquality().hash(isCollectible) ^
      const DeepCollectionEquality().hash(metadataToken) ^
      runtimeType.hashCode;
}

extension $PropertyInfoExtension on PropertyInfo {
  PropertyInfo copyWith(
      {enums.MemberTypes? memberType,
      String? propertyType,
      enums.PropertyAttributes? attributes,
      bool? isSpecialName,
      bool? canRead,
      bool? canWrite,
      MethodInfo? getMethod,
      MethodInfo? setMethod,
      String? name,
      String? declaringType,
      String? reflectedType,
      Module? module,
      List<CustomAttributeData>? customAttributes,
      bool? isCollectible,
      int? metadataToken}) {
    return PropertyInfo(
        memberType: memberType ?? this.memberType,
        propertyType: propertyType ?? this.propertyType,
        attributes: attributes ?? this.attributes,
        isSpecialName: isSpecialName ?? this.isSpecialName,
        canRead: canRead ?? this.canRead,
        canWrite: canWrite ?? this.canWrite,
        getMethod: getMethod ?? this.getMethod,
        setMethod: setMethod ?? this.setMethod,
        name: name ?? this.name,
        declaringType: declaringType ?? this.declaringType,
        reflectedType: reflectedType ?? this.reflectedType,
        module: module ?? this.module,
        customAttributes: customAttributes ?? this.customAttributes,
        isCollectible: isCollectible ?? this.isCollectible,
        metadataToken: metadataToken ?? this.metadataToken);
  }

  PropertyInfo copyWithWrapped(
      {Wrapped<enums.MemberTypes>? memberType,
      Wrapped<String>? propertyType,
      Wrapped<enums.PropertyAttributes>? attributes,
      Wrapped<bool>? isSpecialName,
      Wrapped<bool>? canRead,
      Wrapped<bool>? canWrite,
      Wrapped<MethodInfo?>? getMethod,
      Wrapped<MethodInfo?>? setMethod,
      Wrapped<String>? name,
      Wrapped<String?>? declaringType,
      Wrapped<String?>? reflectedType,
      Wrapped<Module>? module,
      Wrapped<List<CustomAttributeData>>? customAttributes,
      Wrapped<bool>? isCollectible,
      Wrapped<int>? metadataToken}) {
    return PropertyInfo(
        memberType: (memberType != null ? memberType.value : this.memberType),
        propertyType:
            (propertyType != null ? propertyType.value : this.propertyType),
        attributes: (attributes != null ? attributes.value : this.attributes),
        isSpecialName:
            (isSpecialName != null ? isSpecialName.value : this.isSpecialName),
        canRead: (canRead != null ? canRead.value : this.canRead),
        canWrite: (canWrite != null ? canWrite.value : this.canWrite),
        getMethod: (getMethod != null ? getMethod.value : this.getMethod),
        setMethod: (setMethod != null ? setMethod.value : this.setMethod),
        name: (name != null ? name.value : this.name),
        declaringType:
            (declaringType != null ? declaringType.value : this.declaringType),
        reflectedType:
            (reflectedType != null ? reflectedType.value : this.reflectedType),
        module: (module != null ? module.value : this.module),
        customAttributes: (customAttributes != null
            ? customAttributes.value
            : this.customAttributes),
        isCollectible:
            (isCollectible != null ? isCollectible.value : this.isCollectible),
        metadataToken:
            (metadataToken != null ? metadataToken.value : this.metadataToken));
  }
}

@JsonSerializable(explicitToJson: true)
class ModuleHandle {
  const ModuleHandle({
    required this.mdStreamVersion,
  });

  factory ModuleHandle.fromJson(Map<String, dynamic> json) =>
      _$ModuleHandleFromJson(json);

  static const toJsonFactory = _$ModuleHandleToJson;
  Map<String, dynamic> toJson() => _$ModuleHandleToJson(this);

  @JsonKey(name: 'mdStreamVersion')
  final int mdStreamVersion;
  static const fromJsonFactory = _$ModuleHandleFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ModuleHandle &&
            (identical(other.mdStreamVersion, mdStreamVersion) ||
                const DeepCollectionEquality()
                    .equals(other.mdStreamVersion, mdStreamVersion)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(mdStreamVersion) ^
      runtimeType.hashCode;
}

extension $ModuleHandleExtension on ModuleHandle {
  ModuleHandle copyWith({int? mdStreamVersion}) {
    return ModuleHandle(
        mdStreamVersion: mdStreamVersion ?? this.mdStreamVersion);
  }

  ModuleHandle copyWithWrapped({Wrapped<int>? mdStreamVersion}) {
    return ModuleHandle(
        mdStreamVersion: (mdStreamVersion != null
            ? mdStreamVersion.value
            : this.mdStreamVersion));
  }
}

@JsonSerializable(explicitToJson: true)
class LoggingRule {
  const LoggingRule({
    this.ruleName,
    this.targets,
    this.childRules,
    this.filters,
    required this.$final,
    this.finalMinLevel,
    this.loggerNamePattern,
    this.logLevels,
    this.levels,
    required this.defaultFilterResult,
    required this.filterDefaultAction,
  });

  factory LoggingRule.fromJson(Map<String, dynamic> json) =>
      _$LoggingRuleFromJson(json);

  static const toJsonFactory = _$LoggingRuleToJson;
  Map<String, dynamic> toJson() => _$LoggingRuleToJson(this);

  @JsonKey(name: 'ruleName')
  final String? ruleName;
  @JsonKey(name: 'targets', defaultValue: <Target>[])
  final List<Target>? targets;
  @JsonKey(name: 'childRules', defaultValue: <LoggingRule>[])
  final List<LoggingRule>? childRules;
  @JsonKey(name: 'filters', defaultValue: <Filter>[])
  final List<Filter>? filters;
  @JsonKey(name: 'final')
  final bool $final;
  @JsonKey(name: 'finalMinLevel')
  final LogLevel? finalMinLevel;
  @JsonKey(name: 'loggerNamePattern')
  final String? loggerNamePattern;
  @JsonKey(name: 'logLevels', defaultValue: <bool>[])
  final List<bool>? logLevels;
  @JsonKey(name: 'levels', defaultValue: <LogLevel>[])
  final List<LogLevel>? levels;
  @JsonKey(
    name: 'defaultFilterResult',
    toJson: filterResultToJson,
    fromJson: filterResultFromJson,
  )
  final enums.FilterResult defaultFilterResult;
  @JsonKey(
    name: 'filterDefaultAction',
    toJson: filterResultToJson,
    fromJson: filterResultFromJson,
  )
  final enums.FilterResult filterDefaultAction;
  static const fromJsonFactory = _$LoggingRuleFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LoggingRule &&
            (identical(other.ruleName, ruleName) ||
                const DeepCollectionEquality()
                    .equals(other.ruleName, ruleName)) &&
            (identical(other.targets, targets) ||
                const DeepCollectionEquality()
                    .equals(other.targets, targets)) &&
            (identical(other.childRules, childRules) ||
                const DeepCollectionEquality()
                    .equals(other.childRules, childRules)) &&
            (identical(other.filters, filters) ||
                const DeepCollectionEquality()
                    .equals(other.filters, filters)) &&
            (identical(other.$final, $final) ||
                const DeepCollectionEquality().equals(other.$final, $final)) &&
            (identical(other.finalMinLevel, finalMinLevel) ||
                const DeepCollectionEquality()
                    .equals(other.finalMinLevel, finalMinLevel)) &&
            (identical(other.loggerNamePattern, loggerNamePattern) ||
                const DeepCollectionEquality()
                    .equals(other.loggerNamePattern, loggerNamePattern)) &&
            (identical(other.logLevels, logLevels) ||
                const DeepCollectionEquality()
                    .equals(other.logLevels, logLevels)) &&
            (identical(other.levels, levels) ||
                const DeepCollectionEquality().equals(other.levels, levels)) &&
            (identical(other.defaultFilterResult, defaultFilterResult) ||
                const DeepCollectionEquality()
                    .equals(other.defaultFilterResult, defaultFilterResult)) &&
            (identical(other.filterDefaultAction, filterDefaultAction) ||
                const DeepCollectionEquality()
                    .equals(other.filterDefaultAction, filterDefaultAction)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(ruleName) ^
      const DeepCollectionEquality().hash(targets) ^
      const DeepCollectionEquality().hash(childRules) ^
      const DeepCollectionEquality().hash(filters) ^
      const DeepCollectionEquality().hash($final) ^
      const DeepCollectionEquality().hash(finalMinLevel) ^
      const DeepCollectionEquality().hash(loggerNamePattern) ^
      const DeepCollectionEquality().hash(logLevels) ^
      const DeepCollectionEquality().hash(levels) ^
      const DeepCollectionEquality().hash(defaultFilterResult) ^
      const DeepCollectionEquality().hash(filterDefaultAction) ^
      runtimeType.hashCode;
}

extension $LoggingRuleExtension on LoggingRule {
  LoggingRule copyWith(
      {String? ruleName,
      List<Target>? targets,
      List<LoggingRule>? childRules,
      List<Filter>? filters,
      bool? $final,
      LogLevel? finalMinLevel,
      String? loggerNamePattern,
      List<bool>? logLevels,
      List<LogLevel>? levels,
      enums.FilterResult? defaultFilterResult,
      enums.FilterResult? filterDefaultAction}) {
    return LoggingRule(
        ruleName: ruleName ?? this.ruleName,
        targets: targets ?? this.targets,
        childRules: childRules ?? this.childRules,
        filters: filters ?? this.filters,
        $final: $final ?? this.$final,
        finalMinLevel: finalMinLevel ?? this.finalMinLevel,
        loggerNamePattern: loggerNamePattern ?? this.loggerNamePattern,
        logLevels: logLevels ?? this.logLevels,
        levels: levels ?? this.levels,
        defaultFilterResult: defaultFilterResult ?? this.defaultFilterResult,
        filterDefaultAction: filterDefaultAction ?? this.filterDefaultAction);
  }

  LoggingRule copyWithWrapped(
      {Wrapped<String?>? ruleName,
      Wrapped<List<Target>?>? targets,
      Wrapped<List<LoggingRule>?>? childRules,
      Wrapped<List<Filter>?>? filters,
      Wrapped<bool>? $final,
      Wrapped<LogLevel?>? finalMinLevel,
      Wrapped<String?>? loggerNamePattern,
      Wrapped<List<bool>?>? logLevels,
      Wrapped<List<LogLevel>?>? levels,
      Wrapped<enums.FilterResult>? defaultFilterResult,
      Wrapped<enums.FilterResult>? filterDefaultAction}) {
    return LoggingRule(
        ruleName: (ruleName != null ? ruleName.value : this.ruleName),
        targets: (targets != null ? targets.value : this.targets),
        childRules: (childRules != null ? childRules.value : this.childRules),
        filters: (filters != null ? filters.value : this.filters),
        $final: ($final != null ? $final.value : this.$final),
        finalMinLevel:
            (finalMinLevel != null ? finalMinLevel.value : this.finalMinLevel),
        loggerNamePattern: (loggerNamePattern != null
            ? loggerNamePattern.value
            : this.loggerNamePattern),
        logLevels: (logLevels != null ? logLevels.value : this.logLevels),
        levels: (levels != null ? levels.value : this.levels),
        defaultFilterResult: (defaultFilterResult != null
            ? defaultFilterResult.value
            : this.defaultFilterResult),
        filterDefaultAction: (filterDefaultAction != null
            ? filterDefaultAction.value
            : this.filterDefaultAction));
  }
}

@JsonSerializable(explicitToJson: true)
class Filter {
  const Filter({
    required this.action,
  });

  factory Filter.fromJson(Map<String, dynamic> json) => _$FilterFromJson(json);

  static const toJsonFactory = _$FilterToJson;
  Map<String, dynamic> toJson() => _$FilterToJson(this);

  @JsonKey(
    name: 'action',
    toJson: filterResultToJson,
    fromJson: filterResultFromJson,
  )
  final enums.FilterResult action;
  static const fromJsonFactory = _$FilterFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Filter &&
            (identical(other.action, action) ||
                const DeepCollectionEquality().equals(other.action, action)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(action) ^ runtimeType.hashCode;
}

extension $FilterExtension on Filter {
  Filter copyWith({enums.FilterResult? action}) {
    return Filter(action: action ?? this.action);
  }

  Filter copyWithWrapped({Wrapped<enums.FilterResult>? action}) {
    return Filter(action: (action != null ? action.value : this.action));
  }
}

@JsonSerializable(explicitToJson: true)
class LogLevel {
  const LogLevel({
    this.name,
    required this.ordinal,
  });

  factory LogLevel.fromJson(Map<String, dynamic> json) =>
      _$LogLevelFromJson(json);

  static const toJsonFactory = _$LogLevelToJson;
  Map<String, dynamic> toJson() => _$LogLevelToJson(this);

  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'ordinal')
  final int ordinal;
  static const fromJsonFactory = _$LogLevelFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LogLevel &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.ordinal, ordinal) ||
                const DeepCollectionEquality().equals(other.ordinal, ordinal)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(ordinal) ^
      runtimeType.hashCode;
}

extension $LogLevelExtension on LogLevel {
  LogLevel copyWith({String? name, int? ordinal}) {
    return LogLevel(name: name ?? this.name, ordinal: ordinal ?? this.ordinal);
  }

  LogLevel copyWithWrapped({Wrapped<String?>? name, Wrapped<int>? ordinal}) {
    return LogLevel(
        name: (name != null ? name.value : this.name),
        ordinal: (ordinal != null ? ordinal.value : this.ordinal));
  }
}

@JsonSerializable(explicitToJson: true)
class CultureInfo {
  const CultureInfo({
    required this.parent,
    required this.lcid,
    required this.keyboardLayoutId,
    required this.name,
    required this.sortName,
    this.interopName,
    required this.ietfLanguageTag,
    required this.displayName,
    required this.nativeName,
    required this.englishName,
    required this.twoLetterISOLanguageName,
    required this.threeLetterISOLanguageName,
    required this.threeLetterWindowsLanguageName,
    required this.compareInfo,
    required this.textInfo,
    required this.isNeutralCulture,
    required this.cultureTypes,
    required this.numberFormat,
    required this.dateTimeFormat,
    required this.calendar,
    required this.optionalCalendars,
    required this.useUserOverride,
    required this.isReadOnly,
    required this.hasInvariantCultureName,
  });

  factory CultureInfo.fromJson(Map<String, dynamic> json) =>
      _$CultureInfoFromJson(json);

  static const toJsonFactory = _$CultureInfoToJson;
  Map<String, dynamic> toJson() => _$CultureInfoToJson(this);

  @JsonKey(name: 'parent')
  final CultureInfo parent;
  @JsonKey(name: 'lcid')
  final int lcid;
  @JsonKey(name: 'keyboardLayoutId')
  final int keyboardLayoutId;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'sortName')
  final String sortName;
  @JsonKey(name: 'interopName')
  final String? interopName;
  @JsonKey(name: 'ietfLanguageTag')
  final String ietfLanguageTag;
  @JsonKey(name: 'displayName')
  final String displayName;
  @JsonKey(name: 'nativeName')
  final String nativeName;
  @JsonKey(name: 'englishName')
  final String englishName;
  @JsonKey(name: 'twoLetterISOLanguageName')
  final String twoLetterISOLanguageName;
  @JsonKey(name: 'threeLetterISOLanguageName')
  final String threeLetterISOLanguageName;
  @JsonKey(name: 'threeLetterWindowsLanguageName')
  final String threeLetterWindowsLanguageName;
  @JsonKey(name: 'compareInfo')
  final CompareInfo compareInfo;
  @JsonKey(name: 'textInfo')
  final TextInfo textInfo;
  @JsonKey(name: 'isNeutralCulture')
  final bool isNeutralCulture;
  @JsonKey(
    name: 'cultureTypes',
    toJson: cultureTypesToJson,
    fromJson: cultureTypesFromJson,
  )
  final enums.CultureTypes cultureTypes;
  @JsonKey(name: 'numberFormat')
  final NumberFormatInfo numberFormat;
  @JsonKey(name: 'dateTimeFormat')
  final DateTimeFormatInfo dateTimeFormat;
  @JsonKey(name: 'calendar')
  final Calendar calendar;
  @JsonKey(name: 'optionalCalendars', defaultValue: <Calendar>[])
  final List<Calendar> optionalCalendars;
  @JsonKey(name: 'useUserOverride')
  final bool useUserOverride;
  @JsonKey(name: 'isReadOnly')
  final bool isReadOnly;
  @JsonKey(name: 'hasInvariantCultureName')
  final bool hasInvariantCultureName;
  static const fromJsonFactory = _$CultureInfoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CultureInfo &&
            (identical(other.parent, parent) ||
                const DeepCollectionEquality().equals(other.parent, parent)) &&
            (identical(other.lcid, lcid) ||
                const DeepCollectionEquality().equals(other.lcid, lcid)) &&
            (identical(other.keyboardLayoutId, keyboardLayoutId) ||
                const DeepCollectionEquality()
                    .equals(other.keyboardLayoutId, keyboardLayoutId)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.sortName, sortName) ||
                const DeepCollectionEquality()
                    .equals(other.sortName, sortName)) &&
            (identical(other.interopName, interopName) ||
                const DeepCollectionEquality()
                    .equals(other.interopName, interopName)) &&
            (identical(other.ietfLanguageTag, ietfLanguageTag) ||
                const DeepCollectionEquality()
                    .equals(other.ietfLanguageTag, ietfLanguageTag)) &&
            (identical(other.displayName, displayName) ||
                const DeepCollectionEquality()
                    .equals(other.displayName, displayName)) &&
            (identical(other.nativeName, nativeName) ||
                const DeepCollectionEquality()
                    .equals(other.nativeName, nativeName)) &&
            (identical(other.englishName, englishName) ||
                const DeepCollectionEquality()
                    .equals(other.englishName, englishName)) &&
            (identical(other.twoLetterISOLanguageName, twoLetterISOLanguageName) ||
                const DeepCollectionEquality().equals(
                    other.twoLetterISOLanguageName,
                    twoLetterISOLanguageName)) &&
            (identical(other.threeLetterISOLanguageName, threeLetterISOLanguageName) ||
                const DeepCollectionEquality().equals(
                    other.threeLetterISOLanguageName,
                    threeLetterISOLanguageName)) &&
            (identical(other.threeLetterWindowsLanguageName, threeLetterWindowsLanguageName) ||
                const DeepCollectionEquality().equals(
                    other.threeLetterWindowsLanguageName,
                    threeLetterWindowsLanguageName)) &&
            (identical(other.compareInfo, compareInfo) ||
                const DeepCollectionEquality()
                    .equals(other.compareInfo, compareInfo)) &&
            (identical(other.textInfo, textInfo) ||
                const DeepCollectionEquality()
                    .equals(other.textInfo, textInfo)) &&
            (identical(other.isNeutralCulture, isNeutralCulture) ||
                const DeepCollectionEquality()
                    .equals(other.isNeutralCulture, isNeutralCulture)) &&
            (identical(other.cultureTypes, cultureTypes) ||
                const DeepCollectionEquality()
                    .equals(other.cultureTypes, cultureTypes)) &&
            (identical(other.numberFormat, numberFormat) ||
                const DeepCollectionEquality().equals(other.numberFormat, numberFormat)) &&
            (identical(other.dateTimeFormat, dateTimeFormat) || const DeepCollectionEquality().equals(other.dateTimeFormat, dateTimeFormat)) &&
            (identical(other.calendar, calendar) || const DeepCollectionEquality().equals(other.calendar, calendar)) &&
            (identical(other.optionalCalendars, optionalCalendars) || const DeepCollectionEquality().equals(other.optionalCalendars, optionalCalendars)) &&
            (identical(other.useUserOverride, useUserOverride) || const DeepCollectionEquality().equals(other.useUserOverride, useUserOverride)) &&
            (identical(other.isReadOnly, isReadOnly) || const DeepCollectionEquality().equals(other.isReadOnly, isReadOnly)) &&
            (identical(other.hasInvariantCultureName, hasInvariantCultureName) || const DeepCollectionEquality().equals(other.hasInvariantCultureName, hasInvariantCultureName)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(parent) ^
      const DeepCollectionEquality().hash(lcid) ^
      const DeepCollectionEquality().hash(keyboardLayoutId) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(sortName) ^
      const DeepCollectionEquality().hash(interopName) ^
      const DeepCollectionEquality().hash(ietfLanguageTag) ^
      const DeepCollectionEquality().hash(displayName) ^
      const DeepCollectionEquality().hash(nativeName) ^
      const DeepCollectionEquality().hash(englishName) ^
      const DeepCollectionEquality().hash(twoLetterISOLanguageName) ^
      const DeepCollectionEquality().hash(threeLetterISOLanguageName) ^
      const DeepCollectionEquality().hash(threeLetterWindowsLanguageName) ^
      const DeepCollectionEquality().hash(compareInfo) ^
      const DeepCollectionEquality().hash(textInfo) ^
      const DeepCollectionEquality().hash(isNeutralCulture) ^
      const DeepCollectionEquality().hash(cultureTypes) ^
      const DeepCollectionEquality().hash(numberFormat) ^
      const DeepCollectionEquality().hash(dateTimeFormat) ^
      const DeepCollectionEquality().hash(calendar) ^
      const DeepCollectionEquality().hash(optionalCalendars) ^
      const DeepCollectionEquality().hash(useUserOverride) ^
      const DeepCollectionEquality().hash(isReadOnly) ^
      const DeepCollectionEquality().hash(hasInvariantCultureName) ^
      runtimeType.hashCode;
}

extension $CultureInfoExtension on CultureInfo {
  CultureInfo copyWith(
      {CultureInfo? parent,
      int? lcid,
      int? keyboardLayoutId,
      String? name,
      String? sortName,
      String? interopName,
      String? ietfLanguageTag,
      String? displayName,
      String? nativeName,
      String? englishName,
      String? twoLetterISOLanguageName,
      String? threeLetterISOLanguageName,
      String? threeLetterWindowsLanguageName,
      CompareInfo? compareInfo,
      TextInfo? textInfo,
      bool? isNeutralCulture,
      enums.CultureTypes? cultureTypes,
      NumberFormatInfo? numberFormat,
      DateTimeFormatInfo? dateTimeFormat,
      Calendar? calendar,
      List<Calendar>? optionalCalendars,
      bool? useUserOverride,
      bool? isReadOnly,
      bool? hasInvariantCultureName}) {
    return CultureInfo(
        parent: parent ?? this.parent,
        lcid: lcid ?? this.lcid,
        keyboardLayoutId: keyboardLayoutId ?? this.keyboardLayoutId,
        name: name ?? this.name,
        sortName: sortName ?? this.sortName,
        interopName: interopName ?? this.interopName,
        ietfLanguageTag: ietfLanguageTag ?? this.ietfLanguageTag,
        displayName: displayName ?? this.displayName,
        nativeName: nativeName ?? this.nativeName,
        englishName: englishName ?? this.englishName,
        twoLetterISOLanguageName:
            twoLetterISOLanguageName ?? this.twoLetterISOLanguageName,
        threeLetterISOLanguageName:
            threeLetterISOLanguageName ?? this.threeLetterISOLanguageName,
        threeLetterWindowsLanguageName: threeLetterWindowsLanguageName ??
            this.threeLetterWindowsLanguageName,
        compareInfo: compareInfo ?? this.compareInfo,
        textInfo: textInfo ?? this.textInfo,
        isNeutralCulture: isNeutralCulture ?? this.isNeutralCulture,
        cultureTypes: cultureTypes ?? this.cultureTypes,
        numberFormat: numberFormat ?? this.numberFormat,
        dateTimeFormat: dateTimeFormat ?? this.dateTimeFormat,
        calendar: calendar ?? this.calendar,
        optionalCalendars: optionalCalendars ?? this.optionalCalendars,
        useUserOverride: useUserOverride ?? this.useUserOverride,
        isReadOnly: isReadOnly ?? this.isReadOnly,
        hasInvariantCultureName:
            hasInvariantCultureName ?? this.hasInvariantCultureName);
  }

  CultureInfo copyWithWrapped(
      {Wrapped<CultureInfo>? parent,
      Wrapped<int>? lcid,
      Wrapped<int>? keyboardLayoutId,
      Wrapped<String>? name,
      Wrapped<String>? sortName,
      Wrapped<String?>? interopName,
      Wrapped<String>? ietfLanguageTag,
      Wrapped<String>? displayName,
      Wrapped<String>? nativeName,
      Wrapped<String>? englishName,
      Wrapped<String>? twoLetterISOLanguageName,
      Wrapped<String>? threeLetterISOLanguageName,
      Wrapped<String>? threeLetterWindowsLanguageName,
      Wrapped<CompareInfo>? compareInfo,
      Wrapped<TextInfo>? textInfo,
      Wrapped<bool>? isNeutralCulture,
      Wrapped<enums.CultureTypes>? cultureTypes,
      Wrapped<NumberFormatInfo>? numberFormat,
      Wrapped<DateTimeFormatInfo>? dateTimeFormat,
      Wrapped<Calendar>? calendar,
      Wrapped<List<Calendar>>? optionalCalendars,
      Wrapped<bool>? useUserOverride,
      Wrapped<bool>? isReadOnly,
      Wrapped<bool>? hasInvariantCultureName}) {
    return CultureInfo(
        parent: (parent != null ? parent.value : this.parent),
        lcid: (lcid != null ? lcid.value : this.lcid),
        keyboardLayoutId: (keyboardLayoutId != null
            ? keyboardLayoutId.value
            : this.keyboardLayoutId),
        name: (name != null ? name.value : this.name),
        sortName: (sortName != null ? sortName.value : this.sortName),
        interopName:
            (interopName != null ? interopName.value : this.interopName),
        ietfLanguageTag: (ietfLanguageTag != null
            ? ietfLanguageTag.value
            : this.ietfLanguageTag),
        displayName:
            (displayName != null ? displayName.value : this.displayName),
        nativeName: (nativeName != null ? nativeName.value : this.nativeName),
        englishName:
            (englishName != null ? englishName.value : this.englishName),
        twoLetterISOLanguageName: (twoLetterISOLanguageName != null
            ? twoLetterISOLanguageName.value
            : this.twoLetterISOLanguageName),
        threeLetterISOLanguageName: (threeLetterISOLanguageName != null
            ? threeLetterISOLanguageName.value
            : this.threeLetterISOLanguageName),
        threeLetterWindowsLanguageName: (threeLetterWindowsLanguageName != null
            ? threeLetterWindowsLanguageName.value
            : this.threeLetterWindowsLanguageName),
        compareInfo:
            (compareInfo != null ? compareInfo.value : this.compareInfo),
        textInfo: (textInfo != null ? textInfo.value : this.textInfo),
        isNeutralCulture: (isNeutralCulture != null
            ? isNeutralCulture.value
            : this.isNeutralCulture),
        cultureTypes:
            (cultureTypes != null ? cultureTypes.value : this.cultureTypes),
        numberFormat:
            (numberFormat != null ? numberFormat.value : this.numberFormat),
        dateTimeFormat: (dateTimeFormat != null
            ? dateTimeFormat.value
            : this.dateTimeFormat),
        calendar: (calendar != null ? calendar.value : this.calendar),
        optionalCalendars: (optionalCalendars != null
            ? optionalCalendars.value
            : this.optionalCalendars),
        useUserOverride: (useUserOverride != null
            ? useUserOverride.value
            : this.useUserOverride),
        isReadOnly: (isReadOnly != null ? isReadOnly.value : this.isReadOnly),
        hasInvariantCultureName: (hasInvariantCultureName != null
            ? hasInvariantCultureName.value
            : this.hasInvariantCultureName));
  }
}

@JsonSerializable(explicitToJson: true)
class CompareInfo {
  const CompareInfo({
    required this.name,
    required this.version,
    required this.lcid,
  });

  factory CompareInfo.fromJson(Map<String, dynamic> json) =>
      _$CompareInfoFromJson(json);

  static const toJsonFactory = _$CompareInfoToJson;
  Map<String, dynamic> toJson() => _$CompareInfoToJson(this);

  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'version')
  final SortVersion version;
  @JsonKey(name: 'lcid')
  final int lcid;
  static const fromJsonFactory = _$CompareInfoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CompareInfo &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.version, version) ||
                const DeepCollectionEquality()
                    .equals(other.version, version)) &&
            (identical(other.lcid, lcid) ||
                const DeepCollectionEquality().equals(other.lcid, lcid)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(version) ^
      const DeepCollectionEquality().hash(lcid) ^
      runtimeType.hashCode;
}

extension $CompareInfoExtension on CompareInfo {
  CompareInfo copyWith({String? name, SortVersion? version, int? lcid}) {
    return CompareInfo(
        name: name ?? this.name,
        version: version ?? this.version,
        lcid: lcid ?? this.lcid);
  }

  CompareInfo copyWithWrapped(
      {Wrapped<String>? name,
      Wrapped<SortVersion>? version,
      Wrapped<int>? lcid}) {
    return CompareInfo(
        name: (name != null ? name.value : this.name),
        version: (version != null ? version.value : this.version),
        lcid: (lcid != null ? lcid.value : this.lcid));
  }
}

@JsonSerializable(explicitToJson: true)
class SortVersion {
  const SortVersion({
    required this.fullVersion,
    required this.sortId,
  });

  factory SortVersion.fromJson(Map<String, dynamic> json) =>
      _$SortVersionFromJson(json);

  static const toJsonFactory = _$SortVersionToJson;
  Map<String, dynamic> toJson() => _$SortVersionToJson(this);

  @JsonKey(name: 'fullVersion')
  final int fullVersion;
  @JsonKey(name: 'sortId')
  final String sortId;
  static const fromJsonFactory = _$SortVersionFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SortVersion &&
            (identical(other.fullVersion, fullVersion) ||
                const DeepCollectionEquality()
                    .equals(other.fullVersion, fullVersion)) &&
            (identical(other.sortId, sortId) ||
                const DeepCollectionEquality().equals(other.sortId, sortId)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(fullVersion) ^
      const DeepCollectionEquality().hash(sortId) ^
      runtimeType.hashCode;
}

extension $SortVersionExtension on SortVersion {
  SortVersion copyWith({int? fullVersion, String? sortId}) {
    return SortVersion(
        fullVersion: fullVersion ?? this.fullVersion,
        sortId: sortId ?? this.sortId);
  }

  SortVersion copyWithWrapped(
      {Wrapped<int>? fullVersion, Wrapped<String>? sortId}) {
    return SortVersion(
        fullVersion:
            (fullVersion != null ? fullVersion.value : this.fullVersion),
        sortId: (sortId != null ? sortId.value : this.sortId));
  }
}

@JsonSerializable(explicitToJson: true)
class TextInfo {
  const TextInfo({
    required this.ansiCodePage,
    required this.oemCodePage,
    required this.macCodePage,
    required this.ebcdicCodePage,
    required this.lcid,
    required this.cultureName,
    required this.isReadOnly,
    required this.listSeparator,
    required this.isRightToLeft,
  });

  factory TextInfo.fromJson(Map<String, dynamic> json) =>
      _$TextInfoFromJson(json);

  static const toJsonFactory = _$TextInfoToJson;
  Map<String, dynamic> toJson() => _$TextInfoToJson(this);

  @JsonKey(name: 'ansiCodePage')
  final int ansiCodePage;
  @JsonKey(name: 'oemCodePage')
  final int oemCodePage;
  @JsonKey(name: 'macCodePage')
  final int macCodePage;
  @JsonKey(name: 'ebcdicCodePage')
  final int ebcdicCodePage;
  @JsonKey(name: 'lcid')
  final int lcid;
  @JsonKey(name: 'cultureName')
  final String cultureName;
  @JsonKey(name: 'isReadOnly')
  final bool isReadOnly;
  @JsonKey(name: 'listSeparator')
  final String listSeparator;
  @JsonKey(name: 'isRightToLeft')
  final bool isRightToLeft;
  static const fromJsonFactory = _$TextInfoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TextInfo &&
            (identical(other.ansiCodePage, ansiCodePage) ||
                const DeepCollectionEquality()
                    .equals(other.ansiCodePage, ansiCodePage)) &&
            (identical(other.oemCodePage, oemCodePage) ||
                const DeepCollectionEquality()
                    .equals(other.oemCodePage, oemCodePage)) &&
            (identical(other.macCodePage, macCodePage) ||
                const DeepCollectionEquality()
                    .equals(other.macCodePage, macCodePage)) &&
            (identical(other.ebcdicCodePage, ebcdicCodePage) ||
                const DeepCollectionEquality()
                    .equals(other.ebcdicCodePage, ebcdicCodePage)) &&
            (identical(other.lcid, lcid) ||
                const DeepCollectionEquality().equals(other.lcid, lcid)) &&
            (identical(other.cultureName, cultureName) ||
                const DeepCollectionEquality()
                    .equals(other.cultureName, cultureName)) &&
            (identical(other.isReadOnly, isReadOnly) ||
                const DeepCollectionEquality()
                    .equals(other.isReadOnly, isReadOnly)) &&
            (identical(other.listSeparator, listSeparator) ||
                const DeepCollectionEquality()
                    .equals(other.listSeparator, listSeparator)) &&
            (identical(other.isRightToLeft, isRightToLeft) ||
                const DeepCollectionEquality()
                    .equals(other.isRightToLeft, isRightToLeft)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(ansiCodePage) ^
      const DeepCollectionEquality().hash(oemCodePage) ^
      const DeepCollectionEquality().hash(macCodePage) ^
      const DeepCollectionEquality().hash(ebcdicCodePage) ^
      const DeepCollectionEquality().hash(lcid) ^
      const DeepCollectionEquality().hash(cultureName) ^
      const DeepCollectionEquality().hash(isReadOnly) ^
      const DeepCollectionEquality().hash(listSeparator) ^
      const DeepCollectionEquality().hash(isRightToLeft) ^
      runtimeType.hashCode;
}

extension $TextInfoExtension on TextInfo {
  TextInfo copyWith(
      {int? ansiCodePage,
      int? oemCodePage,
      int? macCodePage,
      int? ebcdicCodePage,
      int? lcid,
      String? cultureName,
      bool? isReadOnly,
      String? listSeparator,
      bool? isRightToLeft}) {
    return TextInfo(
        ansiCodePage: ansiCodePage ?? this.ansiCodePage,
        oemCodePage: oemCodePage ?? this.oemCodePage,
        macCodePage: macCodePage ?? this.macCodePage,
        ebcdicCodePage: ebcdicCodePage ?? this.ebcdicCodePage,
        lcid: lcid ?? this.lcid,
        cultureName: cultureName ?? this.cultureName,
        isReadOnly: isReadOnly ?? this.isReadOnly,
        listSeparator: listSeparator ?? this.listSeparator,
        isRightToLeft: isRightToLeft ?? this.isRightToLeft);
  }

  TextInfo copyWithWrapped(
      {Wrapped<int>? ansiCodePage,
      Wrapped<int>? oemCodePage,
      Wrapped<int>? macCodePage,
      Wrapped<int>? ebcdicCodePage,
      Wrapped<int>? lcid,
      Wrapped<String>? cultureName,
      Wrapped<bool>? isReadOnly,
      Wrapped<String>? listSeparator,
      Wrapped<bool>? isRightToLeft}) {
    return TextInfo(
        ansiCodePage:
            (ansiCodePage != null ? ansiCodePage.value : this.ansiCodePage),
        oemCodePage:
            (oemCodePage != null ? oemCodePage.value : this.oemCodePage),
        macCodePage:
            (macCodePage != null ? macCodePage.value : this.macCodePage),
        ebcdicCodePage: (ebcdicCodePage != null
            ? ebcdicCodePage.value
            : this.ebcdicCodePage),
        lcid: (lcid != null ? lcid.value : this.lcid),
        cultureName:
            (cultureName != null ? cultureName.value : this.cultureName),
        isReadOnly: (isReadOnly != null ? isReadOnly.value : this.isReadOnly),
        listSeparator:
            (listSeparator != null ? listSeparator.value : this.listSeparator),
        isRightToLeft:
            (isRightToLeft != null ? isRightToLeft.value : this.isRightToLeft));
  }
}

@JsonSerializable(explicitToJson: true)
class NumberFormatInfo {
  const NumberFormatInfo({
    required this.hasInvariantNumberSigns,
    required this.currencyDecimalDigits,
    required this.currencyDecimalSeparator,
    required this.isReadOnly,
    required this.currencyGroupSizes,
    required this.numberGroupSizes,
    required this.percentGroupSizes,
    required this.currencyGroupSeparator,
    required this.currencySymbol,
    required this.naNSymbol,
    required this.currencyNegativePattern,
    required this.numberNegativePattern,
    required this.percentPositivePattern,
    required this.percentNegativePattern,
    required this.negativeInfinitySymbol,
    required this.negativeSign,
    required this.numberDecimalDigits,
    required this.numberDecimalSeparator,
    required this.numberGroupSeparator,
    required this.currencyPositivePattern,
    required this.positiveInfinitySymbol,
    required this.positiveSign,
    required this.percentDecimalDigits,
    required this.percentDecimalSeparator,
    required this.percentGroupSeparator,
    required this.percentSymbol,
    required this.perMilleSymbol,
    required this.nativeDigits,
    required this.digitSubstitution,
  });

  factory NumberFormatInfo.fromJson(Map<String, dynamic> json) =>
      _$NumberFormatInfoFromJson(json);

  static const toJsonFactory = _$NumberFormatInfoToJson;
  Map<String, dynamic> toJson() => _$NumberFormatInfoToJson(this);

  @JsonKey(name: 'hasInvariantNumberSigns')
  final bool hasInvariantNumberSigns;
  @JsonKey(name: 'currencyDecimalDigits')
  final int currencyDecimalDigits;
  @JsonKey(name: 'currencyDecimalSeparator')
  final String currencyDecimalSeparator;
  @JsonKey(name: 'isReadOnly')
  final bool isReadOnly;
  @JsonKey(name: 'currencyGroupSizes', defaultValue: <int>[])
  final List<int> currencyGroupSizes;
  @JsonKey(name: 'numberGroupSizes', defaultValue: <int>[])
  final List<int> numberGroupSizes;
  @JsonKey(name: 'percentGroupSizes', defaultValue: <int>[])
  final List<int> percentGroupSizes;
  @JsonKey(name: 'currencyGroupSeparator')
  final String currencyGroupSeparator;
  @JsonKey(name: 'currencySymbol')
  final String currencySymbol;
  @JsonKey(name: 'naNSymbol')
  final String naNSymbol;
  @JsonKey(name: 'currencyNegativePattern')
  final int currencyNegativePattern;
  @JsonKey(name: 'numberNegativePattern')
  final int numberNegativePattern;
  @JsonKey(name: 'percentPositivePattern')
  final int percentPositivePattern;
  @JsonKey(name: 'percentNegativePattern')
  final int percentNegativePattern;
  @JsonKey(name: 'negativeInfinitySymbol')
  final String negativeInfinitySymbol;
  @JsonKey(name: 'negativeSign')
  final String negativeSign;
  @JsonKey(name: 'numberDecimalDigits')
  final int numberDecimalDigits;
  @JsonKey(name: 'numberDecimalSeparator')
  final String numberDecimalSeparator;
  @JsonKey(name: 'numberGroupSeparator')
  final String numberGroupSeparator;
  @JsonKey(name: 'currencyPositivePattern')
  final int currencyPositivePattern;
  @JsonKey(name: 'positiveInfinitySymbol')
  final String positiveInfinitySymbol;
  @JsonKey(name: 'positiveSign')
  final String positiveSign;
  @JsonKey(name: 'percentDecimalDigits')
  final int percentDecimalDigits;
  @JsonKey(name: 'percentDecimalSeparator')
  final String percentDecimalSeparator;
  @JsonKey(name: 'percentGroupSeparator')
  final String percentGroupSeparator;
  @JsonKey(name: 'percentSymbol')
  final String percentSymbol;
  @JsonKey(name: 'perMilleSymbol')
  final String perMilleSymbol;
  @JsonKey(name: 'nativeDigits', defaultValue: <String>[])
  final List<String> nativeDigits;
  @JsonKey(
    name: 'digitSubstitution',
    toJson: digitShapesToJson,
    fromJson: digitShapesFromJson,
  )
  final enums.DigitShapes digitSubstitution;
  static const fromJsonFactory = _$NumberFormatInfoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is NumberFormatInfo &&
            (identical(other.hasInvariantNumberSigns, hasInvariantNumberSigns) ||
                const DeepCollectionEquality().equals(
                    other.hasInvariantNumberSigns, hasInvariantNumberSigns)) &&
            (identical(other.currencyDecimalDigits, currencyDecimalDigits) ||
                const DeepCollectionEquality().equals(
                    other.currencyDecimalDigits, currencyDecimalDigits)) &&
            (identical(other.currencyDecimalSeparator, currencyDecimalSeparator) ||
                const DeepCollectionEquality().equals(
                    other.currencyDecimalSeparator,
                    currencyDecimalSeparator)) &&
            (identical(other.isReadOnly, isReadOnly) ||
                const DeepCollectionEquality()
                    .equals(other.isReadOnly, isReadOnly)) &&
            (identical(other.currencyGroupSizes, currencyGroupSizes) ||
                const DeepCollectionEquality()
                    .equals(other.currencyGroupSizes, currencyGroupSizes)) &&
            (identical(other.numberGroupSizes, numberGroupSizes) ||
                const DeepCollectionEquality()
                    .equals(other.numberGroupSizes, numberGroupSizes)) &&
            (identical(other.percentGroupSizes, percentGroupSizes) ||
                const DeepCollectionEquality()
                    .equals(other.percentGroupSizes, percentGroupSizes)) &&
            (identical(other.currencyGroupSeparator, currencyGroupSeparator) ||
                const DeepCollectionEquality().equals(
                    other.currencyGroupSeparator, currencyGroupSeparator)) &&
            (identical(other.currencySymbol, currencySymbol) ||
                const DeepCollectionEquality()
                    .equals(other.currencySymbol, currencySymbol)) &&
            (identical(other.naNSymbol, naNSymbol) ||
                const DeepCollectionEquality()
                    .equals(other.naNSymbol, naNSymbol)) &&
            (identical(other.currencyNegativePattern, currencyNegativePattern) ||
                const DeepCollectionEquality().equals(
                    other.currencyNegativePattern, currencyNegativePattern)) &&
            (identical(other.numberNegativePattern, numberNegativePattern) ||
                const DeepCollectionEquality()
                    .equals(other.numberNegativePattern, numberNegativePattern)) &&
            (identical(other.percentPositivePattern, percentPositivePattern) || const DeepCollectionEquality().equals(other.percentPositivePattern, percentPositivePattern)) &&
            (identical(other.percentNegativePattern, percentNegativePattern) || const DeepCollectionEquality().equals(other.percentNegativePattern, percentNegativePattern)) &&
            (identical(other.negativeInfinitySymbol, negativeInfinitySymbol) || const DeepCollectionEquality().equals(other.negativeInfinitySymbol, negativeInfinitySymbol)) &&
            (identical(other.negativeSign, negativeSign) || const DeepCollectionEquality().equals(other.negativeSign, negativeSign)) &&
            (identical(other.numberDecimalDigits, numberDecimalDigits) || const DeepCollectionEquality().equals(other.numberDecimalDigits, numberDecimalDigits)) &&
            (identical(other.numberDecimalSeparator, numberDecimalSeparator) || const DeepCollectionEquality().equals(other.numberDecimalSeparator, numberDecimalSeparator)) &&
            (identical(other.numberGroupSeparator, numberGroupSeparator) || const DeepCollectionEquality().equals(other.numberGroupSeparator, numberGroupSeparator)) &&
            (identical(other.currencyPositivePattern, currencyPositivePattern) || const DeepCollectionEquality().equals(other.currencyPositivePattern, currencyPositivePattern)) &&
            (identical(other.positiveInfinitySymbol, positiveInfinitySymbol) || const DeepCollectionEquality().equals(other.positiveInfinitySymbol, positiveInfinitySymbol)) &&
            (identical(other.positiveSign, positiveSign) || const DeepCollectionEquality().equals(other.positiveSign, positiveSign)) &&
            (identical(other.percentDecimalDigits, percentDecimalDigits) || const DeepCollectionEquality().equals(other.percentDecimalDigits, percentDecimalDigits)) &&
            (identical(other.percentDecimalSeparator, percentDecimalSeparator) || const DeepCollectionEquality().equals(other.percentDecimalSeparator, percentDecimalSeparator)) &&
            (identical(other.percentGroupSeparator, percentGroupSeparator) || const DeepCollectionEquality().equals(other.percentGroupSeparator, percentGroupSeparator)) &&
            (identical(other.percentSymbol, percentSymbol) || const DeepCollectionEquality().equals(other.percentSymbol, percentSymbol)) &&
            (identical(other.perMilleSymbol, perMilleSymbol) || const DeepCollectionEquality().equals(other.perMilleSymbol, perMilleSymbol)) &&
            (identical(other.nativeDigits, nativeDigits) || const DeepCollectionEquality().equals(other.nativeDigits, nativeDigits)) &&
            (identical(other.digitSubstitution, digitSubstitution) || const DeepCollectionEquality().equals(other.digitSubstitution, digitSubstitution)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(hasInvariantNumberSigns) ^
      const DeepCollectionEquality().hash(currencyDecimalDigits) ^
      const DeepCollectionEquality().hash(currencyDecimalSeparator) ^
      const DeepCollectionEquality().hash(isReadOnly) ^
      const DeepCollectionEquality().hash(currencyGroupSizes) ^
      const DeepCollectionEquality().hash(numberGroupSizes) ^
      const DeepCollectionEquality().hash(percentGroupSizes) ^
      const DeepCollectionEquality().hash(currencyGroupSeparator) ^
      const DeepCollectionEquality().hash(currencySymbol) ^
      const DeepCollectionEquality().hash(naNSymbol) ^
      const DeepCollectionEquality().hash(currencyNegativePattern) ^
      const DeepCollectionEquality().hash(numberNegativePattern) ^
      const DeepCollectionEquality().hash(percentPositivePattern) ^
      const DeepCollectionEquality().hash(percentNegativePattern) ^
      const DeepCollectionEquality().hash(negativeInfinitySymbol) ^
      const DeepCollectionEquality().hash(negativeSign) ^
      const DeepCollectionEquality().hash(numberDecimalDigits) ^
      const DeepCollectionEquality().hash(numberDecimalSeparator) ^
      const DeepCollectionEquality().hash(numberGroupSeparator) ^
      const DeepCollectionEquality().hash(currencyPositivePattern) ^
      const DeepCollectionEquality().hash(positiveInfinitySymbol) ^
      const DeepCollectionEquality().hash(positiveSign) ^
      const DeepCollectionEquality().hash(percentDecimalDigits) ^
      const DeepCollectionEquality().hash(percentDecimalSeparator) ^
      const DeepCollectionEquality().hash(percentGroupSeparator) ^
      const DeepCollectionEquality().hash(percentSymbol) ^
      const DeepCollectionEquality().hash(perMilleSymbol) ^
      const DeepCollectionEquality().hash(nativeDigits) ^
      const DeepCollectionEquality().hash(digitSubstitution) ^
      runtimeType.hashCode;
}

extension $NumberFormatInfoExtension on NumberFormatInfo {
  NumberFormatInfo copyWith(
      {bool? hasInvariantNumberSigns,
      int? currencyDecimalDigits,
      String? currencyDecimalSeparator,
      bool? isReadOnly,
      List<int>? currencyGroupSizes,
      List<int>? numberGroupSizes,
      List<int>? percentGroupSizes,
      String? currencyGroupSeparator,
      String? currencySymbol,
      String? naNSymbol,
      int? currencyNegativePattern,
      int? numberNegativePattern,
      int? percentPositivePattern,
      int? percentNegativePattern,
      String? negativeInfinitySymbol,
      String? negativeSign,
      int? numberDecimalDigits,
      String? numberDecimalSeparator,
      String? numberGroupSeparator,
      int? currencyPositivePattern,
      String? positiveInfinitySymbol,
      String? positiveSign,
      int? percentDecimalDigits,
      String? percentDecimalSeparator,
      String? percentGroupSeparator,
      String? percentSymbol,
      String? perMilleSymbol,
      List<String>? nativeDigits,
      enums.DigitShapes? digitSubstitution}) {
    return NumberFormatInfo(
        hasInvariantNumberSigns:
            hasInvariantNumberSigns ?? this.hasInvariantNumberSigns,
        currencyDecimalDigits:
            currencyDecimalDigits ?? this.currencyDecimalDigits,
        currencyDecimalSeparator:
            currencyDecimalSeparator ?? this.currencyDecimalSeparator,
        isReadOnly: isReadOnly ?? this.isReadOnly,
        currencyGroupSizes: currencyGroupSizes ?? this.currencyGroupSizes,
        numberGroupSizes: numberGroupSizes ?? this.numberGroupSizes,
        percentGroupSizes: percentGroupSizes ?? this.percentGroupSizes,
        currencyGroupSeparator:
            currencyGroupSeparator ?? this.currencyGroupSeparator,
        currencySymbol: currencySymbol ?? this.currencySymbol,
        naNSymbol: naNSymbol ?? this.naNSymbol,
        currencyNegativePattern:
            currencyNegativePattern ?? this.currencyNegativePattern,
        numberNegativePattern:
            numberNegativePattern ?? this.numberNegativePattern,
        percentPositivePattern:
            percentPositivePattern ?? this.percentPositivePattern,
        percentNegativePattern:
            percentNegativePattern ?? this.percentNegativePattern,
        negativeInfinitySymbol:
            negativeInfinitySymbol ?? this.negativeInfinitySymbol,
        negativeSign: negativeSign ?? this.negativeSign,
        numberDecimalDigits: numberDecimalDigits ?? this.numberDecimalDigits,
        numberDecimalSeparator:
            numberDecimalSeparator ?? this.numberDecimalSeparator,
        numberGroupSeparator: numberGroupSeparator ?? this.numberGroupSeparator,
        currencyPositivePattern:
            currencyPositivePattern ?? this.currencyPositivePattern,
        positiveInfinitySymbol:
            positiveInfinitySymbol ?? this.positiveInfinitySymbol,
        positiveSign: positiveSign ?? this.positiveSign,
        percentDecimalDigits: percentDecimalDigits ?? this.percentDecimalDigits,
        percentDecimalSeparator:
            percentDecimalSeparator ?? this.percentDecimalSeparator,
        percentGroupSeparator:
            percentGroupSeparator ?? this.percentGroupSeparator,
        percentSymbol: percentSymbol ?? this.percentSymbol,
        perMilleSymbol: perMilleSymbol ?? this.perMilleSymbol,
        nativeDigits: nativeDigits ?? this.nativeDigits,
        digitSubstitution: digitSubstitution ?? this.digitSubstitution);
  }

  NumberFormatInfo copyWithWrapped(
      {Wrapped<bool>? hasInvariantNumberSigns,
      Wrapped<int>? currencyDecimalDigits,
      Wrapped<String>? currencyDecimalSeparator,
      Wrapped<bool>? isReadOnly,
      Wrapped<List<int>>? currencyGroupSizes,
      Wrapped<List<int>>? numberGroupSizes,
      Wrapped<List<int>>? percentGroupSizes,
      Wrapped<String>? currencyGroupSeparator,
      Wrapped<String>? currencySymbol,
      Wrapped<String>? naNSymbol,
      Wrapped<int>? currencyNegativePattern,
      Wrapped<int>? numberNegativePattern,
      Wrapped<int>? percentPositivePattern,
      Wrapped<int>? percentNegativePattern,
      Wrapped<String>? negativeInfinitySymbol,
      Wrapped<String>? negativeSign,
      Wrapped<int>? numberDecimalDigits,
      Wrapped<String>? numberDecimalSeparator,
      Wrapped<String>? numberGroupSeparator,
      Wrapped<int>? currencyPositivePattern,
      Wrapped<String>? positiveInfinitySymbol,
      Wrapped<String>? positiveSign,
      Wrapped<int>? percentDecimalDigits,
      Wrapped<String>? percentDecimalSeparator,
      Wrapped<String>? percentGroupSeparator,
      Wrapped<String>? percentSymbol,
      Wrapped<String>? perMilleSymbol,
      Wrapped<List<String>>? nativeDigits,
      Wrapped<enums.DigitShapes>? digitSubstitution}) {
    return NumberFormatInfo(
        hasInvariantNumberSigns: (hasInvariantNumberSigns != null
            ? hasInvariantNumberSigns.value
            : this.hasInvariantNumberSigns),
        currencyDecimalDigits: (currencyDecimalDigits != null
            ? currencyDecimalDigits.value
            : this.currencyDecimalDigits),
        currencyDecimalSeparator: (currencyDecimalSeparator != null
            ? currencyDecimalSeparator.value
            : this.currencyDecimalSeparator),
        isReadOnly: (isReadOnly != null ? isReadOnly.value : this.isReadOnly),
        currencyGroupSizes: (currencyGroupSizes != null
            ? currencyGroupSizes.value
            : this.currencyGroupSizes),
        numberGroupSizes: (numberGroupSizes != null
            ? numberGroupSizes.value
            : this.numberGroupSizes),
        percentGroupSizes: (percentGroupSizes != null
            ? percentGroupSizes.value
            : this.percentGroupSizes),
        currencyGroupSeparator: (currencyGroupSeparator != null
            ? currencyGroupSeparator.value
            : this.currencyGroupSeparator),
        currencySymbol: (currencySymbol != null
            ? currencySymbol.value
            : this.currencySymbol),
        naNSymbol: (naNSymbol != null ? naNSymbol.value : this.naNSymbol),
        currencyNegativePattern: (currencyNegativePattern != null
            ? currencyNegativePattern.value
            : this.currencyNegativePattern),
        numberNegativePattern: (numberNegativePattern != null
            ? numberNegativePattern.value
            : this.numberNegativePattern),
        percentPositivePattern: (percentPositivePattern != null
            ? percentPositivePattern.value
            : this.percentPositivePattern),
        percentNegativePattern: (percentNegativePattern != null
            ? percentNegativePattern.value
            : this.percentNegativePattern),
        negativeInfinitySymbol: (negativeInfinitySymbol != null
            ? negativeInfinitySymbol.value
            : this.negativeInfinitySymbol),
        negativeSign:
            (negativeSign != null ? negativeSign.value : this.negativeSign),
        numberDecimalDigits: (numberDecimalDigits != null
            ? numberDecimalDigits.value
            : this.numberDecimalDigits),
        numberDecimalSeparator: (numberDecimalSeparator != null
            ? numberDecimalSeparator.value
            : this.numberDecimalSeparator),
        numberGroupSeparator: (numberGroupSeparator != null
            ? numberGroupSeparator.value
            : this.numberGroupSeparator),
        currencyPositivePattern: (currencyPositivePattern != null
            ? currencyPositivePattern.value
            : this.currencyPositivePattern),
        positiveInfinitySymbol: (positiveInfinitySymbol != null
            ? positiveInfinitySymbol.value
            : this.positiveInfinitySymbol),
        positiveSign:
            (positiveSign != null ? positiveSign.value : this.positiveSign),
        percentDecimalDigits: (percentDecimalDigits != null
            ? percentDecimalDigits.value
            : this.percentDecimalDigits),
        percentDecimalSeparator: (percentDecimalSeparator != null
            ? percentDecimalSeparator.value
            : this.percentDecimalSeparator),
        percentGroupSeparator: (percentGroupSeparator != null
            ? percentGroupSeparator.value
            : this.percentGroupSeparator),
        percentSymbol:
            (percentSymbol != null ? percentSymbol.value : this.percentSymbol),
        perMilleSymbol: (perMilleSymbol != null
            ? perMilleSymbol.value
            : this.perMilleSymbol),
        nativeDigits:
            (nativeDigits != null ? nativeDigits.value : this.nativeDigits),
        digitSubstitution: (digitSubstitution != null
            ? digitSubstitution.value
            : this.digitSubstitution));
  }
}

@JsonSerializable(explicitToJson: true)
class DateTimeFormatInfo {
  const DateTimeFormatInfo({
    required this.amDesignator,
    required this.calendar,
    required this.eraNames,
    required this.abbreviatedEraNames,
    required this.abbreviatedEnglishEraNames,
    required this.dateSeparator,
    required this.firstDayOfWeek,
    required this.calendarWeekRule,
    required this.fullDateTimePattern,
    required this.longDatePattern,
    required this.longTimePattern,
    required this.monthDayPattern,
    required this.pmDesignator,
    required this.rfC1123Pattern,
    required this.shortDatePattern,
    required this.shortTimePattern,
    required this.sortableDateTimePattern,
    required this.generalShortTimePattern,
    required this.generalLongTimePattern,
    required this.dateTimeOffsetPattern,
    required this.timeSeparator,
    required this.universalSortableDateTimePattern,
    required this.yearMonthPattern,
    required this.abbreviatedDayNames,
    required this.shortestDayNames,
    required this.dayNames,
    required this.abbreviatedMonthNames,
    required this.monthNames,
    required this.hasSpacesInMonthNames,
    required this.hasSpacesInDayNames,
    required this.isReadOnly,
    required this.nativeCalendarName,
    required this.abbreviatedMonthGenitiveNames,
    required this.monthGenitiveNames,
    required this.decimalSeparator,
    required this.fullTimeSpanPositivePattern,
    required this.fullTimeSpanNegativePattern,
    required this.compareInfo,
    required this.formatFlags,
    required this.hasForceTwoDigitYears,
    required this.hasYearMonthAdjustment,
  });

  factory DateTimeFormatInfo.fromJson(Map<String, dynamic> json) =>
      _$DateTimeFormatInfoFromJson(json);

  static const toJsonFactory = _$DateTimeFormatInfoToJson;
  Map<String, dynamic> toJson() => _$DateTimeFormatInfoToJson(this);

  @JsonKey(name: 'amDesignator')
  final String amDesignator;
  @JsonKey(name: 'calendar')
  final Calendar calendar;
  @JsonKey(name: 'eraNames', defaultValue: <String>[])
  final List<String> eraNames;
  @JsonKey(name: 'abbreviatedEraNames', defaultValue: <String>[])
  final List<String> abbreviatedEraNames;
  @JsonKey(name: 'abbreviatedEnglishEraNames', defaultValue: <String>[])
  final List<String> abbreviatedEnglishEraNames;
  @JsonKey(name: 'dateSeparator')
  final String dateSeparator;
  @JsonKey(
    name: 'firstDayOfWeek',
    toJson: dayOfWeekToJson,
    fromJson: dayOfWeekFromJson,
  )
  final enums.DayOfWeek firstDayOfWeek;
  @JsonKey(
    name: 'calendarWeekRule',
    toJson: calendarWeekRuleToJson,
    fromJson: calendarWeekRuleFromJson,
  )
  final enums.CalendarWeekRule calendarWeekRule;
  @JsonKey(name: 'fullDateTimePattern')
  final String fullDateTimePattern;
  @JsonKey(name: 'longDatePattern')
  final String longDatePattern;
  @JsonKey(name: 'longTimePattern')
  final String longTimePattern;
  @JsonKey(name: 'monthDayPattern')
  final String monthDayPattern;
  @JsonKey(name: 'pmDesignator')
  final String pmDesignator;
  @JsonKey(name: 'rfC1123Pattern')
  final String rfC1123Pattern;
  @JsonKey(name: 'shortDatePattern')
  final String shortDatePattern;
  @JsonKey(name: 'shortTimePattern')
  final String shortTimePattern;
  @JsonKey(name: 'sortableDateTimePattern')
  final String sortableDateTimePattern;
  @JsonKey(name: 'generalShortTimePattern')
  final String generalShortTimePattern;
  @JsonKey(name: 'generalLongTimePattern')
  final String generalLongTimePattern;
  @JsonKey(name: 'dateTimeOffsetPattern')
  final String dateTimeOffsetPattern;
  @JsonKey(name: 'timeSeparator')
  final String timeSeparator;
  @JsonKey(name: 'universalSortableDateTimePattern')
  final String universalSortableDateTimePattern;
  @JsonKey(name: 'yearMonthPattern')
  final String yearMonthPattern;
  @JsonKey(name: 'abbreviatedDayNames', defaultValue: <String>[])
  final List<String> abbreviatedDayNames;
  @JsonKey(name: 'shortestDayNames', defaultValue: <String>[])
  final List<String> shortestDayNames;
  @JsonKey(name: 'dayNames', defaultValue: <String>[])
  final List<String> dayNames;
  @JsonKey(name: 'abbreviatedMonthNames', defaultValue: <String>[])
  final List<String> abbreviatedMonthNames;
  @JsonKey(name: 'monthNames', defaultValue: <String>[])
  final List<String> monthNames;
  @JsonKey(name: 'hasSpacesInMonthNames')
  final bool hasSpacesInMonthNames;
  @JsonKey(name: 'hasSpacesInDayNames')
  final bool hasSpacesInDayNames;
  @JsonKey(name: 'isReadOnly')
  final bool isReadOnly;
  @JsonKey(name: 'nativeCalendarName')
  final String nativeCalendarName;
  @JsonKey(name: 'abbreviatedMonthGenitiveNames', defaultValue: <String>[])
  final List<String> abbreviatedMonthGenitiveNames;
  @JsonKey(name: 'monthGenitiveNames', defaultValue: <String>[])
  final List<String> monthGenitiveNames;
  @JsonKey(name: 'decimalSeparator')
  final String decimalSeparator;
  @JsonKey(name: 'fullTimeSpanPositivePattern')
  final String fullTimeSpanPositivePattern;
  @JsonKey(name: 'fullTimeSpanNegativePattern')
  final String fullTimeSpanNegativePattern;
  @JsonKey(name: 'compareInfo')
  final CompareInfo compareInfo;
  @JsonKey(
    name: 'formatFlags',
    toJson: dateTimeFormatFlagsToJson,
    fromJson: dateTimeFormatFlagsFromJson,
  )
  final enums.DateTimeFormatFlags formatFlags;
  @JsonKey(name: 'hasForceTwoDigitYears')
  final bool hasForceTwoDigitYears;
  @JsonKey(name: 'hasYearMonthAdjustment')
  final bool hasYearMonthAdjustment;
  static const fromJsonFactory = _$DateTimeFormatInfoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DateTimeFormatInfo &&
            (identical(other.amDesignator, amDesignator) ||
                const DeepCollectionEquality()
                    .equals(other.amDesignator, amDesignator)) &&
            (identical(other.calendar, calendar) ||
                const DeepCollectionEquality()
                    .equals(other.calendar, calendar)) &&
            (identical(other.eraNames, eraNames) ||
                const DeepCollectionEquality()
                    .equals(other.eraNames, eraNames)) &&
            (identical(other.abbreviatedEraNames, abbreviatedEraNames) ||
                const DeepCollectionEquality()
                    .equals(other.abbreviatedEraNames, abbreviatedEraNames)) &&
            (identical(other.abbreviatedEnglishEraNames, abbreviatedEnglishEraNames) ||
                const DeepCollectionEquality().equals(
                    other.abbreviatedEnglishEraNames,
                    abbreviatedEnglishEraNames)) &&
            (identical(other.dateSeparator, dateSeparator) ||
                const DeepCollectionEquality()
                    .equals(other.dateSeparator, dateSeparator)) &&
            (identical(other.firstDayOfWeek, firstDayOfWeek) ||
                const DeepCollectionEquality()
                    .equals(other.firstDayOfWeek, firstDayOfWeek)) &&
            (identical(other.calendarWeekRule, calendarWeekRule) ||
                const DeepCollectionEquality()
                    .equals(other.calendarWeekRule, calendarWeekRule)) &&
            (identical(other.fullDateTimePattern, fullDateTimePattern) ||
                const DeepCollectionEquality()
                    .equals(other.fullDateTimePattern, fullDateTimePattern)) &&
            (identical(other.longDatePattern, longDatePattern) ||
                const DeepCollectionEquality()
                    .equals(other.longDatePattern, longDatePattern)) &&
            (identical(other.longTimePattern, longTimePattern) ||
                const DeepCollectionEquality()
                    .equals(other.longTimePattern, longTimePattern)) &&
            (identical(other.monthDayPattern, monthDayPattern) ||
                const DeepCollectionEquality()
                    .equals(other.monthDayPattern, monthDayPattern)) &&
            (identical(other.pmDesignator, pmDesignator) ||
                const DeepCollectionEquality()
                    .equals(other.pmDesignator, pmDesignator)) &&
            (identical(other.rfC1123Pattern, rfC1123Pattern) ||
                const DeepCollectionEquality()
                    .equals(other.rfC1123Pattern, rfC1123Pattern)) &&
            (identical(other.shortDatePattern, shortDatePattern) ||
                const DeepCollectionEquality()
                    .equals(other.shortDatePattern, shortDatePattern)) &&
            (identical(other.shortTimePattern, shortTimePattern) ||
                const DeepCollectionEquality()
                    .equals(other.shortTimePattern, shortTimePattern)) &&
            (identical(other.sortableDateTimePattern, sortableDateTimePattern) ||
                const DeepCollectionEquality()
                    .equals(other.sortableDateTimePattern, sortableDateTimePattern)) &&
            (identical(other.generalShortTimePattern, generalShortTimePattern) || const DeepCollectionEquality().equals(other.generalShortTimePattern, generalShortTimePattern)) &&
            (identical(other.generalLongTimePattern, generalLongTimePattern) || const DeepCollectionEquality().equals(other.generalLongTimePattern, generalLongTimePattern)) &&
            (identical(other.dateTimeOffsetPattern, dateTimeOffsetPattern) || const DeepCollectionEquality().equals(other.dateTimeOffsetPattern, dateTimeOffsetPattern)) &&
            (identical(other.timeSeparator, timeSeparator) || const DeepCollectionEquality().equals(other.timeSeparator, timeSeparator)) &&
            (identical(other.universalSortableDateTimePattern, universalSortableDateTimePattern) || const DeepCollectionEquality().equals(other.universalSortableDateTimePattern, universalSortableDateTimePattern)) &&
            (identical(other.yearMonthPattern, yearMonthPattern) || const DeepCollectionEquality().equals(other.yearMonthPattern, yearMonthPattern)) &&
            (identical(other.abbreviatedDayNames, abbreviatedDayNames) || const DeepCollectionEquality().equals(other.abbreviatedDayNames, abbreviatedDayNames)) &&
            (identical(other.shortestDayNames, shortestDayNames) || const DeepCollectionEquality().equals(other.shortestDayNames, shortestDayNames)) &&
            (identical(other.dayNames, dayNames) || const DeepCollectionEquality().equals(other.dayNames, dayNames)) &&
            (identical(other.abbreviatedMonthNames, abbreviatedMonthNames) || const DeepCollectionEquality().equals(other.abbreviatedMonthNames, abbreviatedMonthNames)) &&
            (identical(other.monthNames, monthNames) || const DeepCollectionEquality().equals(other.monthNames, monthNames)) &&
            (identical(other.hasSpacesInMonthNames, hasSpacesInMonthNames) || const DeepCollectionEquality().equals(other.hasSpacesInMonthNames, hasSpacesInMonthNames)) &&
            (identical(other.hasSpacesInDayNames, hasSpacesInDayNames) || const DeepCollectionEquality().equals(other.hasSpacesInDayNames, hasSpacesInDayNames)) &&
            (identical(other.isReadOnly, isReadOnly) || const DeepCollectionEquality().equals(other.isReadOnly, isReadOnly)) &&
            (identical(other.nativeCalendarName, nativeCalendarName) || const DeepCollectionEquality().equals(other.nativeCalendarName, nativeCalendarName)) &&
            (identical(other.abbreviatedMonthGenitiveNames, abbreviatedMonthGenitiveNames) || const DeepCollectionEquality().equals(other.abbreviatedMonthGenitiveNames, abbreviatedMonthGenitiveNames)) &&
            (identical(other.monthGenitiveNames, monthGenitiveNames) || const DeepCollectionEquality().equals(other.monthGenitiveNames, monthGenitiveNames)) &&
            (identical(other.decimalSeparator, decimalSeparator) || const DeepCollectionEquality().equals(other.decimalSeparator, decimalSeparator)) &&
            (identical(other.fullTimeSpanPositivePattern, fullTimeSpanPositivePattern) || const DeepCollectionEquality().equals(other.fullTimeSpanPositivePattern, fullTimeSpanPositivePattern)) &&
            (identical(other.fullTimeSpanNegativePattern, fullTimeSpanNegativePattern) || const DeepCollectionEquality().equals(other.fullTimeSpanNegativePattern, fullTimeSpanNegativePattern)) &&
            (identical(other.compareInfo, compareInfo) || const DeepCollectionEquality().equals(other.compareInfo, compareInfo)) &&
            (identical(other.formatFlags, formatFlags) || const DeepCollectionEquality().equals(other.formatFlags, formatFlags)) &&
            (identical(other.hasForceTwoDigitYears, hasForceTwoDigitYears) || const DeepCollectionEquality().equals(other.hasForceTwoDigitYears, hasForceTwoDigitYears)) &&
            (identical(other.hasYearMonthAdjustment, hasYearMonthAdjustment) || const DeepCollectionEquality().equals(other.hasYearMonthAdjustment, hasYearMonthAdjustment)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(amDesignator) ^
      const DeepCollectionEquality().hash(calendar) ^
      const DeepCollectionEquality().hash(eraNames) ^
      const DeepCollectionEquality().hash(abbreviatedEraNames) ^
      const DeepCollectionEquality().hash(abbreviatedEnglishEraNames) ^
      const DeepCollectionEquality().hash(dateSeparator) ^
      const DeepCollectionEquality().hash(firstDayOfWeek) ^
      const DeepCollectionEquality().hash(calendarWeekRule) ^
      const DeepCollectionEquality().hash(fullDateTimePattern) ^
      const DeepCollectionEquality().hash(longDatePattern) ^
      const DeepCollectionEquality().hash(longTimePattern) ^
      const DeepCollectionEquality().hash(monthDayPattern) ^
      const DeepCollectionEquality().hash(pmDesignator) ^
      const DeepCollectionEquality().hash(rfC1123Pattern) ^
      const DeepCollectionEquality().hash(shortDatePattern) ^
      const DeepCollectionEquality().hash(shortTimePattern) ^
      const DeepCollectionEquality().hash(sortableDateTimePattern) ^
      const DeepCollectionEquality().hash(generalShortTimePattern) ^
      const DeepCollectionEquality().hash(generalLongTimePattern) ^
      const DeepCollectionEquality().hash(dateTimeOffsetPattern) ^
      const DeepCollectionEquality().hash(timeSeparator) ^
      const DeepCollectionEquality().hash(universalSortableDateTimePattern) ^
      const DeepCollectionEquality().hash(yearMonthPattern) ^
      const DeepCollectionEquality().hash(abbreviatedDayNames) ^
      const DeepCollectionEquality().hash(shortestDayNames) ^
      const DeepCollectionEquality().hash(dayNames) ^
      const DeepCollectionEquality().hash(abbreviatedMonthNames) ^
      const DeepCollectionEquality().hash(monthNames) ^
      const DeepCollectionEquality().hash(hasSpacesInMonthNames) ^
      const DeepCollectionEquality().hash(hasSpacesInDayNames) ^
      const DeepCollectionEquality().hash(isReadOnly) ^
      const DeepCollectionEquality().hash(nativeCalendarName) ^
      const DeepCollectionEquality().hash(abbreviatedMonthGenitiveNames) ^
      const DeepCollectionEquality().hash(monthGenitiveNames) ^
      const DeepCollectionEquality().hash(decimalSeparator) ^
      const DeepCollectionEquality().hash(fullTimeSpanPositivePattern) ^
      const DeepCollectionEquality().hash(fullTimeSpanNegativePattern) ^
      const DeepCollectionEquality().hash(compareInfo) ^
      const DeepCollectionEquality().hash(formatFlags) ^
      const DeepCollectionEquality().hash(hasForceTwoDigitYears) ^
      const DeepCollectionEquality().hash(hasYearMonthAdjustment) ^
      runtimeType.hashCode;
}

extension $DateTimeFormatInfoExtension on DateTimeFormatInfo {
  DateTimeFormatInfo copyWith(
      {String? amDesignator,
      Calendar? calendar,
      List<String>? eraNames,
      List<String>? abbreviatedEraNames,
      List<String>? abbreviatedEnglishEraNames,
      String? dateSeparator,
      enums.DayOfWeek? firstDayOfWeek,
      enums.CalendarWeekRule? calendarWeekRule,
      String? fullDateTimePattern,
      String? longDatePattern,
      String? longTimePattern,
      String? monthDayPattern,
      String? pmDesignator,
      String? rfC1123Pattern,
      String? shortDatePattern,
      String? shortTimePattern,
      String? sortableDateTimePattern,
      String? generalShortTimePattern,
      String? generalLongTimePattern,
      String? dateTimeOffsetPattern,
      String? timeSeparator,
      String? universalSortableDateTimePattern,
      String? yearMonthPattern,
      List<String>? abbreviatedDayNames,
      List<String>? shortestDayNames,
      List<String>? dayNames,
      List<String>? abbreviatedMonthNames,
      List<String>? monthNames,
      bool? hasSpacesInMonthNames,
      bool? hasSpacesInDayNames,
      bool? isReadOnly,
      String? nativeCalendarName,
      List<String>? abbreviatedMonthGenitiveNames,
      List<String>? monthGenitiveNames,
      String? decimalSeparator,
      String? fullTimeSpanPositivePattern,
      String? fullTimeSpanNegativePattern,
      CompareInfo? compareInfo,
      enums.DateTimeFormatFlags? formatFlags,
      bool? hasForceTwoDigitYears,
      bool? hasYearMonthAdjustment}) {
    return DateTimeFormatInfo(
        amDesignator: amDesignator ?? this.amDesignator,
        calendar: calendar ?? this.calendar,
        eraNames: eraNames ?? this.eraNames,
        abbreviatedEraNames: abbreviatedEraNames ?? this.abbreviatedEraNames,
        abbreviatedEnglishEraNames:
            abbreviatedEnglishEraNames ?? this.abbreviatedEnglishEraNames,
        dateSeparator: dateSeparator ?? this.dateSeparator,
        firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
        calendarWeekRule: calendarWeekRule ?? this.calendarWeekRule,
        fullDateTimePattern: fullDateTimePattern ?? this.fullDateTimePattern,
        longDatePattern: longDatePattern ?? this.longDatePattern,
        longTimePattern: longTimePattern ?? this.longTimePattern,
        monthDayPattern: monthDayPattern ?? this.monthDayPattern,
        pmDesignator: pmDesignator ?? this.pmDesignator,
        rfC1123Pattern: rfC1123Pattern ?? this.rfC1123Pattern,
        shortDatePattern: shortDatePattern ?? this.shortDatePattern,
        shortTimePattern: shortTimePattern ?? this.shortTimePattern,
        sortableDateTimePattern:
            sortableDateTimePattern ?? this.sortableDateTimePattern,
        generalShortTimePattern:
            generalShortTimePattern ?? this.generalShortTimePattern,
        generalLongTimePattern:
            generalLongTimePattern ?? this.generalLongTimePattern,
        dateTimeOffsetPattern:
            dateTimeOffsetPattern ?? this.dateTimeOffsetPattern,
        timeSeparator: timeSeparator ?? this.timeSeparator,
        universalSortableDateTimePattern: universalSortableDateTimePattern ??
            this.universalSortableDateTimePattern,
        yearMonthPattern: yearMonthPattern ?? this.yearMonthPattern,
        abbreviatedDayNames: abbreviatedDayNames ?? this.abbreviatedDayNames,
        shortestDayNames: shortestDayNames ?? this.shortestDayNames,
        dayNames: dayNames ?? this.dayNames,
        abbreviatedMonthNames:
            abbreviatedMonthNames ?? this.abbreviatedMonthNames,
        monthNames: monthNames ?? this.monthNames,
        hasSpacesInMonthNames:
            hasSpacesInMonthNames ?? this.hasSpacesInMonthNames,
        hasSpacesInDayNames: hasSpacesInDayNames ?? this.hasSpacesInDayNames,
        isReadOnly: isReadOnly ?? this.isReadOnly,
        nativeCalendarName: nativeCalendarName ?? this.nativeCalendarName,
        abbreviatedMonthGenitiveNames:
            abbreviatedMonthGenitiveNames ?? this.abbreviatedMonthGenitiveNames,
        monthGenitiveNames: monthGenitiveNames ?? this.monthGenitiveNames,
        decimalSeparator: decimalSeparator ?? this.decimalSeparator,
        fullTimeSpanPositivePattern:
            fullTimeSpanPositivePattern ?? this.fullTimeSpanPositivePattern,
        fullTimeSpanNegativePattern:
            fullTimeSpanNegativePattern ?? this.fullTimeSpanNegativePattern,
        compareInfo: compareInfo ?? this.compareInfo,
        formatFlags: formatFlags ?? this.formatFlags,
        hasForceTwoDigitYears:
            hasForceTwoDigitYears ?? this.hasForceTwoDigitYears,
        hasYearMonthAdjustment:
            hasYearMonthAdjustment ?? this.hasYearMonthAdjustment);
  }

  DateTimeFormatInfo copyWithWrapped(
      {Wrapped<String>? amDesignator,
      Wrapped<Calendar>? calendar,
      Wrapped<List<String>>? eraNames,
      Wrapped<List<String>>? abbreviatedEraNames,
      Wrapped<List<String>>? abbreviatedEnglishEraNames,
      Wrapped<String>? dateSeparator,
      Wrapped<enums.DayOfWeek>? firstDayOfWeek,
      Wrapped<enums.CalendarWeekRule>? calendarWeekRule,
      Wrapped<String>? fullDateTimePattern,
      Wrapped<String>? longDatePattern,
      Wrapped<String>? longTimePattern,
      Wrapped<String>? monthDayPattern,
      Wrapped<String>? pmDesignator,
      Wrapped<String>? rfC1123Pattern,
      Wrapped<String>? shortDatePattern,
      Wrapped<String>? shortTimePattern,
      Wrapped<String>? sortableDateTimePattern,
      Wrapped<String>? generalShortTimePattern,
      Wrapped<String>? generalLongTimePattern,
      Wrapped<String>? dateTimeOffsetPattern,
      Wrapped<String>? timeSeparator,
      Wrapped<String>? universalSortableDateTimePattern,
      Wrapped<String>? yearMonthPattern,
      Wrapped<List<String>>? abbreviatedDayNames,
      Wrapped<List<String>>? shortestDayNames,
      Wrapped<List<String>>? dayNames,
      Wrapped<List<String>>? abbreviatedMonthNames,
      Wrapped<List<String>>? monthNames,
      Wrapped<bool>? hasSpacesInMonthNames,
      Wrapped<bool>? hasSpacesInDayNames,
      Wrapped<bool>? isReadOnly,
      Wrapped<String>? nativeCalendarName,
      Wrapped<List<String>>? abbreviatedMonthGenitiveNames,
      Wrapped<List<String>>? monthGenitiveNames,
      Wrapped<String>? decimalSeparator,
      Wrapped<String>? fullTimeSpanPositivePattern,
      Wrapped<String>? fullTimeSpanNegativePattern,
      Wrapped<CompareInfo>? compareInfo,
      Wrapped<enums.DateTimeFormatFlags>? formatFlags,
      Wrapped<bool>? hasForceTwoDigitYears,
      Wrapped<bool>? hasYearMonthAdjustment}) {
    return DateTimeFormatInfo(
        amDesignator:
            (amDesignator != null ? amDesignator.value : this.amDesignator),
        calendar: (calendar != null ? calendar.value : this.calendar),
        eraNames: (eraNames != null ? eraNames.value : this.eraNames),
        abbreviatedEraNames: (abbreviatedEraNames != null
            ? abbreviatedEraNames.value
            : this.abbreviatedEraNames),
        abbreviatedEnglishEraNames: (abbreviatedEnglishEraNames != null
            ? abbreviatedEnglishEraNames.value
            : this.abbreviatedEnglishEraNames),
        dateSeparator:
            (dateSeparator != null ? dateSeparator.value : this.dateSeparator),
        firstDayOfWeek: (firstDayOfWeek != null
            ? firstDayOfWeek.value
            : this.firstDayOfWeek),
        calendarWeekRule: (calendarWeekRule != null
            ? calendarWeekRule.value
            : this.calendarWeekRule),
        fullDateTimePattern: (fullDateTimePattern != null
            ? fullDateTimePattern.value
            : this.fullDateTimePattern),
        longDatePattern: (longDatePattern != null
            ? longDatePattern.value
            : this.longDatePattern),
        longTimePattern: (longTimePattern != null
            ? longTimePattern.value
            : this.longTimePattern),
        monthDayPattern: (monthDayPattern != null
            ? monthDayPattern.value
            : this.monthDayPattern),
        pmDesignator:
            (pmDesignator != null ? pmDesignator.value : this.pmDesignator),
        rfC1123Pattern: (rfC1123Pattern != null
            ? rfC1123Pattern.value
            : this.rfC1123Pattern),
        shortDatePattern: (shortDatePattern != null
            ? shortDatePattern.value
            : this.shortDatePattern),
        shortTimePattern: (shortTimePattern != null
            ? shortTimePattern.value
            : this.shortTimePattern),
        sortableDateTimePattern: (sortableDateTimePattern != null
            ? sortableDateTimePattern.value
            : this.sortableDateTimePattern),
        generalShortTimePattern: (generalShortTimePattern != null
            ? generalShortTimePattern.value
            : this.generalShortTimePattern),
        generalLongTimePattern: (generalLongTimePattern != null
            ? generalLongTimePattern.value
            : this.generalLongTimePattern),
        dateTimeOffsetPattern: (dateTimeOffsetPattern != null
            ? dateTimeOffsetPattern.value
            : this.dateTimeOffsetPattern),
        timeSeparator:
            (timeSeparator != null ? timeSeparator.value : this.timeSeparator),
        universalSortableDateTimePattern:
            (universalSortableDateTimePattern != null
                ? universalSortableDateTimePattern.value
                : this.universalSortableDateTimePattern),
        yearMonthPattern: (yearMonthPattern != null
            ? yearMonthPattern.value
            : this.yearMonthPattern),
        abbreviatedDayNames: (abbreviatedDayNames != null
            ? abbreviatedDayNames.value
            : this.abbreviatedDayNames),
        shortestDayNames: (shortestDayNames != null
            ? shortestDayNames.value
            : this.shortestDayNames),
        dayNames: (dayNames != null ? dayNames.value : this.dayNames),
        abbreviatedMonthNames: (abbreviatedMonthNames != null
            ? abbreviatedMonthNames.value
            : this.abbreviatedMonthNames),
        monthNames: (monthNames != null ? monthNames.value : this.monthNames),
        hasSpacesInMonthNames: (hasSpacesInMonthNames != null
            ? hasSpacesInMonthNames.value
            : this.hasSpacesInMonthNames),
        hasSpacesInDayNames: (hasSpacesInDayNames != null
            ? hasSpacesInDayNames.value
            : this.hasSpacesInDayNames),
        isReadOnly: (isReadOnly != null ? isReadOnly.value : this.isReadOnly),
        nativeCalendarName: (nativeCalendarName != null
            ? nativeCalendarName.value
            : this.nativeCalendarName),
        abbreviatedMonthGenitiveNames: (abbreviatedMonthGenitiveNames != null
            ? abbreviatedMonthGenitiveNames.value
            : this.abbreviatedMonthGenitiveNames),
        monthGenitiveNames: (monthGenitiveNames != null
            ? monthGenitiveNames.value
            : this.monthGenitiveNames),
        decimalSeparator: (decimalSeparator != null
            ? decimalSeparator.value
            : this.decimalSeparator),
        fullTimeSpanPositivePattern: (fullTimeSpanPositivePattern != null
            ? fullTimeSpanPositivePattern.value
            : this.fullTimeSpanPositivePattern),
        fullTimeSpanNegativePattern: (fullTimeSpanNegativePattern != null
            ? fullTimeSpanNegativePattern.value
            : this.fullTimeSpanNegativePattern),
        compareInfo:
            (compareInfo != null ? compareInfo.value : this.compareInfo),
        formatFlags:
            (formatFlags != null ? formatFlags.value : this.formatFlags),
        hasForceTwoDigitYears: (hasForceTwoDigitYears != null
            ? hasForceTwoDigitYears.value
            : this.hasForceTwoDigitYears),
        hasYearMonthAdjustment: (hasYearMonthAdjustment != null
            ? hasYearMonthAdjustment.value
            : this.hasYearMonthAdjustment));
  }
}

@JsonSerializable(explicitToJson: true)
class Calendar {
  const Calendar({
    required this.minSupportedDateTime,
    required this.maxSupportedDateTime,
    required this.algorithmType,
    required this.id,
    required this.baseCalendarID,
    required this.isReadOnly,
    required this.currentEraValue,
    required this.eras,
    required this.daysInYearBeforeMinSupportedYear,
    required this.twoDigitYearMax,
  });

  factory Calendar.fromJson(Map<String, dynamic> json) =>
      _$CalendarFromJson(json);

  static const toJsonFactory = _$CalendarToJson;
  Map<String, dynamic> toJson() => _$CalendarToJson(this);

  @JsonKey(name: 'minSupportedDateTime')
  final DateTime minSupportedDateTime;
  @JsonKey(name: 'maxSupportedDateTime')
  final DateTime maxSupportedDateTime;
  @JsonKey(
    name: 'algorithmType',
    toJson: calendarAlgorithmTypeToJson,
    fromJson: calendarAlgorithmTypeFromJson,
  )
  final enums.CalendarAlgorithmType algorithmType;
  @JsonKey(
    name: 'id',
    toJson: calendarIdToJson,
    fromJson: calendarIdFromJson,
  )
  final enums.CalendarId id;
  @JsonKey(
    name: 'baseCalendarID',
    toJson: calendarIdToJson,
    fromJson: calendarIdFromJson,
  )
  final enums.CalendarId baseCalendarID;
  @JsonKey(name: 'isReadOnly')
  final bool isReadOnly;
  @JsonKey(name: 'currentEraValue')
  final int currentEraValue;
  @JsonKey(name: 'eras', defaultValue: <int>[])
  final List<int> eras;
  @JsonKey(name: 'daysInYearBeforeMinSupportedYear')
  final int daysInYearBeforeMinSupportedYear;
  @JsonKey(name: 'twoDigitYearMax')
  final int twoDigitYearMax;
  static const fromJsonFactory = _$CalendarFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Calendar &&
            (identical(other.minSupportedDateTime, minSupportedDateTime) ||
                const DeepCollectionEquality().equals(
                    other.minSupportedDateTime, minSupportedDateTime)) &&
            (identical(other.maxSupportedDateTime, maxSupportedDateTime) ||
                const DeepCollectionEquality().equals(
                    other.maxSupportedDateTime, maxSupportedDateTime)) &&
            (identical(other.algorithmType, algorithmType) ||
                const DeepCollectionEquality()
                    .equals(other.algorithmType, algorithmType)) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.baseCalendarID, baseCalendarID) ||
                const DeepCollectionEquality()
                    .equals(other.baseCalendarID, baseCalendarID)) &&
            (identical(other.isReadOnly, isReadOnly) ||
                const DeepCollectionEquality()
                    .equals(other.isReadOnly, isReadOnly)) &&
            (identical(other.currentEraValue, currentEraValue) ||
                const DeepCollectionEquality()
                    .equals(other.currentEraValue, currentEraValue)) &&
            (identical(other.eras, eras) ||
                const DeepCollectionEquality().equals(other.eras, eras)) &&
            (identical(other.daysInYearBeforeMinSupportedYear,
                    daysInYearBeforeMinSupportedYear) ||
                const DeepCollectionEquality().equals(
                    other.daysInYearBeforeMinSupportedYear,
                    daysInYearBeforeMinSupportedYear)) &&
            (identical(other.twoDigitYearMax, twoDigitYearMax) ||
                const DeepCollectionEquality()
                    .equals(other.twoDigitYearMax, twoDigitYearMax)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(minSupportedDateTime) ^
      const DeepCollectionEquality().hash(maxSupportedDateTime) ^
      const DeepCollectionEquality().hash(algorithmType) ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(baseCalendarID) ^
      const DeepCollectionEquality().hash(isReadOnly) ^
      const DeepCollectionEquality().hash(currentEraValue) ^
      const DeepCollectionEquality().hash(eras) ^
      const DeepCollectionEquality().hash(daysInYearBeforeMinSupportedYear) ^
      const DeepCollectionEquality().hash(twoDigitYearMax) ^
      runtimeType.hashCode;
}

extension $CalendarExtension on Calendar {
  Calendar copyWith(
      {DateTime? minSupportedDateTime,
      DateTime? maxSupportedDateTime,
      enums.CalendarAlgorithmType? algorithmType,
      enums.CalendarId? id,
      enums.CalendarId? baseCalendarID,
      bool? isReadOnly,
      int? currentEraValue,
      List<int>? eras,
      int? daysInYearBeforeMinSupportedYear,
      int? twoDigitYearMax}) {
    return Calendar(
        minSupportedDateTime: minSupportedDateTime ?? this.minSupportedDateTime,
        maxSupportedDateTime: maxSupportedDateTime ?? this.maxSupportedDateTime,
        algorithmType: algorithmType ?? this.algorithmType,
        id: id ?? this.id,
        baseCalendarID: baseCalendarID ?? this.baseCalendarID,
        isReadOnly: isReadOnly ?? this.isReadOnly,
        currentEraValue: currentEraValue ?? this.currentEraValue,
        eras: eras ?? this.eras,
        daysInYearBeforeMinSupportedYear: daysInYearBeforeMinSupportedYear ??
            this.daysInYearBeforeMinSupportedYear,
        twoDigitYearMax: twoDigitYearMax ?? this.twoDigitYearMax);
  }

  Calendar copyWithWrapped(
      {Wrapped<DateTime>? minSupportedDateTime,
      Wrapped<DateTime>? maxSupportedDateTime,
      Wrapped<enums.CalendarAlgorithmType>? algorithmType,
      Wrapped<enums.CalendarId>? id,
      Wrapped<enums.CalendarId>? baseCalendarID,
      Wrapped<bool>? isReadOnly,
      Wrapped<int>? currentEraValue,
      Wrapped<List<int>>? eras,
      Wrapped<int>? daysInYearBeforeMinSupportedYear,
      Wrapped<int>? twoDigitYearMax}) {
    return Calendar(
        minSupportedDateTime: (minSupportedDateTime != null
            ? minSupportedDateTime.value
            : this.minSupportedDateTime),
        maxSupportedDateTime: (maxSupportedDateTime != null
            ? maxSupportedDateTime.value
            : this.maxSupportedDateTime),
        algorithmType:
            (algorithmType != null ? algorithmType.value : this.algorithmType),
        id: (id != null ? id.value : this.id),
        baseCalendarID: (baseCalendarID != null
            ? baseCalendarID.value
            : this.baseCalendarID),
        isReadOnly: (isReadOnly != null ? isReadOnly.value : this.isReadOnly),
        currentEraValue: (currentEraValue != null
            ? currentEraValue.value
            : this.currentEraValue),
        eras: (eras != null ? eras.value : this.eras),
        daysInYearBeforeMinSupportedYear:
            (daysInYearBeforeMinSupportedYear != null
                ? daysInYearBeforeMinSupportedYear.value
                : this.daysInYearBeforeMinSupportedYear),
        twoDigitYearMax: (twoDigitYearMax != null
            ? twoDigitYearMax.value
            : this.twoDigitYearMax));
  }
}

@JsonSerializable(explicitToJson: true)
class ServiceRepository {
  const ServiceRepository();

  factory ServiceRepository.fromJson(Map<String, dynamic> json) =>
      _$ServiceRepositoryFromJson(json);

  static const toJsonFactory = _$ServiceRepositoryToJson;
  Map<String, dynamic> toJson() => _$ServiceRepositoryToJson(this);

  static const fromJsonFactory = _$ServiceRepositoryFromJson;

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode => runtimeType.hashCode;
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
    required this.typeName,
    required this.typeNames,
    required this.friendlyName,
  });

  factory DeviceOverview.fromJson(Map<String, dynamic> json) =>
      _$DeviceOverviewFromJson(json);

  static const toJsonFactory = _$DeviceOverviewToJson;
  Map<String, dynamic> toJson() => _$DeviceOverviewToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'typeName')
  final String typeName;
  @JsonKey(name: 'typeNames', defaultValue: <String>[])
  final List<String> typeNames;
  @JsonKey(name: 'friendlyName')
  final String friendlyName;
  static const fromJsonFactory = _$DeviceOverviewFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DeviceOverview &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.typeName, typeName) ||
                const DeepCollectionEquality()
                    .equals(other.typeName, typeName)) &&
            (identical(other.typeNames, typeNames) ||
                const DeepCollectionEquality()
                    .equals(other.typeNames, typeNames)) &&
            (identical(other.friendlyName, friendlyName) ||
                const DeepCollectionEquality()
                    .equals(other.friendlyName, friendlyName)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(typeName) ^
      const DeepCollectionEquality().hash(typeNames) ^
      const DeepCollectionEquality().hash(friendlyName) ^
      runtimeType.hashCode;
}

extension $DeviceOverviewExtension on DeviceOverview {
  DeviceOverview copyWith(
      {int? id,
      String? typeName,
      List<String>? typeNames,
      String? friendlyName}) {
    return DeviceOverview(
        id: id ?? this.id,
        typeName: typeName ?? this.typeName,
        typeNames: typeNames ?? this.typeNames,
        friendlyName: friendlyName ?? this.friendlyName);
  }

  DeviceOverview copyWithWrapped(
      {Wrapped<int>? id,
      Wrapped<String>? typeName,
      Wrapped<List<String>>? typeNames,
      Wrapped<String>? friendlyName}) {
    return DeviceOverview(
        id: (id != null ? id.value : this.id),
        typeName: (typeName != null ? typeName.value : this.typeName),
        typeNames: (typeNames != null ? typeNames.value : this.typeNames),
        friendlyName:
            (friendlyName != null ? friendlyName.value : this.friendlyName));
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
  });

  factory LayoutResponse.fromJson(Map<String, dynamic> json) =>
      _$LayoutResponseFromJson(json);

  static const toJsonFactory = _$LayoutResponseToJson;
  Map<String, dynamic> toJson() => _$LayoutResponseToJson(this);

  @JsonKey(name: 'layout')
  final DeviceLayout? layout;
  @JsonKey(name: 'icon')
  final SvgIcon? icon;
  static const fromJsonFactory = _$LayoutResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LayoutResponse &&
            (identical(other.layout, layout) ||
                const DeepCollectionEquality().equals(other.layout, layout)) &&
            (identical(other.icon, icon) ||
                const DeepCollectionEquality().equals(other.icon, icon)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(layout) ^
      const DeepCollectionEquality().hash(icon) ^
      runtimeType.hashCode;
}

extension $LayoutResponseExtension on LayoutResponse {
  LayoutResponse copyWith({DeviceLayout? layout, SvgIcon? icon}) {
    return LayoutResponse(
        layout: layout ?? this.layout, icon: icon ?? this.icon);
  }

  LayoutResponse copyWithWrapped(
      {Wrapped<DeviceLayout?>? layout, Wrapped<SvgIcon?>? icon}) {
    return LayoutResponse(
        layout: (layout != null ? layout.value : this.layout),
        icon: (icon != null ? icon.value : this.icon));
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
    required this.additionalData,
    required this.version,
    required this.showOnlyInDeveloperMode,
    required this.hash,
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
  @JsonKey(name: 'additionalData')
  final Map<String, dynamic> additionalData;
  @JsonKey(name: 'version')
  final int version;
  @JsonKey(name: 'showOnlyInDeveloperMode')
  final bool showOnlyInDeveloperMode;
  @JsonKey(name: 'hash')
  final String hash;
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
            (identical(other.additionalData, additionalData) ||
                const DeepCollectionEquality()
                    .equals(other.additionalData, additionalData)) &&
            (identical(other.version, version) ||
                const DeepCollectionEquality()
                    .equals(other.version, version)) &&
            (identical(
                    other.showOnlyInDeveloperMode, showOnlyInDeveloperMode) ||
                const DeepCollectionEquality().equals(
                    other.showOnlyInDeveloperMode, showOnlyInDeveloperMode)) &&
            (identical(other.hash, hash) ||
                const DeepCollectionEquality().equals(other.hash, hash)));
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
      const DeepCollectionEquality().hash(additionalData) ^
      const DeepCollectionEquality().hash(version) ^
      const DeepCollectionEquality().hash(showOnlyInDeveloperMode) ^
      const DeepCollectionEquality().hash(hash) ^
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
      Map<String, dynamic>? additionalData,
      int? version,
      bool? showOnlyInDeveloperMode,
      String? hash}) {
    return DeviceLayout(
        uniqueName: uniqueName ?? this.uniqueName,
        iconName: iconName ?? this.iconName,
        typeName: typeName ?? this.typeName,
        typeNames: typeNames ?? this.typeNames,
        ids: ids ?? this.ids,
        dashboardDeviceLayout:
            dashboardDeviceLayout ?? this.dashboardDeviceLayout,
        detailDeviceLayout: detailDeviceLayout ?? this.detailDeviceLayout,
        additionalData: additionalData ?? this.additionalData,
        version: version ?? this.version,
        showOnlyInDeveloperMode:
            showOnlyInDeveloperMode ?? this.showOnlyInDeveloperMode,
        hash: hash ?? this.hash);
  }

  DeviceLayout copyWithWrapped(
      {Wrapped<String>? uniqueName,
      Wrapped<String>? iconName,
      Wrapped<String?>? typeName,
      Wrapped<List<String>?>? typeNames,
      Wrapped<List<int>?>? ids,
      Wrapped<DashboardDeviceLayout?>? dashboardDeviceLayout,
      Wrapped<DetailDeviceLayout?>? detailDeviceLayout,
      Wrapped<Map<String, dynamic>>? additionalData,
      Wrapped<int>? version,
      Wrapped<bool>? showOnlyInDeveloperMode,
      Wrapped<String>? hash}) {
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
        additionalData: (additionalData != null
            ? additionalData.value
            : this.additionalData),
        version: (version != null ? version.value : this.version),
        showOnlyInDeveloperMode: (showOnlyInDeveloperMode != null
            ? showOnlyInDeveloperMode.value
            : this.showOnlyInDeveloperMode),
        hash: (hash != null ? hash.value : this.hash));
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
    required this.editCommand,
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
    name: 'editCommand',
    toJson: messageTypeToJson,
    fromJson: messageTypeFromJson,
  )
  final enums.MessageType editCommand;
  @JsonKey(name: 'editParameter', defaultValue: <EditParameter>[])
  final List<EditParameter> editParameter;
  @JsonKey(
    name: 'editType',
    toJson: editTypeToJson,
    fromJson: editTypeFromJson,
  )
  final enums.EditType editType;
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
            (identical(other.editCommand, editCommand) ||
                const DeepCollectionEquality()
                    .equals(other.editCommand, editCommand)) &&
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
      const DeepCollectionEquality().hash(editCommand) ^
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
      {enums.MessageType? editCommand,
      List<EditParameter>? editParameter,
      enums.EditType? editType,
      String? display,
      String? hubMethod,
      String? valueName,
      dynamic activeValue,
      String? dialog,
      Map<String, dynamic>? extensionData}) {
    return PropertyEditInformation(
        editCommand: editCommand ?? this.editCommand,
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
      {Wrapped<enums.MessageType>? editCommand,
      Wrapped<List<EditParameter>>? editParameter,
      Wrapped<enums.EditType>? editType,
      Wrapped<String?>? display,
      Wrapped<String?>? hubMethod,
      Wrapped<String?>? valueName,
      Wrapped<dynamic>? activeValue,
      Wrapped<String?>? dialog,
      Wrapped<Map<String, dynamic>?>? extensionData}) {
    return PropertyEditInformation(
        editCommand:
            (editCommand != null ? editCommand.value : this.editCommand),
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
class JsonSmarthomeMessage {
  const JsonSmarthomeMessage({
    required this.parameters,
    required this.nodeId,
    required this.longNodeId,
    required this.messageType,
    required this.command,
  });

  factory JsonSmarthomeMessage.fromJson(Map<String, dynamic> json) =>
      _$JsonSmarthomeMessageFromJson(json);

  static const toJsonFactory = _$JsonSmarthomeMessageToJson;
  Map<String, dynamic> toJson() => _$JsonSmarthomeMessageToJson(this);

  @JsonKey(name: 'parameters', defaultValue: <Object>[])
  final List<Object> parameters;
  @JsonKey(name: 'nodeId')
  final int nodeId;
  @JsonKey(name: 'longNodeId')
  final int longNodeId;
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
  static const fromJsonFactory = _$JsonSmarthomeMessageFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is JsonSmarthomeMessage &&
            (identical(other.parameters, parameters) ||
                const DeepCollectionEquality()
                    .equals(other.parameters, parameters)) &&
            (identical(other.nodeId, nodeId) ||
                const DeepCollectionEquality().equals(other.nodeId, nodeId)) &&
            (identical(other.longNodeId, longNodeId) ||
                const DeepCollectionEquality()
                    .equals(other.longNodeId, longNodeId)) &&
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
      const DeepCollectionEquality().hash(nodeId) ^
      const DeepCollectionEquality().hash(longNodeId) ^
      const DeepCollectionEquality().hash(messageType) ^
      const DeepCollectionEquality().hash(command) ^
      runtimeType.hashCode;
}

extension $JsonSmarthomeMessageExtension on JsonSmarthomeMessage {
  JsonSmarthomeMessage copyWith(
      {List<Object>? parameters,
      int? nodeId,
      int? longNodeId,
      enums.MessageType? messageType,
      enums.Command2? command}) {
    return JsonSmarthomeMessage(
        parameters: parameters ?? this.parameters,
        nodeId: nodeId ?? this.nodeId,
        longNodeId: longNodeId ?? this.longNodeId,
        messageType: messageType ?? this.messageType,
        command: command ?? this.command);
  }

  JsonSmarthomeMessage copyWithWrapped(
      {Wrapped<List<Object>>? parameters,
      Wrapped<int>? nodeId,
      Wrapped<int>? longNodeId,
      Wrapped<enums.MessageType>? messageType,
      Wrapped<enums.Command2>? command}) {
    return JsonSmarthomeMessage(
        parameters: (parameters != null ? parameters.value : this.parameters),
        nodeId: (nodeId != null ? nodeId.value : this.nodeId),
        longNodeId: (longNodeId != null ? longNodeId.value : this.longNodeId),
        messageType:
            (messageType != null ? messageType.value : this.messageType),
        command: (command != null ? command.value : this.command));
  }
}

@JsonSerializable(explicitToJson: true)
class BaseSmarthomeMessage {
  const BaseSmarthomeMessage({
    required this.nodeId,
    required this.messageType,
    required this.command,
  });

  factory BaseSmarthomeMessage.fromJson(Map<String, dynamic> json) =>
      _$BaseSmarthomeMessageFromJson(json);

  static const toJsonFactory = _$BaseSmarthomeMessageToJson;
  Map<String, dynamic> toJson() => _$BaseSmarthomeMessageToJson(this);

  @JsonKey(name: 'nodeId')
  final int nodeId;
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
            (identical(other.nodeId, nodeId) ||
                const DeepCollectionEquality().equals(other.nodeId, nodeId)) &&
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
      const DeepCollectionEquality().hash(nodeId) ^
      const DeepCollectionEquality().hash(messageType) ^
      const DeepCollectionEquality().hash(command) ^
      runtimeType.hashCode;
}

extension $BaseSmarthomeMessageExtension on BaseSmarthomeMessage {
  BaseSmarthomeMessage copyWith(
      {int? nodeId, enums.MessageType? messageType, enums.Command2? command}) {
    return BaseSmarthomeMessage(
        nodeId: nodeId ?? this.nodeId,
        messageType: messageType ?? this.messageType,
        command: command ?? this.command);
  }

  BaseSmarthomeMessage copyWithWrapped(
      {Wrapped<int>? nodeId,
      Wrapped<enums.MessageType>? messageType,
      Wrapped<enums.Command2>? command}) {
    return BaseSmarthomeMessage(
        nodeId: (nodeId != null ? nodeId.value : this.nodeId),
        messageType:
            (messageType != null ? messageType.value : this.messageType),
        command: (command != null ? command.value : this.command));
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

int? stackTraceUsageNullableToJson(enums.StackTraceUsage? stackTraceUsage) {
  return stackTraceUsage?.value;
}

int? stackTraceUsageToJson(enums.StackTraceUsage stackTraceUsage) {
  return stackTraceUsage.value;
}

enums.StackTraceUsage stackTraceUsageFromJson(
  Object? stackTraceUsage, [
  enums.StackTraceUsage? defaultValue,
]) {
  return enums.StackTraceUsage.values
          .firstWhereOrNull((e) => e.value == stackTraceUsage) ??
      defaultValue ??
      enums.StackTraceUsage.swaggerGeneratedUnknown;
}

enums.StackTraceUsage? stackTraceUsageNullableFromJson(
  Object? stackTraceUsage, [
  enums.StackTraceUsage? defaultValue,
]) {
  if (stackTraceUsage == null) {
    return null;
  }
  return enums.StackTraceUsage.values
          .firstWhereOrNull((e) => e.value == stackTraceUsage) ??
      defaultValue;
}

String stackTraceUsageExplodedListToJson(
    List<enums.StackTraceUsage>? stackTraceUsage) {
  return stackTraceUsage?.map((e) => e.value!).join(',') ?? '';
}

List<int>? stackTraceUsageListToJson(
    List<enums.StackTraceUsage>? stackTraceUsage) {
  if (stackTraceUsage == null) {
    return null;
  }

  return stackTraceUsage.map((e) => e.value!).toList();
}

List<enums.StackTraceUsage> stackTraceUsageListFromJson(
  List? stackTraceUsage, [
  List<enums.StackTraceUsage>? defaultValue,
]) {
  if (stackTraceUsage == null) {
    return defaultValue ?? [];
  }

  return stackTraceUsage
      .map((e) => stackTraceUsageFromJson(e.toString()))
      .toList();
}

List<enums.StackTraceUsage>? stackTraceUsageNullableListFromJson(
  List? stackTraceUsage, [
  List<enums.StackTraceUsage>? defaultValue,
]) {
  if (stackTraceUsage == null) {
    return defaultValue;
  }

  return stackTraceUsage
      .map((e) => stackTraceUsageFromJson(e.toString()))
      .toList();
}

int? methodAttributesNullableToJson(enums.MethodAttributes? methodAttributes) {
  return methodAttributes?.value;
}

int? methodAttributesToJson(enums.MethodAttributes methodAttributes) {
  return methodAttributes.value;
}

enums.MethodAttributes methodAttributesFromJson(
  Object? methodAttributes, [
  enums.MethodAttributes? defaultValue,
]) {
  return enums.MethodAttributes.values
          .firstWhereOrNull((e) => e.value == methodAttributes) ??
      defaultValue ??
      enums.MethodAttributes.swaggerGeneratedUnknown;
}

enums.MethodAttributes? methodAttributesNullableFromJson(
  Object? methodAttributes, [
  enums.MethodAttributes? defaultValue,
]) {
  if (methodAttributes == null) {
    return null;
  }
  return enums.MethodAttributes.values
          .firstWhereOrNull((e) => e.value == methodAttributes) ??
      defaultValue;
}

String methodAttributesExplodedListToJson(
    List<enums.MethodAttributes>? methodAttributes) {
  return methodAttributes?.map((e) => e.value!).join(',') ?? '';
}

List<int>? methodAttributesListToJson(
    List<enums.MethodAttributes>? methodAttributes) {
  if (methodAttributes == null) {
    return null;
  }

  return methodAttributes.map((e) => e.value!).toList();
}

List<enums.MethodAttributes> methodAttributesListFromJson(
  List? methodAttributes, [
  List<enums.MethodAttributes>? defaultValue,
]) {
  if (methodAttributes == null) {
    return defaultValue ?? [];
  }

  return methodAttributes
      .map((e) => methodAttributesFromJson(e.toString()))
      .toList();
}

List<enums.MethodAttributes>? methodAttributesNullableListFromJson(
  List? methodAttributes, [
  List<enums.MethodAttributes>? defaultValue,
]) {
  if (methodAttributes == null) {
    return defaultValue;
  }

  return methodAttributes
      .map((e) => methodAttributesFromJson(e.toString()))
      .toList();
}

int? methodImplAttributesNullableToJson(
    enums.MethodImplAttributes? methodImplAttributes) {
  return methodImplAttributes?.value;
}

int? methodImplAttributesToJson(
    enums.MethodImplAttributes methodImplAttributes) {
  return methodImplAttributes.value;
}

enums.MethodImplAttributes methodImplAttributesFromJson(
  Object? methodImplAttributes, [
  enums.MethodImplAttributes? defaultValue,
]) {
  return enums.MethodImplAttributes.values
          .firstWhereOrNull((e) => e.value == methodImplAttributes) ??
      defaultValue ??
      enums.MethodImplAttributes.swaggerGeneratedUnknown;
}

enums.MethodImplAttributes? methodImplAttributesNullableFromJson(
  Object? methodImplAttributes, [
  enums.MethodImplAttributes? defaultValue,
]) {
  if (methodImplAttributes == null) {
    return null;
  }
  return enums.MethodImplAttributes.values
          .firstWhereOrNull((e) => e.value == methodImplAttributes) ??
      defaultValue;
}

String methodImplAttributesExplodedListToJson(
    List<enums.MethodImplAttributes>? methodImplAttributes) {
  return methodImplAttributes?.map((e) => e.value!).join(',') ?? '';
}

List<int>? methodImplAttributesListToJson(
    List<enums.MethodImplAttributes>? methodImplAttributes) {
  if (methodImplAttributes == null) {
    return null;
  }

  return methodImplAttributes.map((e) => e.value!).toList();
}

List<enums.MethodImplAttributes> methodImplAttributesListFromJson(
  List? methodImplAttributes, [
  List<enums.MethodImplAttributes>? defaultValue,
]) {
  if (methodImplAttributes == null) {
    return defaultValue ?? [];
  }

  return methodImplAttributes
      .map((e) => methodImplAttributesFromJson(e.toString()))
      .toList();
}

List<enums.MethodImplAttributes>? methodImplAttributesNullableListFromJson(
  List? methodImplAttributes, [
  List<enums.MethodImplAttributes>? defaultValue,
]) {
  if (methodImplAttributes == null) {
    return defaultValue;
  }

  return methodImplAttributes
      .map((e) => methodImplAttributesFromJson(e.toString()))
      .toList();
}

int? callingConventionsNullableToJson(
    enums.CallingConventions? callingConventions) {
  return callingConventions?.value;
}

int? callingConventionsToJson(enums.CallingConventions callingConventions) {
  return callingConventions.value;
}

enums.CallingConventions callingConventionsFromJson(
  Object? callingConventions, [
  enums.CallingConventions? defaultValue,
]) {
  return enums.CallingConventions.values
          .firstWhereOrNull((e) => e.value == callingConventions) ??
      defaultValue ??
      enums.CallingConventions.swaggerGeneratedUnknown;
}

enums.CallingConventions? callingConventionsNullableFromJson(
  Object? callingConventions, [
  enums.CallingConventions? defaultValue,
]) {
  if (callingConventions == null) {
    return null;
  }
  return enums.CallingConventions.values
          .firstWhereOrNull((e) => e.value == callingConventions) ??
      defaultValue;
}

String callingConventionsExplodedListToJson(
    List<enums.CallingConventions>? callingConventions) {
  return callingConventions?.map((e) => e.value!).join(',') ?? '';
}

List<int>? callingConventionsListToJson(
    List<enums.CallingConventions>? callingConventions) {
  if (callingConventions == null) {
    return null;
  }

  return callingConventions.map((e) => e.value!).toList();
}

List<enums.CallingConventions> callingConventionsListFromJson(
  List? callingConventions, [
  List<enums.CallingConventions>? defaultValue,
]) {
  if (callingConventions == null) {
    return defaultValue ?? [];
  }

  return callingConventions
      .map((e) => callingConventionsFromJson(e.toString()))
      .toList();
}

List<enums.CallingConventions>? callingConventionsNullableListFromJson(
  List? callingConventions, [
  List<enums.CallingConventions>? defaultValue,
]) {
  if (callingConventions == null) {
    return defaultValue;
  }

  return callingConventions
      .map((e) => callingConventionsFromJson(e.toString()))
      .toList();
}

int? memberTypesNullableToJson(enums.MemberTypes? memberTypes) {
  return memberTypes?.value;
}

int? memberTypesToJson(enums.MemberTypes memberTypes) {
  return memberTypes.value;
}

enums.MemberTypes memberTypesFromJson(
  Object? memberTypes, [
  enums.MemberTypes? defaultValue,
]) {
  return enums.MemberTypes.values
          .firstWhereOrNull((e) => e.value == memberTypes) ??
      defaultValue ??
      enums.MemberTypes.swaggerGeneratedUnknown;
}

enums.MemberTypes? memberTypesNullableFromJson(
  Object? memberTypes, [
  enums.MemberTypes? defaultValue,
]) {
  if (memberTypes == null) {
    return null;
  }
  return enums.MemberTypes.values
          .firstWhereOrNull((e) => e.value == memberTypes) ??
      defaultValue;
}

String memberTypesExplodedListToJson(List<enums.MemberTypes>? memberTypes) {
  return memberTypes?.map((e) => e.value!).join(',') ?? '';
}

List<int>? memberTypesListToJson(List<enums.MemberTypes>? memberTypes) {
  if (memberTypes == null) {
    return null;
  }

  return memberTypes.map((e) => e.value!).toList();
}

List<enums.MemberTypes> memberTypesListFromJson(
  List? memberTypes, [
  List<enums.MemberTypes>? defaultValue,
]) {
  if (memberTypes == null) {
    return defaultValue ?? [];
  }

  return memberTypes.map((e) => memberTypesFromJson(e.toString())).toList();
}

List<enums.MemberTypes>? memberTypesNullableListFromJson(
  List? memberTypes, [
  List<enums.MemberTypes>? defaultValue,
]) {
  if (memberTypes == null) {
    return defaultValue;
  }

  return memberTypes.map((e) => memberTypesFromJson(e.toString())).toList();
}

int? eventAttributesNullableToJson(enums.EventAttributes? eventAttributes) {
  return eventAttributes?.value;
}

int? eventAttributesToJson(enums.EventAttributes eventAttributes) {
  return eventAttributes.value;
}

enums.EventAttributes eventAttributesFromJson(
  Object? eventAttributes, [
  enums.EventAttributes? defaultValue,
]) {
  return enums.EventAttributes.values
          .firstWhereOrNull((e) => e.value == eventAttributes) ??
      defaultValue ??
      enums.EventAttributes.swaggerGeneratedUnknown;
}

enums.EventAttributes? eventAttributesNullableFromJson(
  Object? eventAttributes, [
  enums.EventAttributes? defaultValue,
]) {
  if (eventAttributes == null) {
    return null;
  }
  return enums.EventAttributes.values
          .firstWhereOrNull((e) => e.value == eventAttributes) ??
      defaultValue;
}

String eventAttributesExplodedListToJson(
    List<enums.EventAttributes>? eventAttributes) {
  return eventAttributes?.map((e) => e.value!).join(',') ?? '';
}

List<int>? eventAttributesListToJson(
    List<enums.EventAttributes>? eventAttributes) {
  if (eventAttributes == null) {
    return null;
  }

  return eventAttributes.map((e) => e.value!).toList();
}

List<enums.EventAttributes> eventAttributesListFromJson(
  List? eventAttributes, [
  List<enums.EventAttributes>? defaultValue,
]) {
  if (eventAttributes == null) {
    return defaultValue ?? [];
  }

  return eventAttributes
      .map((e) => eventAttributesFromJson(e.toString()))
      .toList();
}

List<enums.EventAttributes>? eventAttributesNullableListFromJson(
  List? eventAttributes, [
  List<enums.EventAttributes>? defaultValue,
]) {
  if (eventAttributes == null) {
    return defaultValue;
  }

  return eventAttributes
      .map((e) => eventAttributesFromJson(e.toString()))
      .toList();
}

int? parameterAttributesNullableToJson(
    enums.ParameterAttributes? parameterAttributes) {
  return parameterAttributes?.value;
}

int? parameterAttributesToJson(enums.ParameterAttributes parameterAttributes) {
  return parameterAttributes.value;
}

enums.ParameterAttributes parameterAttributesFromJson(
  Object? parameterAttributes, [
  enums.ParameterAttributes? defaultValue,
]) {
  return enums.ParameterAttributes.values
          .firstWhereOrNull((e) => e.value == parameterAttributes) ??
      defaultValue ??
      enums.ParameterAttributes.swaggerGeneratedUnknown;
}

enums.ParameterAttributes? parameterAttributesNullableFromJson(
  Object? parameterAttributes, [
  enums.ParameterAttributes? defaultValue,
]) {
  if (parameterAttributes == null) {
    return null;
  }
  return enums.ParameterAttributes.values
          .firstWhereOrNull((e) => e.value == parameterAttributes) ??
      defaultValue;
}

String parameterAttributesExplodedListToJson(
    List<enums.ParameterAttributes>? parameterAttributes) {
  return parameterAttributes?.map((e) => e.value!).join(',') ?? '';
}

List<int>? parameterAttributesListToJson(
    List<enums.ParameterAttributes>? parameterAttributes) {
  if (parameterAttributes == null) {
    return null;
  }

  return parameterAttributes.map((e) => e.value!).toList();
}

List<enums.ParameterAttributes> parameterAttributesListFromJson(
  List? parameterAttributes, [
  List<enums.ParameterAttributes>? defaultValue,
]) {
  if (parameterAttributes == null) {
    return defaultValue ?? [];
  }

  return parameterAttributes
      .map((e) => parameterAttributesFromJson(e.toString()))
      .toList();
}

List<enums.ParameterAttributes>? parameterAttributesNullableListFromJson(
  List? parameterAttributes, [
  List<enums.ParameterAttributes>? defaultValue,
]) {
  if (parameterAttributes == null) {
    return defaultValue;
  }

  return parameterAttributes
      .map((e) => parameterAttributesFromJson(e.toString()))
      .toList();
}

int? fieldAttributesNullableToJson(enums.FieldAttributes? fieldAttributes) {
  return fieldAttributes?.value;
}

int? fieldAttributesToJson(enums.FieldAttributes fieldAttributes) {
  return fieldAttributes.value;
}

enums.FieldAttributes fieldAttributesFromJson(
  Object? fieldAttributes, [
  enums.FieldAttributes? defaultValue,
]) {
  return enums.FieldAttributes.values
          .firstWhereOrNull((e) => e.value == fieldAttributes) ??
      defaultValue ??
      enums.FieldAttributes.swaggerGeneratedUnknown;
}

enums.FieldAttributes? fieldAttributesNullableFromJson(
  Object? fieldAttributes, [
  enums.FieldAttributes? defaultValue,
]) {
  if (fieldAttributes == null) {
    return null;
  }
  return enums.FieldAttributes.values
          .firstWhereOrNull((e) => e.value == fieldAttributes) ??
      defaultValue;
}

String fieldAttributesExplodedListToJson(
    List<enums.FieldAttributes>? fieldAttributes) {
  return fieldAttributes?.map((e) => e.value!).join(',') ?? '';
}

List<int>? fieldAttributesListToJson(
    List<enums.FieldAttributes>? fieldAttributes) {
  if (fieldAttributes == null) {
    return null;
  }

  return fieldAttributes.map((e) => e.value!).toList();
}

List<enums.FieldAttributes> fieldAttributesListFromJson(
  List? fieldAttributes, [
  List<enums.FieldAttributes>? defaultValue,
]) {
  if (fieldAttributes == null) {
    return defaultValue ?? [];
  }

  return fieldAttributes
      .map((e) => fieldAttributesFromJson(e.toString()))
      .toList();
}

List<enums.FieldAttributes>? fieldAttributesNullableListFromJson(
  List? fieldAttributes, [
  List<enums.FieldAttributes>? defaultValue,
]) {
  if (fieldAttributes == null) {
    return defaultValue;
  }

  return fieldAttributes
      .map((e) => fieldAttributesFromJson(e.toString()))
      .toList();
}

int? propertyAttributesNullableToJson(
    enums.PropertyAttributes? propertyAttributes) {
  return propertyAttributes?.value;
}

int? propertyAttributesToJson(enums.PropertyAttributes propertyAttributes) {
  return propertyAttributes.value;
}

enums.PropertyAttributes propertyAttributesFromJson(
  Object? propertyAttributes, [
  enums.PropertyAttributes? defaultValue,
]) {
  return enums.PropertyAttributes.values
          .firstWhereOrNull((e) => e.value == propertyAttributes) ??
      defaultValue ??
      enums.PropertyAttributes.swaggerGeneratedUnknown;
}

enums.PropertyAttributes? propertyAttributesNullableFromJson(
  Object? propertyAttributes, [
  enums.PropertyAttributes? defaultValue,
]) {
  if (propertyAttributes == null) {
    return null;
  }
  return enums.PropertyAttributes.values
          .firstWhereOrNull((e) => e.value == propertyAttributes) ??
      defaultValue;
}

String propertyAttributesExplodedListToJson(
    List<enums.PropertyAttributes>? propertyAttributes) {
  return propertyAttributes?.map((e) => e.value!).join(',') ?? '';
}

List<int>? propertyAttributesListToJson(
    List<enums.PropertyAttributes>? propertyAttributes) {
  if (propertyAttributes == null) {
    return null;
  }

  return propertyAttributes.map((e) => e.value!).toList();
}

List<enums.PropertyAttributes> propertyAttributesListFromJson(
  List? propertyAttributes, [
  List<enums.PropertyAttributes>? defaultValue,
]) {
  if (propertyAttributes == null) {
    return defaultValue ?? [];
  }

  return propertyAttributes
      .map((e) => propertyAttributesFromJson(e.toString()))
      .toList();
}

List<enums.PropertyAttributes>? propertyAttributesNullableListFromJson(
  List? propertyAttributes, [
  List<enums.PropertyAttributes>? defaultValue,
]) {
  if (propertyAttributes == null) {
    return defaultValue;
  }

  return propertyAttributes
      .map((e) => propertyAttributesFromJson(e.toString()))
      .toList();
}

int? securityRuleSetNullableToJson(enums.SecurityRuleSet? securityRuleSet) {
  return securityRuleSet?.value;
}

int? securityRuleSetToJson(enums.SecurityRuleSet securityRuleSet) {
  return securityRuleSet.value;
}

enums.SecurityRuleSet securityRuleSetFromJson(
  Object? securityRuleSet, [
  enums.SecurityRuleSet? defaultValue,
]) {
  return enums.SecurityRuleSet.values
          .firstWhereOrNull((e) => e.value == securityRuleSet) ??
      defaultValue ??
      enums.SecurityRuleSet.swaggerGeneratedUnknown;
}

enums.SecurityRuleSet? securityRuleSetNullableFromJson(
  Object? securityRuleSet, [
  enums.SecurityRuleSet? defaultValue,
]) {
  if (securityRuleSet == null) {
    return null;
  }
  return enums.SecurityRuleSet.values
          .firstWhereOrNull((e) => e.value == securityRuleSet) ??
      defaultValue;
}

String securityRuleSetExplodedListToJson(
    List<enums.SecurityRuleSet>? securityRuleSet) {
  return securityRuleSet?.map((e) => e.value!).join(',') ?? '';
}

List<int>? securityRuleSetListToJson(
    List<enums.SecurityRuleSet>? securityRuleSet) {
  if (securityRuleSet == null) {
    return null;
  }

  return securityRuleSet.map((e) => e.value!).toList();
}

List<enums.SecurityRuleSet> securityRuleSetListFromJson(
  List? securityRuleSet, [
  List<enums.SecurityRuleSet>? defaultValue,
]) {
  if (securityRuleSet == null) {
    return defaultValue ?? [];
  }

  return securityRuleSet
      .map((e) => securityRuleSetFromJson(e.toString()))
      .toList();
}

List<enums.SecurityRuleSet>? securityRuleSetNullableListFromJson(
  List? securityRuleSet, [
  List<enums.SecurityRuleSet>? defaultValue,
]) {
  if (securityRuleSet == null) {
    return defaultValue;
  }

  return securityRuleSet
      .map((e) => securityRuleSetFromJson(e.toString()))
      .toList();
}

int? filterResultNullableToJson(enums.FilterResult? filterResult) {
  return filterResult?.value;
}

int? filterResultToJson(enums.FilterResult filterResult) {
  return filterResult.value;
}

enums.FilterResult filterResultFromJson(
  Object? filterResult, [
  enums.FilterResult? defaultValue,
]) {
  return enums.FilterResult.values
          .firstWhereOrNull((e) => e.value == filterResult) ??
      defaultValue ??
      enums.FilterResult.swaggerGeneratedUnknown;
}

enums.FilterResult? filterResultNullableFromJson(
  Object? filterResult, [
  enums.FilterResult? defaultValue,
]) {
  if (filterResult == null) {
    return null;
  }
  return enums.FilterResult.values
          .firstWhereOrNull((e) => e.value == filterResult) ??
      defaultValue;
}

String filterResultExplodedListToJson(List<enums.FilterResult>? filterResult) {
  return filterResult?.map((e) => e.value!).join(',') ?? '';
}

List<int>? filterResultListToJson(List<enums.FilterResult>? filterResult) {
  if (filterResult == null) {
    return null;
  }

  return filterResult.map((e) => e.value!).toList();
}

List<enums.FilterResult> filterResultListFromJson(
  List? filterResult, [
  List<enums.FilterResult>? defaultValue,
]) {
  if (filterResult == null) {
    return defaultValue ?? [];
  }

  return filterResult.map((e) => filterResultFromJson(e.toString())).toList();
}

List<enums.FilterResult>? filterResultNullableListFromJson(
  List? filterResult, [
  List<enums.FilterResult>? defaultValue,
]) {
  if (filterResult == null) {
    return defaultValue;
  }

  return filterResult.map((e) => filterResultFromJson(e.toString())).toList();
}

int? cultureTypesNullableToJson(enums.CultureTypes? cultureTypes) {
  return cultureTypes?.value;
}

int? cultureTypesToJson(enums.CultureTypes cultureTypes) {
  return cultureTypes.value;
}

enums.CultureTypes cultureTypesFromJson(
  Object? cultureTypes, [
  enums.CultureTypes? defaultValue,
]) {
  return enums.CultureTypes.values
          .firstWhereOrNull((e) => e.value == cultureTypes) ??
      defaultValue ??
      enums.CultureTypes.swaggerGeneratedUnknown;
}

enums.CultureTypes? cultureTypesNullableFromJson(
  Object? cultureTypes, [
  enums.CultureTypes? defaultValue,
]) {
  if (cultureTypes == null) {
    return null;
  }
  return enums.CultureTypes.values
          .firstWhereOrNull((e) => e.value == cultureTypes) ??
      defaultValue;
}

String cultureTypesExplodedListToJson(List<enums.CultureTypes>? cultureTypes) {
  return cultureTypes?.map((e) => e.value!).join(',') ?? '';
}

List<int>? cultureTypesListToJson(List<enums.CultureTypes>? cultureTypes) {
  if (cultureTypes == null) {
    return null;
  }

  return cultureTypes.map((e) => e.value!).toList();
}

List<enums.CultureTypes> cultureTypesListFromJson(
  List? cultureTypes, [
  List<enums.CultureTypes>? defaultValue,
]) {
  if (cultureTypes == null) {
    return defaultValue ?? [];
  }

  return cultureTypes.map((e) => cultureTypesFromJson(e.toString())).toList();
}

List<enums.CultureTypes>? cultureTypesNullableListFromJson(
  List? cultureTypes, [
  List<enums.CultureTypes>? defaultValue,
]) {
  if (cultureTypes == null) {
    return defaultValue;
  }

  return cultureTypes.map((e) => cultureTypesFromJson(e.toString())).toList();
}

int? digitShapesNullableToJson(enums.DigitShapes? digitShapes) {
  return digitShapes?.value;
}

int? digitShapesToJson(enums.DigitShapes digitShapes) {
  return digitShapes.value;
}

enums.DigitShapes digitShapesFromJson(
  Object? digitShapes, [
  enums.DigitShapes? defaultValue,
]) {
  return enums.DigitShapes.values
          .firstWhereOrNull((e) => e.value == digitShapes) ??
      defaultValue ??
      enums.DigitShapes.swaggerGeneratedUnknown;
}

enums.DigitShapes? digitShapesNullableFromJson(
  Object? digitShapes, [
  enums.DigitShapes? defaultValue,
]) {
  if (digitShapes == null) {
    return null;
  }
  return enums.DigitShapes.values
          .firstWhereOrNull((e) => e.value == digitShapes) ??
      defaultValue;
}

String digitShapesExplodedListToJson(List<enums.DigitShapes>? digitShapes) {
  return digitShapes?.map((e) => e.value!).join(',') ?? '';
}

List<int>? digitShapesListToJson(List<enums.DigitShapes>? digitShapes) {
  if (digitShapes == null) {
    return null;
  }

  return digitShapes.map((e) => e.value!).toList();
}

List<enums.DigitShapes> digitShapesListFromJson(
  List? digitShapes, [
  List<enums.DigitShapes>? defaultValue,
]) {
  if (digitShapes == null) {
    return defaultValue ?? [];
  }

  return digitShapes.map((e) => digitShapesFromJson(e.toString())).toList();
}

List<enums.DigitShapes>? digitShapesNullableListFromJson(
  List? digitShapes, [
  List<enums.DigitShapes>? defaultValue,
]) {
  if (digitShapes == null) {
    return defaultValue;
  }

  return digitShapes.map((e) => digitShapesFromJson(e.toString())).toList();
}

int? calendarAlgorithmTypeNullableToJson(
    enums.CalendarAlgorithmType? calendarAlgorithmType) {
  return calendarAlgorithmType?.value;
}

int? calendarAlgorithmTypeToJson(
    enums.CalendarAlgorithmType calendarAlgorithmType) {
  return calendarAlgorithmType.value;
}

enums.CalendarAlgorithmType calendarAlgorithmTypeFromJson(
  Object? calendarAlgorithmType, [
  enums.CalendarAlgorithmType? defaultValue,
]) {
  return enums.CalendarAlgorithmType.values
          .firstWhereOrNull((e) => e.value == calendarAlgorithmType) ??
      defaultValue ??
      enums.CalendarAlgorithmType.swaggerGeneratedUnknown;
}

enums.CalendarAlgorithmType? calendarAlgorithmTypeNullableFromJson(
  Object? calendarAlgorithmType, [
  enums.CalendarAlgorithmType? defaultValue,
]) {
  if (calendarAlgorithmType == null) {
    return null;
  }
  return enums.CalendarAlgorithmType.values
          .firstWhereOrNull((e) => e.value == calendarAlgorithmType) ??
      defaultValue;
}

String calendarAlgorithmTypeExplodedListToJson(
    List<enums.CalendarAlgorithmType>? calendarAlgorithmType) {
  return calendarAlgorithmType?.map((e) => e.value!).join(',') ?? '';
}

List<int>? calendarAlgorithmTypeListToJson(
    List<enums.CalendarAlgorithmType>? calendarAlgorithmType) {
  if (calendarAlgorithmType == null) {
    return null;
  }

  return calendarAlgorithmType.map((e) => e.value!).toList();
}

List<enums.CalendarAlgorithmType> calendarAlgorithmTypeListFromJson(
  List? calendarAlgorithmType, [
  List<enums.CalendarAlgorithmType>? defaultValue,
]) {
  if (calendarAlgorithmType == null) {
    return defaultValue ?? [];
  }

  return calendarAlgorithmType
      .map((e) => calendarAlgorithmTypeFromJson(e.toString()))
      .toList();
}

List<enums.CalendarAlgorithmType>? calendarAlgorithmTypeNullableListFromJson(
  List? calendarAlgorithmType, [
  List<enums.CalendarAlgorithmType>? defaultValue,
]) {
  if (calendarAlgorithmType == null) {
    return defaultValue;
  }

  return calendarAlgorithmType
      .map((e) => calendarAlgorithmTypeFromJson(e.toString()))
      .toList();
}

int? calendarIdNullableToJson(enums.CalendarId? calendarId) {
  return calendarId?.value;
}

int? calendarIdToJson(enums.CalendarId calendarId) {
  return calendarId.value;
}

enums.CalendarId calendarIdFromJson(
  Object? calendarId, [
  enums.CalendarId? defaultValue,
]) {
  return enums.CalendarId.values
          .firstWhereOrNull((e) => e.value == calendarId) ??
      defaultValue ??
      enums.CalendarId.swaggerGeneratedUnknown;
}

enums.CalendarId? calendarIdNullableFromJson(
  Object? calendarId, [
  enums.CalendarId? defaultValue,
]) {
  if (calendarId == null) {
    return null;
  }
  return enums.CalendarId.values
          .firstWhereOrNull((e) => e.value == calendarId) ??
      defaultValue;
}

String calendarIdExplodedListToJson(List<enums.CalendarId>? calendarId) {
  return calendarId?.map((e) => e.value!).join(',') ?? '';
}

List<int>? calendarIdListToJson(List<enums.CalendarId>? calendarId) {
  if (calendarId == null) {
    return null;
  }

  return calendarId.map((e) => e.value!).toList();
}

List<enums.CalendarId> calendarIdListFromJson(
  List? calendarId, [
  List<enums.CalendarId>? defaultValue,
]) {
  if (calendarId == null) {
    return defaultValue ?? [];
  }

  return calendarId.map((e) => calendarIdFromJson(e.toString())).toList();
}

List<enums.CalendarId>? calendarIdNullableListFromJson(
  List? calendarId, [
  List<enums.CalendarId>? defaultValue,
]) {
  if (calendarId == null) {
    return defaultValue;
  }

  return calendarId.map((e) => calendarIdFromJson(e.toString())).toList();
}

int? dayOfWeekNullableToJson(enums.DayOfWeek? dayOfWeek) {
  return dayOfWeek?.value;
}

int? dayOfWeekToJson(enums.DayOfWeek dayOfWeek) {
  return dayOfWeek.value;
}

enums.DayOfWeek dayOfWeekFromJson(
  Object? dayOfWeek, [
  enums.DayOfWeek? defaultValue,
]) {
  return enums.DayOfWeek.values.firstWhereOrNull((e) => e.value == dayOfWeek) ??
      defaultValue ??
      enums.DayOfWeek.swaggerGeneratedUnknown;
}

enums.DayOfWeek? dayOfWeekNullableFromJson(
  Object? dayOfWeek, [
  enums.DayOfWeek? defaultValue,
]) {
  if (dayOfWeek == null) {
    return null;
  }
  return enums.DayOfWeek.values.firstWhereOrNull((e) => e.value == dayOfWeek) ??
      defaultValue;
}

String dayOfWeekExplodedListToJson(List<enums.DayOfWeek>? dayOfWeek) {
  return dayOfWeek?.map((e) => e.value!).join(',') ?? '';
}

List<int>? dayOfWeekListToJson(List<enums.DayOfWeek>? dayOfWeek) {
  if (dayOfWeek == null) {
    return null;
  }

  return dayOfWeek.map((e) => e.value!).toList();
}

List<enums.DayOfWeek> dayOfWeekListFromJson(
  List? dayOfWeek, [
  List<enums.DayOfWeek>? defaultValue,
]) {
  if (dayOfWeek == null) {
    return defaultValue ?? [];
  }

  return dayOfWeek.map((e) => dayOfWeekFromJson(e.toString())).toList();
}

List<enums.DayOfWeek>? dayOfWeekNullableListFromJson(
  List? dayOfWeek, [
  List<enums.DayOfWeek>? defaultValue,
]) {
  if (dayOfWeek == null) {
    return defaultValue;
  }

  return dayOfWeek.map((e) => dayOfWeekFromJson(e.toString())).toList();
}

int? calendarWeekRuleNullableToJson(enums.CalendarWeekRule? calendarWeekRule) {
  return calendarWeekRule?.value;
}

int? calendarWeekRuleToJson(enums.CalendarWeekRule calendarWeekRule) {
  return calendarWeekRule.value;
}

enums.CalendarWeekRule calendarWeekRuleFromJson(
  Object? calendarWeekRule, [
  enums.CalendarWeekRule? defaultValue,
]) {
  return enums.CalendarWeekRule.values
          .firstWhereOrNull((e) => e.value == calendarWeekRule) ??
      defaultValue ??
      enums.CalendarWeekRule.swaggerGeneratedUnknown;
}

enums.CalendarWeekRule? calendarWeekRuleNullableFromJson(
  Object? calendarWeekRule, [
  enums.CalendarWeekRule? defaultValue,
]) {
  if (calendarWeekRule == null) {
    return null;
  }
  return enums.CalendarWeekRule.values
          .firstWhereOrNull((e) => e.value == calendarWeekRule) ??
      defaultValue;
}

String calendarWeekRuleExplodedListToJson(
    List<enums.CalendarWeekRule>? calendarWeekRule) {
  return calendarWeekRule?.map((e) => e.value!).join(',') ?? '';
}

List<int>? calendarWeekRuleListToJson(
    List<enums.CalendarWeekRule>? calendarWeekRule) {
  if (calendarWeekRule == null) {
    return null;
  }

  return calendarWeekRule.map((e) => e.value!).toList();
}

List<enums.CalendarWeekRule> calendarWeekRuleListFromJson(
  List? calendarWeekRule, [
  List<enums.CalendarWeekRule>? defaultValue,
]) {
  if (calendarWeekRule == null) {
    return defaultValue ?? [];
  }

  return calendarWeekRule
      .map((e) => calendarWeekRuleFromJson(e.toString()))
      .toList();
}

List<enums.CalendarWeekRule>? calendarWeekRuleNullableListFromJson(
  List? calendarWeekRule, [
  List<enums.CalendarWeekRule>? defaultValue,
]) {
  if (calendarWeekRule == null) {
    return defaultValue;
  }

  return calendarWeekRule
      .map((e) => calendarWeekRuleFromJson(e.toString()))
      .toList();
}

int? dateTimeFormatFlagsNullableToJson(
    enums.DateTimeFormatFlags? dateTimeFormatFlags) {
  return dateTimeFormatFlags?.value;
}

int? dateTimeFormatFlagsToJson(enums.DateTimeFormatFlags dateTimeFormatFlags) {
  return dateTimeFormatFlags.value;
}

enums.DateTimeFormatFlags dateTimeFormatFlagsFromJson(
  Object? dateTimeFormatFlags, [
  enums.DateTimeFormatFlags? defaultValue,
]) {
  return enums.DateTimeFormatFlags.values
          .firstWhereOrNull((e) => e.value == dateTimeFormatFlags) ??
      defaultValue ??
      enums.DateTimeFormatFlags.swaggerGeneratedUnknown;
}

enums.DateTimeFormatFlags? dateTimeFormatFlagsNullableFromJson(
  Object? dateTimeFormatFlags, [
  enums.DateTimeFormatFlags? defaultValue,
]) {
  if (dateTimeFormatFlags == null) {
    return null;
  }
  return enums.DateTimeFormatFlags.values
          .firstWhereOrNull((e) => e.value == dateTimeFormatFlags) ??
      defaultValue;
}

String dateTimeFormatFlagsExplodedListToJson(
    List<enums.DateTimeFormatFlags>? dateTimeFormatFlags) {
  return dateTimeFormatFlags?.map((e) => e.value!).join(',') ?? '';
}

List<int>? dateTimeFormatFlagsListToJson(
    List<enums.DateTimeFormatFlags>? dateTimeFormatFlags) {
  if (dateTimeFormatFlags == null) {
    return null;
  }

  return dateTimeFormatFlags.map((e) => e.value!).toList();
}

List<enums.DateTimeFormatFlags> dateTimeFormatFlagsListFromJson(
  List? dateTimeFormatFlags, [
  List<enums.DateTimeFormatFlags>? defaultValue,
]) {
  if (dateTimeFormatFlags == null) {
    return defaultValue ?? [];
  }

  return dateTimeFormatFlags
      .map((e) => dateTimeFormatFlagsFromJson(e.toString()))
      .toList();
}

List<enums.DateTimeFormatFlags>? dateTimeFormatFlagsNullableListFromJson(
  List? dateTimeFormatFlags, [
  List<enums.DateTimeFormatFlags>? defaultValue,
]) {
  if (dateTimeFormatFlags == null) {
    return defaultValue;
  }

  return dateTimeFormatFlags
      .map((e) => dateTimeFormatFlagsFromJson(e.toString()))
      .toList();
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

String? editTypeNullableToJson(enums.EditType? editType) {
  return editType?.value;
}

String? editTypeToJson(enums.EditType editType) {
  return editType.value;
}

enums.EditType editTypeFromJson(
  Object? editType, [
  enums.EditType? defaultValue,
]) {
  return enums.EditType.values.firstWhereOrNull((e) => e.value == editType) ??
      defaultValue ??
      enums.EditType.swaggerGeneratedUnknown;
}

enums.EditType? editTypeNullableFromJson(
  Object? editType, [
  enums.EditType? defaultValue,
]) {
  if (editType == null) {
    return null;
  }
  return enums.EditType.values.firstWhereOrNull((e) => e.value == editType) ??
      defaultValue;
}

String editTypeExplodedListToJson(List<enums.EditType>? editType) {
  return editType?.map((e) => e.value!).join(',') ?? '';
}

List<String>? editTypeListToJson(List<enums.EditType>? editType) {
  if (editType == null) {
    return null;
  }

  return editType.map((e) => e.value!).toList();
}

List<enums.EditType> editTypeListFromJson(
  List? editType, [
  List<enums.EditType>? defaultValue,
]) {
  if (editType == null) {
    return defaultValue ?? [];
  }

  return editType.map((e) => editTypeFromJson(e.toString())).toList();
}

List<enums.EditType>? editTypeNullableListFromJson(
  List? editType, [
  List<enums.EditType>? defaultValue,
]) {
  if (editType == null) {
    return defaultValue;
  }

  return editType.map((e) => editTypeFromJson(e.toString())).toList();
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
