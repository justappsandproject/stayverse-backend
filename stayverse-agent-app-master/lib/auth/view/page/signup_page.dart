import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/auth/controller/create_account_controller.dart';
import 'package:stayvers_agent/auth/model/data/register_request.dart';
import 'package:stayvers_agent/auth/model/data/verify_code_data.dart';
import 'package:stayvers_agent/auth/view/page/login_page.dart';
import 'package:stayvers_agent/auth/view/page/verify_otp_page.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/app/helper.dart';
import 'package:stayvers_agent/core/util/app/validator.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/core/util/textField/app_text_field.dart';
import 'package:stayvers_agent/feature/splashScreen/view/component/privacy_and_policy_sheet.dart';
import 'package:stayvers_agent/feature/splashScreen/view/component/terms_and_conditions_sheet.dart';
import 'package:stayvers_agent/shared/app_back_button.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

class SignUpPage extends ConsumerStatefulWidget {
  static const route = '/SignUpPage';
  const SignUpPage({super.key, this.accountType});
  final ServiceType? accountType;

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      isAuthSkeleton: true,
      isBusy: ref.watch(signUpController).isBusy,
      appBar: AppBar(
        leading: const AppBackButton(),
        surfaceTintColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sign Up',
                style: $styles.text.bodyBold.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 26,
                  color: Colors.black,
                ),
              ),
              const Gap(8),
              Text(
                'Please fill in this form to create an account',
                style: $styles.text.bodyBold.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              Gap(0.05.sh),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(
                    child: AppTextField(
                      hintText: 'First Name',
                      validator: (value) => Validator.validateName(value),
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.emailAddress,
                      controller: _firstNameController,
                    ),
                  ),
                  const Gap(15),
                  Expanded(
                    child: AppTextField(
                      hintText: 'Last Name',
                      validator: (value) => Validator.validateName(value),
                      textInputAction: TextInputAction.next,
                      controller: _lastNameController,
                      textInputType: TextInputType.emailAddress,
                    ),
                  ),
                ],
              ),
              const Gap(15),
              AppTextField(
                hintText: 'Email Address',
                validator: (value) => Validator.validateEmail(value),
                textInputAction: TextInputAction.next,
                controller: _emailController,
                textInputType: TextInputType.emailAddress,
              ),
              const Gap(15),
              AppTextField(
                hintText: 'Phone Number',
                validator: (value) => Validator.validatePhoneNumber(value),
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.number,
                controller: _phoneNumberController,
              ),
              const Gap(15),
              AppTextField(
                hintText: 'Create Password',
                validator: (value) => Validator.validatePassword(value),
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.visiblePassword,
                isPassword: true,
                controller: _passwordController,
              ),
              const Gap(15),
              AppTextField(
                hintText: 'Confirm Password',
                validator: (value) => Validator.validateConfirmPassword(
                    value, _passwordController.text),
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.visiblePassword,
                controller: _confirmPasswordController,
                isPassword: true,
              ),
              const Gap(40),
              AppBtn.from(
                text: 'Sign Up',
                expand: true,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
                bgColor: AppColors.black,
                onPressed: () {
                  _submit();
                },
              ),
              const Gap(10),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'Already have an account? ',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => $navigate.to(LoginPage.route),
                        text: 'Login',
                        style: TextStyle(
                          color: context.color.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: context.color.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Gap(30),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'By pressing Sign up securely, you agree to our ',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: 'Terms &\nConditions',
                        style: TextStyle(
                          color: context.color.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => showTermsAndConditions(context),
                      ),
                      const TextSpan(
                        text: ' and ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: context.color.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => showPrivacyPolicy(context),
                      ),
                      const TextSpan(
                        text: 'Your data will be securely\nencrypted with US',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Gap(30),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final registerUserRequest = RegisterUserRequest(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          lastname: _lastNameController.text.trim(),
          firstname: _firstNameController.text.trim(),
          phoneNumber: _phoneNumberController.text.trim(),
          serviceType: widget.accountType?.id);

      closKeyPad(context);
      final proceed = await ref
          .read(signUpController.notifier)
          .createAccount(registerUserRequest);

      if (proceed) {
        $navigate.toWithParameters(VerifyCodePage.route,
            args: VerificationCodeData(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ));
      }
    }
  }
}
