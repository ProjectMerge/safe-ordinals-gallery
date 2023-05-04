import 'package:flutter/material.dart';

class SliderPainter extends CustomPainter {
  SliderPainter({
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

    Path path = Path();

    path.moveTo(0, size.height / 2);
    path.quadraticBezierTo(
        dragPosition.dx, dragPosition.dy, size.width, size.height / 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
