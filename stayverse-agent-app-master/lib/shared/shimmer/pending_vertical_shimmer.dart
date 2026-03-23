import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stayvers_agent/core/config/dependecies.dart';
import 'package:stayvers_agent/core/extension/extension.dart';

class PendingListShimmerLoader extends StatelessWidget {
  final int? itemCount;
  const PendingListShimmerLoader({super.key, this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade400,
      child: ListView.separated(
        itemCount: itemCount ?? 5,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              color: $styles.colors.greyMedium.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  spreadRadius: 0,
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                // Image placeholder
                Container(
                  height: 82,
                  width: 120,
                  decoration: BoxDecoration(
                    color: $styles.colors.greyMedium.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                17.sbW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Apartment name placeholder
                      Container(
                        height: 12,
                        width: double.infinity,
                        color: $styles.colors.greyMedium.withValues(alpha: 0.4),
                      ),
                      5.sbH,
                      // Address placeholder
                      Row(
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            color: $styles.colors.greyMedium.withValues(alpha: 0.4),
                          ),
                          4.sbW,
                          Expanded(
                            child: Container(
                              height: 9,
                              color: $styles.colors.greyMedium.withValues(alpha: 0.4),
                            ),
                          ),
                        ],
                      ),
                      5.sbH,
                      // Price placeholder
                      Container(
                        height: 12,
                        width: 100,
                        color: $styles.colors.greyMedium.withValues(alpha: 0.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
