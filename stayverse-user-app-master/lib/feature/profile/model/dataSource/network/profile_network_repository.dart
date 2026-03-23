import 'package:dio/dio.dart';
import 'package:stayverse/core/data/server_respond.dart';
import 'package:stayverse/core/data/typedefs.dart';
import 'package:stayverse/core/util/app/logger.dart';
import 'package:stayverse/feature/profile/model/data/update_password_request.dart';

class _ProfileRepoPath {
  static const String updatePassword = "/users/update-password";
  static const String verifyKyc = "/users/kyc";
  static const String uploadProfile = "/users/profile-picture"; 
  static const String deleteAccount = "/users/me";

}

class ProfileNetworkRepository {
  final log = BrimLogger.load("ProfileNetworkRepository");

  ProfileNetworkRepository({required this.dio});

  final Dio dio;

  Future<ServerResponse?> updatePassword(
      UpdatePasswordRequest updatePasswordRequest) async {
    final result = await dio.put<DynamicMap>(
      "${dio.options.baseUrl}${_ProfileRepoPath.updatePassword}",
      data: updatePasswordRequest.toJson(),
    );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }


  Future<ServerResponse?> verifyKyc(String nin, MultipartFile selfie) async {
    final formData = FormData();

    formData.fields.add(MapEntry('nin', nin));

    formData.files.add(MapEntry('selfie', selfie));

    final result = await dio.post<DynamicMap>(
      "${dio.options.baseUrl}${_ProfileRepoPath.verifyKyc}",
      data: formData,
    );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> uploadProfile(MultipartFile profilePicture) async {
    final formData = FormData();

    formData.files.add(MapEntry('profilePicture', profilePicture));

    final result = await dio.patch<DynamicMap>(
      "${dio.options.baseUrl}${_ProfileRepoPath.uploadProfile}",
      data: formData,
    );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

   Future<ServerResponse?> deleteAccount(String password) async {
    final result = await dio.delete<DynamicMap>(
      "${dio.options.baseUrl}${_ProfileRepoPath.deleteAccount}",
      data: {"password": password},
    );

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }
}
