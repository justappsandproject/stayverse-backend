import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/core/data/current_user.dart';
import 'package:stayverse/core/data/server_error_catch.dart';
import 'package:stayverse/core/data/server_respond.dart';
import 'package:stayverse/core/exception/app_exceptions.dart';
import 'package:stayverse/core/service/brimAuth/brim_auth.dart';
import 'package:stayverse/core/service/toast_service.dart';
import 'package:stayverse/feature/dashboard/model/dataSource/dashboard_network_service.dart';
import 'package:stayverse/feature/dashboard/view/uistate/ui_state.dart';

class DashBoardController extends StateNotifier<DashBoardUiState>
    with CheckForServerError {
  DashBoardController(
    this._dashboardNetworkService,
  ) : super(DashBoardUiState(user: BrimAuth.curentUser()));

  final DashNetworkService _dashboardNetworkService;
  Future<void> refreshUser() async {
    final currentUser = await _getUser();
    if (currentUser != null) {
      _syncUser(currentUser);
    }
  }

  Future<CurrentUser?> _getUser() async {
    try {
      _isBusy(true);
      ServerResponse? serverResponse = await _dashboardNetworkService.getUser();

      if (errorOccured(serverResponse, showToast: false)) {
        return null;
      }

      final raw = serverResponse?.data;
      if (raw is! Map) return null;

      return CurrentUser.fromJson(Map<String, dynamic>.from(raw));
    } on BrimAppException catch (_) {
      return null;
    } catch (_) {
      return null;
    } finally {
      reset();
    }
  }

  Future<bool> updateProfile(String firstName, String lastName) async {
    _isBusy(true);
    try {
      final serverResposne =
          await _dashboardNetworkService.updateProfile(firstName, lastName);

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

  void _syncUser(CurrentUser currentUser) async {
    final updateUser = await BrimAuth.updateCurrentUser(currentUser);
    state = state.copyWith(user: updateUser);
  }

  void startLoading() {
    state = state.copyWith(isBusy: true);
  }

  void stopLoading() {
    state = state.copyWith(isBusy: true);
  }

  void setCurrentPageIndex({required int index}) {
    state = state.copyWith(currentPageIndex: index);
  }

  void _isBusy(bool isBusy) {
    state = state.copyWith(isBusy: isBusy);
  }

  void reset() {
    _isBusy(false);
  }
}

final dashboadController =
    StateNotifierProvider<DashBoardController, DashBoardUiState>(
        (ref) => DashBoardController(locator.get()));
