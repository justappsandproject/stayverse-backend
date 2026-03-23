import 'package:dio/dio.dart';
import 'package:stayverse/auth/model/data/login_request.dart';
import 'package:stayverse/auth/model/data/register_request.dart';
import 'package:stayverse/auth/model/data/reset_password.dart';
import 'package:stayverse/auth/model/data/verify_request.dart';
import 'package:stayverse/core/data/server_respond.dart';
import 'package:stayverse/core/data/typedefs.dart';
import 'package:stayverse/core/util/app/logger.dart';

class _AuthPath {
  static String login = "/users/login";
  static String register = "/users/register";
  static String resetPassword = "/users/forgot-password";
  static String verifyToken = "/users/verify-token";
  static String sendToken = "/users/send-token";
  static String sendResetToken = "/users/request-forgot-password";
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
        "${dio.options.baseUrl}${_AuthPath.sendResetToken}/$email");

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
