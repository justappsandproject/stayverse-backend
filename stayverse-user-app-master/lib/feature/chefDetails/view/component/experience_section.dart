import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/feature/favourite/view/component/experience_card.dart';
import 'package:stayverse/feature/favourite/view/component/section_title.dart';
import 'package:stayverse/feature/home/model/data/chef_response.dart';
import 'package:stayverse/shared/empty_state_view.dart';


class ExperienceSection extends StatefulWidget {
  final Chef? chef;
  const ExperienceSection({super.key, this.chef});

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final experiences = widget.chef?.experiences ?? [];
    final hasMoreThanTwo = experiences.length > 2;
    final displayedExperiences =
        _showAll ? experiences : experiences.take(2).toList();

    if (experiences.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Experience',
            actionText: null,
            onActionTap: null,
          ),
          const Gap(16),
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FlexibleEmptyStateView(
                  message: 'No Experience Found',
                  subtitle: 'No Experience Found at the moment.',
                  lottieAsset: AppAsset.chefEmpty,
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: 'Experience',
          actionText: hasMoreThanTwo
              ? (_showAll ? 'View less' : 'View all')
              : null,
          onActionTap: hasMoreThanTwo
              ? () {
                  setState(() {
                    _showAll = !_showAll;
                  });
                }
              : null,
        ),
        const Gap(16),
        ...displayedExperiences.map((experience) {
          return Column(
            children: [
              ExperienceCard(
                title: experience.title ?? 'N/A',
                company: experience.company ?? 'N/A',
                startDate: experience.startDate ?? 'N/A',
                endDate: experience.endDate ?? 'Present',
                state: experience.address ?? 'N/A',
              ),
              const Gap(16),
            ],
          );
        }),
      ],
    );
  }
}
