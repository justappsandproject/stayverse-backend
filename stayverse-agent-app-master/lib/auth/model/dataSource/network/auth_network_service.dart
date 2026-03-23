import 'package:dio/dio.dart';
import 'package:stayvers_agent/auth/model/data/auth_data_source.dart';
import 'package:stayvers_agent/auth/model/data/login_request.dart';
import 'package:stayvers_agent/auth/model/data/register_request.dart';
import 'package:stayvers_agent/auth/model/data/reset_password.dart';
import 'package:stayvers_agent/auth/model/data/verify_request.dart';
import 'package:stayvers_agent/auth/model/dataSource/network/auth_network_respository.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/exception/app_exceptions.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';

class AuthNetworkService extends AuthDataSource<ServerResponse> {
  final log = BrimLogger.load("AuthService");

  final AuthNetworkRepository _authRepository;

  AuthNetworkService(this._authRepository);

  @override
  Future<ServerResponse?> login(LoginRequest request) async {
    try {
      log.i("  ::::====>  Login User");

      return await _authRepository.login(request);
    } on DioException catch (e) {
      log.i(" Error message ::::=====> ${e.message}");

      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> register(RegisterUserRequest request) async {
    try {
      log.i("  ::::====>  createAccount User");

      return await _authRepository.createAccount(request);
    } on DioException catch (e) {
      log.i(" Error message ::::=====> ${e.message}");

      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> sendResetToken(String email) async {
    try {
      log.i("  ::::====>  forgetPassword User");

      return await _authRepository.sendResetToken(email);
    } on DioException catch (e) {
      log.i(" Error message ::::=====> ${e.message}");

      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> resetPassword(
      ResetPasswordRequest resetPassword) async {
    try {
      log.i("  ::::====>  resetPassword User");

      return await _authRepository.resetPassword(resetPassword);
    } on DioException catch (e) {
      log.i(" Error message ::::=====> ${e.message}");

      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> verifyToken(VeirfyTokenRequest veirfyRequest) async {
    try {
      log.i("  ::::====>  verifyToken");

      return await _authRepository.verifyToken(veirfyRequest);
    } on DioException catch (e) {
      log.i(" Error message ::::=====> ${e.message}");

      return BrimAppException.handleError(e);
    }
  }

  @override
  Future<ServerResponse?> sendEmail(String email) async {
    try {
      log.i("  ::::====>  sendEmail");

      return await _authRepository.sendToken(email);
    } on DioException catch (e) {
      log.i(" Error message ::::=====> ${e.message}");

      return BrimAppException.handleError(e);
    }
  }
}
