import 'package:dio/dio.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/exception/app_exceptions.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';
import 'package:stayvers_agent/feature/carOwner/model/data/create_ride_request.dart';
import 'package:stayvers_agent/feature/carOwner/model/data/ride_data_source.dart';

import 'ride_network_respository.dart';

class RideNetworkService extends RideDataSource<ServerResponse> {
  final log = BrimLogger.load("RideService");

  final RideNetworkRespository _rideRepository;

  RideNetworkService(this._rideRepository);

  @override
  Future<ServerResponse?> createRide(CreateRideRequest request) async {
    try {
      log.i("  ::::====>  creating Ride");

      return await _rideRepository.createRide(request);
    } on DioException catch (e) {
      log.i(" Error message ::::=====> ${e.message}");
        log.i(" Status Code : ${e.response?.statusCode}");
  log.i(" Response Data : ${e.response?.data}");

      return BrimAppException.handleError(e);
    }
  }

   @override
  Future<ServerResponse?> editRide(String rideId, CreateRideRequest request) async {
    try {
      log.i("  ::::====>  editing Ride with ID: $rideId");

      return await _rideRepository.editRide(rideId, request);
    } on DioException catch (e) {
      log.i(" Error message ::::=====> ${e.message}");
      log.i(" Status Code : ${e.response?.statusCode}");
      log.i(" Response Data : ${e.response?.data}");

      return BrimAppException.handleError(e);
    }
  }
}
