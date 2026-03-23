import 'package:dio/dio.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/exception/app_exceptions.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';
import 'package:stayvers_agent/feature/Reviews/model/data/reviews_data_source.dart';
import 'package:stayvers_agent/feature/Reviews/model/data_source/network/review_repository_network.dart';

class ReviewNetworkService extends ReviewsDataSource<ServerResponse> {
  final ReviewNetworkRepository reviewRepository;
  ReviewNetworkService(this.reviewRepository);

  final log = BrimLogger.load("ReviewNetworkService");
  @override
  Future<ServerResponse?> getReviews(String serviceType, String serviceId,
      {int? limit, int? page}) {
    try {
      log.i("::::====> getReviews for $serviceType with ID $serviceId");

      return reviewRepository.getReviews(serviceType, serviceId,
          limit: limit ?? 10, page: page ?? 1);
    } on DioException catch (e) {
      log.i("Error  getReviews : ${e.message}");
      return BrimAppException.handleError(e);
    }
  }
}
