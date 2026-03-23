import 'package:dio/dio.dart';
import 'package:stayverse/core/data/server_respond.dart';
import 'package:stayverse/core/data/typedefs.dart';
import 'package:stayverse/core/util/app/logger.dart';

// ignore: unused_element
class _ChefDetailsPath {
  static String profile(String id) => "/chef/profile/$id";
}

class ChefDetailsRepository {
  final log = BrimLogger.load("ChefDetailsRepository");

  ChefDetailsRepository({required this.dio});

  final Dio dio;

  Future<ServerResponse?> bookService(
    String id,
  ) async {
    final result = await dio.get<DynamicMap>(
      "${dio.options.baseUrl}${_ChefDetailsPath.profile(id)}",
    );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }
}
