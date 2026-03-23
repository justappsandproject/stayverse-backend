import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/shared/app_icons.dart';

class AppDropdown extends StatelessWidget {
  final String? value, hintTxt, title;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final bool enabled;
  final Color? titleColor;

  const AppDropdown({
    super.key,
    required this.value,
    this.hintTxt,
    this.title,
    required this.onChanged,
    required this.items,
    this.enabled = true,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != null) ...[
          Align(
            alignment: Alignment.topLeft,
            child: Text(title!,
                textAlign: TextAlign.start,
                style: $styles.text.h4.copyWith(
                  fontSize: 14,
                  color: titleColor ?? Colors.black,
                  fontWeight: FontWeight.w500,
                  height: 0,
                )),
          ),
          Gap(10.spaceScale),
        ],
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0XFFAAADB7)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: Text(
                hintTxt ?? 'Select an Option',
                style: $styles.text.title1.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
              icon: const AppIcon(
                AppIcons.arrow_down,
                color: AppColors.black,
              ),
              value: value,
              items: items
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: $styles.text.title1.copyWith(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: enabled ? onChanged : null,
            ),
          ),
        ),
      ],
    );
  }
}
