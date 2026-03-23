import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/auth/controller/create_account_controller.dart';
import 'package:stayverse/auth/model/data/register_request.dart';
import 'package:stayverse/auth/model/data/verify_code_data.dart';
import 'package:stayverse/auth/view/page/verify_otp_page.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/util/app/helper.dart';
import 'package:stayverse/core/util/app/validator.dart';
import 'package:stayverse/core/util/textField/app_text_field.dart';
import 'package:stayverse/feature/splashScreen/view/component/privacy_policy_sheet.dart';
import 'package:stayverse/feature/splashScreen/view/component/terms_and_condition_sheet.dart';
import 'package:stayverse/shared/app_back_button.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/skeleton.dart';

class SignUpPage extends ConsumerStatefulWidget {
  static const route = '/SignUpPage';
  const SignUpPage({super.key});

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
      isBusy: ref.watch(signUpController.select((state) => state.isBusy)),
      body: SingleChildScrollView(
        child: Form(
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
                'Create Account',
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
                  fontSize: 13,
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
                      controller: _firstNameController,
                      validator: (value) => Validator.validateName(value),
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.emailAddress,
                    ),
                  ),
                  const Gap(15),
                  Expanded(
                    child: AppTextField(
                      hintText: 'Last Name',
                      controller: _lastNameController,
                      validator: (value) => Validator.validateName(value),
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.emailAddress,
                    ),
                  ),
                ],
              ),
              const Gap(15),
              AppTextField(
                hintText: 'Email Address',
                controller: _emailController,
                validator: (value) => Validator.validateEmail(value),
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.emailAddress,
              ),
              const Gap(15),
              AppTextField(
                hintText: 'Phone Number',
                controller: _phoneNumberController,
                validator: (value) => Validator.validatePhoneNumber(value),
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.number,
              ),
              const Gap(15),
              AppTextField(
                hintText: 'Create Password',
                controller: _passwordController,
                validator: (value) => Validator.validatePassword(value),
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.visiblePassword,
                isPassword: true,
              ),
              const Gap(15),
              AppTextField(
                hintText: 'Confirm Password',
                controller: _confirmPasswordController,
                validator: (value) => Validator.validateConfirmPassword(
                    value, _passwordController.text.trim()),
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.visiblePassword,
                isPassword: true,
              ),
              const Gap(40),
              AppBtn.from(
                text: 'Create Account',
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
              const Gap(10),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'Already have an account?',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => $navigate.back(),
                        text: 'Login',
                        style: TextStyle(
                          color: context.color.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: context.color.primary,
                          fontSize: 12,
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
          phoneNumber: _phoneNumberController.text.trim());

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
