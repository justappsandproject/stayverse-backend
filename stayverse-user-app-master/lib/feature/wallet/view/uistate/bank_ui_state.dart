import 'package:fixed_collections/fixed_collections.dart';

import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/feature/wallet/model/data/bank_response.dart';

@immutable
class BankUiState {
  const BankUiState({
    this.isBusy = false,
    List<Bank>? banks,
    List<Bank>? filterdList,
  })  : _banks = banks,
        _filterdList = filterdList;

  final bool isBusy;

  final List<Bank>? _banks;
  final List<Bank>? _filterdList;

  FixedList<Bank> get getFilteredBanks => FixedList<Bank>(_filterdList ?? []);

  FixedList<Bank> get getBanks => FixedList<Bank>(_banks ?? []);

  BankUiState copy({
    bool? isBusy,
    List<Bank>? banks,
    List<Bank>? filterdList,
  }) {
    return BankUiState(
      filterdList: filterdList ?? _filterdList,
      banks: banks ?? _banks,
      isBusy: isBusy ?? this.isBusy,
    );
  }
}
