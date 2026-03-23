import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/service/toast_service.dart';
import 'package:stayverse/core/util/app/validator.dart';
import 'package:stayverse/core/util/textField/app_text_field.dart';
import 'package:stayverse/feature/dashboard/controller/dashboard_controller.dart';
import 'package:stayverse/feature/profile/controller/kyc_controller.dart';
import 'package:stayverse/shared/app_back_button.dart';
import 'package:stayverse/shared/app_icons.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/selfieCamera/component/selfieView/seflie_dailog.dart';
import 'package:stayverse/shared/skeleton.dart';


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
            const Gap(10),
            Text(
              'Complete your identity verification',
              style: $styles.text.body.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: $styles.colors.black0C,
              ),
            ),
            const Gap(4),
            Text(
              'We need to verify your identity to ensure the security of your account and comply with regulatory requirements.',
              style: $styles.text.body.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: $styles.colors.grey8F,
              ),
            ),
            const Gap(32),
            Text(
              'National Identification Number (NIN)',
              style: $styles.text.body.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: $styles.colors.black0C,
              ),
            ),
            const Gap(8),
            AppTextField(
              controller: ninController,
              hintText: 'Enter your 11-digit NIN',
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: [LengthLimitingTextInputFormatter(11)],
              validator: (value) => Validator.validateNin(value),
            ),
            const Gap(32),
            Text(
              'Selfie Verification',
              style: $styles.text.body.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: $styles.colors.black0C,
              ),
            ),
            const Gap(4),
            Text(
              'Take a clear selfie for identity verification',
              style: $styles.text.body.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: $styles.colors.greyB9,
              ),
            ),
            const Gap(16),
            GestureDetector(
              onTap: _takeSelfie,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: $styles.colors.greyF7,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: $styles.colors.greyB9,
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
                          AppIcon(
                            AppIcons.verify_biometrics,
                            size: 48,
                            color: $styles.colors.greyB9,
                          ),
                          const Gap(10),
                          Text(
                            'Tap to take selfie',
                            style: $styles.text.body.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: $styles.colors.greyB9,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            if (selfieImage != null) ...[
              const Gap(16),
              Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 20,
                  ),
                  const Gap(8),
                  Text(
                    'Selfie captured successfully',
                    style: $styles.text.body.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _takeSelfie,
                    child: Text(
                      'Retake',
                      style: $styles.text.body.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: context.themeColors.primaryAccent,
                      ),
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
            const Gap(20),
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
