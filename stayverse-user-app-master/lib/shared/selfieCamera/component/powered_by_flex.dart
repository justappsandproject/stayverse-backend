import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/util/image/app_assets.dart';

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
                color: $styles.colors.black,
                fontSize: 14.sp),
          ),
          const Gap(5),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: $styles.colors.black,
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
