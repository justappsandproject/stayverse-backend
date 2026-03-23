import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/shared/buttons.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;

  const SectionTitle({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: $styles.text.title2.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        if (actionText != null)
          AppBtn(
            semanticLabel: '',
            onPressed: onActionTap,
            bgColor: Colors.transparent,
            padding: EdgeInsets.zero,
            child: Text(
              actionText!,
              style: $styles.text.title2.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: context.color.primary,
                height: 1.5,
              ),
            ),
          ),
      ],
    );
  }
}
