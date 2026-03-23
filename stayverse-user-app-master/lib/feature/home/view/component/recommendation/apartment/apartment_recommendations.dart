import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/feature/home/controller/home_controller.dart';
import 'package:stayverse/feature/home/model/data/apartment_response.dart';
import 'package:stayverse/feature/home/view/component/cards/apartments_card.dart';
import 'package:stayverse/feature/apartmentDetails/view/page/apartment_details_page.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/empty_state_view.dart';
import 'package:stayverse/shared/item_view.dart';
import 'package:stayverse/shared/shrimmer/horizontal_shrimmer.dart';

class ApartmentRecommendation extends ConsumerWidget {
  const ApartmentRecommendation({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: double.infinity,
        ),
        ItemView<Apartment>(
          items: ref.watch(
            homeController.select((state) => state.apartmentRecommendations),
          ),
          isAdsLoading:
              ref.watch(homeController).isLoadingApartmentRecommendations,
          loader: const HorizontalShimmerLoader(),
          emptyState: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FlexibleEmptyStateView(
                  message: 'No recommendations found',
                  lottieAsset: AppAsset.apartmentEmpty,
                ),
              ],
            ),
          ),
          itemViewBuilder:
              (BuildContext context, Widget? child, List<Apartment> items) {
            return SizedBox(
              height: 260,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return AppBtn.basic(
                    semanticLabel: 'Apartment Details',
                    onPressed: () {
                      $navigate.toWithParameters(
                          ApartmentDetailsPage.route,
                          args: items[index]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ApartmentCard(
                        showFavourite: false,
                        apartment: items[index],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
