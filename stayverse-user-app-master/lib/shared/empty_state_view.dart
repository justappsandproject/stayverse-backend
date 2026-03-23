import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:lottie/lottie.dart';

class EmptyStateView extends StatelessWidget {
  final String? message;
  const EmptyStateView({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset(
          height: 120,
          width: 120,
          AppAsset.empty,
          renderCache: RenderCache.drawingCommands,
        ),
        Text(
          message ?? 'No content found',
          textAlign: TextAlign.center,
          style: $styles.text.bodySmall.copyWith(
              fontWeight: FontWeight.w500,
              height: 1,
              color: Colors.grey[500],
              fontSize: 14.sp),
        )
      ],
    );
  }
}


class FlexibleEmptyStateView extends StatelessWidget {
  final String? message;
  final String? subtitle;
  final String lottieAsset;
  final double? lottieHeight;
  final double? lottieWidth;
  final double? gap;

  const FlexibleEmptyStateView({
    super.key,
    this.message,
    this.subtitle,
    required this.lottieAsset,
    this.lottieHeight = 110,
    this.lottieWidth = 110,
    this.gap = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset(
          height: lottieHeight,
          width: lottieWidth,
          lottieAsset,
          renderCache: RenderCache.drawingCommands,
        ),
        Gap(gap ?? 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message ?? 'No recommendations yet',
                style: $styles.text.body.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                  height: 1.5,
                  fontSize: 14.sp,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle ?? 'We\'ll find perfect apartments based on your preferences',
                style: $styles.text.bodySmall.copyWith(
                  color: Colors.grey[500],
                  height: 1.5,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
