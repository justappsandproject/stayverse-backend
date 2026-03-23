import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';

import '../ui_state/custom_textfield_ui_state.dart';

class CustomTextField extends ConsumerWidget {
  final String semanticLabel;
  final String? title, hintTxt;
  final String initialValue;
  final Color? titleColor;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextField({
    super.key,
    required this.semanticLabel,
    this.title,
    this.hintTxt,
    this.initialValue = '',
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.contentPadding,
    this.titleColor, 
    this.controller
  });

 @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textValue = ref.watch(textFieldProvider(semanticLabel));
    final notifier = ref.read(textFieldProvider(semanticLabel).notifier);
    
    final OutlineInputBorder borders = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: textValue.isEmpty ? AppColors.greyF4 : AppColors.yellowB7,
        width: 1,
      ),
    );

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
        TextFormField(
          controller: controller,
          style: $styles.text.title1.copyWith(
              color: AppColors.primaryyellow,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600),
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hintTxt ?? '',
            filled: true,
            fillColor: textValue.isEmpty ? AppColors.greyF7 : AppColors.yellowD7,
            border: borders,
            enabledBorder: borders,
            focusedBorder: borders,
            hintStyle: $styles.text.bodySmall.copyWith(
              color: AppColors.greyB9,
              fontSize: 12.sp,
            ),
            contentPadding: contentPadding ??
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 11.h),
          ),
          onChanged: (value) {
            notifier.updateText(value);
            onChanged?.call(value);
          },
        ),
      ],
    );
  }
}