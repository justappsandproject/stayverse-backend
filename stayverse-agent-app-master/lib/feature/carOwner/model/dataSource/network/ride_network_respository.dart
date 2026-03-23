import 'package:dio/dio.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/data/typedefs.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';
import 'package:stayvers_agent/feature/carOwner/model/data/create_ride_request.dart';

class _RidePath {
  static String createride = "/ride";
  static String updateRide(String rideId) => "/ride/$rideId";

}

class RideNetworkRespository {
  final log = BrimLogger.load("RideRepository");

  RideNetworkRespository({required this.dio});

  final Dio dio;

  Future<ServerResponse?> createRide(CreateRideRequest request) async {
    final formData = buildRideFormData(request);

    final result = await dio.post<DynamicMap>(
        "${dio.options.baseUrl}${_RidePath.createride}",
        data: formData,
        options: Options(contentType: "multipart/form-data"),
        );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> editRide(String rideId, CreateRideRequest request) async {
    final formData = buildRideFormData(request);

    final result = await dio.put<DynamicMap>(
        "${dio.options.baseUrl}${_RidePath.updateRide(rideId)}",
        data: formData,
        options: Options(contentType: "multipart/form-data"),
        );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }
}