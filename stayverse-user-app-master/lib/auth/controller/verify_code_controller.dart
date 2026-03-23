import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/auth/controller/login_controller.dart';
import 'package:stayverse/auth/model/data/login_request.dart';
import 'package:stayverse/auth/model/data/verify_request.dart';
import 'package:stayverse/auth/model/dataSource/network/auth_network_service.dart';
import 'package:stayverse/auth/view/uistate/verify_otp_ui_state.dart';
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/data/server_error_catch.dart';
import 'package:stayverse/core/data/server_respond.dart';
import 'package:stayverse/core/exception/app_exceptions.dart';
import 'package:stayverse/core/service/toast_service.dart';

class VerifyCodeController extends StateNotifier<VerifyUiState>
    with CheckForServerError {
  VerifyCodeController(this._authNetworkService, this.ref)
      : super(VerifyUiState());

  final Ref ref;
  final AuthNetworkService _authNetworkService;

  Future<bool> resendToken(String email) async {
    try {
      _isBusy(true);
      ServerResponse? serverResponse =
          await _authNetworkService.sendEmail(email);

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

  Future<bool> verifyToken(
      {required LoginRequest loginRequest, required String otp}) async {
    _isBusy(true);
    try {
      final serverResposne = await _authNetworkService
          .verifyToken(VeirfyTokenRequest(email: loginRequest.email, otp: otp));

      if (errorOccured(serverResposne)) {
        return false;
      }

      final procced =
          await ref.refresh(loginController.notifier).login(loginRequest);

      return procced == LoginRoute.success;
    } on BrimAppException catch (e) {
      BrimToast.showError(e.toString());
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

final verifyCodeController =
    StateNotifierProvider<VerifyCodeController, VerifyUiState>((ref) {
  return VerifyCodeController(locator.get(), ref);
});
