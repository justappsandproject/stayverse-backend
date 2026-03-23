import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/image/app_assets.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/apartmentOwner/model/data/apartment_response.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/page/listed_apartment_details.dart';
import 'package:stayvers_agent/feature/profile/controller/listed_apartment_controller.dart';
import 'package:stayvers_agent/feature/profile/view/component/listed_service_type_tab.dart';
import 'package:stayvers_agent/shared/empty_state_view.dart';
import 'package:stayvers_agent/shared/item_view.dart';
import 'package:stayvers_agent/shared/shimmer/pending_vertical_shimmer.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

import '../../../discover/view/component/active_listing_card.dart';

class ListedApartmentPage extends ConsumerStatefulWidget {
  static const route = '/ListedApartmentList';
  const ListedApartmentPage({super.key});

  @override
  ConsumerState<ListedApartmentPage> createState() =>
      _ListedApartmentPageState();
}

class _ListedApartmentPageState extends ConsumerState<ListedApartmentPage>
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
    ref
        .read(listedApartmentController.notifier)
        .getListedApartments(selectedStatus.name);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apartmentState = ref.watch(listedApartmentController);

    return BrimSkeleton(
      appBar: _buildAppBar('Apartments'),
      body: Column(
        children: [
          ListedServiceTypeTab(controller: _tabController),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: statuses.map((status) {
                return ItemView<Apartment>(
                  items: apartmentState.apartments,
                  isAdsLoading: apartmentState.isLoading,
                  loader: const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: PendingListShimmerLoader(itemCount: 15),
                  ),
                  emptyState: buildEmpty(
                    message: 'No ${status.name} Apartments',
                    lottie: AppAsset.apartmentEmpty,
                  ),
                  itemViewBuilder: (context, _, items) {
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 15),
                      itemCount: items.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final apartment = items[index];
                        return GestureDetector(
                          onTap: () => _onCardTap(context, apartment),
                          child: ActiveListingCard(
                            title: apartment.apartmentName ?? 'No Name',
                            location: apartment.address ?? 'Not Available',
                            price: apartment.pricePerDay ?? 0,
                            image: apartment.apartmentImages?.first,
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

  void _onCardTap(BuildContext context, dynamic item) {
    $navigate.toWithParameters(
      ListedApartmentDetailsPage.route,
      args: item,
    );
  }
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

Widget buildEmpty({
  required String lottie,
  required String message,
}) {
  return SizedBox(
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        EmptyStateView(
          image: lottie,
          message: message,
        ),
      ],
    ),
  );
}
