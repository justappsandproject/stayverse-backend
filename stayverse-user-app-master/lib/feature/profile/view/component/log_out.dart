import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/auth/view/page/login_page.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/service/appSession/session.dart';
import 'package:stayverse/shared/buttons.dart';

class LogoutDialog extends ConsumerWidget {
  const LogoutDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog.adaptive(
      backgroundColor: $styles.colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Log Out 🚨',
              style: $styles.text.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: $styles.colors.black,
                  fontSize: 16.sp)),
          const Gap(10),
          Text('Are you sure you want logout?',
              style: $styles.text.bodySmall.copyWith(
                  fontWeight: FontWeight.w400,
                  color: $styles.colors.black,
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
                  bgColor: $styles.colors.greyB9,
                  expand: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                          color: $styles.colors.white,
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
