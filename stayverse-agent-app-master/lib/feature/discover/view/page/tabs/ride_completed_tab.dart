import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/util/image/app_assets.dart';
import 'package:stayvers_agent/feature/carOwner/model/data/booked_ride_details_args.dart';
import 'package:stayvers_agent/feature/carOwner/view/page/booked_ride_details_page.dart';
import 'package:stayvers_agent/feature/discover/controller/apartment_bookings_controller.dart';
import 'package:stayvers_agent/feature/discover/model/data/booking_response.dart';
import 'package:stayvers_agent/feature/discover/view/component/booked_ride_card.dart';
import 'package:stayvers_agent/shared/empty_state_view.dart';
import 'package:stayvers_agent/shared/item_view.dart';
import 'package:stayvers_agent/shared/shimmer/booked_vertical_shimmer.dart';


class RideCompletedTab extends ConsumerWidget {
  const RideCompletedTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final bookingState = ref.watch(bookingController);
    final completedAds = bookingState.completedBookings;
    return  ItemView<Booking>(
      items: completedAds,
      isAdsLoading: ref.watch(bookingController).isLoadingCompleted,
      loader: const BookedListShimmerLoader(),
      emptyState: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FlexibleEmptyStateView(
              message: 'No Completed Rides',
              subtitle: 'No Rides Completed at the moment,',
              lottieAsset: AppAsset.ridesEmpty,
            ),
          ],
        ),
      ),
      itemViewBuilder:
          (BuildContext context, Widget? child, List<Booking> items) {
        return ListView.builder(
      padding: const EdgeInsets.only(top: 20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final ad = items[index];
        return GestureDetector(
          onTap: () {
            $navigate.toWithParameters(BookedRideDetailsPage.route,
              args: BookedRideDetailsArgs(
                rideDetails: ad,
                isCompleted: true
              ),
            );
          },
          child: BookedRideCard(
            acceptedAds: ad,
          ),
        );
      },
    );
      },
    );
  }
}