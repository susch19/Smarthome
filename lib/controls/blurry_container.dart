//Copied from https://github.com/ranjeetrocky/blurry_container

import 'dart:ui';

import 'package:flutter/material.dart';


const double kBlur = 1.0;
const EdgeInsetsGeometry kDefaultPadding = EdgeInsets.all(0);
const EdgeInsetsGeometry kDefaultMargin = EdgeInsets.all(0);
const Color kDefaultColor = Colors.transparent;
const BorderRadius kBorderRadius = BorderRadius.all(Radius.circular(10));
const BlendMode kblendMode = BlendMode.srcOver;

class BlurryContainer extends StatelessWidget {
  final Widget? child;
  final double blur;
  final EdgeInsetsGeometry padding;
  final Color color;
  final EdgeInsetsGeometry margin;
  final BorderRadius borderRadius;
  final BlendMode blendMode;


  BlurryContainer(
      {this.child,
      this.blur = 5,
      this.padding = kDefaultPadding,
      this.color = kDefaultColor,
      this.borderRadius = kBorderRadius,
      this.margin = kDefaultMargin,
      this.blendMode = kblendMode
      });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        blendMode: blendMode,
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          margin: margin,
          color: color,
          child: child,
        ),
      ),
    );
  }
}
