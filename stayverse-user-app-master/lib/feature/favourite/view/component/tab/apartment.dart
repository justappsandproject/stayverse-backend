import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/feature/favourite/controller/favourite_controller.dart';
import 'package:stayverse/feature/home/view/component/cards/apartments_card.dart';
import 'package:stayverse/feature/apartmentDetails/view/page/apartment_details_page.dart';
import 'package:stayverse/shared/empty_state_view.dart';
import 'package:stayverse/shared/shrimmer/grid_shrimmer.dart';

class FavouriteApartmentTab extends ConsumerWidget {
  const FavouriteApartmentTab({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apartments = ref.watch(
        favouriteController.select((state) => state.apartmentsFavourites));
    final isLoading =
        ref.watch(favouriteController).isLoadingApartmentFavourite;

    return RefreshIndicator(
      onRefresh: () async =>
          ref.read(favouriteController.notifier).getApartmentFavourites(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (isLoading)
            const SliverFillRemaining(
              child: GridShimmerLoader(),
            )
          else if (apartments.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FlexibleEmptyStateView(
                      message: 'No Favourite Apartment Found',
                      lottieAsset: AppAsset.apartmentEmpty,
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
                        $navigate.toWithParameters(ApartmentDetailsPage.route,
                            args: apartments[index]);
                      },
                      child: ApartmentCard(
                        apartment: apartments[index],
                      ),
                    );
                  },
                  childCount: apartments.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
