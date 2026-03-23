import 'package:equatable/equatable.dart';

class ServerResponse extends Equatable {
  final Object? payload;
  final String? defaultMessage;
  final Object? data;
  final String errorMessage;
  final bool isSuccess;
  final int? statusCode;

  const ServerResponse({
    required this.payload,
    required this.data,
    required this.defaultMessage,
    required this.errorMessage,
    required this.isSuccess,
    required this.statusCode,
  });

  factory ServerResponse.fromJson(Map<String, dynamic> json) {
    final int? statusCode = json['statusCode'];
    //Check if the reques is success
    bool isSuccess =
        statusCode != null && statusCode >= 200 && statusCode < 300;

    return ServerResponse(
      payload: json,
      data: json['data'],
      defaultMessage: json['message'],
      errorMessage: json['message'] ?? 'Please try again',
      isSuccess: isSuccess,
      statusCode: json['statusCode'],
    );
  }

  @override
  List<Object?> get props =>
      [payload, defaultMessage, errorMessage, isSuccess, statusCode];
}
