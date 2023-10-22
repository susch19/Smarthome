import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

import 'blurry_container.dart';

const BorderRadius defaultBorderRadius = BorderRadius.all(Radius.circular(10));
const MaterialColor defaultLightColor = Colors.lightBlue;
const MaterialColor defaultBlackColor = Colors.blue;
const Color defaultLightShadowColor = Colors.white38;
const Color defaultDarkShadowColor = Colors.black38;
const EdgeInsets defaultMargin = EdgeInsets.all(0);

class BlurryCard extends StatelessWidget {
  final Widget? child;
  final BorderRadius borderRadius;
  final MaterialColor lightColor;
  final MaterialColor darkColor;
  final Color lightShadowColor;
  final Color darkShadowColor;
  final EdgeInsets margin;
  const BlurryCard(
      {final Key? key,
      this.child,
      this.borderRadius = defaultBorderRadius,
      this.lightColor = defaultLightColor,
      this.darkColor = defaultBlackColor,
      this.lightShadowColor = defaultLightShadowColor,
      this.darkShadowColor = defaultDarkShadowColor,
      this.margin = defaultMargin})
      : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        margin: margin,
        child: BlurryContainer(
          color: AdaptiveTheme.of(context).brightness == Brightness.light
              ? defaultLightShadowColor
              : defaultDarkShadowColor,
          child: Card(
            color: Colors.transparent,
            shadowColor: Colors.transparent,
            // color: (ThemeManager.isLightTheme ? this.lightColor.shade400 : this.darkColor.shade800).withAlpha(75),
            // color: ThemeManager.isLightTheme ?  Colors.indigo.shade100.withOpacity(1) : Colors.indigo.shade800.withOpacity(0.25),
            child: child,
          ),
        ),
      ),
    );
  }
}
