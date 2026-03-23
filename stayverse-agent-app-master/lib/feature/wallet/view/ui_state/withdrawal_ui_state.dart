import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/feature/wallet/model/data/bank_response.dart';

@immutable
class WithdrawalUiState {
  const WithdrawalUiState({
    this.isBusy = false,
    this.isFetchingName = false,
    this.selectedBank,
    this.accountName,
    this.isBankLoading = false,
  });

  final bool isBusy;
  final bool isFetchingName;
  final bool isBankLoading;

  final Bank? selectedBank;
  final String? accountName;

  WithdrawalUiState copy({
    bool? isBusy,
    bool? isFetchingName,
    Bank? selectedBank,
    String? accountName,
    bool? isBankLoading,
  }) {
    return WithdrawalUiState(
      isFetchingName: isFetchingName ?? this.isFetchingName,
      isBusy: isBusy ?? this.isBusy,
      selectedBank: selectedBank ?? this.selectedBank,
      isBankLoading: isBankLoading ?? this.isBankLoading,
      accountName: accountName ?? this.accountName,
    );
  }
}
