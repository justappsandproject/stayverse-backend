import 'package:stayverse/core/commonLibs/common_libs.dart';

Widget buildRecommendationCard() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            'Joseph Andy',
            style: $styles.text.title2.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: 12,
            ),
          ),
        ],
      ),
      const Gap(8),
      Text(
        'Lorem ipsum dolor sit amet consectetur. Et dolor dignissim lorem ipsum dolor sit amet consectetur.',
        style: $styles.text.bodySmall.copyWith(
          fontSize: 12,
          height: 1.3,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF616161),
        ),
      ),
    ],
  );
}
