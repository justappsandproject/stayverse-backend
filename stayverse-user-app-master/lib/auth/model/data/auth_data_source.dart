import 'package:stayverse/auth/model/data/login_request.dart';
import 'package:stayverse/auth/model/data/register_request.dart';
import 'package:stayverse/auth/model/data/reset_password.dart';
import 'package:stayverse/auth/model/data/verify_request.dart';

abstract class AuthDataSource<T> {
  Future<T?> login(LoginRequest request);
  Future<T?> register(RegisterUserRequest request);
  Future<T?> verifyToken(VeirfyTokenRequest veirfyRequest);
  Future<T?> sendEmail(String email);
  Future<T?> sendResetToken(String email);
  Future<T?> resetPassword(ResetPasswordRequest resetPassword);
  
}
