import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  double circleRadius;
  Color color;
  Offset offset;

  CirclePainter(this.circleRadius, this.color, this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = color;
    canvas.drawCircle(offset, circleRadius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
