
import 'package:dart_extensions/dart_extensions.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';

class ListLoader extends StatelessWidget {
  final int? itemLength;
  const ListLoader({super.key, this.itemLength});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade500,
      highlightColor: Colors.grey.shade300,
      child: ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, index) => Gap(10 * $styles.scale),
          padding: const EdgeInsets.all(10),
          itemCount: itemLength ?? 12,
          itemBuilder: (context, index) {
            return Container(
              height: 60,
              decoration:
                  BoxDecoration(color: Colors.black.withValues(alpha: 0.1)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.black.withValues(alpha: 0.25),
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
                          color:  Colors.black.withValues(alpha: 0.25),
                          height: 5,
                        ),
                        const Gap(10),
                        Container(
                          color:  Colors.black.withValues(alpha: 0.25),
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
