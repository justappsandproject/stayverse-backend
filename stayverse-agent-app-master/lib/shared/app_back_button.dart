import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/shared/app_icons.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';

class AppBackButton extends StatelessWidget {
  final Color? btnColor;
  final VoidCallback? onPressed;
  const AppBackButton({
    super.key,
    this.btnColor = AppColors.black,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return $navigate.canPop()
        ? AppBtn.basic(
            onPressed: onPressed ?? () {
              $navigate.back();
            },
            semanticLabel: 'back button',
            padding: EdgeInsets.zero,
            child: AppIcon(
              AppIcons.back,
              color: btnColor,
            ),
          )
        : const SizedBox.shrink();
  }
}
