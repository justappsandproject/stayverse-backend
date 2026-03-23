import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/feature/favourite/view/component/cretification_card.dart';
import 'package:stayverse/feature/favourite/view/component/section_title.dart';
import 'package:stayverse/feature/home/model/data/chef_response.dart';
import 'package:stayverse/shared/empty_state_view.dart';

class LicenseSection extends StatefulWidget {
  final Chef? chef;
  const LicenseSection({super.key, this.chef});

  @override
  State<LicenseSection> createState() => _LicenseSectionState();
}

class _LicenseSectionState extends State<LicenseSection> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final licenses = widget.chef?.certifications ?? [];
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
              ),
              const Gap(24),
            ],
          );
        }),
      ],
    );
  }
}
