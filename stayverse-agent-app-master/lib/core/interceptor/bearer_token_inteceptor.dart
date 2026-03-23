// ignore_for_file: unused_element

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:stayvers_agent/core/service/brimAuth/brim_auth.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';

///[BearerTokenInterceptor] intercept call you can add user key here

class BearerTokenInterceptor extends InterceptorsWrapper {
  BearerTokenInterceptor();
  final log = BrimLogger.load(BearerTokenInterceptor);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = BrimAuth.token();

    if (token != null) {
      options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }
    return super.onRequest(
      options,
      handler,
    );
  }
}
