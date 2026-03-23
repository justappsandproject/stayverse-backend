import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/data/server_error_catch.dart';
import 'package:stayverse/core/data/server_respond.dart';
import 'package:stayverse/core/data/typedefs.dart';
import 'package:stayverse/core/exception/app_exceptions.dart';
import 'package:stayverse/core/service/toast_service.dart';
import 'package:stayverse/core/util/app/logger.dart';
import 'package:stayverse/feature/bookings/model/data/add_a_review_request.dart';
import 'package:stayverse/feature/bookings/model/data/review_response.dart';
import 'package:stayverse/feature/bookings/model/dataSource/network/booking_service_network.dart';
import 'package:stayverse/feature/bookings/view/uistate/review_ui_state.dart';

class ReviewController extends StateNotifier<ReviewUiState>
    with CheckForServerError {
  ReviewController(this._networkService) : super(const ReviewUiState());

  final log = BrimLogger.load('ReviewController');
  final BookingNetworkService _networkService;

  Future<bool> sendAReview(String serviceType, String serviceId,
      AddAReviewRequest reviewRequest) async {
    _isBusy(true);
    try {
      final serverResposne = await _networkService.sendAReview(
          serviceType, serviceId, reviewRequest);

      if (errorOccured(serverResposne)) {
        return false;
      }

      BrimToast.showSuccess('Review submitted successfully');
      return true;
    } on BrimAppException catch (e) {
      BrimToast.showError(e.message.toString());
      return false;
    } finally {
      reset();
    }
  }

  Future<void> getReviews(String serviceType, String serviceId,
      {bool loadMore = false}) async {
    try {
      _isLoading(true);

      final ServerResponse? response = await _networkService.getReviews(
        serviceType,
        serviceId,
      );

      if (errorOccured(response, showToast: false)) {
        return;
      }

      final reviewResponse =
          ReviewApiResponse.fromJson(response!.payload as DynamicMap);

      _setReviews(
        reviews: reviewResponse.data?.reviews ?? [],
        pagination: reviewResponse.data?.pagination ?? ReviewPagination(),
        append: loadMore,
      );
    } on BrimAppException catch (e) {
      log.i('getReviews: ${e.message}');
    } finally {
      _isLoading(false);
    }
  }

  void _setReviews({
    required List<Review> reviews,
    required ReviewPagination pagination,
    bool append = false,
  }) {
    state = state.copyWith(
      reviews: append ? [...state.reviews, ...reviews] : reviews,
      reviewPagination: pagination,
    );
  }

  void _isLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void _isBusy(bool isBusy) {
    state = state.copyWith(isBusy: isBusy);
  }

  void reset() {
    _isBusy(false);
    _isLoading(false);
  }
}

final reviewController =
    StateNotifierProvider.autoDispose<ReviewController, ReviewUiState>((ref) {
  return ReviewController(locator.get());
});
