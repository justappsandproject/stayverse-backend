import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/service/toast_service.dart';
import 'package:stayvers_agent/core/util/app/validator.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/core/util/textField/app_text_field.dart';
import 'package:stayvers_agent/feature/dashboard/controller/dashboard_controller.dart';
import 'package:stayvers_agent/feature/profile/controller/kyc_controller.dart';
import 'package:stayvers_agent/shared/app_back_button.dart';
import 'package:stayvers_agent/shared/app_icons.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/selfieCamera/component/selfieView/seflie_dailog.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

class KycVerificationPage extends ConsumerStatefulWidget {
  const KycVerificationPage({super.key});

  static const String route = '/kyc-verification';

  @override
  ConsumerState<KycVerificationPage> createState() =>
      _KycVerificationPageState();
}

class _KycVerificationPageState extends ConsumerState<KycVerificationPage> {
  final TextEditingController ninController = TextEditingController();
  File? selfieImage;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    ninController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      isBusy: ref.watch(kycController).isBusy,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        leading: const AppBackButton(),
        title: const Text(
          'KYC Verification',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      bodyPadding: const EdgeInsets.all(16),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.sbH,
            'Complete your identity verification'.txt16(
              fontWeight: FontWeight.w600,
              color: AppColors.black0C,
            ),
            4.sbH,
            'We need to verify your identity to ensure the security of your account and comply with regulatory requirements.'
                .txt12(
              fontWeight: FontWeight.w400,
              color: AppColors.grey8F,
            ),
            32.sbH,
            'National Identification Number (NIN)'.txt14(
              fontWeight: FontWeight.w500,
              color: AppColors.black0C,
            ),
            8.sbH,
            AppTextField(
              controller: ninController,
              hintText: 'Enter your 11-digit NIN',
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: [LengthLimitingTextInputFormatter(11)],
              validator: (value) => Validator.validateNin(value),
            ),
            32.sbH,
            'Selfie Verification'.txt14(
              fontWeight: FontWeight.w500,
              color: AppColors.black0C,
            ),
            4.sbH,
            'Take a clear selfie for identity verification'.txt14(
              fontWeight: FontWeight.w400,
              color: AppColors.greyB9,
            ),
            16.sbH,
            GestureDetector(
              onTap: _takeSelfie,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.greyF7,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.greyB9,
                    width: 1,
                  ),
                ),
                child: selfieImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          selfieImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const AppIcon(
                            AppIcons.verify_biometrics,
                            size: 48,
                            color: AppColors.greyB9,
                          ),
                          10.sbH,
                          'Tap to take selfie'.txt14(
                            fontWeight: FontWeight.w400,
                            color: AppColors.greyB9,
                          ),
                        ],
                      ),
              ),
            ),
            if (selfieImage != null) ...[
              16.sbH,
              Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 20,
                  ),
                  8.sbW,
                  'Selfie captured successfully'.txt14(
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _takeSelfie,
                    child: 'Retake'.txt14(
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryyellow,
                    ),
                  ),
                ],
              ),
            ],
            const Spacer(),
            AppBtn.from(
              text: 'Submit Verification',
              expand: true,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              onPressed: _submitKyc,
            ),
            20.sbH,
          ],
        ),
      ),
    );
  }

  void _takeSelfie() {
    SelfieDialog.show(context, (File selfie) {
      setState(() {
        selfieImage = selfie;
      });
    });
  }

  void _submitKyc() async {
    if (_formKey.currentState!.validate()) {
      if (selfieImage == null) {
        BrimToast.showError('Take selfie', title: 'Selfie Required');
        return;
      }

      final proceed = await ref
          .read(kycController.notifier)
          .verifyKyc(ninController.text, selfieImage!);
      if (proceed) {
        ref.read(dashboadController.notifier).refreshUser();
        $navigate.back();
      }
    }
  }
}
