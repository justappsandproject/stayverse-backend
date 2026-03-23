import 'package:stayvers_agent/core/commonLibs/common_libs.dart';

class ConfirmationPageArgs {
  final String message;
  final VoidCallback onContinue;
  final String buttonText;
  final bool? underApproval;

  const ConfirmationPageArgs({
    required this.message,
    required this.onContinue,
    this.buttonText = 'Continue',
    this.underApproval = false,
  });
}