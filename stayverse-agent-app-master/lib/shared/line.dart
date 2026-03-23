import '../core/commonLibs/common_libs.dart';

///For Representing a horizontal line in
class HorizontalLine extends StatelessWidget {
  final Color? color;
  final double? thickness;
  final double? height;

  const HorizontalLine({super.key, this.color, this.thickness, this.height});

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: thickness ?? 1.5,
      color: color ?? Colors.grey[300] ?? Colors.grey,
      height: height ?? 10 * $styles.scale,
    );
  }
}

///For showwing a Vertical line
class VerticalLine extends StatelessWidget {
  final Color? color;
  final double? thickness;
  const VerticalLine({super.key, this.color, this.thickness});

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      thickness: thickness ?? 1.5,
      color: color ??Colors.grey[300]??Colors.grey,
      width: 10 * $styles.scale,
    );
  }
}
