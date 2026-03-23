import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/util/app/helper.dart';
import 'package:stayverse/core/util/app/validator.dart';
import 'package:stayverse/core/util/textField/app_text_field.dart';
import 'package:stayverse/shared/buttons.dart';

class EnterPasswordBottomSheet extends ConsumerStatefulWidget {
  const EnterPasswordBottomSheet({super.key, required this.onAddFunds});
  final ValueChanged<String?> onAddFunds;

  static Future<String?> show(
    BuildContext context,
    ValueChanged<String?> onAddFunds,
  ) {
    return showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return EnterPasswordBottomSheet(
          onAddFunds: (value) {
            onAddFunds(value);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  ConsumerState<EnterPasswordBottomSheet> createState() =>
      _EnterPasswordBottomSheetState();
}

class _EnterPasswordBottomSheetState
    extends ConsumerState<EnterPasswordBottomSheet> {
  final formKey = GlobalKey<FormState>();
  String amount = '';

  void _submit() {
    if (formKey.currentState?.validate() ?? false) {
      widget.onAddFunds(amount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        closKeyPad(context);
      },
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.only(
            left: 22,
            right: 21,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Gap(16) ,

              // Title
               Text(
                      'Enter Password',
                      style: $styles.text.body.copyWith(
                        color: $styles.colors.black,
                        fontSize: 20,
                      ),
                    ),
              const Gap(32),

              AppTextField(
                hintText: 'Enter Password',
                isPassword: true,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.visiblePassword,
                validator: (value) => Validator.validatePassword(value),
                onChanged: (value) {
                  setState(() {
                    amount = value;
                  });
                },
              ),
              const Gap(50),

              AppBtn.from(
                text: 'Withdraw',
                expand: true,
                bgColor: context.themeColors.primaryAccent,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
