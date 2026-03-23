
import 'package:stayverse/feature/wallet/model/data/verify_bank_request.dart';
import 'package:stayverse/feature/wallet/model/data/withdrawal_request.dart';

abstract class WalletDataSource<T> {
  Future<T?> getTransaction(String id);
  Future<T?> getTransactions({int limit, int page});
  Future<T?> getBanks();
  Future<T?> verifyBankAccount(VerifyBankRequest request);
  Future<T?> fundWallet(double amount);
  Future<T?> verifyTransaction(String transactionRef);
  Future<T?> withdraw(WithdrawalRequest request);
}
