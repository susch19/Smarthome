import 'dart:math';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class ThemeManager {
  static ThemeData getDarkTheme({final bool useMaterial3 = false}) {
    return ThemeData(
      useMaterial3: useMaterial3,
      // colorSchemeSeed: Colors.blue,
      brightness: Brightness.dark,
      secondaryHeaderColor: Colors.indigo,
      dialogBackgroundColor: Colors.indigo.shade900.withOpacity(0.95),
      cardTheme: CardTheme(color: Colors.indigo.shade800.withOpacity(0.95), shadowColor: Colors.black38),
      // backgroundColor: Colors.indigo.shade800.withOpacity(0.95),
      sliderTheme: const SliderThemeData(thumbColor: Colors.tealAccent, activeTrackColor: Colors.tealAccent),
      canvasColor: Colors.indigo.shade800.withOpacity(0.95),
      popupMenuTheme: PopupMenuThemeData(
        color: Colors.indigo.shade800.withOpacity(0.95),
      ),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith(_getColor),
      )),
      primarySwatch: Colors.blue,
      textTheme: const TextTheme(titleMedium: TextStyle(decorationColor: Colors.teal)),
      colorScheme: ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.teal,
          background: Colors.indigo.shade700,
          surface: Colors.blue.shade900,
          onPrimary: Colors.white,
          onSecondary: Colors.white),
      chipTheme: ChipThemeData(
          backgroundColor: Colors.indigo.shade600.withOpacity(0.95),
          brightness: Brightness.dark,
          disabledColor: Colors.indigo.shade900,
          labelStyle: const TextStyle(),
          padding: const EdgeInsetsDirectional.all(4),
          secondaryLabelStyle: const TextStyle(),
          secondarySelectedColor: Colors.indigo.withOpacity(0.95),
          selectedColor: Colors.indigo),
    );
  }

  static ThemeData getLightTheme({final bool useMaterial3 = false}) {
    final Color indigoColor = Colors.indigo.shade50;
    return ThemeData(
      useMaterial3: useMaterial3,
      brightness: Brightness.light,
      dialogBackgroundColor: indigoColor.withOpacity(0.95),
      cardTheme: CardTheme(color: indigoColor.withOpacity(0.95), shadowColor: Colors.white54),
      sliderTheme:
          SliderThemeData(thumbColor: Colors.tealAccent.shade100, activeTrackColor: Colors.tealAccent.shade100),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith(_getLightColor),
      )),
      popupMenuTheme: PopupMenuThemeData(
        color: Colors.indigo.shade100.withOpacity(0.95),
      ),
      textTheme: TextTheme(titleMedium: TextStyle(decorationColor: Colors.tealAccent.shade100)),
      chipTheme: ChipThemeData(
          backgroundColor: indigoColor.withOpacity(0.95),
          brightness: Brightness.light,
          disabledColor: Colors.indigo.shade400,
          labelStyle: const TextStyle(),
          padding: const EdgeInsetsDirectional.all(4),
          secondaryLabelStyle: const TextStyle(color: Colors.green),
          secondarySelectedColor: Colors.indigo.withOpacity(0.95),
          selectedColor: Colors.indigo),
      colorScheme: ColorScheme.light(
              primary: Colors.lightBlue.shade200,
              secondary: Colors.tealAccent.shade100,
              background: Colors.indigo.shade200,
              surface: indigoColor,
              onPrimary: Colors.black)
          .copyWith(primary: Colors.lightBlue, background: indigoColor.withOpacity(0.95)),
    );
  }

  static BoxDecoration getBackgroundDecoration(final BuildContext context) {
    var fract = MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;
    fract = pow(fract, 2).toDouble();
    return BoxDecoration(
      gradient: LinearGradient(
          colors: AdaptiveTheme.of(context).brightness == Brightness.dark
              ? [Colors.blue.shade900, Colors.deepPurple.shade700]
              : [Colors.blue.shade100, Colors.purple.shade100],
          begin: Alignment((-0.88 / fract), -1),
          end: Alignment((0.88 / fract), 1),
          stops: [
            0.3,
            fract.clamp(0.8, 1),
          ]),
    );
  }

  static Color _getColor(final Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.scrolledUnder,
      MaterialState.error,
      MaterialState.disabled
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.teal.shade900;
    }
    return Colors.tealAccent;
  }

  static Color _getLightColor(final Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.scrolledUnder,
      MaterialState.error,
      MaterialState.disabled
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.teal.shade200;
    }
    return Colors.lightBlue.shade200;
  }
}
