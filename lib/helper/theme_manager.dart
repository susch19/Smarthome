import 'dart:math';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeManager {
  static AdaptiveThemeMode brightness = AdaptiveThemeMode.dark;
  static bool get isLightTheme => brightness == AdaptiveThemeMode.light;

  static void initThemeManager(AdaptiveThemeMode? savedThemeMode) {
    if (savedThemeMode == null) savedThemeMode = AdaptiveThemeMode.system;
    brightness = savedThemeMode;
  }

  static ThemeData getDarkTheme() {
    // return ThemeData.dark();
    return ThemeData(
      brightness: Brightness.dark,
      dialogBackgroundColor: Colors.indigo.shade900.withOpacity(0.95),
      cardTheme: CardTheme(color: Colors.indigo.shade800.withOpacity(0.95), shadowColor: Colors.black38),
      backgroundColor: Colors.indigo.shade800.withOpacity(0.95),
      sliderTheme: SliderThemeData(thumbColor: Colors.tealAccent, activeTrackColor: Colors.tealAccent),
      canvasColor: Colors.indigo.shade800.withOpacity(0.95),
      // dialogTheme: DialogTheme(backgroundColor: Colors.indigo.shade800.withOpacity(0.95),),
      popupMenuTheme: PopupMenuThemeData(
        color: Colors.indigo.shade800.withOpacity(0.95),
      ),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith(_getColor),
      )),
      primarySwatch: Colors.blue,
      textTheme: TextTheme(subtitle1: TextStyle(decorationColor: Colors.teal)),
      colorScheme: ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.teal,
          background: Colors.indigo.shade700,
          secondaryVariant: Colors.indigo.shade900,
          primaryVariant: Colors.blue.shade900,
          surface: Colors.blue.shade900,
          brightness: Brightness.dark,
          onSurface: Colors.white,
          onBackground: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white),
      chipTheme: ChipThemeData(
          backgroundColor: Colors.indigo.shade600.withOpacity(0.95),
          brightness: Brightness.dark,
          disabledColor: Colors.indigo.shade900,
          labelStyle: TextStyle(),
          padding: EdgeInsetsDirectional.all(4),
          secondaryLabelStyle: TextStyle(),
          secondarySelectedColor: Colors.indigo.withOpacity(0.95),
          selectedColor: Colors.indigo),
    );
  }

  static ThemeData getLightTheme() {
    final Color indigoColor = Colors.indigo.shade50;

    // return ThemeData.light();

    return ThemeData(
      brightness: Brightness.light,
      dialogBackgroundColor: indigoColor.withOpacity(0.95),
      cardTheme: CardTheme(color: indigoColor.withOpacity(0.95), shadowColor: Colors.white54),
      backgroundColor: indigoColor.withOpacity(0.95),
      sliderTheme:
          SliderThemeData(thumbColor: Colors.tealAccent.shade100, activeTrackColor: Colors.tealAccent.shade100),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith(_getLightColor),
      )),
      popupMenuTheme: PopupMenuThemeData(
        color: Colors.indigo.shade100.withOpacity(0.95),
      ),
      primarySwatch: Colors.lightBlue,
      textTheme: TextTheme(subtitle1: TextStyle(decorationColor: Colors.tealAccent.shade100)),
      colorScheme: ColorScheme.light(
          primary: Colors.lightBlue.shade200,
          secondary: Colors.tealAccent.shade100,
          background: Colors.indigo.shade200,
          secondaryVariant: indigoColor,
          primaryVariant: Colors.lightBlue.shade50,
          surface: indigoColor,
          brightness: Brightness.light,
          onSurface: Colors.black,
          onBackground: Colors.black,
          onPrimary: Colors.black,
          onSecondary: Colors.black),
      chipTheme: ChipThemeData(
          backgroundColor: indigoColor.withOpacity(0.95),
          brightness: Brightness.light,
          disabledColor: Colors.indigo.shade400,
          labelStyle: TextStyle(),
          padding: EdgeInsetsDirectional.all(4),
          secondaryLabelStyle: TextStyle(color: Colors.green),
          secondarySelectedColor: Colors.indigo.withOpacity(0.95),
          selectedColor: Colors.indigo),
    );
  }

  static toogleThemeMode(BuildContext context) {
    var adaptiveTheme = AdaptiveTheme.of(context);
    brightness = adaptiveTheme.mode == AdaptiveThemeMode.dark ? AdaptiveThemeMode.light : AdaptiveThemeMode.dark;
    adaptiveTheme.setThemeMode(brightness);
  }

  static BoxDecoration getBackgroundDecoration(BuildContext context) {
    var fract = MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;
    fract = pow(fract, 2).toDouble();
    return BoxDecoration(
      gradient: LinearGradient(
          colors: !ThemeManager.isLightTheme
              ? [Colors.blue.shade900, /*Colors.indigo.shade900, 0d47a1 -> 311b92*/ Colors.deepPurple.shade700]
              : [Colors.blue.shade100, Colors.purple.shade100],
          // colors: [Colors.black, Colors.white, Colors.black],
          // begin: Alignment(-1/fract,-1 *fract),
          // end: Alignment(1*fract,1/fract),
          begin: Alignment((-0.88 / fract), -1),
          end: Alignment((0.88 / fract), 1),
          // fract: 1.623469387755102
          // begin:Alignment(0.5,0.8),
          // end: Alignment(-0.15,-1.2),
          // transform: GradientRotation(MediaQuery.of(context).size.width / MediaQuery.of(context).size.height),
          stops: [
            0.3,
            fract.clamp(0.8, 1),
          ]
          // stops: [
          //             0.495,
          //             0.5,
          //             0.505
          //           ]
          // begin: Alignment(-2.0, -8.0),
          // end: Alignment(1.0, 4.0),
          // transform: GradientRotation(3.14/4)
          ),
    );
  }

  static Color _getColor(Set<MaterialState> states) {
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

  static Color _getLightColor(Set<MaterialState> states) {
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
