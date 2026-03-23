import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/core/util/textField/app_text_field.dart';
import 'package:stayvers_agent/feature/carOwner/controller/ride_advert_controller.dart';
import 'package:stayvers_agent/feature/carOwner/view/page/edited_preview_page.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

class EditRideDetailsFormPage extends ConsumerStatefulWidget {
  static const route = '/EditRideDetailsFormPage';
  final String? rideId;
  const EditRideDetailsFormPage({super.key, this.rideId});

  @override
  ConsumerState<EditRideDetailsFormPage> createState() =>
      _EditRideDetailsFormPageState();
}

class _EditRideDetailsFormPageState
    extends ConsumerState<EditRideDetailsFormPage> {
  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(editRideAdvertProvider.notifier);
    return BrimSkeleton(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
      ),
      bodyPadding: const EdgeInsets.symmetric(horizontal: 18),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  'Car Details'.txt(
                    size: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                  'Please fill in this form with car details'.txt14(
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                  ),
                  23.sbH,
                  AppTextField(
                    title: 'Car Plate No.',
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 17),
                    controller: notifier.rideplateController,
                  ),
                  27.sbH,
                  AppTextField(
                    title: 'Vehicle Identification No.',
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 17),
                    controller: notifier.rideIdNumController,
                  ),
                  27.sbH,
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          title: 'Reg. No',
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 17),
                          controller: notifier.rideRegNoController,
                        ),
                      ),
                      11.sbW,
                      Expanded(
                        child: AppTextField(
                          title: 'Color',
                          hintText: 'Select Color',
                          textInputAction: TextInputAction.done,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 17),
                          controller: notifier.rideColorController,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          AppBtn.from(
            text: 'Confirm',
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
          20.sbH,
          const Center(
            child: Text.rich(
              TextSpan(
                text: 'By clicking confirm, you agree to our  ',
                style: TextStyle(
                  color: AppColors.grey8B,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(
                    text: 'Terms &\nConditions',
                    style: TextStyle(
                      color: AppColors.primaryyellow,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: ' and ',
                    style: TextStyle(
                      color: AppColors.grey8B,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      color: AppColors.primaryyellow,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  TextSpan(
                    text: 'Your data will be securely\nencrypted with US',
                    style: TextStyle(
                      color: AppColors.grey8B,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          20.sbH,
        ],
      ),
    );
  }

  void _submit() {
    final notifier = ref.read(editRideAdvertProvider.notifier);
    notifier.updateStateFromControllers();
    $navigate.toWithParameters(
      EditedPreviewPage.route,
      args: widget.rideId ?? '',
    );
  }
}
