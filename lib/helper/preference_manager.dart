import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  static late PreferencesManager instance;

  SharedPreferences _prefs;

  PreferencesManager(this._prefs);

  Future<bool> clear() => _prefs.clear();

  bool containsKey(String key) => _prefs.containsKey(key);

  Object? get(String key) => _prefs.get(key);

  bool? getBool(String key) => _prefs.getBool(key);

  double? getDouble(String key) => _prefs.getDouble(key);

  int? getInt(String key) => _prefs.getInt(key);

  Set<String> getKeys() => _prefs.getKeys();

  String? getString(String key) => _prefs.getString(key);

  List<String>? getStringList(String key) => _prefs.getStringList(key);

  Future<void> reload() => _prefs.reload();

  Future<bool> remove(String key) => _prefs.remove(key);

  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  Future<bool> setDouble(String key, double value) => _prefs.setDouble(key, value);

  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);

  Future<bool> setString(String key, String value) => _prefs.setString(key, value);

  Future<bool> setStringList(String key, List<String> value) => _prefs.setStringList(key, value);
}
