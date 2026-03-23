import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stayvers_agent/auth/controller/verify_code_controller.dart';
import 'package:stayvers_agent/auth/model/data/login_request.dart';
import 'package:stayvers_agent/auth/model/data/verify_code_data.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/app/validator.dart';
import 'package:stayvers_agent/feature/dashBoard/view/page/dashboard_page.dart';
import 'package:stayvers_agent/shared/app_back_button.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/count_down_widget.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

class VerifyCodePage extends ConsumerStatefulWidget {
  static const route = '/VerifyCodePage';
  const VerifyCodePage({super.key, this.codeData});
  final VerificationCodeData? codeData;

  @override
  ConsumerState<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends ConsumerState<VerifyCodePage> {
  final _pinController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      isBusy: ref.watch(verifyCodeController).isBusy,
      isAuthSkeleton: true,
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
              '6-Digit Code',
              style: $styles.text.bodyBold.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 26,
                color: Colors.black,
              ),
            ),
            const Gap(8),
            Text(
              'Please enter the code sent to ${widget.codeData?.email}',
              style: $styles.text.bodyBold.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            Gap(0.05.sh),
            PinCodeTextField(
              appContext: context,
              length: 6,
              controller: _pinController,
              cursorColor: Colors.black,
              animationType: AnimationType.fade,
              validator: (value) => Validator.validatePin(value),
              errorTextSpace: 30,
              textStyle: $styles.text.bodyBold.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 28,
                color: context.color.primary,
              ),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              obscureText: true,
              obscuringCharacter: '*',
              autoDisposeControllers: false,
              blinkWhenObscuring: true,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.underline,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: Colors.transparent,
                inactiveFillColor: Colors.transparent,
                selectedFillColor: Colors.transparent,
                activeColor: context.color.primary,
                inactiveColor: Colors.grey,
                selectedColor: context.color.primary,
              ),
              animationDuration: const Duration(milliseconds: 300),
              enableActiveFill: true,
            ),
            const Gap(20),
            CoolDownButton(builder: (_, coolDown) {
              return InkWell(
                onTap: () {
                  _resendSms(coolDown);
                },
                child: Text(
                  'Resend SMS',
                  style: TextStyle(
                    color: context.color.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: context.color.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }),
            Gap(0.06.sh),
            AppBtn.from(
              text: 'Verify',
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

  void _resendSms(Function coolDown) async {
    final proceed = await ref
        .read(verifyCodeController.notifier)
        .resendToken(widget.codeData?.email ?? '');
    if (proceed) {
      coolDown();
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final proceed = await ref.read(verifyCodeController.notifier).verifyToken(
          loginRequest: LoginRequest(
              email: widget.codeData?.email ?? '',
              password: widget.codeData?.password ?? ''),
          otp: _pinController.text.trim());
      if (proceed) {
        $navigate.clearAllTo(DashBoardPage.route);
      }
    }
  }
}
