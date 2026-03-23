class VerifyOtpRequest {
  final String? otp;

  VerifyOtpRequest({
    this.otp,
  });

  VerifyOtpRequest copyWith({
    String? otp,
  }) =>
      VerifyOtpRequest(
        otp: otp ?? this.otp,
      );

  factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) =>
      VerifyOtpRequest(
        otp: json["otp"],
      );

  Map<String, dynamic> toJson() => {
        "otp": otp,
      };
}