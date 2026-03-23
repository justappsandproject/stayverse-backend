import 'package:shimmer/shimmer.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';

class GridShimmerLoader extends StatelessWidget {
  const GridShimmerLoader({super.key, this.height});
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade400,
        child: GridView.builder(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 180,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: $styles.colors.greyMedium.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: $styles.colors.greyMedium.withOpacity(0.4),
                    width: double.infinity,
                    height: 100, // Reduced from 150 to 100
                  ),
                  const Gap(8), // Reduced spacing
                  Container(
                    color: $styles.colors.greyMedium.withOpacity(0.4),
                    width: 80,
                    height: 8,
                  ),
                  const Gap(4), // Reduced spacing
                  Container(
                    color: $styles.colors.greyMedium.withOpacity(0.4),
                    height: 8,
                    width: 140,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
