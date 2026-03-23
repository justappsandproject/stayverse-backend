
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/auth/controller/login_controller.dart';
import 'package:stayverse/auth/model/data/login_request.dart';
import 'package:stayverse/auth/model/data/verify_code_data.dart';
import 'package:stayverse/auth/view/page/forgot_password.dart';
import 'package:stayverse/auth/view/page/sign_up_page.dart';
import 'package:stayverse/auth/view/page/verify_otp_page.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/util/app/validator.dart';
import 'package:stayverse/core/util/textField/app_text_field.dart';
import 'package:stayverse/feature/dashboard/view/page/dashboard_page.dart';
import 'package:stayverse/shared/app_back_button.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/line.dart';
import 'package:stayverse/shared/skeleton.dart';

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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      isAuthSkeleton: true,
      isBusy: ref.watch(loginController.select((state) => state.isBusy)),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(0.1.sh),
              const AppBackButton(),
              const Gap(20),
              Text(
                'Login',
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
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              Gap(0.05.sh),
              AppTextField(
                hintText: 'Email Address ',
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
              const Gap(20),
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
              Gap(0.05.sh),
              AppBtn.from(
                text: 'Login',
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
              const Gap(30),
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
              const Gap(25),
              // AppBtn(
              //   semanticLabel: '',
              //   onPressed: () {
              //     ThirdPartySignInService.instance.signInWithGoogle();
              //   },
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
              //   onPressed: () {
              //     if (Platform.isIOS) {
              //       ThirdPartySignInService.instance.signInWithApple();
              //     } else {
              //       BrimToast.showSuccess(
              //           'Apple Sign In is not available on this platform');
              //     }
              //   },
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
              //const Gap(20),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'Don’t  have an account? ',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: 'Signup',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => $navigate.to(SignUpPage.route),
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
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final loginRequest = LoginRequest(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      final proceed =
          await ref.read(loginController.notifier).login(loginRequest);

      if (!mounted) return;

      switch (proceed) {
        case LoginRoute.emailNotVerified:
          $navigate.toWithParameters(VerifyCodePage.route,
              args: VerificationCodeData(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
              ));
          break;
        case LoginRoute.success:
          $navigate.clearAllTo(DashbBoardScreenPage.route);
          break;
        case LoginRoute.failed:
          break;
      }
    }
  }
}
