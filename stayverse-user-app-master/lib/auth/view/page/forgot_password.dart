import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/auth/controller/forget_password_controller.dart';
import 'package:stayverse/auth/view/page/reset_password.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/util/app/validator.dart';
import 'package:stayverse/core/util/textField/app_text_field.dart';
import 'package:stayverse/shared/app_back_button.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/skeleton.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  static const route = '/ForgotPasswordPage';
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final _forgetPasswordController = TextEditingController();

  @override
  void dispose() {
    _forgetPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      isAuthSkeleton: true,
      isBusy: ref.watch(forgetPasswordController).isBusy,
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(0.1.sh),
            const AppBackButton(),
            const Gap(20),
            Text(
              'Forgot Password',
              style: $styles.text.bodyBold.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 26,
                color: Colors.black,
              ),
            ),
            const Gap(8),
            Text(
              'Input your registered Email address',
              style: $styles.text.bodyBold.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            Gap(0.05.sh),
            AppTextField(
              hintText: 'Email Address',
              controller: _forgetPasswordController,
              validator: (value) => Validator.validateEmail(value),
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.emailAddress,
            ),
            const Gap(30),
            AppBtn.from(
              text: 'Send Code',
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
          .read(forgetPasswordController.notifier)
          .sendResetToken(_forgetPasswordController.text.trim());

      if (proceed) {
        $navigate.replaceWithParameters(ResetPasswordPage.route,
            args: _forgetPasswordController.text.trim());
      }
    }
  }
}
