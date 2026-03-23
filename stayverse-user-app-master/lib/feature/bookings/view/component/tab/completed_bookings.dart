import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/feature/bookings/controller/bookings_controller.dart';
import 'package:stayverse/feature/bookings/view/component/bookings_card.dart';
import 'package:stayverse/shared/empty_state_view.dart';
import 'package:stayverse/shared/lazy_load_scroll_view.dart';
import 'package:stayverse/shared/shrimmer/booking_shrimmer.dart';

class CompletedBooking extends ConsumerWidget {
  const CompletedBooking({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(bookingController).completedBookings;
    final isLoading = ref.watch(bookingController).isLoadingCompleted;

    return LazyLoadScrollView(
      showLoadinIndicator: true,
      
      onEndOfPage: () async {
        await ref
            .read(bookingController.notifier)
            .getBookings(BookingStatus.completed, loadMore: true);
      },
      child: RefreshIndicator(
        displacement: 20,
        onRefresh: () async => ref
            .read(bookingController.notifier)
            .getBookings(BookingStatus.completed),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            if (isLoading && bookings.isEmpty)
              const SliverFillRemaining(
                child: BookingsCardShimmerLoader(),
              )
            else if (bookings.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FlexibleEmptyStateView(
                        message: 'No Completed Bookings',
                        subtitle: 'No bookings available at the moment,',
                        lottieAsset: AppAsset.empty,
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Column(
                      children: [
                        BookingsCard(
                          booking: bookings[index],
                        ),
                        if (index != bookings.length - 1) const Gap(15),
                      ],
                    );
                  },
                  childCount: bookings.length,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
