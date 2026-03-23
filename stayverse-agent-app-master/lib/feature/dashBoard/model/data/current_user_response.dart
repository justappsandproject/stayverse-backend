import 'package:stayvers_agent/core/data/current_user.dart';

class CurrentUserResponse {
  final int? statusCode;
  final String? message;
  final CurrentUser? data;
  final dynamic error;

  CurrentUserResponse({
    this.statusCode,
    this.message,
    this.data,
    this.error,
  });

  CurrentUserResponse copyWith({
    int? statusCode,
    String? message,
    CurrentUser? data,
    dynamic error,
  }) =>
      CurrentUserResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        data: data ?? this.data,
        error: error ?? this.error,
      );

  factory CurrentUserResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json["data"];

    return CurrentUserResponse(
      statusCode: json["statusCode"],
      message: json["message"],
      data: dataJson == null
          ? null
          : CurrentUser.fromJson({
              ...dataJson["user"],
              "agent": dataJson,
            }),
      error: json["error"],
    );
  }

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "data": data?.toJson(),
        "error": error,
      };
}
