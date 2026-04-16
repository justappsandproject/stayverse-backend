import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/data/server_respond.dart';
import 'package:stayverse/core/data/typedefs.dart';
import 'package:stayverse/core/util/app/logger.dart';

class _HomePath {
  static String listings(ServiceType type) => "/${type.apiPoint}";

  static const String topLocations = "/user/top-locations";
  static const String topChefs = "/user/top-chefs";

  static String newlyListed(ServiceType type) => "/${type.apiPoint}/newest";
}

class HomeNetworkRepository {
  final log = BrimLogger.load("HomeNetworkRepository");

  HomeNetworkRepository({required this.dio});

  final Dio dio;

  Future<ServerResponse?> getRecommendations(
      ServiceType serviceType, LatLng latLng) async {
    final result = await dio.get<DynamicMap>(
      "${dio.options.baseUrl}${_HomePath.listings(serviceType)}",
    );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> getTopLocation() async {
    final result = await dio.get<DynamicMap>(
      "${dio.options.baseUrl}${_HomePath.topLocations}",
    );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> getTopChefs() async {
    final result = await dio.get<DynamicMap>(
      "${dio.options.baseUrl}${_HomePath.topChefs}",
    );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> getNewlyListed(ServiceType serviceType) async {
    final result = await dio.get<DynamicMap>(
      "${dio.options.baseUrl}${_HomePath.newlyListed(serviceType)}",
    );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }
}
