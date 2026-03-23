import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/feature/chefDetails/view/component/certification_section.dart';
import 'package:stayverse/feature/chefDetails/view/component/experience_section.dart';
import 'package:stayverse/feature/favourite/view/component/build_featured_section.dart';
import 'package:stayverse/feature/favourite/view/component/section_title.dart';
import 'package:stayverse/feature/home/model/data/chef_response.dart';
import 'package:stayverse/feature/home/view/component/chef_about_section.dart';
import 'package:stayverse/feature/home/view/component/chef_profile_header.dart';
import 'package:stayverse/shared/line.dart';
import 'package:stayverse/shared/skeleton.dart';

class ChefProfilePage extends StatefulWidget {
  static const route = '/ChefProfilePage';
  const ChefProfilePage({super.key, this.chef});

  final Chef? chef;

  @override
  State<ChefProfilePage> createState() => _ChefProfilePageState();
}

class _ChefProfilePageState extends State<ChefProfilePage> {
  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      backgroundColor: Colors.white,
      bodyPadding: EdgeInsets.zero,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChefProfileHeader(
              chef: widget.chef,
            ),
            const Gap(17),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ChefAboutSection(
                    chef: widget.chef,
                  ),
                  ExperienceSection(chef: widget.chef),
                  const Gap(24),
                  const SectionTitle(title: 'Featured'),
                  const Gap(24),
                  FeaturedSection(chef: widget.chef),
                  const Gap(10),
                  const HorizontalLine(
                    thickness: 0.8,
                  ),
                  const Gap(24),
                  LicenseSection(chef: widget.chef),
                  const Gap(32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


  // Widget _buildRecommendationsSection() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       SectionTitle(
  //         title: 'Recommendations',
  //         actionText: "View all",
  //         onActionTap: () {},
  //       ),
  //       const Gap(16),
  //       buildRecommendationCard(),
  //       const Gap(16),
  //       buildRecommendationCard(),
  //     ],
  //   );
  // }
