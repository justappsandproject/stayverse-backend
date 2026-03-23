class VeirfyTokenRequest {
  final String? email;
  final String? otp;

  VeirfyTokenRequest({
    this.email,
    this.otp,
  });

  VeirfyTokenRequest copyWith({
    String? email,
    String? otp,
  }) =>
      VeirfyTokenRequest(
        email: email ?? this.email,
        otp: otp ?? this.otp,
      );

  factory VeirfyTokenRequest.fromJson(Map<String, dynamic> json) =>
      VeirfyTokenRequest(
        email: json["email"],
        otp: json["otp"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "otp": otp,
      };
}
