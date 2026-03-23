import 'package:dio/dio.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/data/typedefs.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';
import 'package:stayvers_agent/feature/discover/model/data/booking_status_request.dart';

class _DiscoverPath {
  static String getMetrics = "/agents/metrics/{agentId}";
  static String getBookings = "/booking/agent";
  static String updateBookingStatus(String? bookingId) =>
      "/booking/$bookingId/status";
}

class DiscoverNetworkRepository {
  final log = BrimLogger.load("DiscoverRepository");

  DiscoverNetworkRepository({required this.dio});

  final Dio dio;

  Future<ServerResponse?> getOverviewMetrics() async {
    final result = await dio
        .get<DynamicMap>("${dio.options.baseUrl}${_DiscoverPath.getMetrics}");
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> getAgentBookings( BookingStatus status,
      {required int limit, required int page}) async {
    final result = await dio.get<DynamicMap>(
        "${dio.options.baseUrl}${_DiscoverPath.getBookings}",
        queryParameters: {"status": status.name,"limit": limit, "page": page});
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> updateBookingStatus(BookingStatusRequest request) async {
    final result = await dio.patch<DynamicMap>(
      "${dio.options.baseUrl}${_DiscoverPath.updateBookingStatus(request.bookingId)}",
      data: {"status": request.status?.value},
    );
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }
}
