import 'package:dio/dio.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/data/typedefs.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';

class _ReviewsPath {
  static String getReviews(String serviceType, String serviceId) =>
      "/$serviceType/$serviceId/ratings";
}

class ReviewNetworkRepository {
  final log = BrimLogger.load("ReviewRepository");

  ReviewNetworkRepository({required this.dio});

  final Dio dio;

  Future<ServerResponse?> getReviews(String serviceType, String serviceId,
      {required int limit, required int page}) async {
    final result = await dio.get<DynamicMap>(
        "${dio.options.baseUrl}${_ReviewsPath.getReviews(serviceType, serviceId)}",
        queryParameters: {"limit": limit, "page": page});
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }
}