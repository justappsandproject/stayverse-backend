// ignore_for_file: unused_element

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/core/config/deviceInfo/app_device_information.dart';
import 'package:stayverse/core/util/app/logger.dart';

/// [UserAgentInterceptor] intercepts requests and can add user-specific headers.

class UserAgentInterceptor extends InterceptorsWrapper {
  UserAgentInterceptor();
  final log = BrimLogger.load(UserAgentInterceptor);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final device = locator.get<BrimDeviceInfo>();
    final userAgent = device.deviceInformation?.toMap();
    options.headers[HttpHeaders.userAgentHeader] = userAgent;

    return super.onRequest(
      options,
      handler,
    );
  }
}
