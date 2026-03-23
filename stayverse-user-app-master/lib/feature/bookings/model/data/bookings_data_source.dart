import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/feature/bookings/model/data/add_a_review_request.dart';

abstract class BookingsDataSource<T> {
  Future<T?> getBookings(BookingStatus status, {int? page, int? limit});
  Future<T?> getUnavailableBookingDays(
      {required String serviceType, required String serviceId});

  Future<T?> sendAReview(String serviceType, String serviceId, AddAReviewRequest reviewRequest);
  Future<T?> getReviews(String serviceType, String serviceId, {int? limit, int? page});
  Future<T?> cancelBooking(String id);
}
