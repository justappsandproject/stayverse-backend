import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/feature/favourite/controller/favourite_controller.dart';
import 'package:stayverse/feature/home/view/component/cards/rides_cards.dart';
import 'package:stayverse/feature/carDetails/view/page/car_detail_page.dart';
import 'package:stayverse/shared/empty_state_view.dart';
import 'package:stayverse/shared/shrimmer/grid_shrimmer.dart';

class FavouriteCarRentalTab extends ConsumerWidget {
  const FavouriteCarRentalTab({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rides =
        ref.watch(favouriteController.select((state) => state.rideFavourite));
    final isLoading = ref.watch(favouriteController).isLoadingRideFavourite;

    return RefreshIndicator(
      onRefresh: () async =>
          ref.read(favouriteController.notifier).getRideFavourites(),
      child: CustomScrollView(
        slivers: [
          if (isLoading)
            const SliverFillRemaining(child: GridShimmerLoader())
          else if (rides.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FlexibleEmptyStateView(
                      message: 'No Car Rental Found',
                      lottieAsset: AppAsset.ridesEmpty,
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 250,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return GestureDetector(
                      onTap: () {
                        $navigate.toWithParameters(CarDetailPage.route,
                            args: rides[index]);
                      },
                      child: RideCard(
                        ride: rides[index],
                      ),
                    );
                  },
                  childCount: rides.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
