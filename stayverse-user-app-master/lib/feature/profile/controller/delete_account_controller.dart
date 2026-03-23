
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/core/data/server_error_catch.dart';
import 'package:stayverse/core/service/toast_service.dart';
import 'package:stayverse/feature/profile/model/dataSource/network/profile_network_service.dart';
import 'package:stayverse/feature/profile/view/uistate/delete_account_ui_state.dart';

class DeleteAccountController extends StateNotifier<DeleteAccountUiState>
    with CheckForServerError {
  DeleteAccountController(this._profileNetworkService)
      : super(const DeleteAccountUiState());

  final ProfileNetworkService _profileNetworkService;

  Future<bool> deleteAccount(String password) async {
    try {
      _isBusy(true);
      final serverResponse =
          await _profileNetworkService.deleteAccount(password);

      if (errorOccured(serverResponse)) {
        return false;
      }

      BrimToast.showSuccess('Account deleted successfully');
      return true;
    } catch (e) {
      BrimToast.showError(e.toString());
      return false;
    } finally {
      _isBusy(false);
    }
  }

  _isBusy(bool isBusy) {
    state = state.copyWith(isBusy: isBusy);
  }

  reset() {
    _isBusy(false);
  }
}

final deleteAccountController =
    StateNotifierProvider<DeleteAccountController, DeleteAccountUiState>(
  (ref) => DeleteAccountController(locator.get()),
);
