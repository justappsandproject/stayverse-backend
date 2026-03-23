import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stayvers_agent/core/config/dependecies.dart';
import 'package:stayvers_agent/core/extension/extension.dart';

class BookedListShimmerLoader extends StatelessWidget {
  const BookedListShimmerLoader({super.key});

 @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade400,
      child: ListView.separated(
        itemCount: 5,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: $styles.colors.greyMedium.withValues(alpha: 0.3),
              border: const Border(
                bottom: BorderSide(
                  color: Colors.grey,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Circle placeholder for logo
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: $styles.colors.greyMedium.withValues(alpha: 0.4),
                    ),
                  ),
                  10.sbW,
                  // Booking Details placeholder
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 12,
                          width: double.infinity,
                          color: $styles.colors.greyMedium.withValues(alpha: 0.4),
                        ),
                        4.sbH,
                        Container(
                          height: 10,
                          width: 150,
                          color: $styles.colors.greyMedium.withValues(alpha: 0.4),
                        ),
                      ],
                    ),
                  ),
                  40.sbW,
                  // Amount placeholder
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 8,
                        width: 70,
                        color: $styles.colors.greyMedium.withValues(alpha: 0.4),
                      ),
                      4.sbH,
                      Container(
                        height: 12,
                        width: 80,
                        color: $styles.colors.greyMedium.withValues(alpha: 0.4),
                      ),
                    ],
                  ),
                  35.sbW,
                  // Nights placeholder
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 8,
                        width: 80,
                        color: $styles.colors.greyMedium.withValues(alpha: 0.4),
                      ),
                      4.sbH,
                      Container(
                        height: 12,
                        width: 20,
                        color: $styles.colors.greyMedium.withValues(alpha: 0.4),
                      ),
                    ],
                  ),
                ],
              ),
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