import 'package:stayvers_agent/core/commonLibs/common_libs.dart';

enum ConfettiShape {
  rectangle,
  circle,
}

class ConfettiData {
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final Color color;
  final double rotation;
  final bool? hasRadius;
  final ConfettiShape shape;
  final Size size;

  ConfettiData({
    this.left,
    this.right,
    this.top,
    this.bottom,
    this.hasRadius = true,
    required this.color,
    required this.rotation,
    required this.shape,
    required this.size,
  });
}

class ConfettiPainter extends CustomPainter {
  final Color color;
  final bool? hasRadius;
  final ConfettiShape shape;

  ConfettiPainter({
    this.hasRadius = true,
    required this.color,
    required this.shape,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    switch (shape) {
      case ConfettiShape.rectangle:
        // Draw rectangular confetti
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height),
              (hasRadius ?? true) ? const Radius.circular(4.69) : Radius.zero),
          paint,
        );
        break;
      case ConfettiShape.circle:
        // Draw circular confetti
        canvas.drawCircle(
          Offset(size.width / 2, size.height / 2),
          size.width / 2,
          paint,
        );
        break;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
