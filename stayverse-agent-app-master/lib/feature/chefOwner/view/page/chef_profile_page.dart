import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/image/app_assets.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/chefOwner/controller/chef_profile_controller.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/chef_profile_response.dart';
import 'package:stayvers_agent/feature/chefOwner/view/component/build_featured_section.dart';
import 'package:stayvers_agent/feature/chefOwner/view/component/build_profile_header.dart';
import 'package:stayvers_agent/feature/chefOwner/view/component/certification_section.dart';
import 'package:stayvers_agent/feature/chefOwner/view/component/chef_profile_shimmer.dart';
import 'package:stayvers_agent/feature/chefOwner/view/component/culinary_specialties_widget.dart';
import 'package:stayvers_agent/feature/chefOwner/view/component/experience_section.dart';
import 'package:stayvers_agent/feature/chefOwner/view/page/setup_profile.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/empty_state_view.dart';
import 'package:stayvers_agent/shared/line.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

class ChefProfilePage extends ConsumerStatefulWidget {
  static const route = '/ChefProfilePage';
  const ChefProfilePage({super.key});

  @override
  ConsumerState<ChefProfilePage> createState() => _ChefProfilePageState();
}

class _ChefProfilePageState extends ConsumerState<ChefProfilePage> {
  CarouselController carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(chefController.notifier);
      notifier.getChefProfile();
      notifier.getChefStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(chefController);

    if (profileState.isBusy == true) {
      return const ChefProfileShimmer();
    }

    if (profileState.status?.hasProfile == false) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlexibleEmptyStateView(
                message: 'No Chef Profile Created',
                subtitle: 'Please create a profile to see.',
                lottieAsset: AppAsset.chefEmpty,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AppBtn.from(
                  text: 'Create Profile',
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                  expand: true,
                  bgColor: AppColors.black,
                  onPressed: () {
                    $navigate.to(SetupProfilePage.route);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    return BrimSkeleton(
      bodyPadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeader(chefProfileData: profileState.profile),
            17.sbH,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AboutSection(chefProfileData: profileState.profile),
                  const CulinarySpecialtiesWidget(),
                  const Gap(24),
                  ExperienceSection(chefProfileData: profileState.profile),
                  const Gap(24),
                  FeaturedSection(chefProfileData: profileState.profile),
                  const Gap(24),
                  LicenseSection(chefProfileData: profileState.profile),
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

class AboutSection extends StatelessWidget {
  final ChefProfileData? chefProfileData;
  const AboutSection({super.key, required this.chefProfileData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        'About'.txt14(
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
        const Gap(6),
        (chefProfileData?.about ?? 'N/A').txt14(
          fontWeight: FontWeight.w500,
          color: AppColors.grey5F,
          height: 0,
        ),
        const Gap(12),
        const HorizontalLine(color: AppColors.greyF7),
        const Gap(12),
      ],
    );
  }
}
