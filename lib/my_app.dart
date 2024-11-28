import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/helper/preference_manager.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/main.dart';

import 'my_home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp(this.savedThemeMode, {super.key});

  static late PreferencesManager prefManager;
  final AdaptiveThemeMode savedThemeMode;

  @override
  Widget build(final BuildContext context) {
    return AdaptiveTheme(
        light: ThemeManager.getLightTheme(),
        dark: ThemeManager.getDarkTheme(),
        initial: savedThemeMode,
        builder: (final theme, final darkTheme) => MaterialApp(
              scrollBehavior: CustomScrollBehavior(),
              title: 'Smarthome',
              theme: theme,
              darkTheme: darkTheme,
              home: const MyHomePage(title: 'Smarthome Home Page'),
            ));
  }
}
