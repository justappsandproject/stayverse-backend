import 'package:dio/dio.dart';
import 'package:stayverse/core/data/server_respond.dart';
import 'package:stayverse/core/data/typedefs.dart';
import 'package:stayverse/core/util/app/logger.dart';
import 'package:stayverse/feature/search/model/data/apartment_search_filter.dart';
import 'package:stayverse/feature/search/model/data/car_search_filter.dart';
import 'package:stayverse/feature/search/model/data/chef_filter.dart';

class _SearchPath {
  static String searchApartment = '/apartment/search';
  static String rideSearch = '/ride/search';
  static String chefSearch = '/chef/search';
}

class SearchNetworkRepository {
  final log = BrimLogger.load("SearchNetworkRepository");

  SearchNetworkRepository({required this.dio});

  final Dio dio;

  Future<ServerResponse?> searchFilter(
      ApartmentSearchFilter apartmentSearchFilter) async {
    final result = await dio.get<DynamicMap>(
      "${dio.options.baseUrl}${_SearchPath.searchApartment}",
      queryParameters: apartmentSearchFilter.toQueryParameters(),
    );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> searchRides(CarSearchFilter carSearchFilter) async {
    final result = await dio.get<DynamicMap>(
      "${dio.options.baseUrl}${_SearchPath.rideSearch}",
      queryParameters: carSearchFilter.toQueryParameters(),
    );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> searchChef(ChefSearchFilter chefSearchFilter) async {
    final result = await dio.get<DynamicMap>(
      "${dio.options.baseUrl}${_SearchPath.chefSearch}",
      queryParameters: chefSearchFilter.toQueryParameters(),
    );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }
}
