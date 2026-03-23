import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/shared/app_icons.dart';
import 'package:stayverse/shared/buttons.dart';

class WalletBtnComponent extends StatelessWidget {
  final String txt;
  final AppIcons icon;
  final Color bgColor;
  final VoidCallback onPressed;
  const WalletBtnComponent({
    super.key,
    required this.txt,
    required this.icon,
    this.bgColor = Colors.white,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBtn(
      onPressed: onPressed,
      semanticLabel: '',
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      border: BorderSide(color: context.themeColors.primaryAccent),
      bgColor: bgColor,
      child: Row(
        children: [
          AppIcon(icon),
          const Gap(5),
          Text(
            txt,
            style: $styles.text.body.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
