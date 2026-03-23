import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/feature/apartmentDetails/view/page/apartment_details_page.dart';
import 'package:stayverse/feature/carDetails/view/page/car_detail_page.dart';
import 'package:stayverse/feature/chefDetails/view/page/chef_profile_page.dart';
import 'package:stayverse/feature/home/model/data/apartment_response.dart';
import 'package:stayverse/feature/home/model/data/chef_response.dart';
import 'package:stayverse/feature/home/model/data/ride_response.dart';
import 'package:stayverse/feature/home/view/component/cards/apartments_card.dart';
import 'package:stayverse/feature/home/view/component/cards/chefs_card.dart';
import 'package:stayverse/feature/home/view/component/cards/rides_cards.dart';
import 'package:stayverse/feature/search/controller/search_controller.dart';
import 'package:stayverse/shared/empty_state_view.dart';
import 'package:stayverse/shared/item_view.dart';
import 'package:stayverse/shared/shrimmer/grid_shrimmer.dart';

class ListViewTab extends ConsumerStatefulWidget {
  const ListViewTab({super.key});

  @override
  ConsumerState<ListViewTab> createState() => _ListViewTabState();
}

class _ListViewTabState extends ConsumerState<ListViewTab> {
  @override
  Widget build(BuildContext context) {
    final serviceType = ref.watch(searchController).serviceType;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          sliver: SliverFillRemaining(
            child: _buildContentBasedOnServiceType(serviceType),
          ),
        ),
      ],
    );
  }

  Widget _buildContentBasedOnServiceType(ServiceType serviceType) {
    switch (serviceType) {
      case ServiceType.apartment:
        return const ApartmentListView();
      case ServiceType.chefs:
        return const ChefListView();
      case ServiceType.rides:
        return const RideListView();
    }
  }
}

class ApartmentListView extends ConsumerWidget {
  const ApartmentListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ItemView<Apartment>(
      items: ref.watch(
        searchController.select((state) => state.apartmentSearches),
      ),
      isAdsLoading: ref.watch(searchController).isLoadingApartmentSearches,
      loader: const GridShimmerLoader(),
      emptyState: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FlexibleEmptyStateView(
              message: 'No Search Result Found',
              lottieAsset: AppAsset.apartmentEmpty,
              subtitle: 'Try changing your search filters and try again',
            ),
          ],
        ),
      ),
      itemViewBuilder:
          (BuildContext context, Widget? child, List<Apartment> items) {
        return GridView.builder(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 250,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                $navigate.toWithParameters(ApartmentDetailsPage.route,
                    args: items[index]);
              },
              child: ApartmentCard(
                showFavourite: false,
                apartment: items[index],
              ),
            );
          },
        );
      },
    );
  }
}

class ChefListView extends ConsumerWidget {
  const ChefListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ItemView<Chef>(
      items: ref.watch(
        searchController.select((state) => state.chefSearches),
      ),
      isAdsLoading: ref.watch(searchController).isLoadingChefSearches,
      loader: const GridShimmerLoader(),
      emptyState: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FlexibleEmptyStateView(
              message: 'No Chefs Found',
              lottieAsset: AppAsset.chefEmpty,
            ),
          ],
        ),
      ),
      itemViewBuilder: (BuildContext context, Widget? child, List<Chef> items) {
        return GridView.builder(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 210,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                $navigate.toWithParameters(ChefProfilePage.route,
                    args: items[index]);
              },
              child: ChefsCard(
                showFavourite: false,
                chef: items[index],
              ),
            );
          },
        );
      },
    );
  }
}

class RideListView extends ConsumerWidget {
  const RideListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ItemView<Ride>(
      items: ref.watch(
        searchController.select((state) => state.rideSearches),
      ),
      isAdsLoading: ref.watch(searchController).isLoadingRideSearches,
      loader: const GridShimmerLoader(),
      emptyState: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FlexibleEmptyStateView(
              message: 'No Rides Found',
              lottieAsset: AppAsset.ridesEmpty,
            ),
          ],
        ),
      ),
      itemViewBuilder: (BuildContext context, Widget? child, List<Ride> items) {
        return GridView.builder(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 250,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                $navigate.toWithParameters(CarDetailPage.route,
                    args: items[index]);
              },
              child: RideCard(
                showFavourite: false,
                ride: items[index],
              ),
            );
          },
        );
      },
    );
  }
}
