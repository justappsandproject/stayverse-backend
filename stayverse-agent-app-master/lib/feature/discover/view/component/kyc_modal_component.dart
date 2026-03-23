import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/extension/widget_extension.dart';
import 'package:stayvers_agent/core/util/image/app_assets.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/dashBoard/controller/dashboard_controller.dart';
import 'package:stayvers_agent/shared/buttons.dart';

class KycModalComponent extends ConsumerWidget {
  final String? btnTxt;
  final VoidCallback onPressed;
  const KycModalComponent({
    super.key,
    this.btnTxt,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceType = ref.watch(
        dashboadController.select((state) => state.user?.agent?.serviceType));
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            44.sbH,
            SvgPicture.asset(AppAsset.completeKyc),
            29.sbH,
            (serviceType == ServiceType.apartmentOwner
                    ? 'Complete KYC Verification before you can list any apartment'
                    : 'Complete KYC Verification before you can list any car')
                .txt12(
              fontWeight: FontWeight.w500,
              color: AppColors.white,
              textAlign: TextAlign.center,
            ),
          ],
        ).paddingSymmetric(horizontal: 43),
        22.sbH,
        AppBtn.from(
          text: btnTxt ?? 'Start Verification',
          expand: true,
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          onPressed: onPressed,
        ).paddingSymmetric(
          horizontal: 36,
        ),
        22.sbH,
      ],
    );
  }
}
