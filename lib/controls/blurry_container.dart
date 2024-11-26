//Copied from https://github.com/ranjeetrocky/blurry_container

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smarthome/helper/preference_manager.dart';

const EdgeInsetsGeometry kDefaultPadding = EdgeInsets.all(0);
const EdgeInsetsGeometry kDefaultMargin = EdgeInsets.all(0);
const Color kDefaultColor = Colors.transparent;
const BorderRadius kBorderRadius = BorderRadius.all(Radius.circular(10));
const BlendMode kblendMode = BlendMode.srcOver;

final blurryContainerBlurProvider = StateProvider<double>((final ref) {
  return PreferencesManager.instance.getDouble("BlurryContainerBlur") ?? 0;
});

class BlurryContainer extends ConsumerWidget {
  final Widget? child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final EdgeInsetsGeometry margin;
  final BorderRadius borderRadius;
  final BlendMode blendMode;

  const BlurryContainer(
      {this.child,
      this.padding = kDefaultPadding,
      this.color = kDefaultColor,
      this.borderRadius = kBorderRadius,
      this.margin = kDefaultMargin,
      this.blendMode = kblendMode,
      super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        padding: padding,
        margin: margin,
        color: color,
        child: child,
      ),
    );
  }
}
