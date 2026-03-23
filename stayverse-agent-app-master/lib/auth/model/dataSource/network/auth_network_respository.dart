import 'package:dio/dio.dart';
import 'package:stayvers_agent/auth/model/data/login_request.dart';
import 'package:stayvers_agent/auth/model/data/register_request.dart';
import 'package:stayvers_agent/auth/model/data/reset_password.dart';
import 'package:stayvers_agent/auth/model/data/verify_request.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/data/typedefs.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';

class _AuthPath {
  static String login = "/agents/login";
  static String register = "/agents/register";
  static String resetPassword = "/agents/forgot-password";
  static String forgetPassword = "/agents/request-forgot-password";
  static String verifyToken = "/agents/verify-token";
  static String sendToken = "/agents/send-token";
}

class AuthNetworkRepository {
  final log = BrimLogger.load("AuthRepository");

  AuthNetworkRepository({required this.dio});

  final Dio dio;

  Future<ServerResponse?> login(LoginRequest loginRequest) async {
    final result = await dio.post<DynamicMap>(
        "${dio.options.baseUrl}${_AuthPath.login}",
        data: loginRequest.toJson());

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> createAccount(
      RegisterUserRequest signupRequest) async {
    final result = await dio.post<DynamicMap>(
        "${dio.options.baseUrl}${_AuthPath.register}",
        data: signupRequest.toJson());

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> resetPassword(
      ResetPasswordRequest resetPasswordRequest) async {
    final result = await dio.post<DynamicMap>(
        "${dio.options.baseUrl}${_AuthPath.resetPassword}",
        data: resetPasswordRequest.toJson());

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> sendResetToken(String email) async {
    final result = await dio.get<DynamicMap>(
        "${dio.options.baseUrl}${_AuthPath.forgetPassword}/$email");

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> verifyToken(VeirfyTokenRequest veirfyRequest) async {
    final result = await dio.post<DynamicMap>(
        "${dio.options.baseUrl}${_AuthPath.verifyToken}",
        data: veirfyRequest.toJson());

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }

  Future<ServerResponse?> sendToken(String email) async {
    final result = await dio
        .get<DynamicMap>("${dio.options.baseUrl}${_AuthPath.sendToken}/$email");

    return result.data == null ? null : ServerResponse.fromJson(result.data!);
  }
}
