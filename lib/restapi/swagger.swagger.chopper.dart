// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swagger.swagger.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$Swagger extends Swagger {
  _$Swagger([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = Swagger;

  @override
  Future<Response<List<int>>> _deviceRebuildIdPatch({required int? id}) {
    final Uri $url = Uri.parse('/device/rebuild/${id}');
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
    );
    return client.send<List<int>, int>($request);
  }

  @override
  Future<Response<List<int>>> _devicePatch({bool? onlyNew}) {
    final Uri $url = Uri.parse('/device');
    final Map<String, dynamic> $params = <String, dynamic>{'onlyNew': onlyNew};
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<int>, int>($request);
  }

  @override
  Future<Response<List<int>>> _devicePut(
      {required RestCreatedDevice? deviceCreate}) {
    final Uri $url = Uri.parse('/device');
    final $body = deviceCreate;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<List<int>, int>($request);
  }

  @override
  Future<Response<List<int>>> _deviceGet({bool? includeState}) {
    final Uri $url = Uri.parse('/device');
    final Map<String, dynamic> $params = <String, dynamic>{
      'includeState': includeState
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<int>, int>($request);
  }

  @override
  Future<Response<List<int>>> _deviceStatesIdGet({required int? id}) {
    final Uri $url = Uri.parse('/device/states/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<int>, int>($request);
  }

  @override
  Future<Response<List<int>>> _deviceStatesIdPost({required int? id}) {
    final Uri $url = Uri.parse('/device/states/${id}');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<List<int>, int>($request);
  }

  @override
  Future<Response<List<int>>> _deviceHistoryIdGet({
    required int? id,
    required DateTime? from,
    required DateTime? to,
    required String? propName,
  }) {
    final Uri $url = Uri.parse('/device/history/${id}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'from': from,
      'to': to,
      'propName': propName,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<int>, int>($request);
  }

  @override
  Future<Response<List<int>>> _deviceStateIdNameGet({
    required int? id,
    required String? name,
  }) {
    final Uri $url = Uri.parse('/device/state/${id}/${name}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<int>, int>($request);
  }

  @override
  Future<Response<List<int>>> _deviceStateIdPost({required int? id}) {
    final Uri $url = Uri.parse('/device/state/${id}');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<List<int>, int>($request);
  }

  @override
  Future<Response<AppCloudConfiguration>> _securityGet() {
    final Uri $url = Uri.parse('/security');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<AppCloudConfiguration, AppCloudConfiguration>($request);
  }

  @override
  Future<Response<String>> _appGet({required String? name}) {
    final Uri $url = Uri.parse('/app');
    final Map<String, dynamic> $params = <String, dynamic>{'name': name};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<dynamic>> _appPatch({
    required String? id,
    required String? newName,
  }) {
    final Uri $url = Uri.parse('/app');
    final Map<String, dynamic> $params = <String, dynamic>{
      'id': id,
      'newName': newName,
    };
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<String>> _appSettingsGet({
    required String? id,
    required String? key,
  }) {
    final Uri $url = Uri.parse('/app/settings');
    final Map<String, dynamic> $params = <String, dynamic>{
      'id': id,
      'key': key,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<String>> _appSettingsPost({
    required String? id,
    required String? key,
    required String? $value,
  }) {
    final Uri $url = Uri.parse('/app/settings');
    final Map<String, dynamic> $params = <String, dynamic>{
      'id': id,
      'key': key,
      'value': $value,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<List<Device<BaseModel>>>> _appDeviceGet() {
    final Uri $url = Uri.parse('/app/device');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<Device<BaseModel>>, Device<BaseModel>>($request);
  }

  @override
  Future<Response<dynamic>> _appDevicePatch(
      {required DeviceRenameRequest? request}) {
    final Uri $url = Uri.parse('/app/device');
    final $body = request;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<DeviceOverview>>> _appDeviceOverviewGet(
      {bool? onlyShowInApp}) {
    final Uri $url = Uri.parse('/app/device/overview');
    final Map<String, dynamic> $params = <String, dynamic>{
      'onlyShowInApp': onlyShowInApp
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<DeviceOverview>, DeviceOverview>($request);
  }

  @override
  Future<Response<List<HistoryPropertyState>>> _appHistorySettingsGet() {
    final Uri $url = Uri.parse('/app/history/settings');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client
        .send<List<HistoryPropertyState>, HistoryPropertyState>($request);
  }

  @override
  Future<Response<dynamic>> _appHistoryPatch(
      {required SetHistoryRequest? request}) {
    final Uri $url = Uri.parse('/app/history');
    final $body = request;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<History>>> _appHistoryGet({
    required int? id,
    required DateTime? dt,
  }) {
    final Uri $url = Uri.parse('/app/history');
    final Map<String, dynamic> $params = <String, dynamic>{
      'id': id,
      'dt': dt,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<History>, History>($request);
  }

  @override
  Future<Response<History>> _appHistoryRangeGet({
    required int? id,
    required DateTime? from,
    required DateTime? to,
    required String? propertyName,
  }) {
    final Uri $url = Uri.parse('/app/history/range');
    final Map<String, dynamic> $params = <String, dynamic>{
      'id': id,
      'from': from,
      'to': to,
      'propertyName': propertyName,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<History, History>($request);
  }

  @override
  Future<Response<LayoutResponse>> _appLayoutSingleGet({
    required String? typeName,
    required String? iconName,
    required int? deviceId,
  }) {
    final Uri $url = Uri.parse('/app/layout/single');
    final Map<String, dynamic> $params = <String, dynamic>{
      'TypeName': typeName,
      'IconName': iconName,
      'DeviceId': deviceId,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<LayoutResponse, LayoutResponse>($request);
  }

  @override
  Future<Response<List<LayoutResponse>>> _appLayoutMultiGet(
      {required List<dynamic>? request}) {
    final Uri $url = Uri.parse('/app/layout/multi');
    final Map<String, dynamic> $params = <String, dynamic>{'request': request};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<LayoutResponse>, LayoutResponse>($request);
  }

  @override
  Future<Response<List<LayoutResponse>>> _appLayoutAllGet() {
    final Uri $url = Uri.parse('/app/layout/all');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<LayoutResponse>, LayoutResponse>($request);
  }

  @override
  Future<Response<SvgIcon>> _appLayoutIconByNameGet({required String? name}) {
    final Uri $url = Uri.parse('/app/layout/iconByName');
    final Map<String, dynamic> $params = <String, dynamic>{'name': name};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<SvgIcon, SvgIcon>($request);
  }

  @override
  Future<Response<dynamic>> _appLayoutPatch() {
    final Uri $url = Uri.parse('/app/layout');
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _appSmarthomePost(
      {required JsonApiSmarthomeMessage? message}) {
    final Uri $url = Uri.parse('/app/smarthome');
    final $body = message;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<int>>> _appSmarthomeGet({required int? deviceId}) {
    final Uri $url = Uri.parse('/app/smarthome');
    final Map<String, dynamic> $params = <String, dynamic>{
      'deviceId': deviceId
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<int>, int>($request);
  }

  @override
  Future<Response<dynamic>> _appSmarthomeLogPost(
      {required List<AppLog>? logLines}) {
    final Uri $url = Uri.parse('/app/smarthome/log');
    final $body = logLines;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<int>>> _notificationSendNotificationPost(
      {required AppNotification? notification}) {
    final Uri $url = Uri.parse('/notification/sendNotification');
    final $body = notification;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<List<int>, int>($request);
  }

  @override
  Future<Response<Object>> _notificationFirebaseOptionsGet() {
    final Uri $url = Uri.parse('/notification/firebaseOptions');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<String>> _notificationNextNotificationIdGet({
    required String? uniqueName,
    required int? deviceId,
  }) {
    final Uri $url = Uri.parse('/notification/nextNotificationId');
    final Map<String, dynamic> $params = <String, dynamic>{
      'uniqueName': uniqueName,
      'deviceId': deviceId,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<AllOneTimeNotifications>>
      _notificationAllOneTimeNotificationsGet() {
    final Uri $url = Uri.parse('/notification/allOneTimeNotifications');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client
        .send<AllOneTimeNotifications, AllOneTimeNotifications>($request);
  }
}
