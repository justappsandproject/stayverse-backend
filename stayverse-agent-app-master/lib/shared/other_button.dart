import 'package:stayvers_agent/shared/app_icons.dart';
import 'package:stayvers_agent/shared/buttons.dart';

import '../core/commonLibs/common_libs.dart';

class BackBtn extends StatelessWidget {
  const BackBtn({
    super.key,
    this.icon = AppIcons.back,
    this.onPressed,
    this.semanticLabel,
    this.bgColor,
    this.iconColor,
  });

  final Color? bgColor;
  final Color? iconColor;
  final AppIcons icon;
  final VoidCallback? onPressed;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return AppBtn.basic(
      onPressed: onPressed ?? () => Navigator.pop(context),
      semanticLabel: semanticLabel ?? 'Back Button',
      child: AppIcon.svg(
        icon,
        color: iconColor,
      ),
    );
  }

  Widget safe() => _SafeAreaWithPadding(child: this);
}

class _SafeAreaWithPadding extends StatelessWidget {
  const _SafeAreaWithPadding({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.all($styles.insets.sm),
        child: child,
      ),
    );
  }
}
