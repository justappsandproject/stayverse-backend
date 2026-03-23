import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/auth/model/data/register_request.dart';
import 'package:stayvers_agent/auth/model/dataSource/network/auth_network_service.dart';
import 'package:stayvers_agent/auth/view/uistate/create_account_ui_state.dart';
import 'package:stayvers_agent/core/config/dependecies.dart';
import 'package:stayvers_agent/core/data/server_error_catch.dart';
import 'package:stayvers_agent/core/exception/app_exceptions.dart';
import 'package:stayvers_agent/core/service/toast_service.dart';

class CreateAccountController extends StateNotifier<CreateAccountUiState>
    with CheckForServerError {
  CreateAccountController(this._authNetworkService)
      : super(CreateAccountUiState(isBusy: false));

  final AuthNetworkService _authNetworkService;

  Future<bool> createAccount(RegisterUserRequest request) async {
    _isBusy(true);
    try {
      final serverResposne = await _authNetworkService.register(request);

      if (errorOccured(serverResposne)) {
        return false;
      }

      BrimToast.showSuccess('Account created successfully');

      return true;
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

final signUpController =
    StateNotifierProvider<CreateAccountController, CreateAccountUiState>((ref) {
  return CreateAccountController(locator.get());
});
