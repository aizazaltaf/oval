import 'package:flutter/material.dart';

class HalfPainter extends CustomPainter {
  HalfPainter({this.color});
  final Color? color;

  @override
  void paint(Canvas canvas, Size size) {
    const double curveSize = 10;
    const double xStartingPos = 0;
    final double yStartingPos = size.height / 2;
    final double yMaxPos = yStartingPos - curveSize;
    final path = Path()
      ..moveTo(xStartingPos, yStartingPos)
      ..lineTo(size.width - xStartingPos, yStartingPos)
      ..quadraticBezierTo(
        size.width - curveSize,
        yStartingPos,
        size.width - (curveSize + 5),
        yMaxPos,
      )
      ..lineTo(xStartingPos + (curveSize + 5), yMaxPos)
      ..quadraticBezierTo(
        xStartingPos + curveSize,
        yStartingPos,
        xStartingPos,
        yStartingPos,
      )
      ..close();
    canvas.drawPath(path, Paint()..color = color ?? Colors.white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
