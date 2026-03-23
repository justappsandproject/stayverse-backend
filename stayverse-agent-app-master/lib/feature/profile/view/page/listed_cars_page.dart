import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/image/app_assets.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/carOwner/model/data/ride_response.dart';
import 'package:stayvers_agent/feature/carOwner/view/page/listed_ride_details_page.dart';
import 'package:stayvers_agent/feature/profile/controller/listed_ride_controller.dart';
import 'package:stayvers_agent/feature/profile/view/component/listed_service_type_tab.dart';
import 'package:stayvers_agent/feature/profile/view/page/listed_apartment_page.dart';
import 'package:stayvers_agent/shared/item_view.dart';
import 'package:stayvers_agent/shared/shimmer/pending_vertical_shimmer.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

import '../../../discover/view/component/active_listing_card.dart';

class ListedCarsPage extends ConsumerStatefulWidget {
  static const route = '/ListedCarsPage';
  const ListedCarsPage({super.key});

  @override
  ConsumerState<ListedCarsPage> createState() => _ListedCarsPageState();
}

class _ListedCarsPageState extends ConsumerState<ListedCarsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final statuses = [
    Status.pending,
    Status.approved,
    Status.cancelled,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _fetchCurrentTab();
      }
    });
    Future.microtask(() {
      _fetchCurrentTab();
    });
  }

  void _fetchCurrentTab() {
    final selectedStatus = statuses[_tabController.index];
    ref.read(listedRideController.notifier).getListedRides(selectedStatus.name);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rideState = ref.watch(listedRideController);

    return BrimSkeleton(
      appBar: _buildAppBar('Cars'),
      body: Column(
        children: [
          /// custom tab
          ListedServiceTypeTab(controller: _tabController),

          /// tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: statuses.map((status) {
                return ItemView<Ride>(
                  items: rideState.rides,
                  isAdsLoading: rideState.isLoading,
                  loader: const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child:  PendingListShimmerLoader(itemCount: 15),
                  ),
                  emptyState: buildEmpty(
                    message: 'No ${status.name} Cars',
                    lottie: AppAsset.ridesEmpty,
                  ),
                  itemViewBuilder: (context, _, items) {
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 15),
                      itemCount: items.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final ride = items[index];
                        return GestureDetector(
                          onTap: () => _onCardTap(context, ride),
                          child: ActiveListingCard(
                            title: ride.rideName ?? 'No Name',
                            location: ride.address ?? 'Not Available',
                            price: ride.pricePerHour ?? 0,
                            image: ride.rideImages?.first,
                          ),
                        );
                      },
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

void _onCardTap(BuildContext context, dynamic item) {
  $navigate.toWithParameters(
    ListedRideDetailsPage.route,
    args: item,
  );
}

PreferredSizeWidget _buildAppBar(String title) {
  return AppBar(
    centerTitle: true,
    surfaceTintColor: AppColors.white,
    title: 'Listed $title'.txt20(
      fontWeight: FontWeight.w500,
      color: AppColors.black,
    ),
  );
}
