import 'dart:math';

import 'package:flutter/material.dart';

class ThumbPainter extends CustomPainter {
  ThumbPainter({
    required this.dragPosition,
    required this.sliderColor,
  });
  final Offset dragPosition;
  final Color sliderColor;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = sliderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    paint
      ..color = sliderColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(getPointOnQuadraticBezier(Offset(0, size.height / 2), dragPosition, Offset(size.width, size.height / 2), dragPosition.dx), 8.0, paint);
  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return (oldDelegate as ThumbPainter).dragPosition != dragPosition;
  }
}

Offset getPointOnQuadraticBezier(Offset start, Offset control, Offset end, double x) {
  final a = start.dx - 2 * control.dx + end.dx;
  final b = 2 * (control.dx - start.dx);
  final c = start.dx - x;

  final discriminant = b * b - 4 * a * c;
  if (discriminant < 0) {
    return Offset(x, start.dy);
  }

  final t1 = (-b + sqrt(discriminant)) / (2 * a);
  final t2 = (-b - sqrt(discriminant)) / (2 * a);
  final t = (t1 >= 0 && t1 <= 1) ? t1 : t2;

  final y = pow(1 - t, 2) * start.dy + 2 * (1 - t) * t * control.dy + pow(t, 2) * end.dy;

  return Offset(x, y);
}
