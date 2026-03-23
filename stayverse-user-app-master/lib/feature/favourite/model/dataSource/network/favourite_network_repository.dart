import 'package:dio/dio.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/data/server_respond.dart';
import 'package:stayverse/core/data/typedefs.dart';
import 'package:stayverse/core/util/app/logger.dart';
import 'package:stayverse/feature/favourite/model/data/favourite_request.dart';

class _FavouritePath {
  static String getFavourites(ServiceType type) => "/favorites/user";
  static String favourites = '/favorites';
}

class FavouriteNetworkRepository {
  final log = BrimLogger.load("FavouriteNetworkRepository");

  FavouriteNetworkRepository({required this.dio});

  final Dio dio;

  Future<ServerResponse?> getFavourite(ServiceType serviceType,
      {required int page, required int limit}) async {
    final result = await dio.get<DynamicMap>(
      "${dio.options.baseUrl}${_FavouritePath.getFavourites(serviceType)}",
      queryParameters: {
        "serviceType": serviceType.apiPoint,
        "page": page,
        "limit": limit
      },
    );
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> addFavorite(FavouriteRequest favouriteRequest) async {
    final result = await dio.post<DynamicMap>(
      "${dio.options.baseUrl}${_FavouritePath.favourites}",
      data: favouriteRequest.toJson(),
    );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> removeFavorite(
      FavouriteRequest favouriteRequest) async {
    final result = await dio.post<DynamicMap>(
      "${dio.options.baseUrl}${_FavouritePath.favourites}",
      data: favouriteRequest.toJson(),
    );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }
}
