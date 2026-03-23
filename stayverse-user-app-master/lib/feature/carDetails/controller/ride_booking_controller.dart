import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/feature/carDetails/view/uistate/ride_bookings_ui_state.dart';

class RideBookingsController extends StateNotifier<RideBookingUiState> {
  RideBookingsController() : super(const RideBookingUiState());

  // void updateBookingDates(DateTimeRange? dateRange, double pricePerNight) {
  //   if (!isDateRangeValid(dateRange)) {
  //     BrimToast.showError(
  //       'Please select a valid date range',
  //       title: 'Invalid Date Range',
  //     );
  //     return;
  //   }
  //   state = state.copyWith(dateRange: dateRange);
  //   calculateTotalPrice(pricePerNight);
  // }

  void calculateTotalPrice({
    required DateTime startDateTime,
    required int totalHours,
    required double pricePerHour,
  }) {
    // Price is simply hours × pricePerHour
    final ridePrice = pricePerHour * totalHours;

    state = state.copyWith(
      ridePrice: ridePrice,
    );
  }

  // bool isDateRangeValid(DateTimeRange? dateRange) {
  //   if (dateRange == null) return false;

  //   final today = DateTime.now();
  //   final start = DateTime(
  //       dateRange.start.year, dateRange.start.month, dateRange.start.day);
  //   final end =
  //       DateTime(dateRange.end.year, dateRange.end.month, dateRange.end.day);
  //   final current = DateTime(today.year, today.month, today.day);

  //   if (start.isBefore(current) || !end.isAfter(start)) return false;

  //   return true;
  // }
}

final rideBookingsController = StateNotifierProvider.autoDispose<
    RideBookingsController, RideBookingUiState>(
  (ref) => RideBookingsController(),
);
