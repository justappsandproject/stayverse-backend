import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/core/data/server_error_catch.dart';
import 'package:stayverse/core/data/typedefs.dart';
import 'package:stayverse/core/exception/app_exceptions.dart';
import 'package:stayverse/core/service/toast_service.dart';
import 'package:stayverse/core/util/app/logger.dart';
import 'package:stayverse/feature/wallet/model/data/bank_response.dart';
import 'package:stayverse/feature/wallet/model/data/resolve_account_resoponse.dart';
import 'package:stayverse/feature/wallet/model/data/verify_bank_request.dart';
import 'package:stayverse/feature/wallet/model/data/withdrawal_request.dart';
import 'package:stayverse/feature/wallet/model/dataSource/wallet_network_service.dart';
import 'package:stayverse/feature/wallet/view/uistate/withdrawal_ui_state.dart';

class WithdrawalFormNotifier extends StateNotifier<WithdrawalUiState>
    with CheckForServerError {
  final WalletNetworkService _walletNetworkService;
  WithdrawalFormNotifier(this._walletNetworkService)
      : super(const WithdrawalUiState());
  final log = BrimLogger.load("WithdrawalFormNotifier");

  Future<bool> withdraw(WithdrawalRequest request) async {
    _isBusy(true);
    try {
      final serverResponse = await _walletNetworkService.withdraw(request);
      if (errorOccured(serverResponse, showToast: true)) {
        return false;
      }
      BrimToast.showSuccess('Withdrawal successful');
      return true;
    } on BrimAppException catch (e) {
      log.e("Error Withdraw: ${e.toString()}");
      return false;
    } finally {
      _isBusy(false);
    }
  }

  Future<void> verifyBankAccount(VerifyBankRequest request) async {
    _isFetchingName(true);
    _setAccountName('');
    try {
      final serverResponse =
          await _walletNetworkService.verifyBankAccount(request);
      if (errorOccured(serverResponse, showToast: true)) {
        return;
      }
      final resolveAccountResponse = ResolveAccountResponse.fromJson(
          serverResponse?.payload as DynamicMap);
      _setAccountName(resolveAccountResponse.data?.accountName ?? '');
    } on BrimAppException catch (e) {
      log.e("Error Fund Wallet: ${e.toString()}");
      return;
    } finally {
      _isFetchingName(false);
    }
  }

  void _setAccountName(String name) {
    state = state.copy(accountName: name);
  }

  void selectBank(Bank bank) {
    state = state.copy(selectedBank: bank);
  }

  void _isFetchingName(bool value) {
    state = state.copy(isFetchingName: value);
  }

  void _isBusy(bool value) {
    state = state.copy(isBusy: value);
  }
}

final withdrawalController = StateNotifierProvider.autoDispose<
    WithdrawalFormNotifier,
    WithdrawalUiState>((ref) => WithdrawalFormNotifier(locator.get()));
