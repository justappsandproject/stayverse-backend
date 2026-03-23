import 'package:dio/dio.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';

///App exception exception handle custom exception from the server

final logger = BrimLogger.load("AppException");

class BrimAppException implements Exception {
  final String? message;

  BrimAppException([this.message]);

  @override
  String toString() {
    return message ?? 'An unknown error occurred';
  }

  /// Handle Dio error and throw App exception
  static Future<ServerResponse?> handleError(DioException e) async {
    // Intercept server error
    if (e.response?.statusCode == 500) {
      throw BrimAppException(
          handleExceptionError(DioExceptionType.badResponse));
    }

    // Check if the response data is not empty and is a valid map
    if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
      try {
        ServerResponse response = ServerResponse.fromJson(e.response!.data);
        return response;
      } catch (e) {
        throw BrimAppException('Error occured please try again');
      }
    }

    throw BrimAppException(handleExceptionError(e.type));
  }
}

class AuthException extends BrimAppException {
  AuthException([super.message]);
}

class UserNotFoundException extends BrimAppException {
  UserNotFoundException([super.message]);
}

class ErrorOtpException extends BrimAppException {
  ErrorOtpException([super.message]);
}

class FetchDataException extends BrimAppException {
  FetchDataException([super.message]);
}

class BadRequestException extends BrimAppException {
  // ignore: use_super_parameters
  BadRequestException([message]) : super(message);
}

class UnauthorisedException extends BrimAppException {
  // ignore: use_super_parameters
  UnauthorisedException([message]) : super(message);
}

class InvalidInputException extends BrimAppException {
  InvalidInputException([super.message]);
}

String handleExceptionError(DioExceptionType errorType) {
  switch (errorType) {
    case DioExceptionType.connectionTimeout:
      return "Please check your internet connection.";

    case DioExceptionType.sendTimeout:
      return "Stayed Long - Please check your network";

    case DioException.receiveTimeout:
      return "Stayed Long - Please check your network";

    case DioExceptionType.badCertificate:
      return "Please Try again";

    case DioException.badResponse:
      return "sorry its our fault, please try again later.";

    case DioExceptionType.cancel:
      return "please try again";

    case DioException.connectionError:
      return "Please check your internet connection.";

    case DioExceptionType.unknown:
      return "Oops! Something went wrong, please try again later.";

    default:
      return "Error!!! We are working on it ";
  }
}
