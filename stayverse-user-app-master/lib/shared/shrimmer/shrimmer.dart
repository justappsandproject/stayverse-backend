import 'package:shimmer/shimmer.dart';
import 'package:stayverse/core/extension/widget_extension.dart';

import '../../core/commonLibs/common_libs.dart';

class SliverListLaoder extends StatelessWidget {
  final int? itemCount;
  const SliverListLaoder({super.key, this.itemCount});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade400,
        highlightColor: Colors.grey.shade100,
        child: ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (context, index) => Gap(10 * $styles.scale),
            padding: const EdgeInsets.all(10),
            itemCount: itemCount ?? 10,
            itemBuilder: (context, index) {
              return Container(
                height: 60,
                decoration: BoxDecoration(
                    color: $styles.colors.greyMedium.withOpacity(0.3)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: $styles.colors.greyMedium.withOpacity(0.5),
                      width: 70,
                      height: 60,
                    ),
                    const Gap(5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            color: $styles.colors.greyMedium.withOpacity(0.5),
                            height: 5,
                          ),
                          const Gap(10),
                          Container(
                            color: $styles.colors.greyMedium.withOpacity(0.5),
                            height: 5,
                          )
                        ],
                      ).paddingOnly(right: 50),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

class VerticalListLoader extends StatelessWidget {
  final int? itemCount;
  const VerticalListLoader({super.key, this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade100,
      child: ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, index) => Gap(10 * $styles.scale),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          itemCount: itemCount ?? 10,
          itemBuilder: (context, index) {
            return Container(
              height: 60,
              decoration: BoxDecoration(
                  color: $styles.colors.greyMedium.withOpacity(0.3)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: $styles.colors.greyMedium.withOpacity(0.5),
                    width: 70,
                    height: 60,
                  ),
                  const Gap(5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          color: $styles.colors.greyMedium.withOpacity(0.5),
                          height: 5,
                        ),
                        const Gap(10),
                        Container(
                          color: $styles.colors.greyMedium.withOpacity(0.5),
                          height: 5,
                        )
                      ],
                    ).paddingOnly(right: 50),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class SliverGridLoader extends StatelessWidget {
  final int? itemCount;

  const SliverGridLoader({
    super.key,
    this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade400,
        highlightColor: Colors.grey.shade600,
        child: GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 150,
          ),
          itemCount: itemCount ?? 6,
          itemBuilder: (context, index) {
            return Container(
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
                    height: 90,
                  ),
                  const Gap(10),
                  Container(
                    color: $styles.colors.greyMedium.withOpacity(0.4),
                    width: 70,
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
        ),
      ),
    );
  }
}

