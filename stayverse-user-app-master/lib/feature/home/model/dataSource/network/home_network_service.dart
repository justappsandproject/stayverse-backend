import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/data/server_respond.dart';
import 'package:stayverse/core/exception/app_exceptions.dart';
import 'package:stayverse/core/util/app/logger.dart';
import 'package:stayverse/feature/home/model/data/home_data_source.dart';
import 'package:stayverse/feature/home/model/dataSource/network/home_network_repository.dart';

class HomeNetworkService extends HomeDataSource<ServerResponse> {
  final log = BrimLogger.load("HomeService");

  final HomeNetworkRepository _homeRepository;

  HomeNetworkService(this._homeRepository);

  @override
  Future<ServerResponse?> getRecommendations(ServiceType serviceType,LatLng latLng) async {
    try {
      log.i("::::====> Fetching recommendations for ${serviceType.name}");

      return await _homeRepository.getRecommendations(serviceType,latLng);
    } on DioException catch (e) {
      log.i("Error fetching recommendations: ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> getTopLocation() async {
    try {
      log.i("::::====> Fetching top locations");

      return await _homeRepository.getTopLocation();
    } on DioException catch (e) {
      log.i("Error fetching top locations: ${e.message}");

      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> getTopChefs() async {
    try {
      log.i("::::====> Fetching top chefs");

      return await _homeRepository.getTopChefs();
    } on DioException catch (e) {
      log.i("Error fetching top chefs: ${e.message}");

      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> getNewlyListed(ServiceType serviceType) async {
    try {
      log.i("::::====> Fetching newly listed for ${serviceType.name}");

      return await _homeRepository.getNewlyListed(serviceType);
    } on DioException catch (e) {
      log.i("Error fetching newly listed: ${e.message}");

      return BrimAppException.handleError(e);
    }
  }
}
