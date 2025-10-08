// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'dart:ui';

// import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:signalr_client/signalr_client.dart';
// import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'dart:async';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/helper/notification_service.dart';
import 'package:smarthome/helper/preference_manager.dart';
import 'package:smarthome/helper/update_manager.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'info_icon_provider.dart';
import 'my_app.dart';
import 'package:firebase_core/firebase_core.dart'
    show Firebase, FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kDebugMode, kIsWeb;

part 'main.g.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(
    final RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  print(message.toMap().entries.join(','));
  print(message.data);
  print(message.messageId);
  print(message.sentTime?.toIso8601String());
  print(message.notification?.android?.priority);
}

//Implement https://developer.android.com/develop/ui/views/device-control as a seperate build
//Because having support for android kitkat is still wanted

final _brightnessChangeProvider = ChangeNotifierProvider.family<
    AdaptiveThemeModeWatcher, AdaptiveThemeManager>((final ref, final b) {
  return AdaptiveThemeModeWatcher(b);
});

@riverpod
Brightness brightness(final Ref ref, final AdaptiveThemeManager b) {
  final brightness = ref.watch(_brightnessChangeProvider(b)).brightness;
  return brightness;
}

// @riverpod
// Future<Tuple2<bool, bool>> showPin(final ShowPinRef ref) async {
//   final watched = ref.watch(deviceNameProvider);
//   final kioskMode = await ref.watch(inKioskModeProvider.future);
//   final falseTuple = Tuple2(false, kioskMode);

//   return watched.when(
//       data: (final data) => Tuple2(data == "SM-T560", falseTuple.item2),
//       error: ((final _, final __) => falseTuple),
//       loading: () => falseTuple);
// }

@riverpod
Future<String> deviceName(final Ref ref) async {
  if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return "";
  final pluginInfo = DeviceInfoPlugin();
  return (await pluginInfo.androidInfo).model;
}

// @riverpod
// Stream<bool> inKioskMode(final InKioskModeRef ref) {
//   if (!kIsWeb || defaultTargetPlatform != TargetPlatform.android)
//     return Stream.value(false);

//   return watchKioskMode(androidQueryPeriod: const Duration(seconds: 1))
//       .map((final o) => KioskMode.enabled == o);
// }

final _searchProvider = StateProvider<String>(((final ref) => ""));

final searchTextProvider = StateProvider<String>(((final ref) {
  final enabled = ref.watch(searchEnabledProvider);
  final text = ref.watch(_searchProvider);
  if (!enabled) return "";
  return text;
}));
final searchEnabledProvider = StateProvider<bool>(((final ref) => false));

@riverpod
Widget getTitleWidget(final Ref ref) {
  final enabled = ref.watch(searchEnabledProvider);

  if (!enabled) return const Text("Smart Home App");

  return TextField(
      decoration: const InputDecoration(hintText: "Suche"),
      // onSubmitted: (x) => _searchProducts(x, 1),
      autofocus: true,
      onChanged: (final s) => ref.watch(searchTextProvider.notifier).state = s);
}

@riverpod
List<Device> filteredDevices(final Ref ref) {
  final searchText = ref.watch(searchTextProvider).toLowerCase();

  final devices = ref.watch(sortedDeviceProvider);
  if (searchText.isEmpty) return devices;

  return devices
      .where((final element) =>
          element.typeName.toLowerCase().contains(searchText) ||
          (ref
                  .read(element.baseModelTProvider(element.id))
                  ?.friendlyName
                  .toLowerCase()
                  .contains(searchText) ??
              false))
      .toList();
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
      };
}

class DevHttpOverrides extends HttpOverrides {
  final String certificate;
  DevHttpOverrides(this.certificate);

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    context ??= SecurityContext(withTrustedRoots: true);

    context.setTrustedCertificatesBytes(certificate.codeUnits);
    return super.createHttpClient(context);
  }
}

