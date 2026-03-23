import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/shared/app_icons.dart';
import 'package:stayverse/shared/buttons.dart';

class CircleBtn extends StatelessWidget {
  const CircleBtn({
    super.key,
    required this.child,
    this.onPressed,
    this.border,
    this.bgColor,
    this.size,
    required this.semanticLabel,
  });

  static double defaultSize = 48;

  final VoidCallback? onPressed;
  final Color? bgColor;
  final BorderSide? border;
  final Widget child;
  final double? size;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    double sz = size ?? defaultSize;
    return AppBtn(
      onPressed: onPressed,
      semanticLabel: semanticLabel,
      minimumSize: Size(sz, sz),
      padding: EdgeInsets.zero,
      circular: true,
      bgColor: bgColor,
      border: border,
      child: child,
    );
  }
}

class CircleIconBtn extends StatelessWidget {
  const CircleIconBtn({
    super.key,
    required this.icon,
    required this.onPressed,
    this.border,
    this.bgColor,
    this.color,
    this.size,
    this.iconSize,
    required this.semanticLabel,
  });

  static double defaultSize = 28;

  final AppIcons icon;
  final VoidCallback onPressed;
  final BorderSide? border;
  final Color? bgColor;
  final Color? color;
  final String semanticLabel;
  final double? size;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    Color defaultColor = Colors.grey[600] ?? Colors.grey;
    Color iconColor = color ?? Colors.white10;
    return CircleBtn(
      onPressed: onPressed,
      border: border,
      size: size,
      bgColor: bgColor ?? defaultColor,
      semanticLabel: semanticLabel,
      child: AppIcon(icon, size: iconSize ?? defaultSize, color: iconColor),
    );
  }
}

class CircleIcon extends StatelessWidget {
  const CircleIcon({
    super.key,
    required this.icon,
    this.color,
    this.radius,
    this.bgcolor,
    this.iconSize,
    this.iconType,
    iconColor,
  });

  final AppIcons icon;
  final Color? color;
  final Color? bgcolor;
  final double? radius;
  final double? iconSize;
  final IconType? iconType;

  @override
  Widget build(BuildContext context) {
   Color defaultColor = Colors.grey[600] ?? Colors.grey;
    Color iconColor = color ?? Colors.white10;
    return CircleAvatar(
      backgroundColor: bgcolor ?? defaultColor,
      maxRadius: radius ?? 28,
      child: AppIcon(
        icon,
        size: iconSize ?? 28,
        color: iconColor,
        iconType: iconType ?? IconType.svg,
      ),
    );
  }
}
