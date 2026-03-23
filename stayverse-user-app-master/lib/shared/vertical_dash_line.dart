import 'package:stayverse/core/commonLibs/common_libs.dart';

class VeriticalDashLine extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;

  const VeriticalDashLine({super.key, this.height, this.color, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: null,
      height: height,
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
    const double dashLength = 5;
    const double dashSpace = 8;

    final Paint paint = Paint()
      ..color = color ?? Colors.grey[400] ?? Colors.grey
      ..strokeWidth = 2;

    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashLength), paint);
      startY += dashLength + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
