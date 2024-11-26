import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthome/models/notification_topic.dart';

class PreferencesManager {
  static late PreferencesManager instance;

  final SharedPreferences _prefs;

  PreferencesManager(this._prefs);

  Future<bool> clear() => _prefs.clear();

  bool containsKey(final String key) => _prefs.containsKey(key);

  Object? get(final String key) => _prefs.get(key);

  bool? getBool(final String key) => _prefs.getBool(key);

  double? getDouble(final String key) => _prefs.getDouble(key);

  int? getInt(final String key) => _prefs.getInt(key);

  Set<String> getKeys() => _prefs.getKeys();

  String? getString(final String key) => _prefs.getString(key);

  List<String>? getStringList(final String key) => _prefs.getStringList(key);

  DateTime? getDateTime(final String key) =>
      DateTime.tryParse(_prefs.getString(key) ?? '');

  Future<void> reload() => _prefs.reload();

  Future<bool> remove(final String key) => _prefs.remove(key);

  Future<bool> setBool(final String key, final bool value) =>
      _prefs.setBool(key, value);

  Future<bool> setDouble(final String key, final double value) =>
      _prefs.setDouble(key, value);

  Future<bool> setInt(final String key, final int value) =>
      _prefs.setInt(key, value);

  Future<bool> setString(final String key, final String value) =>
      _prefs.setString(key, value);

  Future<bool> setStringList(final String key, final List<String> value) =>
      _prefs.setStringList(key, value);

  Future<bool> setDateTime(final String key, final DateTime value) =>
      _prefs.setString(key, value.toIso8601String());

  List<NotificationTopic> getNotificationTopics() =>
      ((_prefs.getStringList("notification_topics")) ?? [])
          .map((final x) => NotificationTopic.fromJson(jsonDecode(x)))
          .toList();

  Future<bool> setNotificationTopics(final List<NotificationTopic> topics) =>
      _prefs.setStringList(
          "notification_topics", topics.map((final x) => jsonEncode(x)).toList());
}
