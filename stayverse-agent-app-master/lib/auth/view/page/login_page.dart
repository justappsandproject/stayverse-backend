import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/auth/controller/login_controller.dart';
import 'package:stayvers_agent/core/config/dev_test_login.dart';
import 'package:stayvers_agent/auth/model/data/login_request.dart';
import 'package:stayvers_agent/auth/model/data/verify_code_data.dart';
import 'package:stayvers_agent/auth/view/page/verify_otp_page.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/app/helper.dart';
import 'package:stayvers_agent/core/util/app/validator.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/core/util/textField/app_text_field.dart';
import 'package:stayvers_agent/feature/dashBoard/view/page/dashboard_page.dart';

import 'package:stayvers_agent/shared/app_back_button.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/line.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

import 'forgot_password_page.dart';
import 'signup_as_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  static const route = '/LoginPage';
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (kDevTestLoginEnabled && kDevTestAgentAccounts.isNotEmpty) {
      final a = kDevTestAgentAccounts.first;
      _emailController.text = a.email;
      _passwordController.text = a.password;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _loginWithCredentials(a.email, a.password);
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      isAuthSkeleton: true,
      isBusy: ref.watch(loginController).isBusy,
      appBar: AppBar(
        leading: const AppBackButton(),
        surfaceTintColor: AppColors.white,
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sign In',
                style: $styles.text.bodyBold.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 26,
                  color: Colors.black,
                ),
              ),
              const Gap(8),
              Text(
                'Please fill this form with your login credentials',
                style: $styles.text.bodyBold.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              Gap(0.05.sh),
              AppTextField(
                hintText: 'Email Address or Phone Number',
                controller: _emailController,
                validator: (value) => Validator.validateEmail(value),
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.emailAddress,
              ),
              const Gap(15),
              AppTextField(
                hintText: 'Password',
                controller: _passwordController,
                validator: (value) => Validator.validatePassword(value),
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.visiblePassword,
                isPassword: true,
              ),
              if (kDevTestLoginEnabled) ...[
                const Gap(12),
                Text(
                  'Dev: demo agents (Chef auto-login; tap to switch)',
                  style: $styles.text.bodySmall.copyWith(
                    fontSize: 12,
                    color: Colors.orange.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final a in kDevTestAgentAccounts)
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          foregroundColor: AppColors.black,
                          side: const BorderSide(color: Colors.black26),
                        ),
                        onPressed: () {
                          _emailController.text = a.email;
                          _passwordController.text = a.password;
                          setState(() {});
                          _loginWithCredentials(a.email, a.password);
                        },
                        child: Text(a.label),
                      ),
                  ],
                ),
              ],
              const Gap(15),
              InkWell(
                onTap: () => $navigate.to(ForgotPasswordPage.route),
                child: Text(
                  'Forgot Password',
                  style: $styles.text.bodyBold.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    decorationColor: context.color.primary,
                    color: context.color.primary,
                  ),
                ),
              ),
              Gap(0.08.sh),
              AppBtn.from(
                text: 'Sign In',
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
              const Gap(40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  children: [
                    const Expanded(child: HorizontalLine()),
                    const Gap(8),
                    Text(
                      'Or',
                      style: $styles.text.bodySmall.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const Gap(8),
                    const Expanded(child: HorizontalLine()),
                  ],
                ),
              ),
              // const Gap(35),
              // AppBtn(
              //   semanticLabel: '',
              //   onPressed: () {},
              //   bgColor: Colors.transparent,
              //   border: BorderSide(color: Colors.grey.shade300),
              //   expand: true,
              //   padding: const EdgeInsets.symmetric(vertical: 18),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       SvgPicture.asset(AppAsset.googleLogo),
              //       const Gap(8),
              //       const Text(
              //         'Sign in with Google',
              //         style: TextStyle(
              //           fontSize: 13,
              //           fontWeight: FontWeight.w500,
              //           color: Colors.black,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // const Gap(14),
              // AppBtn(
              //   semanticLabel: '',
              //   onPressed: () {},
              //   bgColor: Colors.transparent,
              //   border: BorderSide(color: Colors.grey.shade300),
              //   expand: true,
              //   padding: const EdgeInsets.symmetric(vertical: 18),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       SvgPicture.asset(AppAsset.appleLogo),
              //       const Gap(8),
              //       const Text(
              //         'Sign in with Apple',
              //         style: TextStyle(
              //           fontSize: 13,
              //           fontWeight: FontWeight.w500,
              //           color: Colors.black,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              const Gap(35),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'Don’t  have an account? ',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: 'Signup',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => $navigate.to(SignupAsPage.route),
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
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      closKeyPad(context);
      await _loginWithCredentials(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  Future<void> _loginWithCredentials(String email, String password) async {
    final loginRequest = LoginRequest(email: email, password: password);
    closKeyPad(context);
    if (!mounted) return;

    final proceed =
        await ref.read(loginController.notifier).login(loginRequest);

    if (!mounted) return;

    switch (proceed) {
      case LoginRoute.emailNotVerified:
        $navigate.toWithParameters(VerifyCodePage.route,
            args: VerificationCodeData(
              email: email,
              password: password,
            ));
        break;
      case LoginRoute.success:
        $navigate.clearAllTo(DashBoardPage.route);
        break;
      case LoginRoute.failed:
        break;
    }
  }
}
