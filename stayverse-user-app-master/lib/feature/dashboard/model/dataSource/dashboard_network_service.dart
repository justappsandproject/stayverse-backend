import 'package:dio/dio.dart';
import 'package:stayverse/core/data/server_respond.dart';
import 'package:stayverse/core/exception/app_exceptions.dart';
import 'package:stayverse/core/util/app/logger.dart';
import 'package:stayverse/feature/dashboard/model/data/dashboard_data_source.dart';
import 'package:stayverse/feature/dashboard/model/dataSource/dashboard_network_repository.dart';

class DashNetworkService extends DashDataSource<ServerResponse> {
  final log = BrimLogger.load("DashNetworkService");

  final DashNetworkRepository _dashRepository;

  DashNetworkService(this._dashRepository);

  @override
  Future<ServerResponse?> getUser() async {
    try {
      log.i("  ::::====>  Fetching User Profile");

      return await _dashRepository.getProfile();
    } on DioException catch (e) {
      log.i(" Error message ::::=====> ${e.message}");

      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> proposalAction(
      {required String proposalId, required bool status}) async {
    try {
      return await _dashRepository.proposalAction(
          proposalId: proposalId, status: status);
    } on DioException catch (e) {
      return BrimAppException.handleError(e);
    }
  }

      @override
  Future<ServerResponse?> updateProfile(String firstName, String lastName) async {
    try {
      log.i("::::====> Updating Profile");
      return await _dashRepository.updateProfile(firstName, lastName);
    } on DioException catch (e) {
      log.i("Error Updating Profile: ${e.message}");
      return BrimAppException.handleError(e);
    }
  }
}
