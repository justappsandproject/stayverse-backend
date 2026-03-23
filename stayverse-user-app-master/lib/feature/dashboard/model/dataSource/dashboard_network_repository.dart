import 'package:dio/dio.dart';
import 'package:stayverse/core/data/server_respond.dart';
import 'package:stayverse/core/data/typedefs.dart';
import 'package:stayverse/core/util/app/logger.dart';

class _DashPath {
  static String getUser = "/users/me";
  static String proposalAction(String proposalId) =>
      "/chef/proposal/$proposalId/status";
      static String updateProfile = "/users/profile";
}

class DashNetworkRepository {
  final log = BrimLogger.load("DashRepository");

  DashNetworkRepository({required this.dio});

  final Dio dio;

  Future<ServerResponse?> getProfile() async {
    final result =
        await dio.get<DynamicMap>("${dio.options.baseUrl}${_DashPath.getUser}");
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> proposalAction(
      {required String proposalId, required bool status}) async {
    final result = await dio.patch<DynamicMap>(
      "${dio.options.baseUrl}${_DashPath.proposalAction(proposalId)}",
      data: {"status": status ? "accepted" : "rejected"},
    );
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

    Future<ServerResponse?> updateProfile(String firstName, String lastName) async {
    final result = await dio.put<DynamicMap>(
      "${dio.options.baseUrl}${_DashPath.updateProfile}",
      data: {"firstname": firstName, "lastname": lastName},
    );
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }
}
