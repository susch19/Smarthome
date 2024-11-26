import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_topic.g.dart';

@JsonSerializable()
class NotificationTopic extends EqualityBy<NotificationTopic, (String, int?)> {
  final bool enabled;
  final String topic;
  final String uniqueName;
  final bool oneTime;
  final int? deviceId;

  NotificationTopic({
    required this.enabled,
    required this.topic,
    required this.uniqueName,
    required this.oneTime,
    this.deviceId,
  }) : super(
          (final t) => (t.uniqueName, deviceId),
        );

  factory NotificationTopic.fromJson(final Map<String, dynamic> json) =>
      _$NotificationTopicFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationTopicToJson(this);

  NotificationTopic copyWith({
    final bool? enabled,
    final String? topic,
    final String? uniqueName,
    final bool? oneTime,
    final int? deviceId,
  }) {
    return NotificationTopic(
      enabled: enabled ?? this.enabled,
      topic: topic ?? this.topic,
      uniqueName: uniqueName ?? this.uniqueName,
      oneTime: oneTime ?? this.oneTime,
      deviceId: deviceId ?? this.deviceId,
    );
  }
}
