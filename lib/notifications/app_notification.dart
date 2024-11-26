import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'app_notification.g.dart';

@JsonSerializable(explicitToJson: true)
class AppNotification {
  const AppNotification({
    required this.topic,
    required this.wasOneTime,
  });
  static const fromJsonFactory = AppNotification.fromJson;

  factory AppNotification.fromJson(final Map<String, dynamic> json) {
    switch (json["typeName"]) {
      case "VisibleAppNotification":
        return VisibleAppNotification.fromJson(json);
      case "AppNotification":
      default:
        return _$AppNotificationFromJson(json);
    }
  }

  static const toJsonFactory = _$AppNotificationToJson;
  Map<String, dynamic> toJson() => _$AppNotificationToJson(this);

  @JsonKey(name: 'topic')
  final String topic;
  @JsonKey(name: 'wasOneTime')
  final bool wasOneTime;

  @override
  String toString() => jsonEncode(this);

  AppNotification copyWith({final String? topic, final bool? wasOneTime}) {
    return AppNotification(
        topic: topic ?? this.topic, wasOneTime: wasOneTime ?? this.wasOneTime);
  }
}

@JsonSerializable(explicitToJson: true)
class VisibleAppNotification extends AppNotification {
  VisibleAppNotification({
    required super.topic,
    required super.wasOneTime,
    required this.title,
    this.body,
    this.ttl,
  });

  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'body')
  final String? body;
  @JsonKey(name: 'ttl')
  final int? ttl;
  static const fromJsonFactory = AppNotification.fromJson;

  factory VisibleAppNotification.fromJson(final Map<String, dynamic> json) =>
      _$VisibleAppNotificationFromJson(json);

  static const toJsonFactory = _$VisibleAppNotificationToJson;
  @override
  Map<String, dynamic> toJson() => _$VisibleAppNotificationToJson(this);

  @override
  AppNotification copyWith({
    final String? title,
    final String? body,
    final String? topic,
    final int? ttl,
    final bool? wasOneTime,
  }) {
    return VisibleAppNotification(
      title: title ?? this.title,
      body: body ?? this.body,
      topic: topic ?? this.topic,
      ttl: ttl ?? this.ttl,
      wasOneTime: wasOneTime ?? this.wasOneTime,
    );
  }
}
