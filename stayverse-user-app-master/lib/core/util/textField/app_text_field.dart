import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/util/app/helper.dart';
import 'package:intl/intl.dart';

class AppTextField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String?)? onSaved;
  final Function()? onEditingComplete;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool obscureText;
  final bool readOnly;
  final bool floatHint;
  final String? initialValue;
  final Widget? prefixWidget;
  final bool? isPassword;
  final FocusNode? focusNode;
  final Widget? suffixWidget;
  final TextInputAction textInputAction;
  final TextAlign? textAlign;
  final TextInputType? textInputType;
  final int minLines;
  final int maxLines;
  final Function()? onTap;
  final Color? fillColor;
  final List<TextInputFormatter>? inputFormatters;
  final String? title;
  final EdgeInsetsGeometry? contentPadding;
  final BorderRadius? borderRadius;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final Color? disableBorderColor;

  const AppTextField({
    super.key,
    this.hintText,
    this.controller,
    this.onChanged,
    this.onEditingComplete,
    this.onSaved,
    this.fillColor,
    this.validator,
    this.enabled = true,
    this.title,
    this.obscureText = false,
    this.readOnly = false,
    this.initialValue,
    this.focusNode,
    this.textInputAction = TextInputAction.next,
    this.textInputType,
    this.inputFormatters,
    this.floatHint = false,
    this.textAlign,
    this.prefixWidget,
    this.minLines = 1,
    this.maxLines = 1,
    this.onTap,
    this.suffixWidget,
    this.isPassword = false,
    this.contentPadding,
    this.borderRadius,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.disableBorderColor,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isNotEmpty(widget.title)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(widget.title ?? '',
                        textAlign: TextAlign.start,
                        style: $styles.text.h4.copyWith(
                          fontSize: 14,
                          color: widget.enabled
                              ? Colors.black
                              : Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                          height: 0,
                        )),
                  ),
                  Gap(10.spaceScale)
                ],
              )
            : SizedBox.fromSize(),
        TextFormField(
          style: $styles.text.title1.copyWith(
              color: widget.enabled ? Colors.black : Colors.grey.shade500,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600),
          controller: widget.controller,
          onChanged: widget.onChanged,
          validator: widget.validator,
          onSaved: widget.onSaved,
          focusNode: widget.focusNode,
          onEditingComplete: widget.onEditingComplete,
          onTap: widget.onTap,
          autofocus: false,
          textAlign: widget.textAlign ?? TextAlign.left,
          enabled: widget.enabled,
          obscureText: widget.isPassword! ? _visible : false,
          readOnly: widget.onTap != null || widget.readOnly,
          initialValue: widget.initialValue,
          keyboardType: widget.textInputType,
          textInputAction: widget.textInputAction,
          inputFormatters: widget.inputFormatters,
          minLines: widget.minLines,
          maxLines: widget.minLines > widget.maxLines
              ? widget.minLines
              : widget.maxLines,
          decoration: InputDecoration(
            constraints: BoxConstraints(maxHeight: 200.h, minHeight: 45.h),
            filled: true,
            prefixIcon: widget.prefixWidget == null
                ? null
                : Padding(
                    padding: EdgeInsets.only(left: 11.w, right: 11.w),
                    child: widget.prefixWidget,
                  ),
            suffixIcon: widget.suffixWidget ??
                (widget.isPassword!
                    ? IconButton(
                        icon: _visible
                            ? const Icon(
                                Icons.visibility,
                                color: Color(0xffacacac),
                              )
                            : const Icon(
                                Icons.visibility_off,
                                color: Color(0xffacacac),
                              ),
                        onPressed: () {
                          setState(() {
                            _visible = !_visible;
                          });
                        },
                      )
                    : null),
            fillColor: Colors.transparent,
            hintText: widget.floatHint ? null : widget.hintText,
            enabled: widget.enabled,
            labelText: widget.floatHint ? widget.hintText : null,
            labelStyle: $styles.text.title1.copyWith(
              color: Colors.black,
            ),
            hintStyle: $styles.text.bodySmall.copyWith(
              color: Colors.grey,
              fontSize: 12.sp,
            ),
            floatingLabelStyle: $styles.text.bodySmall
                .copyWith(color: Colors.grey, fontSize: 14.sp),
            enabledBorder: enabledBorder,
            disabledBorder: disableBorder,
            focusedBorder: focusedBorder,
            border: focusedBorder,
            contentPadding: widget.contentPadding ??
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder get enabledBorder => OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
      borderSide: BorderSide(
          color: widget.enabledBorderColor ?? const Color(0XFFAAADB7),
          width: 1));

  OutlineInputBorder get focusedBorder => OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
      borderSide: BorderSide(
          color: widget.focusedBorderColor ?? const Color(0XFFFBC036),
          width: 1));
  OutlineInputBorder get disableBorder => OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
      borderSide: BorderSide(
          color: widget.disableBorderColor ?? const Color(0XFFAAADB7),
          width: 1));
}

class MoneyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (isNotEmpty(newValue.text)) {
      final int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;
      final f = NumberFormat('#,###');
      final number =
          int.parse(newValue.text.replaceAll(f.symbols.GROUP_SEP, ''));
      final newString = f.format(number);
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
            offset: newString.length - selectionIndexFromTheRight),
      );
    } else {
      return newValue;
    }
  }
}
