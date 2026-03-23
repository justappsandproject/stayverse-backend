import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/feature/chefDetails/view/page/chef_profile_page.dart';
import 'package:stayverse/feature/favourite/controller/favourite_controller.dart';
import 'package:stayverse/feature/home/view/component/top_chef_widget.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/empty_state_view.dart';
import 'package:stayverse/shared/shrimmer/top_chef_shrimmer.dart';

class FavouriteChefsTab extends ConsumerWidget {
  const FavouriteChefsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chefs =
        ref.watch(favouriteController.select((state) => state.chefFavourite));
    final isLoading = ref.watch(
        favouriteController.select((state) => state.isLoadingChefFavourite));

    return RefreshIndicator(
      onRefresh: () async =>
          ref.read(favouriteController.notifier).getChefFavourites(),
      child: CustomScrollView(
        slivers: [
          if (isLoading)
            const SliverFillRemaining(child: TopChefShimmerLoader())
          else if (chefs.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: SizedBox(
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
            )
          else
            SliverPadding(
              padding: const EdgeInsets.only(top: 10),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final topChefs = chefs[index];
                    return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: AppBtn.basic(
                          onPressed: () {
                            $navigate.toWithParameters(ChefProfilePage.route,
                                args: chefs[index]);
                          },
                          padding: EdgeInsets.zero,
                          semanticLabel: 'Chef Details',
                          child: TopChefWidget(
                            chef: topChefs,
                          ),
                        ));
                  },
                  childCount: chefs.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
