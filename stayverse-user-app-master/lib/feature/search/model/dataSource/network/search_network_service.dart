import 'package:dio/dio.dart';
import 'package:stayverse/core/data/server_respond.dart';
import 'package:stayverse/core/exception/app_exceptions.dart';
import 'package:stayverse/core/util/app/logger.dart';
import 'package:stayverse/feature/search/model/data/apartment_search_filter.dart';
import 'package:stayverse/feature/search/model/data/car_search_filter.dart';
import 'package:stayverse/feature/search/model/data/chef_filter.dart';
import 'package:stayverse/feature/search/model/data/search_data_source.dart';
import 'package:stayverse/feature/search/model/dataSource/network/search_network_repository.dart';

class SearchNetworkService extends SearchDataSource<ServerResponse> {
  final log = BrimLogger.load("SearchNetworkService");
  final SearchNetworkRepository _searchNetworkRepository;
  SearchNetworkService(this._searchNetworkRepository);

  @override
  Future<ServerResponse?> searchApartments(ApartmentSearchFilter filter) async {
    try {
      log.i("::::====> Search Apartments ");

      return await _searchNetworkRepository.searchFilter(filter);
    } on DioException catch (e) {
      log.i("Error  Search Apartments: ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> searchRides(CarSearchFilter filter) async {
    try {
      log.i("::::====> Search Rides ");

      return await _searchNetworkRepository.searchRides(filter);
    } on DioException catch (e) {
      log.i("Error  Search Rides: ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> searchChef(ChefSearchFilter filter) async {
    try {
      log.i("::::====> Search Chef ");

      return await _searchNetworkRepository.searchChef(filter);
    } on DioException catch (e) {
      log.i("Error  Search Rides: ${e.message}");
      return BrimAppException.handleError(e);
    }
  }
}
