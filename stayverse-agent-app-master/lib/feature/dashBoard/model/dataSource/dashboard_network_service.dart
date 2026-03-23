import 'package:dio/dio.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/exception/app_exceptions.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';
import 'package:stayvers_agent/feature/dashBoard/model/data/dashboard_data_source.dart';
import 'package:stayvers_agent/feature/dashBoard/model/dataSource/dashboard_network_repository.dart';

class DashboardNetworkService extends DashboardDataSource<ServerResponse> {
  final log = BrimLogger.load("DashboardNetworkService");

  final DashboardNetworkRepository _dashboardNetworkRepository;

  DashboardNetworkService(this._dashboardNetworkRepository);

  @override
  Future<ServerResponse?> getUser() async {
    try {
      log.i("::::====> Geting User");
      return await _dashboardNetworkRepository.getUser();
    } on DioException catch (e) {
      log.i("Error Geting User: ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

    @override
  Future<ServerResponse?> updateProfile(String firstName, String lastName) async {
    try {
      log.i("::::====> Updating Profile");
      return await _dashboardNetworkRepository.updateProfile(firstName, lastName);
    } on DioException catch (e) {
      log.i("Error Updating Profile: ${e.message}");
      return BrimAppException.handleError(e);
    }
  }
}
