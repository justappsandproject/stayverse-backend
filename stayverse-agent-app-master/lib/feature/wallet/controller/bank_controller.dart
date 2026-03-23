
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/config/dependecies.dart';
import 'package:stayvers_agent/core/data/server_error_catch.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/data/typedefs.dart';
import 'package:stayvers_agent/feature/wallet/model/data/bank_response.dart';
import 'package:stayvers_agent/feature/wallet/model/dataSource/wallet_network_service.dart';
import 'package:stayvers_agent/feature/wallet/view/ui_state/bank_ui_state.dart';

class BankController extends StateNotifier<BankUiState>
    with CheckForServerError {
  BankController(this._walletNetworkService) : super(const BankUiState());

  final WalletNetworkService _walletNetworkService;

  void searchFilter(String keyword) {
    if (keyword.isEmpty) {
      state = state.copy(filterdList: state.getBanks.toList());
      return;
    }

    final lowercaseKeyword = keyword.toLowerCase();

    final filteredBanks = state.getBanks
        .where((bank) =>
            bank.name?.toLowerCase().contains(lowercaseKeyword) ?? false)
        .toList();

    state = state.copy(filterdList: filteredBanks);
  }

  Future<void> getBanks() async {
    try {
      if (state.getBanks.toList().isNotEmpty) {
        return;
      }
      _isBusy(true);
      ServerResponse? response = await _walletNetworkService.getBanks();

      if (errorOccured(response, showToast: false)) {
        return;
      }

      final resposne = BanksResponse.fromJson(response!.payload as DynamicMap);

      _updateBanks(resposne.data ?? []);
    } catch (_) {
    } finally {
      _isBusy(false);
    }
  }

  void resetFilterdList() {
    if (state.getBanks.isNotEmpty) {
      if (state.getFilteredBanks.length != state.getBanks.length) {
        state = state.copy(filterdList: state.getBanks);
      }
    }
  }

  void _updateBanks(List<Bank> banks) {
    state = state.copy(banks: banks, filterdList: banks);
  }

  _isBusy(bool isBusy) {
    state = state.copy(isBusy: isBusy);
  }
}

final bankController = StateNotifierProvider<BankController, BankUiState>(
    (ref) => BankController(locator.get()));
