import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/feature/home/controller/home_controller.dart';
import 'package:stayverse/feature/home/view/component/recommendation/apartment/apartment_recommendations.dart';
import 'package:stayverse/feature/home/view/component/recommendation/apartment/newly_listed_apartments.dart';
import 'package:stayverse/feature/home/view/component/section_header.dart';
import 'package:stayverse/feature/search/view/page/search_result_page.dart';

class ApartmentTab extends ConsumerWidget {
  const ApartmentTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait([
          ref.read(homeController.notifier).getApartmentRecommendations(),
          ref.read(homeController.notifier).getNewlyListedApartment(),
        ]);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: 'Recommendations',
              onTapViewAll: () {
                $navigate.to(SearchResultPage.route);
              },
            ),
            const ApartmentRecommendation(),
            // const Gap(10),
            // TopLocations(
            //   itemName: 'Top Locations',
            //   locations: locations,
            // ),
            // const Gap(10),
            SectionHeader(
              title: 'Newly Listed',
              onTapViewAll: () {
                $navigate.to(SearchResultPage.route);
              },
            ),
            const NewlyListedApartment(),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}
