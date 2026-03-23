import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/widget_extension.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/profile/view/page/delete_account_page.dart';
import 'package:stayvers_agent/shared/buttons.dart';

class DeleteAccountDialog extends ConsumerWidget {
  const DeleteAccountDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog.adaptive(
      backgroundColor: AppColors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Delete Account 🚨',
              textAlign: TextAlign.center,
              style: $styles.text.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                  fontSize: 16.sp)),
          const Gap(10),
          Text(
              'Are you sure you want delete?\nYou will be asked to input your password',
              textAlign: TextAlign.center,
              style: $styles.text.bodySmall.copyWith(
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                  fontSize: 13.sp)),
          const Gap(14),
          Row(
            children: [
              Expanded(
                child: AppBtn(
                  onPressed: () {
                    $navigate.back();
                  },
                  semanticLabel: '',
                  bgColor: AppColors.greyB9,
                  expand: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  borderRadius: 15,
                  child: Text('No',
                      style: $styles.text.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          fontSize: 16.sp)),
                ),
              ),
              const Gap(10),
              Expanded(
                child: AppBtn(
                  onPressed: () {
                    $navigate.back();
                    $navigate.to(DeleteAccountPage.route);
                  },
                  semanticLabel: '',
                  bgColor: Colors.red,
                  expand: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  borderRadius: 15,
                  child: Text('Yes',
                      style: $styles.text.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          fontSize: 16.sp)),
                ),
              ),
            ],
          ),
        ],
      ),
    ).paddingAll(5);
  }
}
