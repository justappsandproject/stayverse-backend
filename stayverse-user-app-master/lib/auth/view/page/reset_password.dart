import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/auth/controller/reset_password_controller.dart';
import 'package:stayverse/auth/model/data/reset_password.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/util/app/validator.dart';
import 'package:stayverse/core/util/textField/app_text_field.dart';
import 'package:stayverse/shared/app_back_button.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/skeleton.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  static const route = '/ResetPasswordPage';
  const ResetPasswordPage({super.key, this.email});
  final String? email;

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      isAuthSkeleton: true,
      isBusy: ref.watch(resetPasswordControllerProvider).isBusy,
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(0.1.sh),
            const AppBackButton(),
            const Gap(20),
            Text(
              'Reset Password',
              style: $styles.text.bodyBold.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 26,
                color: Colors.black,
              ),
            ),
            const Gap(8),
            Text(
              'Enter Your New Password',
              style: $styles.text.bodyBold.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            Gap(0.05.sh),
            AppTextField(
              hintText:
                  'Enter 6 digits Code sent to ${widget.email ?? 'your email'}',
              validator: (value) => Validator.validatePin(value),
              controller: _otpController,
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.number,
            ),
            const Gap(15),
            AppTextField(
              hintText: 'Create Password',
              validator: (value) => Validator.validatePassword(value),
              textInputAction: TextInputAction.done,
              controller: _passwordController,
              textInputType: TextInputType.visiblePassword,
              isPassword: true,
            ),
            const Gap(15),
            AppTextField(
              hintText: 'Confirm Password',
              controller: _confirmPasswordController,
              validator: (value) => Validator.validateConfirmPassword(
                  value, _passwordController.text),
              textInputAction: TextInputAction.done,
              textInputType: TextInputType.visiblePassword,
              isPassword: true,
            ),
            const Gap(30),
            AppBtn.from(
              text: 'Reset Password',
              expand: true,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              onPressed: () {
                _submit();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final proceed = await ref
          .read(resetPasswordControllerProvider.notifier)
          .resetPassword(
            ResetPasswordRequest(
              email: widget.email ?? '',
              otp: _otpController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );

      if (proceed) {
        $navigate.back();
      }
    }
  }
}
