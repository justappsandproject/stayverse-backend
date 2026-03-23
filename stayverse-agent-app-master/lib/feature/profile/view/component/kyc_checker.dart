import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/discover/view/component/kyc_modal_component.dart';
import 'package:stayvers_agent/feature/dashBoard/controller/dashboard_controller.dart';
import 'package:stayvers_agent/feature/profile/view/page/kyc_verification_page.dart';

class KycChecker {
  static void checKkYC(BuildContext context, WidgetRef ref) async {
    await ref.watch(dashboadController.notifier).refreshUser();
    final user = ref.watch(dashboadController).user;
    if (user?.isVerified == false) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SafeArea(
              child: Dialog(
                insetAnimationCurve: Curves.easeInOut,
                insetAnimationDuration: const Duration(milliseconds: 400),
                backgroundColor: AppColors.black80C,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: AppColors.brown28),
                ),
                child: KycModalComponent(
                  onPressed: () {
                    $navigate.back();
                    $navigate.to(KycVerificationPage.route);
                  },
                ),
              ),
            );
          },
        );
      }
    }
  }
}
