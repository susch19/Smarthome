import 'package:flutter/widgets.dart';
import 'package:smarthome/helper/preference_manager.dart';

class SettingsManager {
  static bool _groupingEnabled = true;
  static String _serverUrl = "192.168.49.56:5055";
  static ValueNotifier<String> serverUrlChanged = ValueNotifier(_serverUrl);

  static bool get groupingEnabled => _groupingEnabled;
  static String get serverUrl => _serverUrl;

  static void initialize() {
    _groupingEnabled = PreferencesManager.instance.getBool("Groupings") ?? true;
    _serverUrl = PreferencesManager.instance.getString("mainserverurl") ?? _serverUrl;
  }

  static void setGroupingEnabled(bool newState) {
    _groupingEnabled = newState;
    PreferencesManager.instance.setBool("Groupings", _groupingEnabled);
  }

  static void setServerUrl(String newUrl) {
    _serverUrl = newUrl;
    serverUrlChanged.value = newUrl;
    PreferencesManager.instance.setString("mainserverurl", newUrl);
  }
}
