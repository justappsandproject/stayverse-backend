import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/auth/model/dataSource/network/auth_network_service.dart';
import 'package:stayverse/auth/view/uistate/forget_password_ui_state.dart';
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/core/data/server_error_catch.dart';
import 'package:stayverse/core/data/server_respond.dart';
import 'package:stayverse/core/exception/app_exceptions.dart';
import 'package:stayverse/core/service/toast_service.dart';

class ForgetPasswordController extends StateNotifier<ForgetPasswordUiState>
    with CheckForServerError {
  ForgetPasswordController(this._authNetworkService)
      : super(ForgetPasswordUiState());

  final AuthNetworkService _authNetworkService;

  Future<bool> sendResetToken(String email) async {
    try {
      _isBusy(true);
      ServerResponse? serverResponse =
          await _authNetworkService.sendResetToken(email);

      if (errorOccured(serverResponse)) {
        return false;
      }

      BrimToast.showSuccess('Email sent successfully');
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

final forgetPasswordController =
    StateNotifierProvider<ForgetPasswordController, ForgetPasswordUiState>(
        (ref) {
  return ForgetPasswordController(locator.get());
});
