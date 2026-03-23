import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/extension/widget_extension.dart';
import 'package:stayvers_agent/core/service/date_time_service.dart';
import 'package:stayvers_agent/core/util/image/app_assets.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/dashBoard/controller/dashboard_controller.dart';
import 'package:stayvers_agent/feature/discover/controller/apartment_bookings_controller.dart';
import 'package:stayvers_agent/feature/discover/controller/overview_controller.dart';
import 'package:stayvers_agent/feature/discover/model/data/booking_status_request.dart';
import 'package:stayvers_agent/feature/discover/view/component/discover_overview_helper_widget.dart';
import 'package:stayvers_agent/feature/discover/view/component/info_container.dart';
import 'package:stayvers_agent/shared/app_icons.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

import 'tabs/apartment_booked_tab.dart';
import 'tabs/apartment_completed_tab.dart';
import 'tabs/apartment_pending_tab.dart';

class ApartmentDiscoverPage extends ConsumerStatefulWidget {
  const ApartmentDiscoverPage({super.key});

  @override
  ConsumerState<ApartmentDiscoverPage> createState() =>
      _ApartmentDiscoverPageState();
}

class _ApartmentDiscoverPageState extends ConsumerState<ApartmentDiscoverPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'This Week';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refresh();
    });
  }

  Future<void> refresh() async {
    await Future.wait([
      ref.read(overviewController.notifier).getOverviewMetrics(),
      ref.read(bookingController.notifier).getBookings(BookingStatus.pending),
      ref.read(bookingController.notifier).getBookings(BookingStatus.completed),
      ref.read(bookingController.notifier).getBookings(BookingStatus.accepted),
      ref.read(bookingController.notifier).getBookings(BookingStatus.rejected),
      ref.read(dashboadController.notifier).refreshUser(),
    ]);
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
      body: RefreshIndicator(
        onRefresh: () async {
          await refresh();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(30),
                  'Good ${DateTimeService.getTimeOfDay}'.txt24(
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                  Row(
                    children: [
                      (ref.read(dashboadController).user?.firstname ?? '')
                          .txt24(
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryyellow,
                      ),
                      4.sbW,
                      Image.asset(
                        AppAsset.smallSmile,
                      ),
                    ],
                  ),
                  18.sbH,
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
                  10.sbH,
                  TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    dividerColor: Colors.transparent,
                    unselectedLabelColor: AppColors.grey5F,
                    labelStyle: $styles.text.body.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: $styles.text.body.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    labelPadding: EdgeInsets.zero,
                    tabs: const [
                      Tab(child: Text('Pending')),
                      Tab(child: Text('Booked')),
                      Tab(child: Text('Completed')),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        ApartmentPendingTab(),
                        ApartmentBookedTab(),
                        CompletedTab(),
                      ],
                    ),
                  ),
                ],
              ),
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
