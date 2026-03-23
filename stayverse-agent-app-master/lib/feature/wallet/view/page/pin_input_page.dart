import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/shared/app_back_button.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

class PinInputPage extends StatefulWidget {
  static const route = '/PinInputPage';
  const PinInputPage({super.key});

  @override
  State<PinInputPage> createState() => _PinInputPageState();
}

class _PinInputPageState extends State<PinInputPage> {
  final _inputPinController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _inputPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      isAuthSkeleton: true,
      appBar: AppBar(
        leading: const AppBackButton(),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            Text(
              'Security PIN',
              style: $styles.text.bodyBold.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 26,
                color: Colors.black,
              ),
            ),
            const Gap(8),
            Text(
              'Please enter your PIN to confirm transaction',
              style: $styles.text.bodyBold.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            Gap(0.05.sh),
            Container(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.3),
              child: PinCodeTextField(
                appContext: context,
                length: 4,
                controller: _inputPinController,
                cursorColor: Colors.black,
                animationType: AnimationType.fade,
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
            ),
            Gap(0.06.sh),
            AppBtn.from(
              text: 'Confirm',
              expand: true,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      $navigate.popUntil(3);
    }
  }
}
