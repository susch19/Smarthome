import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smarthome/helper/preference_manager.dart';

part 'settings_manager.g.dart';

const fallbackServerUrl = "http://localhost:5056/SmartHome";

final debugInformationEnabledProvider = Provider<bool>((final ref) {
  return ref
      .watch(settingsManagerProvider.select((final x) => x.showDebugInformation));
});

final serverUrlProvider = Provider<String>((final ref) {
  return ref.watch(settingsManagerProvider.select((final x) => x.serverUrl));
});

final groupingEnabledProvider = Provider<bool>((final ref) {
  return ref.watch(settingsManagerProvider.select((final x) => x.groupingEnabled));
});

@Riverpod(keepAlive: true)
class SettingsManager extends _$SettingsManager {
  @override
  Settings build() {
    return Settings();
  }

  void setGroupingEnabled(final bool newState) {
    state = state.copyWith(groupingEnabled: newState);
    PreferencesManager.instance.setBool("Groupings", newState);
  }

  void setShowDebugInformation(final bool showDebugInformation) {
    state = state.copyWith(showDebugInformation: showDebugInformation);
    PreferencesManager.instance
        .setBool("ShowDebugInformation", showDebugInformation);
  }

  void setServerUrl(final String newUrl) {
    state = state.copyWith(serverUrl: newUrl);
    PreferencesManager.instance.setString("mainserverurl", newUrl);
  }

  void setName(final String name) {
    state = state.copyWith(name: name);
    PreferencesManager.instance.setString("Name", name);
  }
}

class Settings {
  String serverUrl = "";
  bool groupingEnabled = true;
  bool showDebugInformation = false;
  String name = "";

  Settings() {
    groupingEnabled = PreferencesManager.instance.getBool("Groupings") ?? true;
    serverUrl = PreferencesManager.instance.getString("mainserverurl") ?? "";
    showDebugInformation =
        PreferencesManager.instance.getBool("ShowDebugInformation") ?? false;
    name = PreferencesManager.instance.getString("Name") ?? "";
  }

  Settings copyWith(
      {final bool? groupingEnabled,
      final String? serverUrl,
      final bool? showDebugInformation,
      final String? name}) {
    return Settings()
      ..groupingEnabled = groupingEnabled ?? this.groupingEnabled
      ..serverUrl = serverUrl ?? this.serverUrl
      ..showDebugInformation = showDebugInformation ?? this.showDebugInformation
      ..name = name ?? this.name;
  }
}
