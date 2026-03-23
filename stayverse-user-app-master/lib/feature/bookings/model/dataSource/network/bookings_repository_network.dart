import 'package:dio/dio.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/data/server_respond.dart';
import 'package:stayverse/core/data/typedefs.dart';
import 'package:stayverse/core/util/app/logger.dart';
import 'package:stayverse/feature/bookings/model/data/add_a_review_request.dart';

class _BookingsPath {
  static String bookings = '/booking/user';
  static String unAvailableBookingDays = '/booking/unavailable-dates';
  static String sendAReview(String serviceType, String serviceId) =>
      "/$serviceType/$serviceId/rating";
  static String getReviews(String serviceType, String serviceId) =>
      "/$serviceType/$serviceId/ratings";
      static String cancelBooking(String bookingId) => "/booking/$bookingId/cancel";
}

class BookingNetworkRepository {
  final log = BrimLogger.load("BookingRepository");

  BookingNetworkRepository({required this.dio});

  final Dio dio;

  Future<ServerResponse?> getBookings(BookingStatus status,
      {required int page, required int limit}) async {
    final result = await dio.get<DynamicMap>(
      "${dio.options.baseUrl}${_BookingsPath.bookings}",
      queryParameters: {"status": status.name, "page": page, "limit": limit},
    );
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> getUnavailableBookingDays(
      {required String serviceType, required String serviceId}) async {
    final result = await dio.get<DynamicMap>(
      "${dio.options.baseUrl}${_BookingsPath.unAvailableBookingDays}",
      queryParameters: {"serviceType": serviceType, "id": serviceId},
    );
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> sendAReview(String serviceType, String serviceId,
      AddAReviewRequest reviewRequest) async {
    final result = await dio.post<DynamicMap>(
      "${dio.options.baseUrl}${_BookingsPath.sendAReview(serviceType, serviceId)}",
      data: reviewRequest.toJson(),
    );
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> getReviews(String serviceType, String serviceId,
      {required int limit, required int page}) async {
    final result = await dio.get<DynamicMap>(
        "${dio.options.baseUrl}${_BookingsPath.getReviews(serviceType, serviceId)}",
        queryParameters: {"limit": limit, "page": page});
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

     Future<ServerResponse?> cancelBooking(String id) async {
    final result = await dio.post<DynamicMap>(
      "${dio.options.baseUrl}${_BookingsPath.cancelBooking(id)}",
     
    );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }
}
