import 'package:flutter/material.dart';

class CircleBlurPainter extends CustomPainter {

  CircleBlurPainter(this.color, this.offset, {required this.circleWidth, required this.blurSigma});

  double circleWidth;
  double blurSigma;
  Color color;
  Offset offset;


  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);
    Offset center = offset;
    canvas.drawCircle(center, circleWidth, line);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}