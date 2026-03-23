import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/util/image/app_assets.dart';
import 'package:stayvers_agent/feature/carOwner/view/page/pending_ride_details.dart';
import 'package:stayvers_agent/feature/discover/controller/apartment_bookings_controller.dart';
import 'package:stayvers_agent/feature/discover/model/data/booking_response.dart';
import 'package:stayvers_agent/feature/discover/view/component/ride_pending_card.dart';
import 'package:stayvers_agent/shared/empty_state_view.dart';
import 'package:stayvers_agent/shared/item_view.dart';
import 'package:stayvers_agent/shared/shimmer/pending_vertical_shimmer.dart';

class RidePendingTab extends ConsumerWidget {
  const RidePendingTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingController);
    final pendingAds = bookingState.pendingBookings;
    return ItemView<Booking>(
      items: pendingAds,
      isAdsLoading: ref.watch(bookingController).isLoadingPending,
      loader: const PendingListShimmerLoader(),
      emptyState: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FlexibleEmptyStateView(
              message: 'No Pending Rides',
              subtitle: 'No Rides Pending at the moment,',
              lottieAsset: AppAsset.ridesEmpty,
            ),
          ],
        ),
      ),
      itemViewBuilder:
          (BuildContext context, Widget? child, List<Booking> items) {
        return ListView.builder(
          padding: const EdgeInsets.only(top: 10),
          itemCount: items.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final ad = items[index];
            return GestureDetector(
                onTap: () {
                  $navigate.toWithParameters(PendingRideDetails.route,
                      args: items[index]);
                },
                child: RidePendingCard(
                  pendingAds: ad,
                ));
          },
        );
      },
    );
  }
}
