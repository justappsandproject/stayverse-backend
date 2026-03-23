import 'package:dart_extensions/dart_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/service/date_time_service.dart';
import 'package:stayvers_agent/core/util/image/app_assets.dart';
import 'package:stayvers_agent/core/util/style/app_style.dart';
import 'package:stayvers_agent/feature/chefOwner/controller/chef_profile_controller.dart';
import 'package:stayvers_agent/feature/chefOwner/view/component/certification_form.dart';
import 'package:stayvers_agent/feature/chefOwner/view/component/experience_form.dart';
import 'package:stayvers_agent/feature/dashBoard/controller/dashboard_controller.dart';
import 'package:stayvers_agent/feature/discover/controller/overview_controller.dart';
import 'package:stayvers_agent/feature/discover/view/component/discover_overview_helper_widget.dart';
import 'package:stayvers_agent/feature/discover/view/component/info_container.dart';
import 'package:stayvers_agent/shared/app_icons.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

import '../../../chefOwner/view/page/setup_profile.dart';

class DiscoverChefPage extends ConsumerStatefulWidget {
  static const route = '/DiscoverChefPage';
  const DiscoverChefPage({super.key});

  @override
  ConsumerState<DiscoverChefPage> createState() => _DiscoverChefPageState();
}

class _DiscoverChefPageState extends ConsumerState<DiscoverChefPage> {
  String _selectedPeriod = 'This Week';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(overviewController.notifier).getOverviewMetrics();
      ref.read(chefController.notifier).getChefStatus();
      ref.read(dashboadController.notifier).refreshUser();
    });
  }

  void _onPeriodSelected(String period) {
    setState(() {
      _selectedPeriod = period;
    });
  }

  String _getMetricValue(Map<String, dynamic>? metrics) {
    if (metrics == null) return '0';

    switch (_selectedPeriod) {
      case 'This Week':
        return metrics['week']?.toString() ?? '0';
      case 'This Month':
        return metrics['month']?.toString() ?? '0';
      case 'This Year':
        return metrics['year']?.toString() ?? '0';
      default:
        return metrics['week']?.toString() ?? '0';
    }
  }

  @override
  Widget build(BuildContext context) {
    final overviewState = ref.watch(overviewController);
    final isLoading = overviewState.isLoading;
    final chefState = ref.watch(chefController);
    final chefStatus = chefState.status;

    final earningsValue =
        _getMetricValue(overviewState.data?.earnings?.toJson());
    final bookingsValue =
        _getMetricValue(overviewState.data?.bookings?.toJson());
    final favouritesValue =
        _getMetricValue(overviewState.data?.favorites?.toJson());
    final requestsValue =
        _getMetricValue(overviewState.data?.request?.toJson());

    return BrimSkeleton(
      bodyPadding: EdgeInsets.zero,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(60),
            'Good ${DateTimeService.getTimeOfDay}'.txt24(
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            Row(
              children: [
                (ref.read(dashboadController).user?.firstname ?? '').txt24(
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryyellow,
                ),
                4.sbW,
                Image.asset(
                  AppAsset.smallSmile,
                ),
              ],
            ),
            12.sbH,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                'Overview'.txt18(
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
                PopupMenuButton<String>(
                  onSelected: _onPeriodSelected,
                  itemBuilder: (BuildContext context) => [
                    _buildPopupMenuItem('This Week'),
                    _buildPopupMenuItem('This Month'),
                    _buildPopupMenuItem('This Year'),
                  ],
                  offset: const Offset(0, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 17, vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _selectedPeriod.txt10(
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                        7.sbW,
                        const AppIcon(AppIcons.arrow_down),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            11.sbH,
            Row(
              children: [
                Expanded(
                  child: InfoCardComponent(
                    title: 'Earnings',
                    icon: AppIcons.money,
                    digit: 'N${formatCurrencySmart(
                      num.tryParse(earningsValue) ?? 0.00,
                      isEarnings: true,
                    )}',
                    isLoading: isLoading,
                    backgroundImagePath: AppAsset.dottedCircles,
                    backgroundColor: AppColors.primaryyellow,
                    digitColor: AppColors.black,
                    iconColor: AppColors.black,
                    txtColor: AppColors.black,
                  ),
                ),
                10.sbW,
                Expanded(
                  child: InfoCardComponent(
                    title: 'Bookings',
                    icon: AppIcons.calender,
                   digit: formatCurrencySmart(
                              num.tryParse(bookingsValue) ?? 0),
                    borderColor: AppColors.brown50,
                    isLoading: isLoading,
                  ),
                ),
              ],
            ),
            16.sbH,
            Row(
              children: [
                Expanded(
                  child: InfoCardComponent(
                    title: 'Likes',
                    icon: AppIcons.heart,
                    digit: formatCurrencySmart(
                              num.tryParse(favouritesValue) ?? 0),
                    borderColor: AppColors.brown50,
                    isLoading: isLoading,
                  ),
                ),
                10.sbW,
                Expanded(
                  child: InfoCardComponent(
                    title: 'Requests',
                    icon: AppIcons.add,
                    digit: formatCurrencySmart(
                              num.tryParse(requestsValue) ?? 0),
                    borderColor: AppColors.brown50,
                    isLoading: isLoading,
                  ),
                ),
              ],
            ),
            15.sbH,
            const Divider(
              color: AppColors.greyF7,
            ),
            10.sbH,
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppBtn(
                  onPressed: chefStatus?.hasProfile == false
                      ? () => $navigate.to(SetupProfilePage.route)
                      : null,
                  semanticLabel: '',
                  padding: EdgeInsets.zero,
                  bgColor: Colors.transparent,
                  child: ChefDetailsWidget(
                    headerIcon: AppIcons.chef_profile,
                    title: 'Chef Profile',
                    subTitle: 'Complete chef profile to activate account',
                    isCompleted: chefStatus?.hasProfile ?? false,
                  ),
                ),
                12.sbH,
                AppBtn(
                  onPressed: () => $navigate.to(ExperienceForm.route),
                  semanticLabel: '',
                  padding: EdgeInsets.zero,
                  bgColor: Colors.transparent,
                  child: ChefDetailsWidget(
                    headerIcon: AppIcons.experience,
                    title: 'Add Experience',
                    subTitle: 'Fill up your cooking experience here',
                    isCompleted: chefStatus?.hasExperience ?? false,
                  ),
                ),
                12.sbH,
                AppBtn(
                  onPressed: () => $navigate.to(CertificationForm.route),
                  semanticLabel: '',
                  padding: EdgeInsets.zero,
                  bgColor: Colors.transparent,
                  child: ChefDetailsWidget(
                    headerIcon: AppIcons.certification,
                    title: 'Certification',
                    subTitle: 'Add relevant certification to your profile',
                    isCompleted: chefStatus?.hasCertifications ?? false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).paddingOnly(left: 20, right: 11);
  }

  PopupMenuItem<String> _buildPopupMenuItem(String period) {
    return PopupMenuItem<String>(
      value: period,
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: _selectedPeriod == period
                    ? context.color.primary
                    : context.color.scrim,
                width: 1.5,
              ),
            ),
            child: _selectedPeriod == period
                ? Center(
                    child: Icon(
                      Icons.check,
                      size: 14,
                      color: context.color.primary,
                    ),
                  )
                : null,
          ),
          const Gap(8),
          Text(
            period,
            style: $styles.text.bodySmall.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: context.color.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class ChefDetailsWidget extends StatelessWidget {
  final AppIcons headerIcon;
  final String title, subTitle;
  final bool isCompleted;
  const ChefDetailsWidget({
    super.key,
    required this.headerIcon,
    required this.title,
    required this.subTitle,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.yellow95 : AppColors.greyF2,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 3,
            child: SvgPicture.asset(
              AppAsset.bigdottedCircles,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 11.0, vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: AppIcon(headerIcon),
                    ),
                    9.sbW,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title.txt16(
                          fontWeight: FontWeight.w600,
                        ),
                        subTitle.txt12(
                          fontWeight: FontWeight.w400,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
                isCompleted
                    ? SvgPicture.asset(
                        AppAsset.verified,
                        height: 24,
                        // ignore: deprecated_member_use
                        color: AppColors.black42,
                      )
                    : const Icon(
                        Icons.chevron_right_rounded,
                        size: 30,
                        color: AppColors.black42,
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
