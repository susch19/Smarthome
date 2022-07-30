import 'package:smarthome/helper/preference_manager.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

const fallbackServerUrl = "http://localhost:5056/SmartHome";

final settingsProvider = StateProvider<Settings>((final ref) {
  SettingsManager(ref);
  return Settings();
});

final debugInformationEnabledProvider = Provider<bool>((final ref) {
  return ref.watch(settingsProvider).showDebugInformation;
});

final serverUrlProvider = Provider<String>((final ref) {
  return ref.watch(settingsProvider).serverUrl;
});

final groupingEnabledProvider = Provider<bool>((final ref) {
  return ref.watch(settingsProvider).groupingEnabled;
});

class Settings {
  String serverUrl = "";
  bool groupingEnabled = true;
  bool showDebugInformation = false;

  Settings() {
    groupingEnabled = PreferencesManager.instance.getBool("Groupings") ?? true;
    serverUrl = PreferencesManager.instance.getString("mainserverurl") ?? fallbackServerUrl;
    showDebugInformation = PreferencesManager.instance.getBool("ShowDebugInformation") ?? false;
  }

  Settings copyWith({final bool? groupingEnabled, final String? serverUrl, final bool? showDebugInformation}) {
    return Settings()
      ..groupingEnabled = groupingEnabled ?? this.groupingEnabled
      ..serverUrl = serverUrl ?? this.serverUrl
      ..showDebugInformation = showDebugInformation ?? this.showDebugInformation;
  }
}

class SettingsManager {
  static StateProviderRef<Settings>? _ref;

  SettingsManager(final StateProviderRef<Settings> ref) {
    _ref = ref;
  }

  static void setGroupingEnabled(final bool newState) {
    if (_ref == null) return;

    final state = _ref!.read(settingsProvider.notifier);

    state.state = state.state.copyWith(groupingEnabled: newState);
    PreferencesManager.instance.setBool("Groupings", newState);
  }

  static void setShowDebugInformation(final bool showDebugInformation) {
    if (_ref == null) return;

    final state = _ref!.read(settingsProvider.notifier);

    state.state = state.state.copyWith(showDebugInformation: showDebugInformation);
    PreferencesManager.instance.setBool("ShowDebugInformation", showDebugInformation);
  }

  static void setServerUrl(final String newUrl) {
    if (_ref == null) return;

    final state = _ref!.read(settingsProvider.notifier);

    state.state = state.state.copyWith(serverUrl: newUrl);
    PreferencesManager.instance.setString("mainserverurl", newUrl);
  }
}
