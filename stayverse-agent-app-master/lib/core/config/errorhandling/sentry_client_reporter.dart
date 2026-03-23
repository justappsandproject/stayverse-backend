import 'dart:async';

import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/config/appEnviroment/enviroment.dart';
import 'package:stayvers_agent/core/config/deviceInfo/app_device_information.dart';
import 'package:stayvers_agent/core/config/errorhandling/error_reporter.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';
import 'package:sentry/sentry.dart';

class SenrtyClientReporter implements ReporterClient {
  const SenrtyClientReporter(
    this.client, {
    required this.deviceInformation,
    required this.environment,
  });

  final SentryClient client;
  final DeviceInformation deviceInformation;
  final Environment environment;

  @override
  FutureOr<void> report(
      {required StackTrace stackTrace,
      required Object error,
      Object? extra}) async {
    final SentryEvent event = SentryEvent(
      throwable: error,
      environment: environment.name.toUpperCase(),
      release: deviceInformation.appVersion,
      tags: deviceInformation.toMap(),
      user: SentryUser(
        id: deviceInformation.deviceId,
      ),
      // ignore: deprecated_member_use
      extra: extra is Map
          ? extra as Map<String, dynamic>?
          : <String, dynamic>{'extra': extra},
    );

    await client.captureEvent(event, stackTrace: stackTrace);
  }

  @override
  FutureOr<void> reportCrash(FlutterErrorDetails details) =>
      client.captureException(details.exception, stackTrace: details.stack);

  @override
  void log(Object object) => BrimLogger.load(SenrtyClientReporter).i(object);
}
