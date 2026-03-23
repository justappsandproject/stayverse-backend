import 'package:dio/dio.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/exception/app_exceptions.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';
import 'package:stayvers_agent/feature/wallet/model/data/verify_bank_request.dart';
import 'package:stayvers_agent/feature/wallet/model/data/wallet_data_source.dart';
import 'package:stayvers_agent/feature/wallet/model/data/withdrawal_request.dart';
import 'package:stayvers_agent/feature/wallet/model/dataSource/wallet_network_repository.dart';

class WalletNetworkService extends WalletDataSource<ServerResponse> {
  final WalletNetworkRepository _walletNetworkRepository;

  final log = BrimLogger.load("WalletNetworkService");

  WalletNetworkService(this._walletNetworkRepository);

  @override
  Future<ServerResponse?> fundWallet(double amount) async {
    try {
      log.i("::::====> Fund Wallet");
      return await _walletNetworkRepository.fundWallet(amount);
    } on DioException catch (e) {
      log.i("Error Fund Wallet: ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> getBanks() async {
    try {
      log.i("::::====> Get Banks");
      return await _walletNetworkRepository.getBanks();
    } on DioException catch (e) {
      log.i("Error Get Banks: ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> getTransaction(String id) async {
    try {
      log.i("::::====> Get Transaction");
      return await _walletNetworkRepository.getTransaction(id);
    } on DioException catch (e) {
      log.i("Error Get Transaction: ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> getTransactions(
      {int limit = 10, int page = 1}) async {
    try {
      log.i("::::====> Get Transactions");
      return await _walletNetworkRepository.getTransactions(
          limit: limit, page: page);
    } on DioException catch (e) {
      log.i("Error Get Transactions: ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> verifyBankAccount(VerifyBankRequest request) async {
    try {
      log.i("::::====> Verify Bank Account");
      return await _walletNetworkRepository.verifyBankAccount(request);
    } on DioException catch (e) {
      log.i("Error Verify Bank Account: ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> verifyTransaction(String transactionRef) async {
    try {
      log.i("::::====> Verify Transaction");
      return await _walletNetworkRepository.verifyTransaction(transactionRef);
    } on DioException catch (e) {
      log.i("Error Verify Transaction: ${e.message}");
      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> withdraw(WithdrawalRequest request) async {
    try {
      log.i("::::====> Withdraw");
      return await _walletNetworkRepository.withdraw(request);
    } on DioException catch (e) {
      log.i("Error Withdraw: ${e.message}");
      return BrimAppException.handleError(e);
    }
  }
}
