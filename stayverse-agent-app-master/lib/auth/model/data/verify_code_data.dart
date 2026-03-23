
import 'package:stayvers_agent/auth/model/data/login_request.dart';

class VerificationCodeData {
  final String? email;
  final String? password;

  VerificationCodeData({
    this.email,
    this.password,
  });

  LoginRequest toLoginRequest() =>
      LoginRequest(email: email, password: password);

  VerificationCodeData copyWith({
    String? email,
    String? password,
  }) =>
      VerificationCodeData(
        email: email ?? this.email,
        password: password ?? this.password,
      );

  factory VerificationCodeData.fromJson(Map<String, dynamic> json) =>
      VerificationCodeData(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
