import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/config/dependecies.dart';
import 'package:stayvers_agent/core/data/current_user.dart';
import 'package:stayvers_agent/core/data/server_error_catch.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/data/typedefs.dart';
import 'package:stayvers_agent/core/exception/app_exceptions.dart';
import 'package:stayvers_agent/core/service/brimAuth/brim_auth.dart';
import 'package:stayvers_agent/core/service/toast_service.dart';
import 'package:stayvers_agent/feature/dashBoard/model/data/current_user_response.dart';
import 'package:stayvers_agent/feature/dashBoard/model/dataSource/dashboard_network_service.dart';
import 'package:stayvers_agent/feature/dashBoard/view/uistate/dashboard_ui_state.dart';

class DashBoardNotifier extends StateNotifier<DashBoardUiState>  with CheckForServerError {
  final DashboardNetworkService _dashboardNetworkService;
  DashBoardNotifier(this._dashboardNetworkService)
      : super(DashBoardUiState(user: BrimAuth.curentUser()));

  Future<void> refreshUser() async {
    final currentUser = await _getUser();
    if (currentUser != null) {
      _syncUser(currentUser);
    }
  }

  Future<CurrentUser?> _getUser() async {
    try {
      _isBusy(true);
      ServerResponse? serverResponse =
          await _dashboardNetworkService.getUser();

      if (errorOccured(serverResponse, showToast: false)) {
        return null;
      }

      final currentUserResponse = CurrentUserResponse.fromJson(
        serverResponse?.payload as DynamicMap,
      );
      return currentUserResponse.data;
    } on BrimAppException catch (_) {
      return null;
    } finally {
      reset();
    }
  }

    Future<bool> updateProfile(String firstName, String lastName) async {
    _isBusy(true);
    try {
      final serverResposne = await _dashboardNetworkService.updateProfile(firstName, lastName);

      if (errorOccured(serverResposne)) {
        return false;
      }

      BrimToast.showSuccess('Profile updated successfully');
      await refreshUser();
      return true;
    } on BrimAppException catch (e) {
      BrimToast.showError(e.toString());
      return false;
    } finally {
      reset();
    }
  }

  void startLoading() {
    state = state.copyWith(isLoading: true);
  }

  void stopLoading() {
    state = state.copyWith(isLoading: false);
  }

  void setCurrentPageIndex({required int index}) {
    state = state.copyWith(currentPageIndex: index);
  }

  void _syncUser(CurrentUser currentUser) async {
    final updateUser = await BrimAuth.updateCurrentUser(currentUser);
    state = state.copyWith(user: updateUser);
  }

  void reset() {
    _isBusy(false);
  }

  void _isBusy(bool isBusy) {
    state = state.copyWith(isLoading: isBusy);
  }
}

final dashboadController =
    StateNotifierProvider<DashBoardNotifier, DashBoardUiState>(
        (ref) => DashBoardNotifier(locator.get()));
