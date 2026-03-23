class FundWalletResponse {
  final int? statusCode;
  final String? message;
  final Data? data;
  final dynamic error;

  FundWalletResponse({
    this.statusCode,
    this.message,
    this.data,
    this.error,
  });

  FundWalletResponse copyWith({
    int? statusCode,
    String? message,
    Data? data,
    dynamic error,
  }) =>
      FundWalletResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        data: data ?? this.data,
        error: error ?? this.error,
      );

  factory FundWalletResponse.fromJson(Map<String, dynamic> json) =>
      FundWalletResponse(
        statusCode: json["statusCode"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "data": data?.toJson(),
        "error": error,
      };
}

class Data {
  final String? authorizationUrl;
  final String? accessCode;
  final String? reference;

  Data({
    this.authorizationUrl,
    this.accessCode,
    this.reference,
  });

  Data copyWith({
    String? authorizationUrl,
    String? accessCode,
    String? reference,
  }) =>
      Data(
        authorizationUrl: authorizationUrl ?? this.authorizationUrl,
        accessCode: accessCode ?? this.accessCode,
        reference: reference ?? this.reference,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        authorizationUrl: json["authorization_url"],
        accessCode: json["access_code"],
        reference: json["reference"],
      );

  Map<String, dynamic> toJson() => {
        "authorization_url": authorizationUrl,
        "access_code": accessCode,
        "reference": reference,
      };
}
