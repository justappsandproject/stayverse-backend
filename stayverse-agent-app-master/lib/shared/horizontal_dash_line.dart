import 'package:stayvers_agent/core/commonLibs/common_libs.dart';

class HorizontalDashLine extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;

  const HorizontalDashLine({super.key, this.height, this.color, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: CustomPaint(
        painter: DashedDividerPainter(color: color),
      ),
    );
  }
}

class DashedDividerPainter extends CustomPainter {
  final Color? color;

  DashedDividerPainter({Key? key, this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const double dashWidth = 5;
    const double dashSpace = 8;

    final Paint paint = Paint()
      ..color = color ?? Colors.grey[400]??Colors.grey
      ..strokeWidth = 1;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
