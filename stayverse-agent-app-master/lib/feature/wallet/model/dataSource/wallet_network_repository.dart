import 'package:dio/dio.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/feature/wallet/model/data/verify_bank_request.dart';
import 'package:stayvers_agent/feature/wallet/model/data/withdrawal_request.dart';

class _WalletPath {
  static String getTransaction = "/payments";
  static String getTransactions = "/payments";
  static String getBanks = "/payments/banks";
  static String verifyBankAccount = "/payments/resolve-account";
  static String fundWallet = "/payments/fund-wallet";
  static String verifyTransaction = "/payments/verify";
  static String withdraw = "/payments/withdraw";
}

class WalletNetworkRepository {
  WalletNetworkRepository({required this.dio});

  final Dio dio;

  Future<ServerResponse?> getTransaction(String id) async {
    final result = await dio.get<Map<String, dynamic>>(
      "${dio.options.baseUrl}${_WalletPath.getTransaction}",
    );
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> getTransactions(
      {required int limit, required int page}) async {
    final result = await dio.get<Map<String, dynamic>>(
      "${dio.options.baseUrl}${_WalletPath.getTransactions}",
      queryParameters: {
        "limit": limit,
        "page": page,
      },
    );
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> getBanks() async {
    final result = await dio.get<Map<String, dynamic>>(
      "${dio.options.baseUrl}${_WalletPath.getBanks}",
    );
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> verifyBankAccount(VerifyBankRequest request) async {
    final result = await dio.post<Map<String, dynamic>>(
      "${dio.options.baseUrl}${_WalletPath.verifyBankAccount}",
      data: request.toJson(),
    );
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> fundWallet(double amount) async {
    final result = await dio.post<Map<String, dynamic>>(
      "${dio.options.baseUrl}${_WalletPath.fundWallet}",
      data: {"amount": amount},
    );
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> verifyTransaction(String transactionRef) async {
    final result = await dio.post<Map<String, dynamic>>(
      "${dio.options.baseUrl}${_WalletPath.verifyTransaction}/$transactionRef",
    );
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> withdraw(WithdrawalRequest request) async {
    final result = await dio.post<Map<String, dynamic>>(
      "${dio.options.baseUrl}${_WalletPath.withdraw}",
      data: request.toJson(),
    );
    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }
}
