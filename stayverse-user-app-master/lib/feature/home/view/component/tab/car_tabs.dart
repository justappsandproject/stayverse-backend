import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/feature/home/controller/home_controller.dart';
import 'package:stayverse/feature/home/view/component/recommendation/rides/newly_listed_rides.dart';
import 'package:stayverse/feature/home/view/component/recommendation/rides/rides_recommendations.dart';
import 'package:stayverse/feature/home/view/component/section_header.dart';
import 'package:stayverse/feature/search/view/page/search_result_page.dart';

class CarRentalTab extends ConsumerWidget {
  const CarRentalTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait([
          ref.read(homeController.notifier).getNewlyListedRide(),
          ref.read(homeController.notifier).getRideRecommendations(),
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
            const RideRecommendations(),
            // const Gap(10),
            // TopVehicles(
            //   itemName: 'Top Vehicles',
            //   vehicles: vehicles,
            // ),
            // const Gap(10),
            SectionHeader(
              title: 'Newly Listed',
              onTapViewAll: () {
                $navigate.to(SearchResultPage.route);
              },
            ),
            const NewlyListedRides(),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}

final vehicles = [
  'Lexus RX 350h',
  'Toyota Land ',
  'Toyota Hilux',
  'Toyota Land ',
];
