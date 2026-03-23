import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/util/image/app_assets.dart';
import 'package:stayvers_agent/feature/chefOwner/controller/chef_profile_controller.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/chef_profile_response.dart';
import 'package:stayvers_agent/feature/chefOwner/view/component/delete_dialog.dart';
import 'package:stayvers_agent/shared/empty_state_view.dart';

import 'build_section.dart';
import 'experience_card.dart';

class ExperienceSection extends ConsumerStatefulWidget {
  final ChefProfileData? chefProfileData;
  const ExperienceSection({super.key, required this.chefProfileData});

  @override
  ConsumerState<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends ConsumerState<ExperienceSection> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final experiences = widget.chefProfileData?.experiences ?? [];
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
          actionText:
              hasMoreThanTwo ? (_showAll ? 'View less' : 'View all') : null,
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
                onDelete: () {
                  _deleteExperience();
                },
              ),
              const Gap(16),
            ],
          );
        }),
      ],
    );
  }

  void _deleteExperience() {
    showDialog(
      context: context,
      builder: (_) => DeleteDialog(
          title: 'Experience',
          onConfirm: () {
            final experience = widget.chefProfileData?.experiences?.first.id;
            ref
                .read(chefController.notifier)
                .deleteExperience(experience ?? '');
            $navigate.back();
          }),
    );
  }
}
