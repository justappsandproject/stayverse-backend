import 'package:shimmer/shimmer.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/widget_extension.dart';

class TopChefShimmerLoader extends StatelessWidget {
  const TopChefShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade500,
      child: ListView.separated(
        itemCount: 5,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => const Gap(10),
        itemBuilder: (context, index) {
          return Container(
            clipBehavior: Clip.hardEdge,
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: $styles.colors.greyMedium.withOpacity(0.3),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      color: $styles.colors.greyMedium.withOpacity(0.4),
                      size: 16,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Gap(20),
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: $styles.colors.greyMedium.withOpacity(0.4),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(80),
                        ),
                      ),
                    ),
                    const Gap(8),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 14,
                                width: 100,
                                color:
                                    $styles.colors.greyMedium.withOpacity(0.4),
                              ),
                              const Gap(5),
                              Container(
                                height: 12,
                                width: 160,
                                color:
                                    $styles.colors.greyMedium.withOpacity(0.4),
                              ),
                              const Gap(3),
                              Container(
                                height: 12,
                                width: 140,
                                color:
                                    $styles.colors.greyMedium.withOpacity(0.4),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                height: 14,
                                width: 30,
                                color:
                                    $styles.colors.greyMedium.withOpacity(0.4),
                              ),
                              const Gap(5),
                              Container(
                                height: 26,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: $styles.colors.greyMedium
                                      .withOpacity(0.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),
                  ],
                ).paddingSymmetric(horizontal: 15),
              ],
            ),
          );
        },
      ),
    );
  }
}
