import 'package:dio/dio.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/exception/app_exceptions.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';
import 'package:stayvers_agent/feature/discover/model/data/booking_status_request.dart';
import 'package:stayvers_agent/feature/discover/model/data/discover_data_source.dart';
import 'package:stayvers_agent/feature/discover/model/dataSource/network/discover_network_repository.dart';

class DiscoverNetworkService extends DiscoverDataSource<ServerResponse> {
  final log = BrimLogger.load("DiscoverService");

  final DiscoverNetworkRepository _discoverRepository;

  DiscoverNetworkService(this._discoverRepository);

  @override
  Future<ServerResponse?> getOverviewMetrics() async {
    try {
      log.i("  ::::====>  fetching Metrics");

      return await _discoverRepository.getOverviewMetrics();
    } on DioException catch (e) {
      log.i(" Error message ::::=====> ${e.message}");

      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> getAgentBookings(BookingStatus status, {int? page, int? limit}) async {
    try {
      log.i("  ::::====>  getAgentBookings ");

      return await _discoverRepository.getAgentBookings(
          status,
          page: page ?? 1, limit: limit ?? 10);
    } on DioException catch (e) {
      log.i(" Error message ::::=====> ${e.message}");
      log.i(" Error message ::::=====> ${e.response?.data}");
      log.i(" Error message ::::=====> ${e.response?.statusCode}");

      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> updateBookingStatus(BookingStatusRequest request) async {
    try {
      log.i(
          "Patching booking status for ${request.bookingId} to ${request.status?.value}");
      return await _discoverRepository.updateBookingStatus(request);
    } on DioException catch (e) {
      log.i("Error patching booking: ${e.message}");
      return BrimAppException.handleError(e);
    }
  }
}
