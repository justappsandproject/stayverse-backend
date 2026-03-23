import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/config/dependecies.dart';
import 'package:stayvers_agent/core/data/server_error_catch.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/data/typedefs.dart';
import 'package:stayvers_agent/core/exception/app_exceptions.dart';
import 'package:stayvers_agent/core/service/toast_service.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';
import 'package:stayvers_agent/feature/discover/model/data/booking_response.dart';
import 'package:stayvers_agent/feature/discover/model/data/booking_status_request.dart';
import 'package:stayvers_agent/feature/discover/model/dataSource/network/discover_network_service.dart';
import 'package:stayvers_agent/feature/discover/view/ui_state/booking_ui_state.dart';

class ApartmentBookingsController extends StateNotifier<BookingUiState>
    with CheckForServerError {

  ApartmentBookingsController(this._discoverNetworkService)
      : super(const BookingUiState());

  final log = BrimLogger.load('BookingController');
  final DiscoverNetworkService _discoverNetworkService;

  Future<void> getBookings(BookingStatus status,
      {bool loadMore = false}) async {
    try {
      _setLoadingStatus(status, true);

      final ServerResponse? response = await _discoverNetworkService.getAgentBookings(
        status,
      );

        if (errorOccured(response, showToast: false)) {
        return;
      }
    

      final bookingResponse = BookingApiResponse.fromJson(response!.payload as DynamicMap);

      _setBookings(
        status: status,
        bookings: bookingResponse.data?.bookings ?? [],
        pagination: bookingResponse.data?.pagination ?? Pagination(),
        append: loadMore,
      );
    } on BrimAppException catch (e) {
      log.i('getPendingBooking: ${e.message}');
    } finally {
      _setLoadingStatus(status, false);
    }
  }

    Future<bool> acceptBooking(BookingStatusRequest request) async {
     _isBusy(true);
      try {
       final ServerResponse? serverResponse = await _discoverNetworkService.updateBookingStatus(request);

      if (errorOccured(serverResponse)) {
        return false;
      }

      BrimToast.showSuccess('Booking accepted successfully');
      getBookings(BookingStatus.pending);
      getBookings(BookingStatus.accepted); 
      return true;
    } on BrimAppException catch (e) {
      BrimToast.showError(e.toString());
      return false;
    } finally {
      reset();
    }
  }

  Future<bool> declineBooking(BookingStatusRequest request) async {
   _isBusy(true);
      try {
       final ServerResponse? serverResponse = await _discoverNetworkService.updateBookingStatus(request);

      if (errorOccured(serverResponse)) {
        return false;
      }

      BrimToast.showSuccess('Booking cancelled successfully');
      getBookings(BookingStatus.rejected);
      getBookings(BookingStatus.pending);
      getBookings(BookingStatus.accepted);
      return true;
    } on BrimAppException catch (e) {
      BrimToast.showError(e.toString());
      return false;
    } finally {
      reset();
    }
  }

 void _setBookings({
    required BookingStatus status,
    required List<Booking> bookings,
    required Pagination pagination,
    bool append = false,
  }) {
    switch (status) {
      case BookingStatus.pending:
        state = state.copyWith(
          pendingBookings:
              append ? [...state.pendingBookings, ...bookings] : bookings,
          pendingPagination: pagination,
        );
        break;
      case BookingStatus.completed:
        state = state.copyWith(
          completedBookings:
              append ? [...state.completedBookings, ...bookings] : bookings,
          completedPagination: pagination,
        );
        break;
      case BookingStatus.rejected:
        state = state.copyWith(
          rejectedBookings:
              append ? [...state.rejectedBookings, ...bookings] : bookings,
          rejectedPagination: pagination,
        );
        break;
      case BookingStatus.accepted:
        state = state.copyWith(
          acceptedBookings:
              append ? [...state.acceptedBookings, ...bookings] : bookings,
          acceptedPagination: pagination,
        );
        break;
    }
  }

  void _setLoadingStatus(BookingStatus status, bool isLoading) {
    switch (status) {
      case BookingStatus.pending:
        state = state.copyWith(isLoadingPending: isLoading);
        break;
      case BookingStatus.completed:
        state = state.copyWith(isLoadingCompleted: isLoading);
        break;
      case BookingStatus.rejected:
        state = state.copyWith(isLoadingRejected: isLoading);
        break;
      case BookingStatus.accepted:
        state = state.copyWith(isLoadingAccepted: isLoading);
        break;
    }
  }

 void _isBusy(bool isBusy) {
    state = state.copyWith(isBusy: isBusy);
  }

  void reset() {
    _isBusy(false);
  }
}


final bookingController =
    StateNotifierProvider<ApartmentBookingsController, BookingUiState>((ref) {
  return ApartmentBookingsController(locator.get());
});
