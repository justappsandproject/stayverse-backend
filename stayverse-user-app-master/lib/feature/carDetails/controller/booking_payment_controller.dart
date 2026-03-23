import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/core/data/server_error_catch.dart';
import 'package:stayverse/core/exception/app_exceptions.dart';
import 'package:stayverse/core/service/toast_service.dart';
import 'package:stayverse/core/util/app/logger.dart';
import 'package:stayverse/feature/apartmentDetails/model/data/booking_request.dart';
import 'package:stayverse/feature/apartmentDetails/model/dataSource/aparment_network_service.dart';
import 'package:stayverse/feature/carDetails/view/uistate/booking_confrim_ui_state.dart';

class BookingPaymentController extends StateNotifier<RideBookingPaymentUiState>
    with CheckForServerError {
  BookingPaymentController(this._detailsNetworkService)
      : super(const RideBookingPaymentUiState());
  final AparmentDetailsNetworkService _detailsNetworkService;

  final logger = BrimLogger.load('BookingConfirmendController');

  Future<bool> bookService(BookingRequest bookingRequest) async {
    try {
      _isBusy(true);
      final result = await _detailsNetworkService.bookService(bookingRequest);

      if (errorOccured(result)) {
        return false;
      }
      BrimToast.showSuccess('Booking has been sent successfully');
      return true;
    } on BrimAppException catch (e) {
      logger.d('Error booking apartment: ${e.message}');
      return false;
    } finally {
      _isBusy(false);
    }
  }

  void _isBusy(bool isBusy) {
    state = state.copyWith(isBusy: isBusy);
  }
}

final rideBookingPaymenrController =
    StateNotifierProvider<BookingPaymentController, RideBookingPaymentUiState>(
        (ref) => BookingPaymentController(locator.get()));
