import 'package:stayvers_agent/feature/discover/model/data/booking_status_request.dart';

abstract class DiscoverDataSource<T> {
  Future<T?> getOverviewMetrics();
  Future<T?> getAgentBookings(BookingStatus status, {int? page, int? limit});
  Future<T?> updateBookingStatus(BookingStatusRequest request);
}