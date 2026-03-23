import 'package:dio/dio.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/exception/app_exceptions.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';
import 'package:stayvers_agent/feature/apartmentOwner/model/data/apartment_data_source.dart';
import 'package:stayvers_agent/feature/apartmentOwner/model/data/create_apartment_request.dart';
import 'package:stayvers_agent/feature/apartmentOwner/model/dataSource/network/apartment_network_respository.dart';

class ApartmentNetworkService extends ApartmentDataSource<ServerResponse> {
  final log = BrimLogger.load("ApartmentService");

  final ApartmentNetworkRespository _apartmentRepository;

  ApartmentNetworkService(this._apartmentRepository);

  @override
  Future<ServerResponse?> createApartment(CreateApartmentRequest request) async {
    try {
      log.i("  ::::====>  creating Apartment");

      return await _apartmentRepository.createApartment(request);
    } on DioException catch (e) {
      log.i(" Error message ::::=====> ${e.message}");
  log.i(" Status Code : ${e.response?.statusCode}");
  log.i(" Response Data : ${e.response?.data}");

      return BrimAppException.handleError(e);
    }
  }

    @override
  Future<ServerResponse?> editApartment(String apartmentId, CreateApartmentRequest request) async {
    try {
      log.i("  ::::====>  editing Apartment with ID: $apartmentId");

      return await _apartmentRepository.updateApartment(apartmentId, request);
    } on DioException catch (e) {
      log.i(" Error message ::::=====> ${e.message}");
      log.i(" Status Code : ${e.response?.statusCode}");
      log.i(" Response Data : ${e.response?.data}");

      return BrimAppException.handleError(e);
    }
  }
}
