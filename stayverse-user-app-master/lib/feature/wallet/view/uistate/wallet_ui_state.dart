import 'package:fixed_collections/fixed_collections.dart';
import 'package:stayverse/feature/wallet/model/data/transaction_history_response.dart';

class WalletUiState {
  final bool isBusy;
  final bool showBalance;
  final List<Transactions>? _transactions;
  final Pagination? pagination;
  final bool isLoadingTransactions;

  WalletUiState({
    this.isBusy = false,
    this.showBalance = false,
    this.isLoadingTransactions = false,
    this.pagination,
    List<Transactions>? transactions,
  }) : _transactions = transactions;

  FixedList<Transactions> get transactions => FixedList(_transactions ?? []);

  WalletUiState copyWith({
    bool? isBusy,
    bool? showBalance,
    bool? isLoadingTransactions,
    Pagination? pagination,
    List<Transactions>? transactions,
  }) {
    return WalletUiState(
      transactions: transactions ?? this.transactions,
      isLoadingTransactions:
          isLoadingTransactions ?? this.isLoadingTransactions,
      isBusy: isBusy ?? this.isBusy,
      pagination: pagination ?? this.pagination,
      showBalance: showBalance ?? this.showBalance,
    );
  }
}
