import 'package:dio/dio.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/data/typedefs.dart';

class _DashboardPath {
  static String user = "/agents/me";
  static String updateProfile = "/agents/profile";
}

class DashboardNetworkRepository {
  DashboardNetworkRepository({required this.dio});

  final Dio dio;

  Future<ServerResponse?> getUser() async {
    final result = await dio.get<DynamicMap>(
      "${dio.options.baseUrl}${_DashboardPath.user}",
    );
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> updateProfile(String firstName, String lastName) async {
    final result = await dio.put<DynamicMap>(
      "${dio.options.baseUrl}${_DashboardPath.updateProfile}",
      data: {"firstname": firstName, "lastname": lastName},
    );
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }
}
