import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/util/image/app_assets.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/chefOwner/controller/chef_profile_controller.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/chef_profile_response.dart';
import 'package:stayvers_agent/feature/chefOwner/view/component/build_section.dart';
import 'package:stayvers_agent/feature/chefOwner/view/component/delete_dialog.dart';
import 'package:stayvers_agent/feature/chefOwner/view/component/experience_card.dart';
import 'package:stayvers_agent/shared/empty_state_view.dart';
import 'package:stayvers_agent/shared/line.dart';

class LicenseSection extends ConsumerStatefulWidget {
  final ChefProfileData? chefProfileData;
  const LicenseSection({super.key, required this.chefProfileData});

  @override
  ConsumerState<LicenseSection> createState() => _LicenseSectionState();
}

class _LicenseSectionState extends ConsumerState<LicenseSection> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final licenses = widget.chefProfileData?.certifications ?? [];
    final hasMoreThanTwo = licenses.length > 2;
    final displayedLicenses = _showAll ? licenses : licenses.take(2).toList();

    if (displayedLicenses.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'License & Certification',
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
                  message: 'No Certifications Added',
                  subtitle: 'No Certifications Added at the moment.',
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
          title: 'License & Certification',
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
        const Gap(14),
        ...displayedLicenses.map((license) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LicenseCard(
                title: license.title ?? 'N/A',
                certName: license.organization ?? 'N/A',
                issueDate: license.issuedDate ?? 'N/A',
                onDelete: () {
                  _deleteCertification();
                },
              ),
              const Gap(24),
              const HorizontalLine(color: AppColors.greyF7),
              const Gap(16),
            ],
          );
        }),
      ],
    );
  }
   void _deleteCertification() {
    showDialog(
      context: context,
      builder: (_) => DeleteDialog(
          title: 'Certification',
          onConfirm: () {
            final license = widget.chefProfileData?.certifications?.first.id;
            ref.read(chefController.notifier).deleteCertification(license ?? '');
            $navigate.back();
          }),
    );
  }
}
