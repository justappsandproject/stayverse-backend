import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/feature/chefDetails/view/page/chef_profile_page.dart';
import 'package:stayverse/feature/home/controller/home_controller.dart';
import 'package:stayverse/feature/home/model/data/chef_response.dart';
import 'package:stayverse/feature/home/view/component/top_chef_widget.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/empty_state_view.dart';
import 'package:stayverse/shared/item_view.dart';
import 'package:stayverse/shared/shrimmer/top_chef_shrimmer.dart';

class TopChefs extends ConsumerWidget {
  const TopChefs({
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
            homeController.select((state) => state.newlyListedChefs),
          ),
          isAdsLoading: ref.watch(
            homeController.select((state) => state.isLoadingNewlyListedChefs),
          ),
          loader: const TopChefShimmerLoader(),
          emptyState: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FlexibleEmptyStateView(
                  message: 'No Top Chefs found',
                  subtitle: 'Chefs not available at the moment,',
                  lottieAsset: AppAsset.chefEmpty,
                ),
              ],
            ),
          ),
          itemViewBuilder:
              (BuildContext context, Widget? child, List<Chef> items) {
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return AppBtn.basic(
                  onPressed: () {
                    $navigate.toWithParameters(ChefProfilePage.route,
                        args: items[index]);
                  },
                  padding: EdgeInsets.zero,
                  semanticLabel: 'Chef Details',
                  child: TopChefWidget(
                    showFavourite: false,
                    chef: items[index],
                  ),
                );
              },
            );
          },
        ),
        const Gap(10),
      ],
    );
  }
}
