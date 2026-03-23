import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/config/dependecies.dart';
import 'package:stayvers_agent/core/data/server_error_catch.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/data/typedefs.dart';
import 'package:stayvers_agent/core/exception/app_exceptions.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';
import 'package:stayvers_agent/feature/Reviews/model/data/review_response.dart';
import 'package:stayvers_agent/feature/Reviews/model/data_source/network/review_service_network.dart';
import 'package:stayvers_agent/feature/Reviews/view/ui_state/review_ui_state.dart';

class ReviewController extends StateNotifier<ReviewUiState>
    with CheckForServerError {
  ReviewController(this._networkService) : super(const ReviewUiState());

  final log = BrimLogger.load('ReviewController');
  final ReviewNetworkService _networkService;

  Future<void> getReviews(String serviceType, String serviceId,
      {bool loadMore = false, int limit = 10}) async {
    try {
      _isLoading(true);

      final ServerResponse? response = await _networkService.getReviews(
        serviceType,
        serviceId,
        limit: limit,
        page: 1,
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
    StateNotifierProvider<ReviewController, ReviewUiState>((ref) {
  return ReviewController(locator.get());
});
