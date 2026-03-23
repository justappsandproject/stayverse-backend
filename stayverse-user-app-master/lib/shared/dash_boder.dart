import 'package:stayverse/core/commonLibs/common_libs.dart';

class DottedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey[400]??Colors.grey
      ..strokeWidth = 10;

    double dashWidth = 5.0;
    double dashSpace = 5.0;

    // Draw top border
    for (double i = 0; i < size.width; i += dashWidth + dashSpace) {
      canvas.drawLine(Offset(i, 0), Offset(i + dashWidth, 0), paint);
    }

    // Draw right border
    for (double i = 0; i < size.height; i += dashWidth + dashSpace) {
      canvas.drawLine(
          Offset(size.width, i), Offset(size.width, i + dashWidth), paint);
    }

    // Draw bottom border
    for (double i = size.width; i > 0; i -= dashWidth + dashSpace) {
      canvas.drawLine(
          Offset(i, size.height), Offset(i - dashWidth, size.height), paint);
    }

    // Draw left border
    for (double i = size.height; i > 0; i -= dashWidth + dashSpace) {
      canvas.drawLine(Offset(0, i), Offset(0, i - dashWidth), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
