// recommendations_list.dart
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

class NewlyListedApartment extends ConsumerWidget {
  const NewlyListedApartment({
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
            homeController.select((state) => state.newlyListedApartments),
          ),
          isAdsLoading:
              ref.watch(homeController).isLoadingNewlyListedApartments,
          loader: const HorizontalShimmerLoader(),
          emptyState: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FlexibleEmptyStateView(
                  message: 'No Newly Listed Apartments',
                  subtitle: 'No apartments available at the moment,',
                  lottieAsset: AppAsset.apartmentEmpty,
                ),
              ],
            ),
          ),
          itemViewBuilder:
              (BuildContext context, Widget? child, List<Apartment> items) {
            return SizedBox(
              height: 260,
              child: ListView.separated(
                separatorBuilder: (context, index) => const Gap(10),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return AppBtn.basic(
                    onPressed: () {
                      $navigate.toWithParameters(ApartmentDetailsPage.route,
                          args: items[index]);
                    },
                    padding: EdgeInsets.zero,
                    semanticLabel: 'Apartment Details',
                    child: ApartmentCard(
                      showFavourite: false,
                      apartment: items[index],
                    ),
                  );
                },
              ),
            );
          },
        ),
        const Gap(10),
      ],
    );
  }
}
