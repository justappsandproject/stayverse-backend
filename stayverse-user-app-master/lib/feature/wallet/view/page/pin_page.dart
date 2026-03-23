import 'package:pinput/pinput.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/feature/wallet/view/page/create_pin_page.dart';
import 'package:stayverse/shared/app_back_button.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/skeleton.dart';

class PinPage extends StatefulWidget {
  static const route = '/PinPage';
  const PinPage({super.key});

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 45,
      height: 45,
      textStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: context.color.primary,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
    );

    return BrimSkeleton(
      isAuthSkeleton: false,
      backgroundColor: Colors.white,
      bodyPadding: EdgeInsets.zero,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        leading: const AppBackButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Security PIN',
                style: $styles.text.body.copyWith(
                  color: Colors.black,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Gap(5),
              Text(
                'Please enter your PIN to confirm transaction',
                style: $styles.text.body.copyWith(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 32),
              Pinput(
                length: 4,
                controller: pinController,
                focusNode: focusNode,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom:
                          BorderSide(color: context.color.primary, width: 2),
                    ),
                  ),
                ),
                showCursor: false,
              ),
              const Spacer(),
              AppBtn.from(
                text: "Confirm",
                expand: true,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                onPressed: () {
                  // Handle PIN confirmation
                  if (pinController.text.length == 4) {
                    $navigate.to(CreatePinPage.route);
                    // Process the PIN
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
