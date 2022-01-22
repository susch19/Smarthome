import 'dart:io';

import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:smarthome/helper/helper_methods.dart';
import 'package:smarthome/helper/preference_manager.dart';
import 'package:smarthome/helper/simple_dialog.dart' as simpleDialog;
import 'package:smarthome/models/versionAndUrl.dart';
import 'package:version/version.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class UpdateManager {
  static final Version version = Version(1, 1, 5);
  static const int checkEveryHours = 16;
  static final GitHub gitHub = GitHub();
  static final RepositorySlug repositorySlug = RepositorySlug("susch19", "SmartHome");
  static final RegExp versionRegExp = RegExp(r'v|V');
  static DateTime? lastChecked;

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static const String updateNotificationTitle = "Neue Version verfügbar"; // Update available
  static const String updateNotificationBody =
      "Bitte aktualisiere auf "; // A new update is available. Please update to version

  static int notificationId = 0;

  static Future<void> initialize() async {
    lastChecked = PreferencesManager.instance.getDateTime("lastChecked");

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String? payload) {
      if (payload != null) {
        HelperMethods.openUrl(payload);
      }
    });
  }

  static Future<void> showUpdateNotification(BuildContext context) async {
    print("showUpdateNotification called " + (lastChecked?.toString() ?? "lastChecked is null"));
    // TODO: at a later point maybe schedule this notification to be shown every x hours
    // TODO: maybe also put the check every x hours in the settings
    if (lastChecked == null || DateTime.now().difference(lastChecked!).inHours > checkEveryHours) {
      lastChecked = DateTime.now();
      PreferencesManager.instance.setDateTime("lastChecked", lastChecked!);

      final versionAndUrl = await getVersionAndUrl();
      if (versionAndUrl?.url != null && await _isNewVersionAvailable(versionAndUrl?.version)) {
        if (Platform.isAndroid) {
          // Show notification
          await _showNotification(versionAndUrl!);
        } else {
          // Show dialog
          showDialog(
              context: context,
              builder: (BuildContext c) => simpleDialog.SimpleDialog.create(
                  context: c,
                  title: updateNotificationTitle,
                  content: updateNotificationBody + versionAndUrl!.version.toString(),
                  okButtonText: "Aktualisieren",
                  cancelButtonText: "Später",
                  onSubmitted: () => HelperMethods.openUrl(versionAndUrl.url!)));
        }
      }
    }
  }

  static Future<void> _showNotification(VersionAndUrl versionAndUrl) async {
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

  static String getVersionString(Version? newVersion) {
    var v = version.toString();

    if (newVersion != null) {
      v += " (neue Version " + newVersion.toString() + " verfügbar)";
    }

    return v;
  }

  static Future<bool> isNewVersionAvailable() async {
    final newVersion = await _getNewVersion();
    return _isNewVersionAvailable(newVersion);
  }

  static Future<bool> _isNewVersionAvailable(Version? newVersion) async {
    return newVersion != null && newVersion > version;
  }

  static Future<VersionAndUrl?> getVersionAndUrl() async {
    final v = await _getNewVersion();
    if (v == null) return null;

    final url = await _newVersionUrl();

    return VersionAndUrl(v, url);
  }

  static Future<Version?> _getNewVersion() {
    return gitHub.repositories.listTags(repositorySlug).asyncMap((element) {
      try {
        return Version.parse(element.name.replaceFirst(versionRegExp, ''));
      } catch (e) {
        // TODO: log
        return null;
      }
    }).firstWhere((element) => (element ?? Version(0, 0, 0)) > version, orElse: () => null);
  }

  static Future<String?> _newVersionUrl() async {
    final release = await gitHub.repositories.getLatestRelease(repositorySlug);
    return release.assets?.firstWhere((element) {
      if (Platform.isAndroid) {
        return element.contentType == "application/vnd.android.package-archive";
      } else if (Platform.isWindows) {
        return element.contentType == "application/zip";
      } else if (Platform.isLinux) {
        return element.contentType == "application/gzip";
      } else {
        return false;
      }
    }).browserDownloadUrl;
  }
}
