import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';

import 'build_section.dart';


class RecommendationsSection extends StatefulWidget {
  const RecommendationsSection({super.key});

  @override
  State<RecommendationsSection> createState() => _RecommendationsSectionState();
}

class _RecommendationsSectionState extends State<RecommendationsSection> {
  bool _showAll = false;

  // Sample recommendations data
  final List<Map<String, String>> recommendations = [
    {
      'name': 'Joseph Andy',
      'text':
          'Lorem ipsum dolor sit amet consectetur. Et dolor dignissim lorem ipsum dolor sit amet consectetur.',
    },
    {
      'name': 'Sarah Johnson',
      'text':
          'Lorem ipsum dolor sit amet consectetur. Et dolor dignissim lorem ipsum dolor sit amet consectetur.',
    },
    {
      'name': 'Michael Chen',
      'text':
          'Lorem ipsum dolor sit amet consectetur. Et dolor dignissim lorem ipsum dolor sit amet consectetur.',
    },
    // Add more recommendations as needed
  ];

  @override
  Widget build(BuildContext context) {
    final displayedRecommendations =
        _showAll ? recommendations : recommendations.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: 'Recommendations',
          actionText: _showAll ? 'View less' : 'View all',
          onActionTap: () {
            setState(() {
              _showAll = !_showAll;
            });
          },
        ),
        const Gap(16),
        ...displayedRecommendations.map((recommendation) {
          return Column(
            children: [
              _buildRecommendationCard(recommendation),
              const Gap(16),
            ],
          );
        }),
      ],
    );
  }

   Widget _buildRecommendationCard(Map<String, String> recommendation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            recommendation['name']!.txt12(
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ],
        ),
        recommendation['text']!.txt(
          size: 9,
          fontWeight: FontWeight.w500,
          color: AppColors.grey61,
        ),
      ],
    );
  }
}
