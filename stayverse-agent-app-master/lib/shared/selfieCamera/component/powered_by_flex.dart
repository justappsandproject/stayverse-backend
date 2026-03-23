import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/util/image/app_assets.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';

class PoweredByStayvers extends StatelessWidget {
  const PoweredByStayvers({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Powered by',
            textAlign: TextAlign.center,
            style: $styles.text.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.black,
                fontSize: 14.sp),
          ),
          const Gap(5),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: AppColors.black,
            ),
            padding: const EdgeInsets.all(1),
            height: 24,
            width: 24,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                AppAsset.pngLogo,
                height: 24,
                width: 24,
              ),
            ),
          )
        ],
      ),
    );
  }
}
