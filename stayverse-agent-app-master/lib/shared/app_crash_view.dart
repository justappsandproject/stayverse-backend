import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

class AppCrashErrorView extends StatelessWidget {
  const AppCrashErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      backgroundColor: Colors.white,
      isBusy: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Gap(20),
          Text('We are fixing this issue',
              textAlign: TextAlign.start,
              style: $styles.text.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 18.sp)),
          const Gap(20),
        ],
      ),
    );
  }
}
