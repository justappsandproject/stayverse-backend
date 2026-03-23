import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/feature/home/controller/home_controller.dart';

import 'package:stayverse/feature/home/view/component/recommendation/chefs/chefs_recommendations.dart';
import 'package:stayverse/feature/home/view/component/section_header.dart';
import 'package:stayverse/feature/home/view/component/cards/top_chef.dart';
import 'package:stayverse/feature/search/view/page/search_result_page.dart';

class ChefsTab extends ConsumerWidget {
  const ChefsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait([
          ref.read(homeController.notifier).getChefRecommendations(),
          ref.read(homeController.notifier).getNewlyListedChef(),
        ]);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SectionHeader(
              title: 'Recommendations',
              onTapViewAll: () {
                $navigate.to(SearchResultPage.route);
              },
            ),
            const Gap(10),
            const ChefsRecommendations(),
            SectionHeader(
              title: 'Newly Listed',
              onTapViewAll: () {
                $navigate.to(SearchResultPage.route);
              },
            ),
            const Gap(10),
            const TopChefs()
          ],
        ),
      ),
    );
  }
}
