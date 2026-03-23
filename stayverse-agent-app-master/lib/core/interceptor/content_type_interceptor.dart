// ignore_for_file: unused_element

import 'package:dio/dio.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';

///[ContentTypeInterceptor] intercept call you can add user key here

class ContentTypeInterceptor extends InterceptorsWrapper {
  ContentTypeInterceptor();
  final log = BrimLogger.load(ContentTypeInterceptor);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers[Headers.contentTypeHeader] = Headers.jsonContentType;

    if (options.data is FormData) {
      options.headers[Headers.contentTypeHeader] =
          Headers.multipartFormDataContentType;
    }

    return super.onRequest(
      options,
      handler,
    );
  }
}
