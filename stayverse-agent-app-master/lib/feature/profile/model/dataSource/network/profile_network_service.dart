import 'package:dio/dio.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/exception/app_exceptions.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';
import 'package:stayvers_agent/feature/profile/model/data/profile_data_source.dart';
import 'package:stayvers_agent/feature/profile/model/data/update_password_request.dart';
import 'package:stayvers_agent/feature/profile/model/dataSource/network/profile_network_repository.dart';

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
  Future<ServerResponse?> getListedApartments(String status) async {
    try {
      log.i("  ::::====>  getListedApartments ");

      return await _profileNetworkRepository.getListedApartments(status);
    } on DioException catch (e) {
      log.i(" Error Getting List of Apartments: ${e.message}");

      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> getListedRides(String status) async {
    try {
      log.i("  ::::====>  getListedRides ");

      return await _profileNetworkRepository.getListedRides(status);
    } on DioException catch (e) {
      log.i(" Error Getting List of Rides :${e.message}");

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
      return BrimAppException.handleError(e);
    }
  }
}
