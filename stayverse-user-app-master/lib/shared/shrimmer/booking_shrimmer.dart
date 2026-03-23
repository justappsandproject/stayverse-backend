import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BookingsCardShimmerLoader extends StatelessWidget {
  final int itemCount;
  final EdgeInsetsGeometry? padding;

  const BookingsCardShimmerLoader({
    super.key,
    this.itemCount = 5,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: ListView.separated(
          itemCount: itemCount,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) => const BookingsCardShimmer(),
        ),
      ),
    );
  }
}

class BookingsCardShimmer extends StatelessWidget {
  const BookingsCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 130,
            height: 100,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
          // Content placeholders
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title placeholder
                  Container(
                    height: 14,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Location row placeholder
                  Row(
                    children: [
                      Container(
                        height: 14,
                        width: 14,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        height: 12,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Description placeholder
                  Container(
                    height: 12,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 12,
                    width: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
