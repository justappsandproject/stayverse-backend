import 'package:dio/dio.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/data/typedefs.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';
import 'package:stayvers_agent/feature/profile/model/data/update_password_request.dart';

class _ProfilePath {
  static const String updatePassword = "/agents/update-password";
  static const String getListedApartments = "/apartment/owner";
  static const String getListedRides = "/ride/owner";
  static const String verifyKyc = "/agents/kyc";
  static const String uploadProfile = "/agents/profile-picture";
}

class ProfileNetworkRepository {
  final log = BrimLogger.load("ProfileNetworkRepository");

  ProfileNetworkRepository({required this.dio});

  final Dio dio;

  Future<ServerResponse?> updatePassword(
      UpdatePasswordRequest updatePasswordRequest) async {
    final result = await dio.put<DynamicMap>(
      "${dio.options.baseUrl}${_ProfilePath.updatePassword}",
      data: updatePasswordRequest.toJson(),
    );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> getListedApartments(String status) async {
    final result = await dio.get<DynamicMap>(
      "${dio.options.baseUrl}${_ProfilePath.getListedApartments}",
      queryParameters: {"status": status},
    );
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> getListedRides(String status) async {
    final result = await dio.get<DynamicMap>(
      "${dio.options.baseUrl}${_ProfilePath.getListedRides}",
      queryParameters: {"status": status},
    );
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> verifyKyc(String nin, MultipartFile selfie) async {
    final formData = FormData();

    formData.fields.add(MapEntry('nin', nin));

    formData.files.add(MapEntry('selfie', selfie));

    final result = await dio.post<DynamicMap>(
      "${dio.options.baseUrl}${_ProfilePath.verifyKyc}",
      data: formData,
    );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> uploadProfile(MultipartFile profilePicture) async {
    final formData = FormData();

    formData.files.add(MapEntry('profilePicture', profilePicture));

    final result = await dio.patch<DynamicMap>(
      "${dio.options.baseUrl}${_ProfilePath.uploadProfile}",
      data: formData,
    );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }
}
