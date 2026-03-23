import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/shared/app_icons.dart';
import 'package:stayvers_agent/shared/buttons.dart';

class WalletBtnComponent extends StatelessWidget {
  final String txt;
  final AppIcons icon;
  final Color bgColor;
  final VoidCallback onPressed;
  const WalletBtnComponent({
    super.key,
    required this.txt,
    required this.icon,
    this.bgColor = AppColors.white,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBtn(
      onPressed: onPressed,
      semanticLabel: '',
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      border: const BorderSide(color: AppColors.primaryyellow),
      bgColor: bgColor,
      child: Row(
        children: [
          AppIcon(icon),
          5.sbW,
          txt.txt16(
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
        ],
      ),
    );
  }
}
