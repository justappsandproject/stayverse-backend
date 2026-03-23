import 'package:dart_extensions/dart_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/feature/profile/view/page/delete_account_page.dart';
import 'package:stayverse/shared/buttons.dart';

class DeleteAccountDialog extends ConsumerWidget {
  const DeleteAccountDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog.adaptive(
      backgroundColor: $styles.colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Delete Account 🚨',
              textAlign: TextAlign.center,
              style: $styles.text.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: $styles.colors.black,
                  fontSize: 16.sp)),
          const Gap(10),
          Text(
              'Are you sure you want delete?\nYou will be asked to input your password',
              textAlign: TextAlign.center,
              style: $styles.text.bodySmall.copyWith(
                  fontWeight: FontWeight.w400,
                  color:$styles.colors.black ,
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
                  bgColor: $styles.colors.greyB9,
                  expand: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  borderRadius: 15,
                  child: Text('No',
                      style: $styles.text.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: $styles.colors.white,
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
                          color: $styles.colors.white,
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
