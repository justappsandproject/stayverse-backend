class ResetPasswordRequest {
  final String? email;
  final String? otp;
  final String? password;

  ResetPasswordRequest({
    this.email,
    this.otp,
    this.password,
  });

  ResetPasswordRequest copyWith({
    String? email,
    String? otp,
    String? password,
  }) =>
      ResetPasswordRequest(
        email: email ?? this.email,
        otp: otp ?? this.otp,
        password: password ?? this.password,
      );

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      ResetPasswordRequest(
        email: json["email"],
        otp: json["otp"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "otp": otp,
        "password": password,
      };
}
