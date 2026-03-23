import 'package:dio/dio.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/data/server_respond.dart';
import 'package:stayverse/core/exception/app_exceptions.dart';
import 'package:stayverse/core/util/app/logger.dart';
import 'package:stayverse/feature/favourite/model/data/favourite_data_source.dart';
import 'package:stayverse/feature/favourite/model/data/favourite_request.dart';
import 'package:stayverse/feature/favourite/model/dataSource/network/favourite_network_repository.dart';

class FavouriteNetworkService extends FavouriteDataSource<ServerResponse> {
  final log = BrimLogger.load("FavouriteNetworkService");
  final FavouriteNetworkRepository favouriteNetworkRepository;
  FavouriteNetworkService(this.favouriteNetworkRepository);

  @override
  Future<ServerResponse?> getFavourites(ServiceType serviceType,
      {int? page, int? limit}) async {
    try {
      log.i("::::====> Fetching Favourite for ${serviceType.name}");

      return await favouriteNetworkRepository.getFavourite(serviceType,
          page: page ?? 1, limit: limit ?? 10);
    } on DioException catch (e) {
      log.i("Error  Fetching Favourite: ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> addFavorite(FavouriteRequest favouriteRequest) async {
    try {
      log.i("::::====> Adding Favourite ");

      return await favouriteNetworkRepository.addFavorite(favouriteRequest);
    } on DioException catch (e) {
      log.i("Error  Fetching Favourite: ${e.message}");
      log.i("Error  Favourite data: ${e.response?.data}");
      log.i("Error  Favourite statuscode: ${e.response?.statusCode}");

      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> removeFavorite(
      FavouriteRequest favouriteRequest) async {
    try {
      log.i("::::====> Removing Favourite ");

      return await favouriteNetworkRepository.removeFavorite(favouriteRequest);
    } on DioException catch (e) {
      log.i("Error  Fetching Favourite: ${e.message}");
      log.i("Error  Favourite data: ${e.response?.data}");
      log.i("Error  Favourite statuscode: ${e.response?.statusCode}");
      return BrimAppException.handleError(e);
    }
  }
}
