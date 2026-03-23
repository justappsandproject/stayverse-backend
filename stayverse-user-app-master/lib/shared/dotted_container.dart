import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/util/color/color_utils.dart';
import 'package:stayverse/shared/dash_boder.dart';

class DottedContainer extends StatelessWidget {
  final Widget child;
  const DottedContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CustomPaint(
          painter: DottedPainter(),
          child:
              ColoredBox(color: ColorUtils.parseHex('#1D1D1D'), child: child),
        ),
      ),
    );
  }
}
