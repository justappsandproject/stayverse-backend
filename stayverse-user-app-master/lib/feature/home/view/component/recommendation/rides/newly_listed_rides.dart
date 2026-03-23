// recommendations_list.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/feature/carDetails/view/page/car_detail_page.dart';
import 'package:stayverse/feature/home/controller/home_controller.dart';
import 'package:stayverse/feature/home/model/data/ride_response.dart';
import 'package:stayverse/feature/home/view/component/cards/rides_cards.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/empty_state_view.dart';
import 'package:stayverse/shared/item_view.dart';
import 'package:stayverse/shared/shrimmer/horizontal_shrimmer.dart';

class NewlyListedRides extends ConsumerWidget {
  const NewlyListedRides({
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
        ItemView<Ride>(
          items: ref.watch(
            homeController.select((state) => state.newlyListedRides),
          ),
          isAdsLoading: ref.watch(homeController).isLoadingNewlyListedRides,
          loader: const HorizontalShimmerLoader(),
          emptyState: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FlexibleEmptyStateView(
                  message: 'No Newly Listed Rides',
                  subtitle: 'No new rides available at the moment',
                  lottieAsset: AppAsset.ridesEmpty,
                ),
              ],
            ),
          ),
          itemViewBuilder:
              (BuildContext context, Widget? child, List<Ride> items) {
            return SizedBox(
              height: 260,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return AppBtn.basic(
                    onPressed: () {
                      $navigate.toWithParameters(CarDetailPage.route,
                          args: items[index]);
                    },
                    padding: EdgeInsets.zero,
                    semanticLabel: 'Ride Details',
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: RideCard(
                        showFavourite: false,
                        ride: items[index],
                      ),
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
