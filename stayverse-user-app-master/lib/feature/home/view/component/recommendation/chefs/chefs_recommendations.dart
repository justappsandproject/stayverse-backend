// recommendations_list.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/feature/home/controller/home_controller.dart';
import 'package:stayverse/feature/home/model/data/chef_response.dart';
import 'package:stayverse/feature/home/view/component/cards/chefs_card.dart';
import 'package:stayverse/feature/chefDetails/view/page/chef_profile_page.dart';
import 'package:stayverse/shared/empty_state_view.dart';
import 'package:stayverse/shared/item_view.dart';
import 'package:stayverse/shared/shrimmer/horizontal_shrimmer.dart';

class ChefsRecommendations extends ConsumerWidget {
  const ChefsRecommendations({
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
        ItemView<Chef>(
          items: ref.watch(
            homeController.select((state) => state.chefRecommendations),
          ),
          isAdsLoading: ref.watch(homeController).isLoadingChefRecommendations,
          loader: const HorizontalShimmerLoader(),
          emptyState: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FlexibleEmptyStateView(
                  message: 'No recommendations found',
                  subtitle: 'No chefs available at the moment,',
                  lottieAsset: AppAsset.chefEmpty,
                ),
              ],
            ),
          ),
          itemViewBuilder:
              (BuildContext context, Widget? child, List<Chef> items) {
            return SizedBox(
              height: 220,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      $navigate.toWithParameters(ChefProfilePage.route,
                          args: items[index]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ChefsCard(
                        showFavourite: false,
                        chef: items[index],
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
