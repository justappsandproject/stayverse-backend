import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/auth/view/page/login_page.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/service/appSession/session.dart';
import 'package:stayvers_agent/core/util/style/app_style.dart';
import 'package:stayvers_agent/shared/buttons.dart';

class LogoutDialog extends ConsumerWidget {
  const LogoutDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog.adaptive(
      backgroundColor: AppColors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Log Out 🚨',
              style: $styles.text.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                  fontSize: 16.sp)),
          const Gap(10),
          Text('Are you sure you want logout?',
              style: $styles.text.bodySmall.copyWith(
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                  fontSize: 14.5.sp)),
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
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                    //$navigate.back();
                    _logOut(ref);
                  },
                  semanticLabel: '',
                  bgColor: Colors.red,
                  expand: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
    );
  }

  _logOut(WidgetRef ref) async {
    await AppSession.logOut(ref, route: LoginPage.route);
  }
}