StreamController<NotificationResponse> onDidReceiveNotificationResponse =
    StreamController<NotificationResponse>.broadcast();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) {
    SharedPreferences.setPrefix("debug.");
  } else {
    SharedPreferences.setPrefix("test.");
  }
  final prefs = await SharedPreferences.getInstance();
  // prefs.clear();
  final String certificate =
      await rootBundle.loadString('assets/certs/Smarthome.pem');

  HttpOverrides.global = DevHttpOverrides(certificate);

  PreferencesManager.instance = PreferencesManager(prefs);

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();
  final LinuxInitializationSettings initializationSettingsLinux =
      LinuxInitializationSettings(defaultActionName: 'Open notification');
  const WindowsInitializationSettings initSettings =
      WindowsInitializationSettings(
    appName: 'Smarthome',
    appUserModelId: 'de.susch19.Smarthome',
    guid: '07DCF00D-5E87-4882-9F37-A5F3242BF1A1',
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
    macOS: initializationSettingsDarwin,
    linux: initializationSettingsLinux,
    windows: initSettings,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (final details) =>
        onDidReceiveNotificationResponse.add(details),
  );

  final savedThemeMode =
      await AdaptiveTheme.getThemeMode() ?? AdaptiveThemeMode.system;
  DeviceManager.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Intl.defaultLocale = "de-DE";
  initializeDateFormatting("de-DE").then((final _) {
    // ConnectionManager.startConnection();
    runApp(ProviderScope(
      child: OKToast(
        backgroundColor: Colors.grey.withOpacity(0.3),
        position: ToastPosition.bottom,
        child: _EagerInitialization(
          child: MyApp(savedThemeMode),
        ),
      ),
    ));
  });
  UpdateManager.initialize();
}

class AdaptiveThemeModeWatcher extends ChangeNotifier {
  late Brightness brightness;

  final AdaptiveThemeManager _themeManager;
  AdaptiveThemeModeWatcher(this._themeManager) {
    _themeManager.modeChangeNotifier.addListener(modeChanged);
    brightness = _themeManager.brightness!;
  }

  void modeChanged() {
    final newBrightness = _themeManager.brightness;
    if (newBrightness != brightness) {
      brightness = newBrightness!;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _themeManager.modeChangeNotifier.removeListener(modeChanged);
    super.dispose();
  }
}

final infoIconProvider = StateNotifierProvider<InfoIconProvider, IconData>(
  (final ref) => InfoIconProvider(ref),
);

final maxCrossAxisExtentProvider = StateProvider<double>((final _) =>
    PreferencesManager.instance.getDouble("DashboardCardSize") ??
    (!kIsWeb && Platform.isAndroid ? 370 : 300));

class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});
  final Widget child;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    ref.read(notificationServiceProvider);

    ref.watch(_firebaseConfigProvider).whenData((final value) async {
      if (value == null) {
        return;
      }
      await Firebase.initializeApp(
        options: value,
      );
      await FirebaseMessaging.instance.requestPermission();

      FirebaseMessaging.onMessage.listen((final element) {
        print(element.data);
        print(element.messageId);
        print(element.sentTime?.toIso8601String());
        print(element.notification?.android?.priority);
      });
      if (Platform.isAndroid) {
        FirebaseMessaging.instance.subscribeToTopic("app");
      }
    });

    return child;
  }
}

final _firebaseConfigProvider =
    FutureProvider<FirebaseOptions?>((final ref) async {
  final connection = ref.watch(apiProvider);

  final apiRes = await connection.notificationFirebaseOptionsGet();
  final res = apiRes.bodyOrThrow as Map<String, dynamic>;
  final plattformName =
      kIsWeb ? "web" : defaultTargetPlatform.name.toLowerCase();
  if (!res.containsKey(plattformName)) return null;
  final subMap = res[plattformName] as Map<String, dynamic>;

  return FirebaseOptions(
      apiKey: subMap["apiKey"]!,
      appId: subMap["appId"]!,
      messagingSenderId: subMap["messagingSenderId"]!,
      projectId: subMap["projectId"]!,
      storageBucket: subMap["storageBucket"],
      iosBundleId: subMap["iosBundleId"],
      authDomain: subMap["authDomain"]);
});
