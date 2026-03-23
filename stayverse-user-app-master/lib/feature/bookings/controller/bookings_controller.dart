import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/data/server_error_catch.dart';
import 'package:stayverse/core/data/typedefs.dart';
import 'package:stayverse/core/exception/app_exceptions.dart';
import 'package:stayverse/core/service/toast_service.dart';
import 'package:stayverse/core/util/app/logger.dart';
import 'package:stayverse/feature/bookings/model/data/booking_response.dart';
import 'package:stayverse/feature/bookings/model/dataSource/network/booking_service_network.dart';
import 'package:stayverse/feature/bookings/view/uistate/booking_ui_state.dart';

class BookingController extends StateNotifier<BookingUiState>
    with CheckForServerError {
  BookingController(this._networkService) : super(BookingUiState());

  final log = BrimLogger.load('BookingController');
  final BookingNetworkService _networkService;

  Future<void> getBookings(BookingStatus status,
      {bool loadMore = false}) async {
    try {
      int page = 1;
      if (loadMore) {
        switch (status) {
          case BookingStatus.pending:
            if (state.pendingPagination?.currentPage ==
                state.pendingPagination?.totalPages) {
              return;
            }
            page = (state.pendingPagination?.currentPage ?? 0) + 1;
            break;
          case BookingStatus.completed:
            if (state.completedPagination?.currentPage ==
                state.completedPagination?.totalPages) {
              return;
            }
            page = (state.completedPagination?.currentPage ?? 0) + 1;
            break;
          case BookingStatus.rejected:
            if (state.rejectedPagination?.currentPage ==
                state.rejectedPagination?.totalPages) {
              return;
            }
            page = (state.rejectedPagination?.currentPage ?? 0) + 1;
            break;
          case BookingStatus.accepted:
            if (state.acceptedPagination?.currentPage ==
                state.acceptedPagination?.totalPages) {
              return;
            }
            page = (state.acceptedPagination?.currentPage ?? 0) + 1;
            break;
        }
      }
      _setLoadingStatus(status, true);

      final serverResponse = await _networkService.getBookings(
        status,
        page: page,
      );

      if (errorOccured(serverResponse, showToast: false)) {
        return;
      }
      final bookingsResponse =
          BookingResponse.fromJson(serverResponse?.payload as DynamicMap);

      _setBookings(
        status: status,
        bookings: bookingsResponse.data?.data ?? [],
        pagination: bookingsResponse.data?.pagination ?? Pagination(),
        append: loadMore,
      );
    } on BrimAppException catch (e) {
      log.i('getPendingBooking: ${e.message}');
    } finally {
      _setLoadingStatus(status, false);
    }
  }

  Future<bool> cancelBooking(String id, BookingStatus status) async {
    try {
      _isCancelling(true);
      final serverResponse = await _networkService.cancelBooking(id);
      if (errorOccured(serverResponse)) {
        return false;
      }

      BrimToast.showSuccess('Booking canceled successfully');
      getBookings(status);
      return true;
    } catch (e) {
      BrimToast.showError(e.toString());
      return false;
    } finally {
      _isCancelling(false);
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

  void _isCancelling(bool isCancelling) {
    state = state.copyWith(isCancelling: isCancelling);
  }

  

  void reset() {
    _isBusy(false);
  }
}

final bookingController =
    StateNotifierProvider<BookingController, BookingUiState>((ref) {
  return BookingController(locator.get());
});
