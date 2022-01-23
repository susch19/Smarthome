import 'package:flutter/material.dart';

class CircleBlurPainter extends CustomPainter {

  CircleBlurPainter(this.color, this.offset, {required this.circleWidth, required this.blurSigma});

  double circleWidth;
  double blurSigma;
  Color color;
  Offset offset;


  @override
  void paint(final Canvas canvas, final Size size) {
    final Paint line = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);
    final Offset center = offset;
    canvas.drawCircle(center, circleWidth, line);
  }

  @override
  bool shouldRepaint(final CustomPainter oldDelegate) {
    return true;
  }
}