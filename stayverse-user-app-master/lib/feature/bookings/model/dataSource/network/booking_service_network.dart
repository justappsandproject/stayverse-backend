import 'package:dio/dio.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/data/server_respond.dart';
import 'package:stayverse/core/exception/app_exceptions.dart';
import 'package:stayverse/core/util/app/logger.dart';
import 'package:stayverse/feature/bookings/model/data/add_a_review_request.dart';
import 'package:stayverse/feature/bookings/model/data/bookings_data_source.dart';
import 'package:stayverse/feature/bookings/model/dataSource/network/bookings_repository_network.dart';

class BookingNetworkService extends BookingsDataSource<ServerResponse> {
  final BookingNetworkRepository bookingRepository;
  BookingNetworkService(this.bookingRepository);

  final log = BrimLogger.load("BookingServiceNetwork");

  @override
  Future<ServerResponse?> getBookings(BookingStatus status,
      {int? page, int? limit}) async {
    try {
      log.i("::::====> getBookings ");

      return await bookingRepository.getBookings(status,
          page: page ?? 1, limit: limit ?? 10);
    } on DioException catch (e) {
      log.i("Error  getBookings : ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> getUnavailableBookingDays(
      {required String serviceType, required String serviceId}) {
    try {
      log.i("::::====> getUnavailableBookingDays ");

      return bookingRepository.getUnavailableBookingDays(
          serviceType: serviceType, serviceId: serviceId);
    } on DioException catch (e) {
      log.i("Error  getUnavailableBookingDays : ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> sendAReview(
      String serviceType, String serviceId, AddAReviewRequest reviewRequest) {
    try {
      log.i("::::====> sendAReview to $serviceType with ID $serviceId");

      return bookingRepository.sendAReview(
          serviceType, serviceId, reviewRequest);
    } on DioException catch (e) {
      log.i("Error  sendAReview : ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> getReviews(String serviceType, String serviceId,
      {int? limit, int? page}) {
    try {
      log.i("::::====> getReviews for $serviceType with ID $serviceId");

      return bookingRepository.getReviews(serviceType, serviceId,
          limit: limit ?? 10, page: page ?? 1);
    } on DioException catch (e) {
      log.i("Error  getReviews : ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

    @override
  Future<ServerResponse?> cancelBooking(String id) async {
    try {
      log.i("::::====> Canceling Booking with ID: $id");
      return await bookingRepository.cancelBooking(id);
    } on DioException catch (e) {
      log.i("Error: ${e.message}");
      log.i(" Status Code : ${e.response?.statusCode}");
      log.i(" Response Data : ${e.response?.data}");
      return BrimAppException.handleError(e);
    }
  }
}
