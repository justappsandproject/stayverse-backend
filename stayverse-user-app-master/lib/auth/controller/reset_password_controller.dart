import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/auth/model/data/reset_password.dart';
import 'package:stayverse/auth/model/dataSource/network/auth_network_service.dart';
import 'package:stayverse/auth/view/uistate/reset_password_ui_state.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/data/server_error_catch.dart';
import 'package:stayverse/core/data/server_respond.dart';
import 'package:stayverse/core/exception/app_exceptions.dart';
import 'package:stayverse/core/service/toast_service.dart';

class ResetPasswordController extends StateNotifier<ResetPasswordUiState>
    with CheckForServerError {
  ResetPasswordController(this._authNetworkService)
      : super(ResetPasswordUiState());

  final AuthNetworkService _authNetworkService;

  Future<bool> resetPassword(ResetPasswordRequest resetPassword) async {
    try {
      _isBusy(true);
      ServerResponse? serverResponse =
          await _authNetworkService.resetPassword(resetPassword);

      if (errorOccured(serverResponse)) {
        return false;
      }

      BrimToast.showSuccess('Password reset successfully');
      return true;
    } on BrimAppException catch (error) {
      BrimToast.showError(error.toString());
      return false;
    } finally {
      reset();
    }
  }

  void _isBusy(bool isBusy) {
    state = state.copyWith(isBusy: isBusy);
  }

  void reset() {
    _isBusy(false);
  }
}

final resetPasswordControllerProvider =
    StateNotifierProvider<ResetPasswordController, ResetPasswordUiState>(
        (ref) => ResetPasswordController(locator.get()));
