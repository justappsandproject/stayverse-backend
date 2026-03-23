import 'dart:ui';

import 'package:stayvers_agent/core/commonLibs/common_libs.dart';

// class DottedPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = Colors.grey[400]??Colors.grey
//       ..strokeWidth = 10;

//     double dashWidth = 5.0;
//     double dashSpace = 5.0;

//     // Draw top border
//     for (double i = 0; i < size.width; i += dashWidth + dashSpace) {
//       canvas.drawLine(Offset(i, 0), Offset(i + dashWidth, 0), paint);
//     }

//     // Draw right border
//     for (double i = 0; i < size.height; i += dashWidth + dashSpace) {
//       canvas.drawLine(
//           Offset(size.width, i), Offset(size.width, i + dashWidth), paint);
//     }

//     // Draw bottom border
//     for (double i = size.width; i > 0; i -= dashWidth + dashSpace) {
//       canvas.drawLine(
//           Offset(i, size.height), Offset(i - dashWidth, size.height), paint);
//     }

//     // Draw left border
//     for (double i = size.height; i > 0; i -= dashWidth + dashSpace) {
//       canvas.drawLine(Offset(0, i), Offset(0, i - dashWidth), paint);
//     }
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }


enum DottedShape { rectangle, circle }

class DottedPainter extends CustomPainter {
  final DottedShape shape;
  final Color dashColor;
  final double? recRadius;

  DottedPainter({required this.shape, required this.dashColor, this.recRadius});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = dashColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    double dashWidth = 5.0;
    double dashSpace = 5.0;

    Path path = Path();
    if (shape == DottedShape.rectangle) {
      // Create a rectangular path
      path.addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(recRadius ?? 8.0),
        ),
      );
    } else if (shape == DottedShape.circle) {
      // Create a circular path
      path.addOval(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ));
    }

    for (PathMetric pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        canvas.drawPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}