import 'dart:io';

import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:smarthome/helper/helper_methods.dart';
import 'package:smarthome/helper/preference_manager.dart';
import 'package:smarthome/helper/simple_dialog.dart' as simple_dialog;
import 'package:smarthome/models/version_and_url.dart';
import 'package:version/version.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final versionAndUrlProvider = StateNotifierProvider<UpdateManager, VersionAndUrl?>((final ref) {
  final um = UpdateManager();
  UpdateManager.checkForNewestVersion();
  return um;
});

class UpdateManager extends StateNotifier<VersionAndUrl?> {
  static final Version version = Version(1, 2, 3);
  static const int checkEveryHours = 16;
  static final GitHub gitHub = GitHub();
  static final RepositorySlug repositorySlug = RepositorySlug("susch19", "SmartHome");
  static final RegExp versionRegExp = RegExp(r'v|V');
  static DateTime? lastChecked;
  static late UpdateManager _instance;

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static const String updateNotificationTitle = "Neue Version verfügbar"; // Update available
  static const String updateNotificationBody =
      "Bitte aktualisiere auf "; // A new update is available. Please update to version

  static int notificationId = 0;

  UpdateManager() : super(null) {
    _instance = this;
  }

  static Future<void> initialize() async {
    lastChecked = PreferencesManager.instance.getDateTime("lastChecked");

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (final details) {
      if (details.payload != null) {
        HelperMethods.openUrl(details.payload!);
      }
    });
  }

  static Future<void> checkForNewestVersion() async {
    print("showUpdateNotification called ${lastChecked?.toString() ?? "lastChecked is null"}");
    // TODO: at a later point maybe schedule this notification to be shown every x hours
    // TODO: maybe also put the check every x hours in the settings
    if (lastChecked == null || DateTime.now().difference(lastChecked!).inHours > checkEveryHours) {
      lastChecked = DateTime.now();
      PreferencesManager.instance.setDateTime("lastChecked", lastChecked!);

      final versionAndUrl = await getVersionAndUrl();
      if (versionAndUrl != null && !versionAndUrl.upToDate && versionAndUrl.url != null) {
        _instance.state = versionAndUrl;
      }
    }
  }

  static Future<void> displayNotificationDialog(final BuildContext context, final VersionAndUrl versionAndUrl) async {
    _instance.state = null;
    if (Platform.isAndroid) {
      // Show notification
      await _showNotification(versionAndUrl);
    } else {
      // Show dialog
      showDialog(
          context: context,
          builder: (final BuildContext c) => simple_dialog.SimpleDialog.create(
              context: c,
              title: updateNotificationTitle,
              content: updateNotificationBody + versionAndUrl.version.toString(),
              okButtonText: "Aktualisieren",
              cancelButtonText: "Später",
              onSubmitted: () => HelperMethods.openUrl(versionAndUrl.url!)));
    }
  }

  static Future<void> _showNotification(final VersionAndUrl versionAndUrl) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'updateNotifications', 'Update Benachrichtigungen',
        channelDescription: 'Benachrichtigungen über neue Updates',
        importance: Importance.low,
        priority: Priority.low,
        ticker: 'SmartHome');
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(notificationId++, updateNotificationTitle,
        updateNotificationBody + versionAndUrl.version.toString(), platformChannelSpecifics,
        payload: versionAndUrl.url);
  }

  static String getVersionString(final VersionAndUrl? newVersion) {
    var v = version.toString();

    if (newVersion == null) {
      v += " - konnte neue Version nicht überprüfen";
    } else if (newVersion.upToDate) {
      v += " - aktuell";
    } else {
      v += " - neue Version ${newVersion.version} verfügbar";
    }

    return v;
  }

  static Future<VersionAndUrl?> getVersionAndUrl() async {
    final release = await gitHub.repositories.getLatestRelease(repositorySlug);
    Version latestVersion;
    try {
      latestVersion = Version.parse(release.tagName!.replaceFirst(versionRegExp, ''));
    } catch (e) {
      return null;
    }

    final asset = _extractUrl(release);

    if (asset != null && latestVersion > version) {
      return VersionAndUrl(latestVersion, false, asset.browserDownloadUrl);
    } else {
      return VersionAndUrl(latestVersion, true, null);
    }
  }

  static ReleaseAsset? _extractUrl(final Release release) {
    return release.assets?.firstWhere((final element) {
      if (element.name == null) return false;
      if (Platform.isAndroid) {
        return element.name!.contains("Android");
      } else if (Platform.isWindows) {
        return element.name!.contains("Windows");
      } else if (Platform.isLinux) {
        return element.name!.contains("Linux");
      } else {
        return false;
      }
    });
  }
}
