import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/helper/number_extensions.dart';
import 'package:smarthome/helper/preference_manager.dart';
import 'package:smarthome/models/notification_topic.dart';
import 'package:smarthome/notifications/app_notification.dart';

part 'notification_service.g.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Callback<T> {
  Type get type => T;

  final String id;
  final Function(T parameter) func;

  const Callback(this.id, this.func);
}

@Riverpod(keepAlive: true)
class NotificationService extends _$NotificationService {
  static int notificationId = 0;

  static final Map<Type, Map<String, void Function(dynamic notification)>>
      _callbacks = {};

  @override
  Future build() async {
    final connection = ref.watch(hubConnectionConnectedProvider);
    if (connection == null) return;
    connection.invoke("activate");
    connection.on("Notify", processNotification);
    final topics = PreferencesManager.instance.getNotificationTopics();
    final origLength = topics.length;
    final api = ref.read(apiProvider);
    final res = await api.notificationAllOneTimeNotificationsGet();
    final allIds = res.bodyOrThrow.topics;
    topics.removeWhere((final x) => x.oneTime && !allIds.contains(x.topic));
    if (origLength != topics.length) {
      PreferencesManager.instance.setNotificationTopics(topics);
    }
  }

  void processNotification(final List<Object?>? arguments) {
    final notification = AppNotification.fromJson(arguments!.first as dynamic);
    final topics = PreferencesManager.instance.getNotificationTopics();
    final topic =
        topics.firstOrDefault((final x) => x.topic == notification.topic);
    if (topic == null) return;
    if (notification.wasOneTime) {
      final idx = topics.indexOf(topic);
      topics[idx] = topic.copyWith(enabled: false, topic: "");
      PreferencesManager.instance.setNotificationTopics(topics);
    }

    if (notification is VisibleAppNotification) {
      flutterLocalNotificationsPlugin.show(
          notificationId++, notification.title, notification.body, null);
    }

    final callbacks = _callbacks[notification.runtimeType];
    if (callbacks == null || callbacks.isEmpty) return;

    for (final element in callbacks.values) {
      element(notification);
    }
  }

  static String registerCallback<T>(
      final String id, final Function(T parameter) func) {
    return _registerCallback(id, T, (final p) => func(p));
  }

  static String _registerCallback(final String id, final Type type,
      final Function(dynamic parameter) func) {
    if (_callbacks.containsKey(type)) {
      _callbacks[type]!.addAll({id: func});
    } else {
      _callbacks.addAll({
        type: {id: func}
      });
    }

    return id;
  }

  void unregisterCallback(final String id, final Type type) {
    if (_callbacks.containsKey(type)) {
      _callbacks[type]!.remove(id);
    }
  }

  Future showNotificationDialog(
    final BuildContext context,
    final List<(String, int?, NotificationSetup)> notifications,
  ) async {
    List<NotificationTopic> topics;
    try {
      topics = PreferencesManager.instance.getNotificationTopics();
    } catch (e) {
      topics = [];
      PreferencesManager.instance.setNotificationTopics(topics);
    }
    final api = ref.read(apiProvider);
    final grouped = notifications.groupBy((final x) => x.$1);

    final hookedBuilder = HookBuilder(
      builder: (final context) {
        final expansionTiles = <Widget>[];

        for (final grp in grouped.entries) {
          final widgets = <Widget>[];
          for (final (_, id, element) in grp.value) {
            final topic = useState(topics.firstWhere(
              (final x) =>
                  x.uniqueName == element.uniqueName && x.deviceId == id,
              orElse: () {
                final oneTime = element.times == 1;
                final String topic;
                if (oneTime) {
                  topic = "";
                } else if (id == null) {
                  topic = element.uniqueName;
                } else {
                  topic = "${element.uniqueName}_${id.toHex()}";
                }
                return NotificationTopic(
                    enabled: false,
                    deviceId: id,
                    oneTime: oneTime,
                    topic: topic,
                    uniqueName: element.uniqueName);
              },
            ));
            if (!topics.contains(topic.value)) topics.add(topic.value);

            final checked = useState(topic.value.enabled);
            widgets.add(CheckboxListTile(
              value: checked.value,
              title: Text(element.translatableName),
              onChanged: (final value) async {
                checked.value = value ?? false;
                if (topic.value.topic == "") {
                  final res = await api.notificationNextNotificationIdGet(
                    uniqueName: topic.value.uniqueName,
                    deviceId: id,
                  );
                  final notificationTopic = res.bodyOrThrow;
                  print(notificationTopic);
                  final idx = topics.indexOf(topic.value);
                  topic.value = topic.value.copyWith(
                      topic: notificationTopic, enabled: checked.value);
                  topics[idx] = topic.value;
                } else if (checked.value) {
                  final idx = topics.indexOf(topic.value);
                  topic.value = topic.value.copyWith(enabled: checked.value);
                  topics[idx] = topic.value;
                } else {
                  final idx = topics.indexOf(topic.value);
                  topic.value = topic.value.copyWith(enabled: checked.value);
                  topics[idx] = topic.value;
                }
              },
            ));
          }
          expansionTiles.add(ExpansionTile(
            title: Text(grp.key),
            initiallyExpanded: grouped.length == 1,
            children: widgets,
          ));
        }

        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: expansionTiles,
          ),
        );
      },
    );

    final ad = AlertDialog(
      title: Text("Benachrichtigungen"),
      content: hookedBuilder,
      actions: <Widget>[
        TextButton(
            child: Text("Abbrechen"),
            onPressed: () {
              Navigator.pop(context, false);
            }),
        TextButton(
            child: Text("Speichern"),
            onPressed: () {
              Navigator.pop(context, true);
            })
      ],
    );
    final dialogRes =
        await showDialog(context: context, builder: (final ctx) => ad);
    if (dialogRes == true) {
      final validTopics = topics
          .where((final x) => x.topic.isNotEmpty && (!x.oneTime || x.enabled))
          .toList();

      PreferencesManager.instance.setNotificationTopics(validTopics);
      if (Platform.isAndroid || Platform.isIOS) {
        for (final topic in validTopics) {
          if (topic.enabled) {
            FirebaseMessaging.instance.subscribeToTopic(topic.topic);
          } else {
            FirebaseMessaging.instance.unsubscribeFromTopic(topic.topic);
          }
        }
      }
    }
  }
}
