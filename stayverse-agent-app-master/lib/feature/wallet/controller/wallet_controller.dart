import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/data/server_error_catch.dart';
import 'package:stayvers_agent/core/data/typedefs.dart';
import 'package:stayvers_agent/core/exception/app_exceptions.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';
import 'package:stayvers_agent/feature/wallet/model/data/transaction_history_response.dart';
import 'package:stayvers_agent/feature/wallet/model/data/fund_wallet_response.dart';
import 'package:stayvers_agent/feature/wallet/model/dataSource/wallet_network_service.dart';
import 'package:stayvers_agent/feature/wallet/view/ui_state/wallet_ui_state.dart';

class WalletController extends StateNotifier<WalletUiState>
    with CheckForServerError {
  final WalletNetworkService _walletNetworkService;
  final log = BrimLogger.load("WalletController");
  WalletController(this._walletNetworkService)
      : super(WalletUiState(showBalance: false));

  void toggleBalance() {
    state = state.copyWith(showBalance: !state.showBalance);
  }

  Future<FundWalletResponse?> fundWallet(double amount) async {
    try {
      final serverResponse = await _walletNetworkService.fundWallet(amount);
      if (errorOccured(serverResponse)) {
        return null;
      }
      return FundWalletResponse.fromJson(serverResponse?.payload as DynamicMap);
    } on BrimAppException catch (e) {
      log.e("Error Fund Wallet: ${e.toString()}");
      return null;
    }
  }

  Future<void> verifyPayment(String reference) async {
    try {
      final serverResponse =
          await _walletNetworkService.verifyTransaction(reference);
      if (errorOccured(serverResponse, showToast: true)) {
        return;
      }
      return;
    } on BrimAppException catch (e) {
      log.e("Error Fund Wallet: ${e.toString()}");
      return;
    }
  }

  Future<void> getTransactionHistory({bool loadMore = false}) async {
    try {
      if (loadMore) {
        if (state.pagination?.currentPage == state.pagination?.totalPages) {
          return;
        }
      }
      _updateLoadingTransactions(true);
      final currentPage = state.pagination?.currentPage ?? 0;

      final page = loadMore ? (currentPage + 1) : 1;

      final serverResponse =
          await _walletNetworkService.getTransactions(page: page);

      if (errorOccured(serverResponse, showToast: false)) {
        return;
      }
      final transactions = TransactionHistoryResponse.fromJson(
          serverResponse?.payload as DynamicMap);
      _updateTransactions(transactions.data?.data ?? [], loadMore: loadMore);

      _updatePagination(transactions.data?.pagination);

      return;
    } on BrimAppException catch (e) {
      log.e("Error Fund Wallet: ${e.toString()}");
      return;
    } finally {
      _updateLoadingTransactions(false);
    }
  }

  void _updateTransactions(List<Transactions> transactions,
      {bool loadMore = false}) {
    state = state.copyWith(
      transactions:
          loadMore ? [...state.transactions, ...transactions] : transactions,
    );
  }

  void _updatePagination(Pagination? pagination) {
    state = state.copyWith(
      pagination: pagination,
    );
  }

  void _updateLoadingTransactions(bool isLoading) {
    state = state.copyWith(
      isLoadingTransactions: isLoading,
    );
  }
}

final walletController = StateNotifierProvider<WalletController, WalletUiState>(
    (ref) => WalletController(locator.get()));
