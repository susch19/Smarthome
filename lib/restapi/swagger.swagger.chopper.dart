// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

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
  Future<Response<String>> _appGet({
    String? name,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["App"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/app');
    final Map<String, dynamic> $params = <String, dynamic>{'name': name};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<dynamic>> _appPatch({
    String? id,
    String? newName,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["App"],
      deprecated: false,
    ),
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
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<String>> _appSettingsGet({
    String? id,
    String? key,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["App"],
      deprecated: false,
    ),
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
      tag: swaggerMetaData,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<String>> _appSettingsPost({
    String? id,
    String? key,
    String? $value,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["App"],
      deprecated: false,
    ),
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
      tag: swaggerMetaData,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<dynamic>> _deviceRebuildIdPatch({
    required int? id,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Device"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/device/rebuild/${id}');
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _devicePatch({
    bool? onlyNew,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Device"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/device');
    final Map<String, dynamic> $params = <String, dynamic>{'onlyNew': onlyNew};
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _devicePut({
    required RestCreatedDevice? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Device"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/device');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _deviceGet({
    bool? includeState,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Device"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/device');
    final Map<String, dynamic> $params = <String, dynamic>{
      'includeState': includeState,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _deviceStatesIdGet({
    required int? id,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Device"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/device/states/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _deviceStatesIdPost({
    required int? id,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Device"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/device/states/${id}');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _deviceHistoryIdGet({
    required int? id,
    DateTime? from,
    DateTime? to,
    String? propName,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Device"],
      deprecated: false,
    ),
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
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _deviceStateIdNameGet({
    required int? id,
    required String? name,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Device"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/device/state/${id}/${name}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _deviceStateIdPost({
    required int? id,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Device"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/device/state/${id}');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<Device<BaseModel>>>> _appDeviceGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Device"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/app/device');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<List<Device<BaseModel>>, Device<BaseModel>>($request);
  }

  @override
  Future<Response<dynamic>> _appDevicePatch({
    required DeviceRenameRequest? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Device"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/app/device');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<DeviceOverview>>> _appDeviceOverviewGet({
    bool? onlyShowInApp,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Device"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/app/device/overview');
    final Map<String, dynamic> $params = <String, dynamic>{
      'onlyShowInApp': onlyShowInApp,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<List<DeviceOverview>, DeviceOverview>($request);
  }

  @override
  Future<Response<List<HistoryPropertyState>>> _appHistorySettingsGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["History"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/app/history/settings');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<List<HistoryPropertyState>, HistoryPropertyState>(
      $request,
    );
  }

  @override
  Future<Response<dynamic>> _appHistoryPatch({
    required SetHistoryRequest? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["History"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/app/history');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<History>>> _appHistoryGet({
    int? id,
    DateTime? dt,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["History"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/app/history');
    final Map<String, dynamic> $params = <String, dynamic>{'id': id, 'dt': dt};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<List<History>, History>($request);
  }

  @override
  Future<Response<History>> _appHistoryRangeGet({
    int? id,
    DateTime? from,
    DateTime? to,
    String? propertyName,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["History"],
      deprecated: false,
    ),
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
      tag: swaggerMetaData,
    );
    return client.send<History, History>($request);
  }

  @override
  Future<Response<LayoutResponse>> _appLayoutSingleGet({
    String? typeName,
    String? iconName,
    int? deviceId,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Layout"],
      deprecated: false,
    ),
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
      tag: swaggerMetaData,
    );
    return client.send<LayoutResponse, LayoutResponse>($request);
  }

  @override
  Future<Response<List<LayoutResponse>>> _appLayoutMultiGet({
    List<LayoutRequest>? request,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Layout"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/app/layout/multi');
    final Map<String, dynamic> $params = <String, dynamic>{'request': request};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<List<LayoutResponse>, LayoutResponse>($request);
  }

  @override
  Future<Response<List<LayoutResponse>>> _appLayoutAllGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Layout"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/app/layout/all');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<List<LayoutResponse>, LayoutResponse>($request);
  }

  @override
  Future<Response<SvgIcon>> _appLayoutIconByNameGet({
    String? name,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Layout"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/app/layout/iconByName');
    final Map<String, dynamic> $params = <String, dynamic>{'name': name};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<SvgIcon, SvgIcon>($request);
  }

  @override
  Future<Response<dynamic>> _appLayoutPatch({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Layout"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/app/layout');
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _notificationSendNotificationPost({
    required AppNotification? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Notification"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/notification/sendNotification');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<Object>> _notificationFirebaseOptionsGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Notification"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/notification/firebaseOptions');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<String>> _notificationNextNotificationIdGet({
    String? uniqueName,
    int? deviceId,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Notification"],
      deprecated: false,
    ),
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
      tag: swaggerMetaData,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<AllOneTimeNotifications>>
  _notificationAllOneTimeNotificationsGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Notification"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/notification/allOneTimeNotifications');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<AllOneTimeNotifications, AllOneTimeNotifications>(
      $request,
    );
  }

  @override
  Future<Response<List<NotificationSetup>>>
  _notificationAllGlobalNotificationsGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Notification"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/notification/allGlobalNotifications');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<List<NotificationSetup>, NotificationSetup>($request);
  }

  @override
  Future<Response<dynamic>> _painlessTimePut({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Painless"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/painless/time');
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<AppCloudConfiguration>> _securityGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Security"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/security');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<AppCloudConfiguration, AppCloudConfiguration>($request);
  }

  @override
  Future<Response<dynamic>> _appSmarthomePost({
    required JsonApiSmarthomeMessage? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Smarthome"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/app/smarthome');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _appSmarthomeGet({
    int? deviceId,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Smarthome"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/app/smarthome');
    final Map<String, dynamic> $params = <String, dynamic>{
      'deviceId': deviceId,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _appSmarthomeLogPost({
    required List<AppLog>? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Smarthome"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/app/smarthome/log');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _windmillPost({
    required WindmillSmarthomeMessage? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '',
      operationId: '',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Windmill"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/windmill');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
