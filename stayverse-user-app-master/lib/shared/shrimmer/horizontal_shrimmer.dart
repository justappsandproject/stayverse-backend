
import 'package:shimmer/shimmer.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';

class HorizontalShimmerLoader extends StatelessWidget {
  const HorizontalShimmerLoader({super.key, this.height});
  final double? height;

  @override
  Widget build(
    BuildContext context,
  ) {
    return SizedBox(
      height: height ?? 160.h,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade400,
        child: ListView.separated(
          itemCount: 10,
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: 160.w,
              margin: EdgeInsets.zero,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: $styles.colors.greyMedium.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: $styles.colors.greyMedium.withOpacity(0.4),
                    width: 160.w,
                    height: 90,
                  ),
                  const Gap(10),
                  Container(
                    color: $styles.colors.greyMedium.withOpacity(0.4),
                    width: 80,
                    height: 8,
                  ),
                  const Gap(5),
                  Container(
                    color: $styles.colors.greyMedium.withOpacity(0.4),
                    height: 8,
                    width: 140,
                  ),
                  const Gap(5),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Gap(15);
          },
        ),
      ),
    );
  }
}
