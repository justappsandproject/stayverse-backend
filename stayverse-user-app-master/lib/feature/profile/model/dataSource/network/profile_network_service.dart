import 'package:dio/dio.dart';
import 'package:stayverse/core/data/server_respond.dart';
import 'package:stayverse/core/exception/app_exceptions.dart';
import 'package:stayverse/core/util/app/logger.dart';
import 'package:stayverse/feature/profile/model/data/data_source.dart';
import 'package:stayverse/feature/profile/model/data/update_password_request.dart';
import 'package:stayverse/feature/profile/model/dataSource/network/profile_network_repository.dart';

class ProfileNetworkService extends ProfileDataSource<ServerResponse> {
  final log = BrimLogger.load("ProfileNetworkService");

  final ProfileNetworkRepository _profileNetworkRepository;

  ProfileNetworkService(this._profileNetworkRepository);

  @override
  Future<ServerResponse?> updatePassword(
      UpdatePasswordRequest updatePasswordRequest) async {
    try {
      log.i("::::====> Updating password");
      return await _profileNetworkRepository
          .updatePassword(updatePasswordRequest);
    } on DioException catch (e) {
      log.i("Error updating password: ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> verifyKyc(String nin, MultipartFile selfie) async {
    try {
      log.i("::::====> Verifying Kyc");
      return await _profileNetworkRepository.verifyKyc(nin, selfie);
    } on DioException catch (e) {
      log.i("Error verifying Kyc: ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> uploadProfile(MultipartFile profilePicture) async {
    try {
      log.i("::::====> Uploading Profile");
      return await _profileNetworkRepository.uploadProfile(profilePicture);
    } on DioException catch (e) {
      log.i("Error: ${e.message}");
      log.i("Error: ${e.response?.data}");
      log.i("Error: ${e.response?.statusCode}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> deleteAccount(String password) async {
    try {
      log.i("::::====> Deleting Account");
      return await _profileNetworkRepository.deleteAccount(password);
    } on DioException catch (e) {
      log.i("Error: ${e.message}");
      log.i(" Status Code : ${e.response?.statusCode}");
      log.i(" Response Data : ${e.response?.data}");
      return BrimAppException.handleError(e);
    }
  }
}
